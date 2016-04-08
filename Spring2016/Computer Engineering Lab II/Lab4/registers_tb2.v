`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:51:29 04/06/2016
// Design Name:   registers
// Module Name:   C:/Users/kevin/Documents/CE_Lab/lab3/mips_registers/registers_tb2.v
// Project Name:  mips_registers
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: registers
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module registers_tb2;

	// Inputs
	reg clk;
	reg rst_n;
	reg [4:0] rs;
	reg [4:0] rt;
	reg [4:0] wr_reg;
	reg [31:0] wr_dat;
	reg RegWrite;
    
    integer count = 0;

	// Outputs
	wire [31:0] read_dat1;
	wire [31:0] read_dat2;

	// Instantiate the Unit Under Test (UUT)
	registers uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.rs(rs), 
		.rt(rt), 
		.wr_reg(wr_reg), 
		.wr_dat(wr_dat), 
		.read_dat1(read_dat1), 
		.read_dat2(read_dat2), 
		.RegWrite(RegWrite)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		rs = 0;
		rt = 0;
		wr_reg = 0;
		wr_dat = 32'd200;
		RegWrite = 1;
        
        #10 rst_n = 1;

		// Wait 100 ns for global reset to finish
        
		// Add stimulus here

	end
    
    always
    begin
        forever
        begin
            #10 clk = ~clk;
            count = count + 1;
        end
    end
    
    always @(posedge clk)
    begin
        if(count < 52)
        begin
            wr_reg <= wr_reg + 1'b1;
        end
    end
      
endmodule

