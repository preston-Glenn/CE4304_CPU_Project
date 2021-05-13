module decoder_tb;

	// Inputs
	reg [3:0]  reg_dest;
	reg [3:0]  reg_source_1;
	reg [3:0]  reg_source_2;
	reg [15:0] immediate;
	reg [4:0]  opcode;
    reg [INSTRUCTION_WIDTH-1:0] instruction;

	// Outputs
	wire [15:0] read_data;

	// Instantiate the Unit Under Test (UUT)
	decode_instruction uut (
		instruction,
        reg_dest,     
        reg_source_1,  
        reg_source_2,  
        immediate,
        opcode,
	);
   integer c ;
	initial begin
		// Initialize Inputs

		clk = 0;


        clk <= clk + 1;
		#100;
        
        // program 1
        instruction <= 33'h011000010;
        clk <= clk + 1;
		#100;

        instruction <= 33'h012000020;
        clk <= clk + 1;
		#100;


        instruction <= 33'h052210000;
        clk <= clk + 1;
		#100;

        instruction <= 33'h030100030;
        clk <= clk + 1;
		#100;


        // program 2
        instruction <= 33'h021000000;
        clk <= clk + 1;
		#100;

        instruction <= 33'h022000000;
        clk <= clk + 1;
		#100;

        instruction <= 33'h02300000A;
        clk <= clk + 1;
		#100;

        instruction <= 33'h052210000;
        clk <= clk + 1;
		#100;

        instruction <= 33'h061000001;
        clk <= clk + 1;
		#100;

        instruction <= 33'h0E130FFFD
        clk <= clk + 1;
		#100;

        clk <= clk + 1;
		#100;

	end
      
endmodule
