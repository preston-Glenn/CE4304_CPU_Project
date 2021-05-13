// Inputs
	reg clock;
	reg reset;
   wire [15:0] program_out ;
	
	// Instantiate the Unit Under Test (UUT)
	Multi_Cycle_Computer uut (
		.clock(clock), 
		.reset(reset),
		.program_out(program_out)
	);


   integer c ;
	initial begin
		// Initialize Inputs
		
		clock = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for ( c = 0 ; c <= 4 ; c = c+1 ) begin
		   clock <= c ;
			reset <= 1 ;
			#100 ;
	   end
		
		for ( c = 0 ; c <= 40; c = c+1 ) begin
		   clock <= c ;
			reset <= 0 ;
			#100 ;
	   end
	
		

	end
      
endmodule

