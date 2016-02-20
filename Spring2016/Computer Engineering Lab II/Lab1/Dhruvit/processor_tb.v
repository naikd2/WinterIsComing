`timescale 1ns / 1ps



module processor_tb;

	// Inputs
	reg clk;
	wire rst_n;
	reg [15:0] M;

	// Outputs
	wire [15:0] AC;
	wire [15:0] mem_out;
	wire wr_en;
    
   integer count = 0;
   reg [15:0] memory [25:0];

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

		clk = 0;
		
		memory[0000] <= 16'h6019;		// INC | A = 0
		memory[0001] <= 16'h0000;		// NOT | A = 0
		memory[0002] <= 16'h1000;		// NOT | A = 1
		memory[0003] <= 16'h7001;		// INC | A = 1
		
		memory[0004] <= 16'h2000;		// ADC | A = 0
		memory[0005] <= 16'h6012;		// INC | A = 0
		memory[0006] <= 16'h8018;		// STA | A = 0	| addr = 24
		memory[0007] <= 16'h6000;		// INC | A = 0
		memory[0008] <= 16'hA018;		// LDA | A = 0	| addr = 24
		
		
		memory[0009] <= 16'h3003;		// ADC | A = 1	| addr = 001
		memory[0010] <= 16'h0000;		// NOT | A = 0
		memory[0011] <= 16'h9000;		// STA | A = 1	| addr = 019
		memory[0012] <= 16'h6000;		// INC | A = 0
		memory[0013] <= 16'hB000;		// LDA | A = 1	| addr = 019
		memory[0014] <= 16'h5005;		// JPA | A = 1
		// Jumped
		memory[0015] <= 16'h0000;
		memory[0016] <= 16'h0000;
		memory[0017] <= 16'h0000;
		// Here
		memory[0018] <= 16'h8017;		// STA | A = 0
		memory[0019] <= 16'h0000;		// NOT | A = 0
		memory[0020] <= 16'h6000;		// NOT | A = 0
		memory[0021] <= 16'h2000;		// ADC | A = 0
		memory[0022] <= 16'h4000;
		// Jumps back to start

		memory[0023] <= 16'h0000;
		memory[0024] <= 16'h0000;
		memory[0025] <= 16'h0000;

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
      
		
		
	always @(*)
	begin
		if (processor_tb.uut.PRstate == 0)
			M <= memory[processor_tb.uut.PC];
		else
		processor_tb.uut.MD <= memory[processor_tb.uut.MA];
	end
	
	
	always @(posedge clk)
	begin
		if (wr_en)
			memory[processor_tb.uut.MA] <= mem_out;
	end

		
endmodule

