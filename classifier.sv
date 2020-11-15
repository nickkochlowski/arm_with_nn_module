module classifier(input logic signed [7:0] result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12, result13, result14, result15,
                  input logic [3:0] outputNodeNumber,
                  input logic s,
                  output logic [7:0] partial_classification);	
						
  logic [7:0] result0_en, result1_en, result2_en, result3_en, result4_en, result5_en, result6_en, result7_en, result8_en, result9_en, result10_en, result11_en, result12_en, result13_en, result14_en, result15_en;
  logic [7:0] d1_y, d2_y, d3_y, d4_y, d5_y, d6_y, d7_y, d8_y, c1_y, c2_y, c3_y, c4_y, b1_y, b2_y, a1_y;
  logic [15:0] enabled;
  logic d1_winner, d2_winner, d3_winner, d4_winner, d5_winner, d6_winner, d7_winner, d8_winner, c1_winner, c2_winner, c3_winner, c4_winner, b1_winner, b2_winner;
  logic a, b, c, d;
  logic [15:0] complete_classification;

					
  decode_enable_nodes decode_enable(outputNodeNumber-1, enabled);
	
  enable_mux_2 en1(result0, -8'd128, enabled[0], result0_en);
  enable_mux_2 en2(result1, -8'd128, enabled[1], result1_en);
  enable_mux_2 en3(result2, -8'd128, enabled[2], result2_en);
  enable_mux_2 en4(result3, -8'd128, enabled[3], result3_en);
  enable_mux_2 en5(result4, -8'd128, enabled[4], result4_en);
  enable_mux_2 en6(result5, -8'd128, enabled[5], result5_en);
  enable_mux_2 en7(result6, -8'd128, enabled[6], result6_en);
  enable_mux_2 en8(result7, -8'd128, enabled[7], result7_en);
  enable_mux_2 en9(result8, -8'd128, enabled[8], result8_en);
  enable_mux_2 en10(result9, -8'd128, enabled[9], result9_en);
  enable_mux_2 en11(result10, -8'd128, enabled[10], result10_en);
  enable_mux_2 en12(result11, -8'd128, enabled[11], result11_en);
  enable_mux_2 en13(result12, -8'd128, enabled[12], result12_en);
  enable_mux_2 en14(result13, -8'd128, enabled[13], result13_en);
  enable_mux_2 en15(result14, -8'd128, enabled[14], result14_en);
  enable_mux_2 en16(result15, -8'd128, enabled[15], result15_en);

  comparator d1(result0_en, result1_en, d1_y, d1_winner);
  comparator d2(result2_en, result3_en, d2_y, d2_winner);
  comparator d3(result4_en, result5_en, d3_y, d3_winner);
  comparator d4(result6_en, result7_en, d4_y, d4_winner);
  comparator d5(result8_en, result9_en, d5_y, d5_winner);
  comparator d6(result10_en, result11_en, d6_y, d6_winner);
  comparator d7(result12_en, result13_en, d7_y, d7_winner);
  comparator d8(result14_en, result15_en, d8_y, d8_winner);

  comparator c1(d1_y, d2_y, c1_y, c1_winner);
  comparator c2(d3_y, d4_y, c2_y, c2_winner);
  comparator c3(d5_y, d6_y, c3_y, c3_winner);
  comparator c4(d7_y, d8_y, c4_y, c4_winner);

  comparator b1(c1_y, c2_y, b1_y, b1_winner);
  comparator b2(c3_y, c4_y, b2_y, b2_winner);

  comparator a1(b1_y, b2_y, a1_y, a);

	class_mux_2 outputmux2(b1_winner, b2_winner, a, b);
	class_mux_4 outputmux4(c1_winner, c2_winner, c3_winner, c4_winner, {a, b}, c);
  class_mux_8 outputmux8(d1_winner, d2_winner, d3_winner, d4_winner, d5_winner, d6_winner, d7_winner, d8_winner, {a, b, c}, d);

	decode_one_hot final_output({a, b, c, d}, complete_classification);

  final_write_mux_2 writemux(complete_classification, s, partial_classification);

endmodule


module comparator(input logic signed [7:0] a, b,
						output logic signed [7:0] y,
						output logic winner);
						
	assign y = (a > b) ? a : b;
	assign winner = (a > b) ? 0 : 1;

endmodule


module final_write_mux_2(input logic [15:0] a,
                          input logic s,
                          output logic [7:0] y);
						  
	assign y = s ? a[7:0] : a[15:8];

endmodule


module class_mux_2(input logic a, b, s,
                    output logic y);
						  
	assign y = s ? b : a;

endmodule


module enable_mux_2(input logic signed [7:0] a, b, 
                    input logic s,
                    output logic signed [7:0] y);
						  
	assign y = s ? a : b;

endmodule

						  
module class_mux_4(input logic a, b, c, d,
                    input logic [1:0] s,
						  output logic y);
	always_comb
	begin
		case(s)
			2'b00: y = a;
			2'b01: y = b;
			2'b10: y = c;
			2'b11: y = d;
			default: y = 0;
		endcase
	end
	
endmodule


module class_mux_8(input logic a, b, c, d, e, f, g, h,
                    input logic [2:0] s,
						        output logic y);
	always_comb
	begin
		case(s)
			3'b000: y = a;
			3'b001: y = b;
			3'b010: y = c;
			3'b011: y = d;
      3'b100: y = e;
			3'b101: y = f;
			3'b110: y = g;
			3'b111: y = h;
			default: y = 0;
		endcase
	end
	
endmodule


module decode_one_hot(input logic [3:0] s,
                    output logic [15:0] classification);

	always_comb
	begin
		case(s)
			4'b0000: classification = 16'b0000000000000001;
			4'b0001: classification = 16'b0000000000000010;
			4'b0010: classification = 16'b0000000000000100;
			4'b0011: classification = 16'b0000000000001000;
			4'b0100: classification = 16'b0000000000010000;
			4'b0101: classification = 16'b0000000000100000;
			4'b0110: classification = 16'b0000000001000000;
			4'b0111: classification = 16'b0000000010000000;
      4'b1000: classification = 16'b0000000100000000;
			4'b1001: classification = 16'b0000001000000000;
			4'b1010: classification = 16'b0000010000000000;
			4'b1011: classification = 16'b0000100000000000;
			4'b1100: classification = 16'b0001000000000000;
			4'b1101: classification = 16'b0010000000000000;
			4'b1110: classification = 16'b0100000000000000;
			4'b1111: classification = 16'b1000000000000000;
			default: classification = 16'b0000000000000000;
		endcase
	end
	
endmodule


module decode_enable_nodes(input logic [3:0] s,
                    output logic [15:0] enabled);

	always_comb
	begin
		case(s)
			4'b0000: enabled = 16'b0000000000000001;
			4'b0001: enabled = 16'b0000000000000011;
			4'b0010: enabled = 16'b0000000000000111;
			4'b0011: enabled = 16'b0000000000001111;
			4'b0100: enabled = 16'b0000000000011111;
			4'b0101: enabled = 16'b0000000000111111;
			4'b0110: enabled = 16'b0000000001111111;
			4'b0111: enabled = 16'b0000000011111111;
      4'b1000: enabled = 16'b0000000111111111;
			4'b1001: enabled = 16'b0000001111111111;
			4'b1010: enabled = 16'b0000011111111111;
			4'b1011: enabled = 16'b0000111111111111;
			4'b1100: enabled = 16'b0001111111111111;
			4'b1101: enabled = 16'b0011111111111111;
			4'b1110: enabled = 16'b0111111111111111;
			4'b1111: enabled = 16'b1111111111111111;
			default: enabled = 16'b1111111111111111;
		endcase
	end
	
endmodule
