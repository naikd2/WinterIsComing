`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:59:59 03/25/2016
// Design Name:   alu
// Module Name:   H:/Computer_Engineering_Lab_II/lab3/alu/alu_tb.v
// Project Name:  alu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_tb;

	// Inputs
	reg [31:0] a;
	reg [31:0] b;
	reg [2:0] operation;
    
    wire [31:0] result;
    wire        zero;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.a(a), 
		.b(b), 
		.operation(operation),
        .result(result),
        .zero(zero)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		operation = 0;

		// Wait 100 ns for global reset to finish
		#100; // and 
        a = 32'h0000FFFF;
        b = 32'h00000001;
        operation = 3'b000;
        #100; // or
        operation = 3'b001;
        #100; // add
        operation = 3'b010;
        #100; // subtract
        operation = 3'b110;
        #100; // slt
        operation = 3'b111;
        #100;

		// Add stimulus here

	end
      
endmodule

