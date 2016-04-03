//////////////////////////////////////////////////////////////////////////////////
// Module Name:             control.v
// Create Date:             4/3/2016 
// Last Modification:       4/3/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             control sub-module. Located within instruction decode step.
//                              Determines what operations are performed within processor
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module control(op_code, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0
    );
    
    input                       op_code;
    
    //Control Reg Values
    output reg                  RegDst;
    output reg                  ALUSrc;
    output reg                  MemtoReg;
    output reg                  RegWrite;
    output reg                  MemRead;
    output reg                  MemWrite;
    output reg                  Branch;
    output reg                  ALUOp1;
    output reg                  ALUOp0;
    
    
        //Control Bit Values
    always @(*)
    begin
        if(op_code == 6'd0) // R type
        begin
            RegDst      <= 1'b1;
            ALUSrc      <= 1'b0;
            MemtoReg    <= 1'b0;
            RegWrite    <= 1'b1;
            MemRead     <= 1'b0;
            MemWrite    <= 1'b0;
            Branch      <= 1'b0;
            ALUOp1      <= 1'b1;
            ALUOp0      <= 1'b0;
        end
        else if(op_code == 6'd35) // load word
        begin
            RegDst      <= 1'b0;
            ALUSrc      <= 1'b1;
            MemtoReg    <= 1'b1;
            RegWrite    <= 1'b1;
            MemRead     <= 1'b1;
            MemWrite    <= 1'b0;
            Branch      <= 1'b0;
            ALUOp1      <= 1'b0;
            ALUOp0      <= 1'b0;
        end
        else if(op_code == 6'd43) // store word
        begin
            RegDst      <= 1'bx;
            ALUSrc      <= 1'b1;
            MemtoReg    <= 1'bx;
            RegWrite    <= 1'b0;
            MemRead     <= 1'b0;
            MemWrite    <= 1'b1;
            Branch      <= 1'b0;
            ALUOp1      <= 1'b0;
            ALUOp0      <= 1'b0;
        end
        else if(op_code == 6'd4) // beq
        begin
            RegDst      <= 1'bx;
            ALUSrc      <= 1'b0;
            MemtoReg    <= 1'bx;
            RegWrite    <= 1'b0;
            MemRead     <= 1'b0;
            MemWrite    <= 1'b0;
            Branch      <= 1'b1;
            ALUOp1      <= 1'b0;
            ALUOp0      <= 1'b1;
        end
    end
    
endmodule