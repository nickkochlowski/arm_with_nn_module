// True Dual-Port RAM with single clock and different data width on the two ports
//
// The first datawidth and the widths of the addresses are specified
// The second data width is equal to DATA_WIDTH1 * RATIO, where RATIO = (1 << (ADDRESS_WIDTH1 - ADDRESS_WIDTH2)
// RATIO must have value that is supported by the memory blocks in your target
// device.  Otherwise, no RAM will be inferred.  
//
// Read-during-write behavior returns old data for all combinations of read and
// write on both ports

module mixed_width_true_dual_port_ram
  #(parameter int
    DATA_WIDTH1 = 8,
    ADDRESS_WIDTH1 = 32,
    ADDRESS_WIDTH2 = 30)
(
    input logic [ADDRESS_WIDTH1-1:0] addr1,
    input logic [ADDRESS_WIDTH2-1:0] addr2,
    input logic [DATA_WIDTH1      -1:0] data_in1, 
    input logic [DATA_WIDTH1*(1<<(ADDRESS_WIDTH1 - ADDRESS_WIDTH2))-1:0] data_in2, 
    input logic we1, we2, clk,
    output logic [DATA_WIDTH1-1      :0] data_out1,
    output logic [DATA_WIDTH1*(1<<(ADDRESS_WIDTH1 - ADDRESS_WIDTH2))-1:0] data_out2);
    
  localparam RATIO = 1 << (ADDRESS_WIDTH1 - ADDRESS_WIDTH2); // valid values are 2,4,8... family dependent
  localparam DATA_WIDTH2 = DATA_WIDTH1 * RATIO;
  localparam RAM_DEPTH = 1 << ADDRESS_WIDTH2;

  // Use a multi-dimensional packed array to model the different read/ram width
  logic [0:RATIO-1] [DATA_WIDTH1-1:0] ram[255:0];
    
  logic [DATA_WIDTH1-1:0] data_reg1;
  logic [DATA_WIDTH2-1:0] data_reg2;

  initial
    begin
      $readmemh("ram.dat", ram); 
    end

  // Port A
  always@(posedge clk)
  begin
    if(we1)
      ram[addr1 / RATIO][addr1 % RATIO] <= data_in1;
    data_reg1 <= ram[addr1 / RATIO][addr1 % RATIO];
  end
  assign data_out1 = data_reg1;

  // port B
  always@(posedge clk)
  begin
    if(we2)
      ram[addr2] <= data_in2;
    data_reg2 <= ram[addr2];
  end

  assign data_out2 = data_reg2;
endmodule
