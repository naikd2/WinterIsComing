`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:28:09 02/05/2016
// Design Name:   processor
// Module Name:   C:/Users/kevin/Documents/CE_Lab/simple_processor/processor_tb.v
// Project Name:  simple_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

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
    reg [15:0] memory [4095:0];		//instructions
	 reg [11:0] memory2 [2047:0];		//data

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
		memory[4095] = 12'd20;
		
		//Test Not
		//M = 16'h
		
		
		//Test increment
		//M = 16'h 
		
		//Test Jump without AM
		//M = 16'h4FFF; // 0100 1111 1111 1111
		
		//Test Jump with AM
		M = 16'h5FFF; //0101 1111 1111 1111

		// Wait 100 ns for global reset to finish
		#100;
        
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
	 
	//When bits 15:13 change in M, state changes which is undesirable
	//Possibly have 2 memories one with instructions and one with data
	 always @(*)
	 begin
		if(processor_tb.uut.PRstate == processor_tb.uut.S4) //MA 12 bits,  MD 16 bits, M 16 bits
		begin
			//$display("AM : %d", processor_tb.uut.AM);
			//$display("MA : %d", processor_tb.uut.MA);
			//$display("memory[processor_tb.uut.MA : %d", memory[processor_tb.uut.MA]);
			M[11:0] = memory2[processor_tb.uut.MA];
		end
	 end
      
endmodule

