module systolic_array(input logic signed [7:0] xin, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, 
                input logic clk, reset, output_layer,
                input logic [3:0] shift,
                output logic signed [7:0] result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12, result13, result14, result15,
                output logic signed [7:0] xout);

  logic [7:0]	x1_2, x2_3, x3_4, x4_5, x5_6, x6_7, x7_8, x8_9, x9_10, x10_11, x11_12, x12_13, x13_14, x14_15, x15_16;
	
  vu_activation vu1(xin, w1, clk, reset, shift, output_layer, x1_2, result0);
  vu_activation vu2(x1_2, w2, clk, reset, shift, output_layer, x2_3, result1);
  vu_activation vu3(x2_3, w3, clk, reset, shift, output_layer, x3_4, result2);
  vu_activation vu4(x3_4, w4, clk, reset, shift, output_layer, x4_5, result3);
  vu_activation vu5(x4_5, w5, clk, reset, shift, output_layer, x5_6, result4);
  vu_activation vu6(x5_6, w6, clk, reset, shift, output_layer, x6_7, result5);
  vu_activation vu7(x6_7, w7, clk, reset, shift, output_layer, x7_8, result6);
  vu_activation vu8(x7_8, w8, clk, reset, shift, output_layer, x8_9, result7);
  vu_activation vu9(x8_9, w9, clk, reset, shift, output_layer, x9_10, result8);
  vu_activation vu10(x9_10, w10, clk, reset, shift, output_layer, x10_11, result9);
  vu_activation vu11(x10_11, w11, clk, reset, shift, output_layer, x11_12, result10);
  vu_activation vu12(x11_12, w12, clk, reset, shift, output_layer, x12_13, result11);
  vu_activation vu13(x12_13, w13, clk, reset, shift, output_layer, x13_14, result12);
  vu_activation vu14(x13_14, w14, clk, reset, shift, output_layer, x14_15, result13);
  vu_activation vu15(x14_15, w15, clk, reset, shift, output_layer, x15_16, result14);
  vu_activation vu16(x15_16, w16, clk, reset, shift, output_layer, xout, result15);
	
endmodule

/*
Este módulo es una combinación de 16 instancias del 
módulo de MAC + activación. Es decir, este módulo soportará
redes neuronales de hasta 16 nodos por capa.
*/