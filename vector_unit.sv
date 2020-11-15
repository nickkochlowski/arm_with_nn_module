module vector_unit(input logic signed [7:0] xin, w,
                    input logic clk, rst,
                    output logic signed [31:0] accum,
                    output logic signed [7:0] xout);

  logic [15:0] multOut, accIn;
	
  mult8bitmodule multiplier1(xin, w, clk, rst, multOut, xout);
  acc32bitmodule accumulator1(accIn, clk, rst, accum);
	
  assign accIn = multOut;

endmodule

/*
Este módulo utiliza una instancia del multiplicador y 
del acumulador para generar un vector unit (operación
multiply-and-accumulate [MAC]).
*/