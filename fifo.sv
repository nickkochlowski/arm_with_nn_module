module fifo (input logic [7:0] data_in, // La memoria tiene 8 bits de dato
              input logic clk, rst, rd, wr,
              output logic empty, full,
              output logic [7:0] fifo_cnt, // El contador de datos ocupados por la FIFO
              output logic [7:0] data_out);

  logic [7:0] fifo_ram[31:0]; // Memoria de 8bits x 32 registros
  logic [3:0] rd_ptr, wr_ptr; // Punteros o índices para lectura y escritura. (in y out)
	
  assign empty = (fifo_cnt == 8'h0);
  assign full = (fifo_cnt == 8'h20);
	
  always @( posedge clk )
    if( rst )
      begin
        wr_ptr <= 0; // in=0
        rd_ptr <= 0; // out=0
        fifo_cnt <= 0; // size=0
        data_out <= 0;
      end
    else
      begin
        if((wr && !full)||(wr && rd && !empty)) //Operación de escritura
          begin
            fifo_ram[wr_ptr] <= data_in; //almaceno dato en la RAM
            wr_ptr <= wr_ptr + 1'b1; //incremento in
            if (!(rd && !empty)) fifo_cnt <= fifo_cnt + 1'b1; // incremento size
          end
        if(rd && !empty) //Operación de lectura
          begin
            data_out <= fifo_ram[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
            if (!wr) fifo_cnt <= fifo_cnt - 1'b1;
          end
        if(rd && empty) //Operación de lectura
          begin
            data_out <= 0;
          end
      end

endmodule

/*
Este módulo es un FIFO de 32 datos de 8 bits cada uno.
*/