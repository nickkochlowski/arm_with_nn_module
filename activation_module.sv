module activation_module(input logic signed [31:0] accumulator,
                          input logic [3:0] shift,
                          input logic output_layer,
                          output logic signed [7:0] result);	
					
	logic signed [31:0] temp;
		
	assign temp = (accumulator >>> shift) > -128 ? ((accumulator >>> shift) < 127 ? (accumulator >>> shift) : 127) : -128;
	
	assign result = (!output_layer) ? ((temp < 0) ? 0 : temp) : temp;
	
endmodule

/*
Este módulo hace un corrimiento de bits para tomar la parte 
más significativa del valor acumulado y bajarlo a 8 bits
para poder ser insertado nuevamente como dato de entrada
en la próxima capa de la red. Si el resultado llega a 
superar 127 o -128, será saturado en esos valores, 
debido a que necesitarian más de 8 bits para ser 
representados.
*/