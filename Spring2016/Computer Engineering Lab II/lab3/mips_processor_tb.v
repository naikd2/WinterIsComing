`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:32:23 04/06/2016
// Design Name:   mips_processor
// Module Name:   C:/Users/kevin/Documents/CE_Lab/lab3/lab3/mips_processor_tb.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips_processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_processor_tb;

	// Inputs
	reg clk;
	reg rst_n;
	reg [31:0] instr;

	// Outputs
	wire [31:0] pc_out;
	wire [31:0] wr_dat;
	wire [4:0] wr_reg;
    
    
    reg     [31:0]      instr_mem [0:32];

	// Instantiate the Unit Under Test (UUT)
	mips_processor uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.instr(instr), 
		.pc_out(pc_out), 
		.wr_dat(wr_dat), 
		.wr_reg(wr_reg)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		instr = 0;
        
        
        
        instr_mem[0] = 32'h01098020;            //add t0 t1 s0
        instr_mem[4] = 32'h014b8822;            //sub t2 t3 s1
        instr_mem[8] = 32'h018d9024;            //and t4 t5 s2
        instr_mem[12] = 32'h01cf9825;            //or t6 t7 s3
        instr_mem[16] = 32'h0319a02a;            //slt t8 t9 s4

		// Wait 100 ns for global reset to finish
		#5;
        rst_n = 1;
        
		// Add stimulus here

	end
    
    always
    begin
        forever
        begin
            #10 clk = ~clk;
        end
    end
    
    
    always @(posedge clk)
    begin
        instr <= instr_mem[pc_out];
    end
      
endmodule

