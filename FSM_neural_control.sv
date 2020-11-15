module neural_control (input logic clk, reset, run_inference, registers_initialized, data_loaded, data_processed, output_written,
                        input logic [7:0] totalLayerNumber,
                        output logic ready, begin_initialize_registers, begin_load_data, begin_process_data, begin_write_output, 
                        output logic [7:0] stage);

logic n_ready, n_begin_initialize_registers, n_begin_load_data, n_begin_process_data, n_begin_write_output;
logic [7:0] n_stage;

import fsm_pkg_1::*;		
state_1 present_state, next_state;

always_ff @ (posedge clk, posedge reset) // logica secuencial de estado
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
      if(run_inference)
        next_state = s1;
      else
        next_state = s0; //@ loopback
    end

    s1 : begin
      if(registers_initialized)
        next_state = s2;
      else
        next_state = s1; //@ loopback
    end

    s2 : begin
      if(data_loaded)
        next_state = s3;
      else
        next_state = s2; //@ loopback
    end

    s3 : begin
      if(data_processed)
        if(stage >= totalLayerNumber - 1)
          next_state = s4;
        else
          next_state = s2;
      else
        next_state = s3; //@ loopback
    end

    s4 : begin
      if(output_written)
        next_state = s0;
      else
        next_state = s4; //@ loopback
    end

  endcase
end

always_comb begin // lógica combinacional de salida (next_state)

  n_stage = stage;
  n_ready = ready;

  n_begin_initialize_registers = begin_initialize_registers;
  n_begin_load_data = begin_load_data;
  n_begin_process_data = begin_process_data;
  n_begin_write_output = begin_write_output;

  case (next_state)

    s0 : begin
      n_ready = 1;
      n_stage = 0;
      n_begin_write_output = 0;
    end

    s1 : begin
      n_begin_initialize_registers = 1;
      n_ready = 0;
    end

    s2 : begin
      if(registers_initialized || data_processed)
        n_stage = stage + 1;
      n_begin_load_data = 1;
      n_begin_initialize_registers = 0;
      n_begin_process_data = 0;
    end

    s3 : begin
      n_begin_process_data = 1;
      n_begin_load_data = 0;
    end

    s4 : begin
      n_begin_write_output = 1;  
      n_begin_process_data = 0;
		end

  endcase
end

always_ff @ (posedge clk, posedge reset) // registros de salida
  begin
    if (reset) begin

      stage <= 0;
      ready <= 1;

      begin_initialize_registers <= 0;
      begin_load_data <= 0;
      begin_process_data <= 0;
      begin_write_output <= 0;

    end else begin
      
      stage <= n_stage;
      ready <= n_ready;

      begin_initialize_registers <= n_begin_initialize_registers;
      begin_load_data <= n_begin_load_data;
      begin_process_data <= n_begin_process_data;
      begin_write_output <= n_begin_write_output;

    end
  end

endmodule

/*
Este módulo es el FSM de control primario que recibe la orden
para iniciar el procesamiento ('run_inference'). 

Al recibir la orden, la FSM pasa por los siguientes estados:
 - inicializar registros
 - cargar datos en FIFOs
 - procesar datos
 - escribir salidas

Al terminar de procesar, la señal de 'ready' se pone en alto
y el módulo neuronal queda pendiente esperando la próxima orden.
*/