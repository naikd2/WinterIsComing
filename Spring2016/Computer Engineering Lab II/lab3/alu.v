`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:25 03/25/2016 
// Design Name: 
// Module Name:    alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu(a, b, operation, result, zero
    );

    input           [31:0]      a;
    input           [31:0]      b;
    input           [2:0]       operation;
    
    output wire     [31:0]      result;
    output wire                 zero;
    
    
    localparam              AND = 3'b000;
    localparam              OR  = 3'b001;
    localparam              ADD = 3'b010;
    localparam              SUB = 3'b110;
    localparam              SLT = 3'b111;
    
    
    assign result = (operation == AND) ? a & b:
                    (operation == OR)  ? a | b:
                    (operation == ADD) ? a + b:
                    (operation == SUB) ? a - b:
                    (operation == SLT) ? a < b:
                    result;
                    
    assign zero =   (result == 32'd0)  ?  1'b0:
                    zero;
    

endmodule
