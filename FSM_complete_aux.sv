module complete_aux (input logic clk, reset, begin_initialize_registers, begin_load_data, begin_process_data, begin_write_output,
                      input logic [7:0] RAM_rd, stage,
                      output logic registers_initialized, data_loaded, data_processed, output_written, RAM_we, fifo_wr, input_fifo_wr, input_fifo_rd, input_mux, bias, reset_accumulators, output_layer, 
                      output logic [9:0] RAM_address,
                      output logic [7:0] totalLayerNumber, output_mux, fifo_wr_demux,
                      output logic [15:0] fifo_rd,
							 output logic [3:0] shift,
							 output logic [7:0] nodeNumberB, result_counter);

logic n_registers_initialized, n_data_loaded, n_data_processed, n_output_written, n_RAM_we, n_reset_accumulators, n_output_layer;
logic n_input_mux, n_fifo_wr, n_input_fifo_rd, n_input_fifo_wr, n_bias;
logic [3:0] n_shift;
logic [7:0] n_totalLayerNumber, n_nodeNumberA, nodeNumberA, n_nodeNumberB;
logic [7:0] n_input_counter, input_counter, n_progress_counter, progress_counter, n_result_counter;
logic [7:0] n_fifo_wr_ptr, fifo_wr_ptr, n_fifo_wr_demux, n_output_mux;
logic [15:0] n_fifo_rd;
logic [31:0] n_input_ptr, input_ptr, n_data_ptr, data_ptr, n_result_ptr, result_ptr, n_layer_ptr, layer_ptr, n_RAM_address, n_counter, counter;
 
import fsm_pkg_2::*;
state_2 present_state, next_state;

always_ff @ (posedge clk, posedge reset) // lógica secuencial de estado
  begin
    if (reset)
      present_state <= s0;
    else
      present_state <= next_state;
  end

always_comb begin // lógica combinacional para el siguiente estado
  next_state = XX;

  case (present_state)

    s0 : begin
      if(begin_initialize_registers)
        next_state = s1;
      else if(begin_load_data)
        next_state = s3;
      else if(begin_process_data)
        next_state = s12;
      else if(begin_write_output)
        next_state = s15;
      else
        next_state = s0; //@ loopback
    end

    s1 : begin
      next_state = s2;
    end

    s2 : begin
      next_state = s0;
    end

    s3 : begin
      next_state = s4;
    end

    s4 : begin
      next_state = s5;
    end

    s5 : begin
      next_state = s6;
    end

    s6 : begin
      next_state = s7;
    end

    s7 : begin
      if(counter >= nodeNumberA * nodeNumberB + nodeNumberB)
        if(stage == 1)
          next_state = s8;
        else
          next_state = s9;
      else
        next_state = s7; //@ loopback
    end

    s8 : begin
      if(input_counter >= nodeNumberA)
        next_state = s10;
      else
        next_state = s8; //@ loopback
    end

    s9 : begin
      if(input_counter >= nodeNumberA)
        next_state = s10;
      else
        next_state = s9; //@ loopback
    end

    s10 : begin
      next_state = s11;
    end
	 
	 s11 : begin
      next_state = s0;
    end

    s12 : begin
      if(progress_counter >= nodeNumberB)
        next_state = s13;
      else
        next_state = s12; //@ loopback
    end

    s13 : begin
      if(progress_counter >= nodeNumberA + nodeNumberB + 2)
        next_state = s14;
      else
        next_state = s13; //@ loopback
    end

    s14 : begin
      next_state = s0;
    end

    s15 : begin
      if(result_counter >= 2)
        next_state = s16;
      else
        next_state = s15; //@ loopback
    end

    s16 : begin
      next_state = s0;
    end

  endcase
end

