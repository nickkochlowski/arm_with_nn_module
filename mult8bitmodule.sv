module mult8bitmodule(input logic signed [7:0] xin, w,
                      input logic clk, rst,
                      output logic signed [15:0] result,
                      output logic signed [7:0] xout);
				
always @(posedge clk)
  if (rst)
    begin
      result <= 0;
      xout <= 0;
    end
  else
    begin
      result <= xin * w;
      xout <= xin;
    end

endmodule

/*
Este módulo multiplica el dato de entrada de 8 bits (xin) con el
peso de 8 bits correspondiente del modelo (w) y genera un 
resultado de 16 bits (result). El dato de entrada se saca cómo
salida (xout) para el módulo que le sigue.
*/