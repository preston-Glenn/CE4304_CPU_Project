`timescale 1ns / 1ps




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
    wire [WIDTH_OPCODE-1:0] opcode;
    wire [1:0] pc_source;


    wire [1:0] alu_b_ctr;
    wire [DATA_BUS_WIDTH-1:0] alu_a_input;
    wire [DATA_BUS_WIDTH-1:0] alu_b_input;

    instr_ram iram(

    );

    registers regfile(

    );


    data_ram dram(

    );





    // TEMPORARY REGISTERS

    program_counter addr_register(
        clk(), 
        in_data(), 
        out_data(),
        en()
    );


    instr_register inst_register(

    );

    alu_out_register data_register(
        clk(clock), 
        in_data(alu_out), 
        out_data(alu_reg_out),
        en()
    );

    // Program counter Mux

    pc_mux mux4(
        data0(),
        data1(),
        data2(),
        data3(24'b1024),
        select(pc_source),
        data_output()
    );


    // MUX's for ALU INPUT

    alu_A_mux #(DATA_BUS_WIDTH) mux2(
        data0(),
        data1(),
        select(),
        data_output(alu_a_input)
    );

    alu_B_mux #(DATA_BUS_WIDTH) mux4(
        data0(),
        data1(),
        data2(),
        data3(),
        select(),
        data_output(alu_b_input)
    );



    ALU alu(
        A(alu_a_input),
        B(alu_b_input),
        result(alu_out),
        Alu_Op(alu_ctrl),
        Z(zero)
    );

    decode_instruction instr_decoder(
        instruction(),
        reg_dest(),     
        reg_source_1(),  
        reg_source_2(),  
        immediate(),
        opcode()
    );








    controller control(
        clk(clock),                // CLOCK
        reset(reset),              // RESET
        opcode(opcode),             // OPCODE from decode
        zero(zero),               // tells when alu output = 0

        IR_Write(enable_instr_reg),    // enables writing to instruction register (where we store instruction)
        MemToReg(mem_not_alu),         // selects if data being written into reg file is from mem FF or alu FF --- mem FF on Load ALU FF everything else :
        Mem_Read_not_Write(read_not_write), // enables reading from memory else writing to memory  
        Mem_Select(),
        PC_Source(pc_source),          // choose what is written to pc
        pc_write_enable(pc_enabled),    // enable writing to pc
        alu_src_a(alu_a_ctr),          // alu_src_a select
        alu_src_b(alu_b_ctr),          // alu_src_b select
        ALUop(alu_ctrl),     
        RegWrite(enable_regfile_write)    
    );












  endmodule