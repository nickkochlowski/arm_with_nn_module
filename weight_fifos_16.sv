module weight_fifos_16(input logic clk, reset, 
                      input logic [15:0] rd, wr,
                      input logic [7:0] data_in,
                      output logic [15:0] empty, full,
                      output logic [7:0] q0, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15);
	
	fifo f1(data_in, clk, reset, rd[0], wr[0], empty[0], full[0], fifo_cnt1, q0);
	fifo f2(data_in, clk, reset, rd[1], wr[1], empty[1], full[1], fifo_cnt2, q1);
	fifo f3(data_in, clk, reset, rd[2], wr[2], empty[2], full[2], fifo_cnt3, q2);
	fifo f4(data_in, clk, reset, rd[3], wr[3], empty[3], full[3], fifo_cnt4, q3);
	fifo f5(data_in, clk, reset, rd[4], wr[4], empty[4], full[4], fifo_cnt5, q4);
	fifo f6(data_in, clk, reset, rd[5], wr[5], empty[5], full[5], fifo_cnt6, q5);
	fifo f7(data_in, clk, reset, rd[6], wr[6], empty[6], full[6], fifo_cnt7, q6);
	fifo f8(data_in, clk, reset, rd[7], wr[7], empty[7], full[7], fifo_cnt8, q7);
	fifo f9(data_in, clk, reset, rd[8], wr[8], empty[8], full[8], fifo_cnt9, q8);
	fifo f10(data_in, clk, reset, rd[9], wr[9], empty[9], full[9], fifo_cnt10, q9);
	fifo f11(data_in, clk, reset, rd[10], wr[10], empty[10], full[10], fifo_cnt11, q10);
	fifo f12(data_in, clk, reset, rd[11], wr[11], empty[11], full[11], fifo_cnt12, q11);
	fifo f13(data_in, clk, reset, rd[12], wr[12], empty[12], full[12], fifo_cnt13, q12);
	fifo f14(data_in, clk, reset, rd[13], wr[13], empty[13], full[13], fifo_cnt14, q13);
	fifo f15(data_in, clk, reset, rd[14], wr[14], empty[14], full[14], fifo_cnt15, q14);
	fifo f16(data_in, clk, reset, rd[15], wr[15], empty[15], full[15], fifo_cnt16, q15);
	
endmodule

/*
Este módulo es el conjunto de 16 FIFOs para los pesos del la red neuronal.
*/