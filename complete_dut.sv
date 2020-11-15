module neural(input  logic clk, reset, run_inference,
              output logic ready,
              output logic [9:0] RAM_address, 
              output logic [7:0] RAM_wd,
              output logic RAM_we,
              input  logic [7:0] RAM_rd);
						  
  logic fifo_wr, reset_accumulators;	
  logic [7:0] bias_data, input_data, output_data, input_mux, output_mux, y, fifo_wr_demux, xin;
  logic [3:0] shift;
  logic [7:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16;
  logic [7:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15;
  logic [15:0] fifo_rd, dout;
  logic [7:0] partial_classification, outputNodeNumber, result_selector;

  control_unit control(clk, reset, run_inference, RAM_rd, ready, RAM_we, fifo_wr, input_fifo_wr, input_fifo_rd, input_mux, bias, reset_accumulators, output_layer, 
                        output_mux, fifo_wr_demux, shift, fifo_rd, RAM_address, outputNodeNumber, result_selector);

  weight_fifos_16 weight_fifos(clk, reset, fifo_rd, dout, RAM_rd, empty_w, full_w, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16);

  fifo input_fifo(y, clk, reset, input_fifo_rd, input_fifo_wr, empty, full, fifo_cnt, xin);

  systolic_array systolic_vector_array(xin, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, 
                                        clk, reset_accumulators, output_layer, shift,
                                        d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15,
                                        xout);
													 
  classifier output_classifier(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, outputNodeNumber, result_selector-1, RAM_wd);

  nn_mux_2 input_multiplexer(input_mux, RAM_rd, output_data, input_data);
  nn_mux_2 bias_multiplexer(bias, input_data, bias_data, y);
  nn_mux_16 output_multiplexer(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, output_mux, output_data);
  nn_demux_16 fifo_wr_demultiplexer(dout, fifo_wr, fifo_wr_demux);

  assign bias_data = 8'h05;

endmodule

/*
Este es el módulo neuronal completo. Contiene:
 - unidad de control
 - unidad de procesamiento (systolic array)
 - memoria RAM
 - fifos de datos de entrada y pesos
 - multiplexores y demultiplexores
*/