`timescale 1ns / 1ps


module iram(
    address,
    data,
    read_not_write,
    clk   
);
`include "params.v"

input [ADDRESS_BUS_WIDTH-1:0]address;
inout [INSTRUCTION_WIDTH-1:0] data;
input read_not_write;
input clk;

parameter NUM_INSTR_WORDS = NUM_ADDRESS; // Bytes for  instr_width / bytes for address_width
//parameter NUM_INSTR_WORDS = 64 ;
reg [INSTRUCTION_WIDTH-1:0] memory [NUM_INSTR_WORDS-1:0];
reg [INSTRUCTION_WIDTH-1:0] current_value;


// Place instructions here
initial begin
memory[1024] = 33'h011000010;
memory[1025] = 33'h012000020;
memory[1026] = 33'h052210000;
memory[1027] = 33'h032000030;

  // Program 1:
  // 0x011000010
  // 0x012000020
  // 0x052210000
  // 0x030200030


  // PROGRAM 2
  // 0x021000000
  // 0x022000000
  // 0x02300000A
  // 0x052210000


end



always @(posedge clk) begin
    if(read_not_write)
        current_value <= memory[address];
    else
        memory[address] <= data;
end
assign data = current_value;

endmodule

// since Data_BUS_Width is 24 and each address is byte oriented we get PC = PC + 1