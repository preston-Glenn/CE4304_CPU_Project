// Here are the parameter definitions for all modules
parameter ADDRESS_BUS_WIDTH = 11 ;
parameter NUM_ADDRESS = 2048 ;
parameter PROGRAM_LOAD_ADRESS = 1024 ;
parameter DATA_BUS_WIDTH = 24 ;
parameter REGFILE_ADDR_BITS = 4 ;
parameter NUM_REGISTERS = 16 ;
parameter WIDTH_REGISTER_FILE = 24 ;
parameter INSTRUCTION_WIDTH = 33 ;
parameter IMMEDIATE_WIDTH = 16 ;
parameter NUM_INSTRUCTIONS = 32 ;
parameter WIDTH_OPCODE = 5 ;  // log 2 NUM_INSTRUCTIONS
// Decoded instructions:   Fill in these instructions
parameter INSTR_NOP = 0 ;
parameter INSTR_LR = 1 ;
parameter INSTR_LI  = 2 ;
parameter INSTR_SR  = 3 ;
parameter INSTR_MOVE = 4 ;
parameter INSTR_ADD = 5 ;
parameter INSTR_ADDI = 6 ;
parameter INSTR_SUB = 7 ;
parameter INSTR_CMP = 8 ;
parameter INSTR_AND = 9 ;
parameter INSTR_OR  = 10 ;
parameter INSTR_NOT = 11 ;
parameter INSTR_SHL  = 12 ;
parameter INSTR_SHR  = 13 ;
parameter INSTR_BNE = 14 ;
parameter INSTR_BE = 15 ;
//    register file index 4 it takes 3 bits to encode r0...r7
///   addr  --------------------
//          | 63            10 |
//       r0 |  .............   |      Address has nothing to do with the size of data!
//       r1 |  width of data   |      Address | Data tupple (A,D)
//          |                  |
//       .  |                  |
//       .  |                  |
//       .  |                  |
//          |                  |
//       r7 |                  |
//          |                  |
///         --------------------
//
