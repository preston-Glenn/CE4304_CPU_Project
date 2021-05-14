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
    
    wire [DATA_BUS_WIDTH-1:0] regfile_data ;
    wire [REGFILE_ADDR_BITS-1:0] reg_src_1;
    wire [REGFILE_ADDR_BITS-1:0] reg_src_2;
    wire [REGFILE_ADDR_BITS-1:0] reg_dest;
    wire [REGFILE_ADDR_BITS-1:0] reg_dest_data;

    wire [WIDTH_REGISTER_FILE-1:0] reg_src_1_data;
    wire [WIDTH_REGISTER_FILE-1:0] reg_src_2_data;
    
    wire [IMMEDIATE_WIDTH-1:0] immediate;
    wire [ADDRESS_BUS_WIDTH-1:0] pc_addr ;
    wire [ADDRESS_BUS_WIDTH-1:0] next_pc_addr ;
    wire [INSTRUCTION_WIDTH-1:0] instruction;
    wire [WIDTH_OPCODE-1:0] opcode;
    wire [1:0] pc_source;
	 wire [DATA_BUS_WIDTH-1:0] alu_reg_out;
	 wire [DATA_BUS_WIDTH-1:0] alu_out;

    wire [INSTRUCTION_WIDTH-1:0] iram_out;
    wire [DATA_BUS_WIDTH-1:0] dram_data;

    wire [1:0] alu_B_src;
    wire [DATA_BUS_WIDTH-1:0] alu_a_input;
    wire [DATA_BUS_WIDTH-1:0] alu_b_input;
    wire [DATA_BUS_WIDTH-1:0] alu_a_input_reg;
    wire [DATA_BUS_WIDTH-1:0] alu_b_input_reg;
    wire [DATA_BUS_WIDTH-1:0] dest_data_reg;
	wire [DATA_BUS_WIDTH-1:0] sign_extended ;
    wire [DATA_BUS_WIDTH-1:0] loaded_memory;

      // data address wires
    wire [ADDRESS_BUS_WIDTH-1:0] reset_address ;
    wire [ADDRESS_BUS_WIDTH-1:0] jump_address ;
	 wire [2:0] alu_ctrl;

    wire clock_delayed;

    assign reset_address = 11'd1024 ;
    assign jump_address = 11'd1024 ;

    assign program_out = dram_data ;

// MEMORY FILES

    assign #30 clock_delayed = clock ;
    iram instr_ram(
        .address(pc_addr),
        .data(iram_out),
        .read_not_write(VDD),
        .clk(clock_delayed)
    );

    regfile registers(
        .read_addr1(reg_src_1),
        .read_addr2(reg_src_2),
        .write_addr(reg_dest),
        .read_data1(reg_src_1_data),
        .read_data2(reg_src_2_data),
        .read_data3(reg_dest_data),
        .write_data(regfile_data),
        .write_enable(regfile_write_enable),
        .clk(clock)
    );

    // need mux for regfile data

    //WORK
    mux2 #(DATA_BUS_WIDTH) regfile_mux(
        .data0(alu_reg_out),
        .data1(loaded_memory),
        .select(mem_not_alu),
        .data_output(regfile_data)
    );

    dram data_ram (
        .address(alu_reg_out[ADDRESS_BUS_WIDTH-1:0]),
        .write_data(dest_data_reg), //store word
        .read_data(alu_b_input_reg), 
        .read_not_write(mem_read),
        .clk(clock),
        .cs(mem_select)
    );


    // TEMPORARY REGISTERS

    addr_register program_counter(
        .clk(clock), 
        .in_data(next_pc_addr), 
        .out_data(pc_addr),
        .en(pc_enabled)
    );


    instruction_register i_register(
        .clk(clock), 
        .in_data(iram_out), 
        .instruction(instruction),
        .en(enable_instr_reg)
    );

    data_register load_memory_register(
        .clk(clock_delayed), 
        .in_data(dram_data), 
        .out_data(loaded_memory),
        .en(mem_select)
    );

    data_register alu_out_register(
        .clk(clock), 
        .in_data(alu_out), 
        .out_data(alu_reg_out),
        .en(VDD)
    );

    // Program counter Mux

    mux4 pc_mux(
        .data0(alu_out),
        .data1(alu_reg_out),
        .data2(jump_address),
        .data3(reset_address),
        .select(pc_source),
        .data_output(next_pc_addr)
    );


	sign_extender se ( .src(immediate), .out1(sign_extended) ) ;


    // MUX's for ALU INPUT

    // WORK
    mux2 #(DATA_BUS_WIDTH) alu_A_mux(
        .data0({13'b0,pc_addr}),
        .data1(alu_a_input_reg),
        .select(alu_A_src),
        .data_output(alu_a_input)
    );

    //WORK
    mux4  #(DATA_BUS_WIDTH) alu_B_mux(
        .data0(alu_b_input_reg),
        .data1(24'b1),
        .data2(sign_extended),
        .data3(24'd1023), //error
        .select(alu_B_src),
        .data_output(alu_b_input)
    );
    // WORK
	data_register regA( 
    .clk(clock), 
    .in_data(reg_src_1_data), 
    .out_data(alu_a_input_reg),
    .en(VDD)
  ) ;
  
    // WORK
  data_register regB( 
    .clk(clock), 
    .in_data(reg_src_2_data), 
    .out_data(alu_b_input_reg),
    .en(VDD)
  ) ;

    data_register regDest( 
    .clk(clock), 
    .in_data(reg_dest_data), 
    .out_data(dest_data_reg),
    .en(VDD)
  ) ;
	

    alu ALU(
        .A(alu_a_input),
        .B(alu_b_input),
        .result(alu_out),
        .Alu_Op(alu_ctrl),
        .Z(zero)
    );

    decode_instruction instr_decoder(
        .instruction(instruction),
        .reg_dest(reg_dest),     
        .reg_source_1(reg_src_1),  
        .reg_source_2(reg_src_2),  
        .immediate(immediate),
        .opcode(opcode)
    );


    control controller(
        .clk(clock),                // CLOCK
        .reset(reset),              // RESET
        .instruction(instruction),            // OPCODE from decode
        .zero(zero),                // tells when alu output = 0

        .IR_Write(enable_instr_reg),    // enables writing to instruction register (where we store instruction)
        .MemToReg(mem_not_alu),         // selects if data being written into reg file is from mem FF or alu FF --- mem FF on Load ALU FF everything else :
        .Mem_Read_not_Write(mem_read), // enables reading from memory else writing to memory  
        .Mem_Select(mem_select),
        .PC_Source(pc_source),          // choose what is written to pc
        .pc_write_enable(pc_enabled),    // enable writing to pc
        .alu_src_a(alu_A_src),          // alu_src_a select
        .alu_src_b(alu_B_src),          // alu_src_b select
        .ALUop(alu_ctrl),     
        .RegWrite(regfile_write_enable)    
    );


  endmodule