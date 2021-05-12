
// Sample Instruction Set Architecture Design

module decode_instruction(
  instruction,
  reg_dest,     
  reg_source_1,  
  reg_source_2,  
  immediate,
  opcode,
  decoded) ;
  `include "params.v"

  input [INSTRUCTION_WIDTH-1:0] instruction ;
  output [REGFILE_ADDR_BITS-1:0] reg_source_1 ;
  output [REGFILE_ADDR_BITS-1:0] reg_source_2 ;
  output [REGFILE_ADDR_BITS-1:0] reg_dest ;
  output [IMMEDIATE_WIDTH-1:0] immediate ;
  output [WIDTH_OPCODE-1:0] opcode ;
  output [NUM_INSTRUCTIONS-1:0] decoded ;

  parameter OPCODE_LSB = INSTRUCTION_WIDTH - WIDTH_OPCODE ;
  assign opcode = instruction[INSTRUCTION_WIDTH-1:OPCODE_LSB];


  parameter DEST_LSB = OPCODE_LSB - REGFILE_ADDR_BITS ;
  assign reg_dest = instruction[OPCODE_LSB-1:DEST_LSB] ;
                                           
  parameter SRC1_LSB = DEST_LSB - REGFILE_ADDR_BITS ;                                          
  assign reg_source_1 = instruction[DEST_LSB-1:SRC1_LSB] ;
 
  parameter SRC2_LSB = SRC1_LSB - REGFILE_ADDR_BITS ;                                          
  assign reg_source_2 = instruction[SRC1_LSB-1:SRC2_LSB] ;


  assign immediate = instruction[IMMEDIATE_WIDTH-1:0] ;    
  

  // Instruction formats:
  // 
  // Instruction 1: NOP
  // ASSEMBLY: nop
  // opcode = INSTR_NOP
  // opcode | unused
  //   5    |   28      // 33 - 5  = 28
           
           
  // Instruction 2: Load Register
  // ASSEMBLY: lr RDest, RSource[Immediate] : lr R2, R1[0x10] or load ((R1)+0x10) into R2
  // opcode = INSTR_LR
  // opcode | reg_dest | reg_source_1 | unused | immediate   
  //   5    |    4     |      4       |   4    |    16     // 33 - 13 - 16 = 4
           
           
  // Instruction 3: Load Immeadiate
  // ASSEMBLY: li RDest, Immediate : li R1, 0x10     or load 0x10 into R1
  // opcode = INSTR_LR
  // opcode | reg_dest |  unused | immediate   
  //   5    |    4     |    8    |    16     // 33 - 9 - 16 = 8
           
           
  // Instruction 4: Save Register
  // ASSEMBLY: sr RDest[Immediate], RSrc : sr R1[0x10], R2       or save R2 into ((R1)+0x10)   
  // opcode = INSTR_SR
  // opcode | reg_dest | reg_source_1 | unused | immediate   
  //   5    |    4     |    4         |    4   |     16     // 33 - 13 - 16 = 6
         
                                                                            
  // Instruction 5: Move Register
  // ASSEMBLY: move RDest, RSource  ; move R1, R2    or  set R1 = R2
  // opcode = INSTR_MOVE
  // opcode | reg_dest | reg_source_1 |  unused  
  //   5    |    4     |       4      |   19    // 33 - 14  = 19
         
                                                                                                                                        
  // Instruction 6: Add Registers
  // ASSEMBLY: add RDest,RSrc_1, RSrc_2  ; add R3, R1, R2  or R3 = R1 + R2
  // opcode = INSTR_ADD
  // opcode | reg_dest | reg_source_1 | reg_source_2 | unused  
  //   5    |    4     |       4      |      4       |  16    // 33 - 17  = 16
        
        
  // Instruction 7: Add Immeadiate
  // ASSEMBLY: addi RDest, immeadiate  ; addi R1, 0x02 ;   or R1 = R1 + 0x02
  // opcode = INSTR_ADD
  // opcode | reg_dest |  unused  | immeadiate
  //   5    |    4     |    8     |    16      // 33 - 25  = 8  
      
      
  // Instruction 8: Subtract
  // ASSEMBLY: sub RDest, RSrc_1, RSrc_2  ; sub R3, R1, R2      or R3 <= R1 - R2 ;
  // opcode = INSTR_SUB
  // opcode | reg_dest | reg_source_1 | reg_source_2 | unused  
  //   5    |    4     |        4     |     4        |  16    // 33 - 17  = 16 
         
         
  // Instruction 9: Compare
  // ASSEMBLY: cmp RSrc_1, RSrc_2  ; cmp R1, R2 updates flag based off of R1-R2
  // opcode = INSTR_CMP
  // opcode | reg_source_1 | reg_source_2 |  unused  
  //   5    |        4     |       4      |    20    // 33 - 13  = 20
         
         
  // Instruction 10: And Registers
  // ASSEMBLY: and RDest,RSrc_1,RSrc_2  ;and R3,  R3 <= R1 & R2 ;
  // opcode = INSTR_AND
  // opcode | reg_dest | reg_source_1 | reg_source_2 | unused  
  //   5    |    4     |       4      |       4      |  16    // 33 - 17  = 16
       
       
  // Instruction 11: Or Registers
  // ASSEMBLY: or RDest,RSrc_1, RSrc_2  ; R3 <= R1 | R2 ;
  // opcode = INSTR_OR
  // opcode | reg_dest | reg_source_1 | reg_source_2 | unused  
  //   5    |    4     |       4      |      4       |  16    // 33 - 17  = 16
        
        
  // Instruction 12: Not Register
  // ASSEMBLY: not RDest, RSrc_1  ; R1 <= !R2;
  // opcode = INSTR_NOT
  // opcode | reg_dest | reg_source_1 | unused   
  //   5    |     4    |       4      |   20       // 33 - 13  = 20 
      
      
  // Instruction 13: Shift Left
  // ASSEMBLY: sl RDest, RSrc_1, 0x02  ;   R1 <= R2 << 0x02  
  // opcode = INSTR_SHL
  // opcode | reg_dest | reg_source_1 | unused | immediate   
  //   5    |    4     |      4       |   4    |    16     // 33 - 13 - 16 = 4
     
     
  // Instruction 14: Shift Right
  // ASSEMBLY: sr RDest, RSrc_1, 0x02  ;   R1 <= R2 >> 0x02  
  // opcode = INSTR_SHR
  // opcode | reg_dest | reg_source_1 | unused | immediate   
  //   5    |    4     |      4       |   4    |    16     // 33 - 13 - 16 = 4
     
     
  // Instruction 15: Branch  Equal
  // ASSEMBLY: beq RDest, RSource, Immediate : beq R2, R1, 0x10    
  // opcode = INSTR_BE
  // opcode | reg_dest | reg_source_1 | unused | immediate   
  //   5    |    4     |      4       |    4   |    16     // 33 - 13 - 16 = 4
  
  
  // Instruction 16: Branch Not Equal
  // ASSEMBLY: bneq RDest, RSource, Immediate : bneq R2, R1, 0x10 
  // opcode = INSTR_BNE
  // opcode | reg_dest | reg_source_1 | unused | immediate   
  //   5    |    4     |      4       |    4   |    16     // 33 - 13 - 16 = 4

  //**********************************************************************************************************************************************
  //**********************************************************************************************************************************************
  //**********************************************************************************************************************************************
    
    
   
  // Program C = A + B   A @ 0x10 B @ 0x20 C @ 0x30
  // lr R1, R0[0x10]
  // lr R2, R0[0x20]
  // add R2, R2, R1  ; R2 <= (R1) + (R2)
  // sr R0[0x30], R2
  //    
  
  
  // R0 has constant value of zero
  
  // Program machine encoding:
  // lr opcode = 1. lr R1, R0[0x10]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    4     |    4       |   4    |    16     // 33 - 13 - 16 = 4
  // 00001     0001        0000        0000      0000 0000 0001 0000
  // regroup bits:
  // 0 0001  0001     0000      0000   0000 0000 0001 0000
  // hex value:
  // 0x011000010
  //
  // lr opcode = 1. lr R2, R0[0x20]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    4     |    4       |   4    |    16     // 33 - 13 - 16 = 4
  // 00001     0010       0000         0000       0000 0010 0000
  // regroup bits:
  // 0 0010 0010   0000   0000   0000 0000 0010 0000
  // hex value:
  // 0x012000020
  //
  // add opcode = 5. add R2, R2, R1  ; R2 <= (R1) + (R2)
  // opcode | reg_dest | reg_source_1 | reg_source_2 | unused  
  //   5    |    4     |         4    |      4       |  16    
  // 0 0101     0010        0010         0001          0000 0000 0000 0000
  // regroup bits:
  // 0 0101  0010 0010  0001 0000 0000 0000 0000
  // hex value:
  // 0x052210000
  //
  // sr opcode = 3. sr Rd[immediate], Rsource
  // ASSEMBLY: sr RDest[Immediate], Rsource : sr R0[0x30], R2
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    4     |    4       |    4   |     16 
  // 00011     0000        0010         0000      0000 0000 0011 0000
  // regroup bits:
  // 0  0110 0000  0001 0000 0000 0000 0011 0000
  // hex value:
  // 0x030100030
  //
  // Program 1:
  // 0x011000010
  // 0x012000020
  // 0x052210000
  // 0x030100030
  //
  // Program 2:
  // int sum = 0 ;
  // for( i = 0 ; i <= 10 ; i++ ){
  //   sum += i ; 
  // }
  // Assembly code for sum progam here:
  // 
  // 
  // li  R1, 0x00     
  // li  R2, 0x00        
  // li  R3, 0x0A
  // add R2, R2, R1
  // addi R1, 0x01
  // bne R1, R3, -3
  //   

  // Machine code sum progam process:  
  
  // ASSEMBLY: li  R1, 0x00     
  // opcode = 2
  // opcode | reg_dest |  unused | immediate   
  //   5    |    4     |    8    |    16           
  // 00010     0001     0000  0000   0000 0000 0000 0000
  // regroup bits:
  // 0 0010 0001 0000 0000 0000 0000 0000 0000
  // hex value:
  // 0x021000000
                       
                         
  // ASSEMBLY: li  R2, 0x00     
  // opcode = 2
  // opcode | reg_dest |  unused | immediate   
  //   5    |    4     |    8    |    16           
  // 00010     0010     0000  0000   0000 0000 0000 0000
  // regroup bits:
  // 0 0010 0010 0000 0000 0000 0000 0000 0000
  // hex value:
  // 0x022000000
                             
                             
  // ASSEMBLY: li  R3, 0x0A     
  // opcode = 2
  // opcode | reg_dest |  unused | immediate   
  //   5    |    4     |    8    |    16           
  // 00010     0011     0000  0000   0000 0000 0000 1010
  // regroup bits:
  // 0 0010 0011 0000 0000 0000 0000 0000 1010
  // hex value:
  // 0x02300000A     
  
  // ASSEMBLY: add R2, R2, R1
  // opcode = 5
  // opcode | reg_dest | reg_source_1 | reg_source_2 | unused  
  //   5    |    4     |      4       |      4       |  16    
  // 0 0101     0010        0010          0001         0000 0000 0000 0000
  // hex code: 0x052210000       
        
  // ASSEMBLY: addi R1, 0x01
  // opcode = 6
  // opcode | reg_dest |  unused  | immeadiate
  //   5    |    4     |    8     |    16
  // 0 0110     0001    0000 0000    0000 0000 0000 0001
  // hex code: 0x061000001
  
  // ASSEMBLY: bne R1, R3, -3 
  // opcode = 14
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    4     |    4       |    4   |    16 
  // 0 1110     0001       0011        0000     1111 1111 1111 1101 (2's complement of -3) 
  // hex code: 0x0E130FFFD  
  
  
  // Machine code sum progam here:  
  // 0x021000000
  // 0x022000000
  // 0x02300000A
  // 0x052210000
  // 0x061000001
  // 0x0E130FFFD
  //
    
endmodule

                                
  
  
  
  
                                
                      