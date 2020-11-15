module control_unit(input logic clk, reset, run_inference,
            input logic [7:0] RAM_rd,
            output logic ready,
            output logic RAM_we, fifo_wr, input_fifo_wr, input_fifo_rd, input_mux, bias, reset_accumulators, output_layer, 
            output logic [7:0] output_mux, fifo_wr_demux,
				output logic [3:0] shift,
            output logic [15:0] fifo_rd,
            output logic [9:0] RAM_address,
				output logic [7:0] outputNodeNumber, result_selector);
	
  logic begin_initialize_registers, begin_load_data, begin_process_data, begin_write_output, registers_initialized, data_loaded, data_processed, output_written;
  logic [7:0] stage, totalLayerNumber;
	
  neural_control main(clk, reset, run_inference, registers_initialized, data_loaded, data_processed, output_written, totalLayerNumber,
                        ready, begin_initialize_registers, begin_load_data, begin_process_data, begin_write_output, 
                        stage);
  
  complete_aux secondary(clk, reset, begin_initialize_registers, begin_load_data, begin_process_data, begin_write_output, RAM_rd, stage,
                        registers_initialized, data_loaded, data_processed, output_written, RAM_we, fifo_wr, input_fifo_wr, input_fifo_rd, input_mux, bias, reset_accumulators, output_layer, 
                        RAM_address, totalLayerNumber, output_mux, fifo_wr_demux, fifo_rd, shift, outputNodeNumber, result_selector);
	
endmodule

/*
Este módulo es la unidad de control completa. 
*/