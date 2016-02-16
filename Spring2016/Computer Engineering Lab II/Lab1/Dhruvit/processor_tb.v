`timescale 1ns / 1ps



module processor_tb;

	// Inputs
	reg clk;
	wire rst_n;
	reg [15:0] M;

	// Outputs
	wire [15:0] AC;
	reg [15:0] mem_out;
	wire wr_en;
    
   integer count = 0;
   reg [15:0] memory [2047:0];

	// Instantiate the Unit Under Test (UUT)
	processor uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.AC(AC), 
		.mem_out(mem_out), 
		.wr_en(wr_en), 
		.M(M)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		//M = 16'b0110000000000000;

		// Wait 100 ns for global reset to finish
		#1000;
		//M = 16'b0010000000000000;
		
        
		// Add stimulus here

	end
    
    always
    begin
        forever
        begin
            #5 clk = ~clk;
            count = count + 1;                                                                                  
        end
    end
    
    assign rst_n = !(count < 20);
      
		
		
		
		// MEMORY ADDRESS
		
		//processor_tb.uut.MA
	always @(*)
	begin
	
		if(!rst_n)
			begin
			
			memory[2047] <= 0'b0; 
			memory[2046] <= 0'b0;
			memory[2045] <= 0'b0;
			memory[2044] <= 0'b0;
			memory[2043] <= 0'b0;
			memory[2042] <= 0'b0;
			
			memory[0000] <= 16'b0110000000000000;  	// INC 
			memory[0001] <= 16'b0110000000000000;		// INC
			//memory[0002] <= 16'b0110000000001000;	// INC
			//memory[0003] <= 16'b0100000000000001;	// JPA A = 0
			//memory[0003] <= 16'b0101000000000001;	// JPA A = 1
			//memory[0002] <= 16'b1000000000000000;  	// STA A = 0 
			memory[0002] <= 16'b1001000000000000;  	// STA A = 1
			memory[0003] <= 16'b0110000000000000;		// INC 
			end
		else 
			begin
				if (wr_en) 
					begin
						memory[processor_tb.uut.MA] <= mem_out;
					end
				else
					begin
						processor_tb.uut.MD <= memory[processor_tb.uut.MA];
			
						memory[2047] <= processor_tb.uut.AC; 
						memory[2046] <= processor_tb.uut.IR;
						memory[2045] <= processor_tb.uut.MD;
						memory[2044] <= processor_tb.uut.PC; 
						memory[2043] <= processor_tb.uut.MA;
						memory[2042] <= processor_tb.uut.AM;
			
						M <= memory[processor_tb.uut.PC];
					end
			
			
	
			end
	end

		
endmodule

