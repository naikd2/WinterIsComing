//////////////////////////////////////////////////////////////////////////////////
// Module Name:             mips_processor.v
// Create Date:             3/25/2016 
// Last Modification:       4/3/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             alu_control sub-module. Located within execution stage.
//                              Determines what operations are performed within the ALU
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module alu_control(ALUOp, funct, operation
    );

    input           [1:0]       ALUOp;
    input           [5:0]       funct;
    
    output wire     [2:0]       operation;
    
    
    
    assign operation =  (ALUOp == 2'b00)                                ? 3'b010:
                        (ALUOp == 2'b01;)                               ? 3'b110:
                        (ALUOp[1] == 1'b1 && funct[3:0] == 4'b0000)     ? 3'b010:
                        (ALUOp[1] == 1'b1 && funct[3:0] == 4'b0010)     ? 3'b110:
                        (ALUOp[1] == 1'b1 && funct[3:0] == 4'b0100)     ? 3'b000:
                        (ALUOp[1] == 1'b1 && funct[3:0] == 4'b0101)     ? 3'b001:
                        (ALUOp[1] == 1'b1 && funct[3:0] == 4'b1010)     ? 3'b111:
                        operation;
                    
    

endmodule
