`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:13:27 04/06/2016
// Design Name:   control
// Module Name:   C:/Users/kevin/Documents/CE_Lab/lab3/mips_control/control_tb.v
// Project Name:  mips_control
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_tb;

	// Inputs
	reg [5:0] op_code;

	// Outputs
	wire RegDst;
	wire ALUSrc;
	wire MemtoReg;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire Branch;
	wire ALUOp1;
	wire ALUOp0;

	// Instantiate the Unit Under Test (UUT)
	control uut (
		.op_code(op_code), 
		.RegDst(RegDst), 
		.ALUSrc(ALUSrc), 
		.MemtoReg(MemtoReg), 
		.RegWrite(RegWrite), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.Branch(Branch), 
		.ALUOp1(ALUOp1), 
		.ALUOp0(ALUOp0)
	);

	initial begin
		// Initialize Inputs
		op_code = 6'd0;

		// Wait 100 ns for global reset to finish
		#100 op_code = 6'd35;
        
        #100 op_code = 6'd43;
        
        #100 op_code = 6'd4;
        
        #100 op_code = 0;
		// Add stimulus here

	end
      
endmodule

