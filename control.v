`timescale 1ns / 1ps






module control(
clk,                // CLOCK
reset,              // RESET
opcode,             // OPCODE from decode
zero,               // tells when alu output = 0

IR_Write,    // enables writing to instruction register (where we store instruction)
MemToReg,         // selects if data being written into reg file is from mem FF or alu FF --- mem FF on Load ALU FF everything else :
Mem_Read_not_Write, // enables reading from memory else writing to memory  
Mem_Select,
PC_Source,          // choose what is written to pc
pc_write_enable,    // enable writing to pc
alu_src_a,          // alu_src_a select
alu_src_b,          // alu_src_b select
ALUop,     
RegWrite,    


);
input clk;
input reset ;              
input [WIDTH_OPCODE-1:0] opcode ; 

output IR_Write ;     
output MemToReg ;          
output Mem_Read_not_Write ; 
output alu_src_a ;           
output [1:0] alu_src_b ;  
output [1:0] PC_Source ;           
output pc_write_enable ;    
output ALUop;  
output RegWrite;
output Mem_Select;    


parameter NUM_STATE_BITS = 4;

parameter TRUE  = 1'b1;
parameter FALSE = 1'b0;

parameter STATE_RESET = 0 ;
parameter STATE_IF = 1 ;
parameter STATE_ID = 2 ;
parameter STATE_R_EXE = 3 ;
parameter STATE_LR_ADDR = 4 ;
parameter STATE_SR_ADDR = 5 ;
parameter STATE_BRANCH_NEQ = 6 ;
parameter STATE_MOVE = 7 ;
parameter STATE_LI = 8 ;
parameter STATE_MEM_READ = 9 ;
parameter STATE_MEM_WRITEBACK = 10 ;
parameter STATE_MEM_STORE = 11 ;
parameter STATE_ALU_WB = 12 ;
parameter STATE_ERROR = 13 ;




parameter ALU_OP_ADD = 0 ;
parameter ALU_OP_SUB = 1 ;

parameter ALU_SRC_A_PC_ENABLE = 1'b0 ;
parameter ALU_SRC_A_REG_SRC = 1'b1 ;

parameter ALU_SRC_B_REG_SRC   = 2'd0 ;
parameter ALU_SRC_B_PLUS_1    = 2'd1 ;
parameter ALU_SRC_B_IMM_BYTES = 2'd2 ;

parameter DATA_SELECT_ALU_OUT = 1'b0 ;
parameter DATA_SELECT_MEMORY = 1'b1 ;

// PC select mux value
parameter PC_SELECT_ALU = 2'b0 ;
parameter PC_SELECT_ALU_BUF = 2'b1 ;
parameter PC_SELECT_JUMP = 2'b2 ;
parameter PC_SELECT_RESET = 2'b3 ;


reg [NUM_STATE_BITS-1:0] current_state ;
reg [NUM_STATE_BITS-1:0] next_state ;

always @ (posedge clk) begin
    if( reset )
        current_state <= STATE_RESET ;
    else 
        current_state <= next_state ;
end

always @(current_state or opcode or zero ) begin
    
    IR_Write <= 1'b0;     
    MemToReg <= 1'b0;          
    Mem_Read_not_Write <= 1'b0; 
    alu_src_a <= 1'b0;           
    alu_src_b <= 2'b00;  
    PC_Source <= 2'b00;           
    pc_write_enable <= 1'b0;    
    ALUop <= ALU_OP_ADD;
    RegWrite <= FALSE;
    Mem_Select <= FALSE;
    MemToReg <= DATA_SELECT_ALU_OUT;

 case (current_state)
     STATE_RESET: begin
        next_state <= STATE_IF;
        PC_Source <= PC_SELECT_RESET;
        pc_write_enable <= 1'b1;
        RegWrite <= FALSE;
        Mem_Select <= FALSE; 
        MemToReg <= DATA_SELECT_ALU_OUT;
        IR_Write <= 1'b0; 
        alu_src_a <= 1'b0;           
        alu_src_b <= 2'b00;
        ALUop <= ALU_OP_ADD;
        Mem_Read_not_Write <= TRUE; // not needed
        // everything else can be as initialized

     end
     STATE_IF: begin
        next_state <= STATE_ID;
        PC_Source  <= PC_SELECT_ALU;
        pc_write_enable <= TRUE;
        RegWrite <= FALSE;

        IR_Write <= TRUE
        alu_src_a <=  ALU_SRC_A_PC_ENABLE;
        alu_src_b <=  ALU_SRC_B_PLUS_1;
        Mem_Read_not_Write <= TRUE; // either or, since mem_select disabled
        Mem_Select <= FALSE;
        ALUop <= ALU_OP_ADD;
     end
     STATE_ID: begin
        pc_write_enable  <= FALSE;
        IR_Write  <= FALSE;
        alu_src_a <=  ALU_SRC_A_PC_ENABLE;
        alu_src_b <=  ALU_SRC_B_IMM_BYTES;
        Mem_Read_not_Write <= TRUE;
        ALUop <= ALU_OP_ADD;
         
        case( opcode )
            INSTR_NOP:  next_state <= STATE_IF ;    //good
            INSTR_ADD:  next_state <= STATE_R_EXE ;
            INSTR_ADDI: next_state <= STATE_R_EXE ;            
            INSTR_LR:   next_state <= STATE_LR_ADDR ;//good
            INSTR_SR:   next_state <= STATE_SR_ADDR ;//good
            INSTR_BNEQ: next_state <= STATE_BRANCH_NEQ ;
            INSTR_LI:   next_state <= STATE_R_EXE ;             // treat as addi + $0; //addi functions as li in his example
            default:    next_state <= STATE_ERROR ;//good
        endcase
     end
     STATE_LR_ADDR: begin
        next_state <= STATE_MEM_READ;
        alu_src_a <= ALU_SRC_A_REG_SRC;
        alu_src_b <= ALU_SRC_B_IMM_BYTES;
        ALUop <= ALU_OP_ADD;
     end
     STATE_SR_ADDR: begin
        next_state <= STATE_MEM_STORE;
        alu_src_a <= TRUE;
        alu_src_b <= ALU_SRC_B_IMM_BYTES;
        ALUop <= ALU_OP_ADD;

     end
     STATE_MEM_READ: begin
        next_state <= STATE_MEM_WRITEBACK;
        Mem_Read_not_Write <= TRUE;//read
        Mem_Select <= TRUE;

     end
     STATE_MEM_WRITEBACK: begin
        next_state <= STATE_IF;
        Mem_Select <= TRUE;
        RegWrite <= TRUE;
        MemToReg <= DATA_SELECT_MEMORY;

     end
     STATE_MEM_STORE: begin
        next_state <= STATE_IF;
        Mem_Read_not_Write <= FALSE; //write
        Mem_Select <= TRUE;
         
     end
     STATE_R_EXE: begin
         ALUop <= ALU_OP_ADD;
         next_state <= STATE_ALU_WB ;
         case(opcode)
            INSTR_ADD: begin
                alu_src_a <=  ALU_SRC_A_REG_SRC;
                alu_src_b <=  ALU_SRC_B_REG_SRC;
            end
            INSTR_ADDI: begin
                alu_src_a <= ALU_SRC_A_REG_SRC ;
                alu_src_b <= ALU_SRC_B_IMM_BYTES ;
            end
            INSTR_LI: begin
                alu_src_a <=  ALU_SRC_A_REG_SRC;
                alu_src_b <=  ALU_SRC_B_IMM_BYTES;
            end
     end
     STATE_ALU_WB: begin
         next_state <= STATE_IF ;
         RegWrite <= TRUE; //write
         MemToReg <= DATA_SELECT_ALU_OUT;
     end

     STATE_BRANCH_NEQ: begin
        next_state <= STATE_IF;
        alu_src_a <= TRUE;
        alu_src_b <= ALU_SRC_B_REG_SRC;
        ALUop <= ALU_OP_SUB;
        if(zero): // if they are equal aka zero, then dont branch
            pc_write_enable <= FALSE;
        else begin
            pc_write_enable <= TRUE;
            PC_Source <= PC_SELECT_ALU_BUF;
        end
     end

     default: begin
        next_state <= STATE_RESET ;
        PC_Source <= PC_SELECT_RESET;
        pc_write_enable <= 1'b1;
        RegWrite <= FALSE;
        Mem_Select <= FALSE; 
        MemToReg <= DATA_SELECT_ALU_OUT;
        IR_Write <= 1'b0; 
        alu_src_a <= 1'b0;           
        alu_src_b <= 2'b00;
        ALUop <= ALU_OP_ADD;
        Mem_Read_not_Write <= TRUE; // not needed

     end
        
    
 endcase


end



endmodule