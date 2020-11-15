module nn_mux_2(input logic s,
              input logic [7:0] a, b, 
              output logic [7:0] y);

  assign y = s ? b : a;

endmodule

/*
Este módulo es un multiplexor de 2 entradas. Se utilizará
para elegir el origen de los datos de entrada al input FIFO.
*/