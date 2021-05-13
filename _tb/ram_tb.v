module data_ram_tb;

	// Inputs
	reg [10:0] address;
	reg [23:0] write_data;
	reg read_not_write;
	reg cs;
	reg clk;

	// Outputs
	wire [15:0] read_data;

	// Instantiate the Unit Under Test (UUT)
	dram uut (
		.address(address), 
		.write_data(write_data), 
		.read_data(read_data), 
		.read_not_write(read_not_write), 
		.cs(cs), 
		.clk(clk)
	);
   integer c ;
	initial begin
		// Initialize Inputs
		address = 0;
		write_data = 0;
		read_not_write = 1;
		cs = 1;
		clk = 0;

		// Wait 100 ns for global reset to finish
        clk <= clk + 1;
		#100;
        
        clk <= clk + 1;
		#100;

        clk <= clk + 1;
        address <= 12'd16 ;
        read_not_write <=0;
        write_data <= 23'd10;
		#100;

        clk <= clk + 1;
		#100;

        cs <= 1;
        clk <= clk + 1;
        address <= 12'd16 ;
        read_not_write <=0;
        write_data <= 23'd10;
		#100;


        clk <= clk + 1;
		#100;


        address <= 12'd16 ;
        read_not_write <=1;
        clk <= clk + 1;
		#100;

	end
      
endmodule