always_comb begin // lógica combinacional de salida (next_state)
    
  n_registers_initialized = registers_initialized;
  n_data_loaded = data_loaded;
  n_data_processed = data_processed;
  n_output_written = output_written;

  n_layer_ptr = layer_ptr;
  n_input_ptr = input_ptr;
  n_data_ptr = data_ptr;
  n_result_ptr = result_ptr;

  n_totalLayerNumber = totalLayerNumber;
  n_nodeNumberA = nodeNumberA;
  n_nodeNumberB = nodeNumberB;
  n_shift = shift;

  n_RAM_address = RAM_address;
  n_RAM_we = RAM_we;

  n_counter = counter;
  n_input_counter = input_counter;
  n_progress_counter = progress_counter;
  n_result_counter = result_counter;

  n_fifo_wr = fifo_wr;
  n_fifo_wr_ptr = fifo_wr_ptr;
  n_input_fifo_wr = input_fifo_wr;

  n_input_mux = input_mux;
  n_bias = bias;
  n_fifo_wr_demux = fifo_wr_demux;
  n_output_mux = output_mux;

  n_fifo_rd = fifo_rd;
  n_input_fifo_rd = input_fifo_rd;
  n_reset_accumulators = reset_accumulators;

  n_output_layer = output_layer;
  
  case (next_state)

    s0 : begin
      n_registers_initialized = 0;
      n_data_loaded = 0;
      n_data_processed = 0;
      n_output_written = 0;

      n_counter = 0;
      n_progress_counter = 0;
      n_input_counter = 0;
      n_result_counter = 0;
		
      n_fifo_wr_ptr = 0;
      n_bias = 0;
    end

    s1 : begin
      n_layer_ptr = 10'h0000;
      n_input_ptr = 10'h0200;
      n_result_ptr = 10'h0202;
      n_RAM_address = layer_ptr;
    end

    s2 : begin
      n_totalLayerNumber = RAM_rd;
      n_RAM_address = layer_ptr + 1;
      n_layer_ptr = layer_ptr + 1;
      n_data_ptr = layer_ptr + RAM_rd + 1;
      n_registers_initialized = 1;
    end

    s3 : begin
      n_RAM_address = layer_ptr + 1;
      n_layer_ptr = layer_ptr + 1;
      n_nodeNumberA = RAM_rd;

    end

    s4 : begin
      n_RAM_address = data_ptr;
    end

    s5 : begin
      n_nodeNumberB = RAM_rd;
      n_RAM_address = data_ptr;
      n_data_ptr = data_ptr + 1;
    end

    s6 : begin
      n_data_ptr = data_ptr + 1;
      n_shift = RAM_rd[3:0];
      n_RAM_address = data_ptr;
    end

    s7 : begin
      n_fifo_wr = 1;
      n_RAM_address = data_ptr;
      n_fifo_wr_demux = fifo_wr_ptr;
      n_counter = counter + 1;
      
      if(fifo_wr_ptr >= nodeNumberB - 1)
        n_fifo_wr_ptr = 0;
      else
        n_fifo_wr_ptr = fifo_wr_ptr + 1;

      if(counter < nodeNumberA * nodeNumberB + nodeNumberB - 1)
        n_data_ptr = data_ptr + 1;
      
      if(stage == 1 && counter >= nodeNumberA * nodeNumberB + nodeNumberB - 1)
        n_RAM_address = input_ptr;
    end

    s8 : begin
      n_fifo_wr = 0;
      n_input_fifo_wr = 1;
      n_input_mux = 0;

      n_RAM_address = input_ptr + 1;
      n_input_ptr = input_ptr + 1;
      n_input_counter = input_counter + 1;
    end

    s9 : begin
      n_fifo_wr = 0;
      n_input_fifo_wr = 1;
      n_input_mux = 1;

      n_output_mux = input_counter;
      n_input_counter = input_counter + 1;
    end
	 
	 s10 : begin
      n_bias = 1;
    end

    s11 : begin
      n_input_fifo_wr = 0;
      n_data_loaded = 1;
      n_reset_accumulators = 1;
    end

    s12 : begin
	 	n_reset_accumulators = 0;
      n_input_fifo_rd = 1;
      n_fifo_rd = fifo_rd * 2 + 1;
      n_progress_counter = progress_counter + 1;
    end

    s13 : begin
      n_progress_counter = progress_counter + 1;
    end

    s14 : begin
      n_input_fifo_rd = 0;
      n_fifo_rd = 0;
      n_data_processed = 1;
      
      if(stage < totalLayerNumber - 1)
        n_RAM_address = layer_ptr;
    end

    s15 : begin
	    n_output_layer = 1;
      n_RAM_address = result_ptr;
      n_RAM_we = 1;
      n_result_ptr = result_ptr + 1;
      n_result_counter = result_counter + 1;
    end

    s16 : begin
      n_output_layer = 0;
      n_output_written = 1;
      n_RAM_we = 0;
      n_RAM_address = 32'h0000;
    end

  endcase
end

always_ff @ (posedge clk, posedge reset) // registros de salida
  begin
    if (reset) begin

      registers_initialized <= 0;
      data_loaded <= 0;
      data_processed <= 0;
      output_written <= 0;

      layer_ptr <= 0;
      input_ptr <= 0;
      data_ptr <= 0;
      result_ptr <= 0;

      totalLayerNumber <= 0;
      nodeNumberA <= 0;
      nodeNumberB <= 0;
      shift <= 0;

      RAM_address <= 0;
      RAM_we <= 0;

      counter <= 0;
      input_counter <= 0;
      progress_counter <= 0;
      result_counter <= 0;

      fifo_wr <= 0;
      fifo_wr_ptr <= 0;
      input_fifo_wr <= 0;

      input_mux <= 0;
      bias <= 0;
      fifo_wr_demux <= 0;
      output_mux <= 0;

      fifo_rd <= 0;
      input_fifo_rd <= 0;
      reset_accumulators <= 0;

      output_layer <= 0;

    end else begin
      
      registers_initialized <= n_registers_initialized;
      data_loaded <= n_data_loaded;
      data_processed <= n_data_processed;
      output_written <= n_output_written;

      layer_ptr <= n_layer_ptr;
      input_ptr <= n_input_ptr;
      data_ptr <= n_data_ptr;
      result_ptr <= n_result_ptr;

      totalLayerNumber <= n_totalLayerNumber;
      nodeNumberA <= n_nodeNumberA;
      nodeNumberB <= n_nodeNumberB;
      shift <= n_shift;

      RAM_address <= n_RAM_address;
      RAM_we <= n_RAM_we;

      counter <= n_counter;
      input_counter <= n_input_counter;
      progress_counter <= n_progress_counter;
      result_counter <= n_result_counter;

      fifo_wr <= n_fifo_wr;
      fifo_wr_ptr <= n_fifo_wr_ptr;
      input_fifo_wr <= n_input_fifo_wr;

      input_mux <= n_input_mux;
      bias <= n_bias;
      fifo_wr_demux <= n_fifo_wr_demux;
      output_mux <= n_output_mux;

      fifo_rd <= n_fifo_rd;
      input_fifo_rd <= n_input_fifo_rd;
      reset_accumulators <= n_reset_accumulators;

      output_layer <= n_output_layer;

    end
  end

endmodule

/*
Este módulo es el FSM de control secundario que recibe ordenes
del FSM primario para generar señales de control para los 
FIFOs, multiplexores, demultiplexores, memoria RAM y módulo
de procesamiento. 

Despues de cada etapa, este FSM le comunica al FSM principal
que terminó su tarea y queda pendiente para la próxima tarea.
*/