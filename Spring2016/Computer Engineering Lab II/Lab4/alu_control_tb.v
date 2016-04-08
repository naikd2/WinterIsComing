`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:27:19 04/06/2016
// Design Name:   alu_control
// Module Name:   C:/Users/kevin/Documents/CE_Lab/lab3/mips_alu_control/alu_control_tb.v
// Project Name:  mips_alu_control
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu_control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_control_tb;

	// Inputs
	reg [1:0] ALUOp;
	reg [5:0] funct;

	// Outputs
	wire [2:0] operation;

	// Instantiate the Unit Under Test (UUT)
	alu_control uut (
		.ALUOp(ALUOp), 
		.funct(funct), 
		.operation(operation)
	);

	initial begin
		// Initialize Inputs
		ALUOp = 2'b00;
		funct = 4'b0000;

		// Wait 100 ns for global reset to finish
		#100;
        ALUOp = 2'b01;
        
        #100;
        ALUOp[1] = 1'b1;
        funct = 4'b0000;
        
        #100;
        ALUOp[1] = 1'b1;
        funct[3:0] = 4'b0010;
        
        #100;
        ALUOp[1] = 1'b1;
        funct[3:0] = 4'b0100;
        
        #100;
        ALUOp[1] = 1'b1;
        funct[3:0] = 4'b0101;
        
        #100;
        ALUOp[1] = 1'b1;
        funct[3:0] = 4'b1010;
        
        #100;
		// Add stimulus here

	end
      
endmodule

                    
