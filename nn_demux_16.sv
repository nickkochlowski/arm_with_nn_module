module nn_demux_16(output logic [15:0] dout,
                input logic din,
                input logic  [3:0] s);
				
always_comb 
  begin
  dout = 16'b0;
    case(s)
      4'b0000 : dout[0] = din;
      4'b0001 : dout[1] = din;
      4'b0010 : dout[2] = din;
      4'b0011 : dout[3] = din;
      4'b0100 : dout[4] = din;
      4'b0101 : dout[5] = din;
      4'b0110 : dout[6] = din;
      4'b0111 : dout[7] = din;
      4'b1000 : dout[8] = din;
      4'b1001 : dout[9] = din;
      4'b1010 : dout[10] = din;
      4'b1011 : dout[11] = din;
      4'b1100 : dout[12] = din;
      4'b1101 : dout[13] = din;
      4'b1110 : dout[14] = din;
      default : dout[15] = din;
    endcase
  end

endmodule

/*
Este módulo es un demultiplexor de 16 salidas. Se utilizará
para enviar señal de escritura individualmente a cada weight
FIFO.
*/