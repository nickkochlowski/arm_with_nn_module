module acc32bitmodule(input logic signed [15:0] zin, 
                      input logic clk, rst, 
                      output logic signed [31:0] accum);
		
always @(posedge clk)
  begin
    if (rst) accum <= 32'b0;
    else accum <= accum + zin;
  end

endmodule

/*
Este módulo suma todas las multiplicaciones hechas por el
módulo multiplicador en un registro de 32 bits (accum).
Al terminar de acumular todos los valores, el valor final
es pasado al módulo de activación.
*/