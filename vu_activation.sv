module vu_activation(input logic signed [7:0] xin, w,
                      input logic clk, rst,
                      input logic [3:0] shift,
                      input logic output_layer,
                      output logic signed [7:0] xout, 
                      output logic signed [7:0] result);

  logic [31:0] accum_o, accum_i;

  vector_unit single_vector_unit(xin, w, clk, rst, accum_o, xout);
  activation_module single_activation_module(accum_i, shift, output_layer, result);

  assign accum_i = accum_o;

endmodule

/*
Este módulo utiliza una instancia del vector unit y 
del módulo de activación para generar un vector unit
con función de activación y escalado.

Este es el módulo de procesamiento completo que se 
instanciará las veces que permita la disponibilidad
de recursos de la FPGA.
*/