




module Multi_Cycle_Computer(
    clock,
	reset,
	program_out
  ) ;
  `include "params.v"

  input clock ;
  input reset ;
  output [DATA_BUS_WIDTH-1:0] program_out ;

  supply1 VDD;


  wire [ADDRESS_BUS_WIDTH-1:0] pc_addr ;
  wire [ADDRESS_BUS_WIDTH-1:0] next_pc_addr ;
  wire [INSTRUCTION_WIDTH-1:0] instruction;


decode_instruction instr_decoder(
  instruction,
  reg_dest,     
  reg_source_1,  
  reg_source_2,  
  immediate,
  opcode
);









  endmodule