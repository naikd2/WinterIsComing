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
    reg [15:0] memory [255:0];

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
		M = 16'h0000;

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
      
endmodule

