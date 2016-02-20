`timescale 1ns / 1ps



module processor_tb;

	// Inputs
	reg                 clk;
	wire                rst_n;
	reg     [15:0]      M;

	// Outputs
	wire    [15:0]      AC;
	wire    [15:0]      mem_out;
	wire                wr_en;
    
    // Internal Variables
    integer             count = 0;
    reg     [15:0]      memory [25:0];

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
		
        // Initialize memory data and instructions
		memory[0000] <= 16'h6019;		// INC | A = 0
		memory[0001] <= 16'h0000;		// NOT | A = 0
		memory[0002] <= 16'h1000;		// NOT | A = 1
		memory[0003] <= 16'h7001;		// INC | A = 1
		
		memory[0004] <= 16'h2000;		// ADC | A = 0
		memory[0005] <= 16'h6012;		// INC | A = 0
		memory[0006] <= 16'h8018;		// STA | A = 0	| Store in memory[24]
		memory[0007] <= 16'h6000;		// INC | A = 0
		memory[0008] <= 16'hA018;		// LDA | A = 0	| Load from memory[24]
		
		
		memory[0009] <= 16'h3003;		// ADC | A = 1	| Add value from memory[1]
		memory[0010] <= 16'h0000;		// NOT | A = 0
		memory[0011] <= 16'h9000;		// STA | A = 1	| store in memory[25]
		memory[0012] <= 16'h6000;		// INC | A = 0
		memory[0013] <= 16'hB000;		// LDA | A = 1	| Load from memory[25]
		memory[0014] <= 16'h5005;		// JPA | A = 1  | Jump to memory[18]
		// Jumped
		memory[0015] <= 16'h0000;
		memory[0016] <= 16'h0000;
		memory[0017] <= 16'h0000;
		// Here
		memory[0018] <= 16'h8017;		// STA | A = 0  | Store in memory[23]
		memory[0019] <= 16'h0000;		// NOT | A = 0
		memory[0020] <= 16'h6000;		// NOT | A = 0
		memory[0021] <= 16'h2000;		// ADC | A = 0 
		memory[0022] <= 16'h4000;       // JPA | A = 0  | Jump to memory[0]
		// Jumps back to start

		memory[0023] <= 16'h0000;
		memory[0024] <= 16'h0000;
		memory[0025] <= 16'h0000;

	end
    
    
    // Defining master clock
    always
    begin
        forever
        begin
            #5 clk = ~clk;
            count = count + 1;                                                                                  
        end
    end
    
    // Set negedge reset as high after 10 clock cycles
    assign rst_n = !(count < 20);
    
   
      
	// Assigning data/instruction input to processor.v			
	always @(*)
	begin
		if (processor_tb.uut.PRstate == 0)
			M <= memory[processor_tb.uut.PC];
		else
            processor_tb.uut.MD <= memory[processor_tb.uut.MA];
	end
	
	
    // Write output of mem_out to memory if wr_en is high
	always @(posedge clk)
	begin
		if (wr_en)
			memory[processor_tb.uut.MA] <= mem_out;
	end

		
endmodule

