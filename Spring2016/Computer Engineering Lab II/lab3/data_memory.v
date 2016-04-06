//////////////////////////////////////////////////////////////////////////////////
// Module Name:             data_memory.v
// Create Date:             4/6/2016 
// Last Modification:       4/6/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             data memory of MIPS processor
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module data_memory(clk, rst_n, MemRead, MemWrite, address, write_data, read_data
    );

    input                       clk;
    input                       rst_n;
    
    input                       MemRead;
    input                       MemWrite;
    
    input           [31:0]      address;
    input           [31:0]      write_data;
    
    output reg      [31:0]      read_data;
    
    reg             [31:0]      memory [0:15];
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            memory[ 0] <= 32'd0;
            memory[ 1] <= 32'd1;
            memory[ 2] <= 32'd2;
            memory[ 3] <= 32'd3;
            memory[ 4] <= 32'd4;
            memory[ 5] <= 32'd5;
            memory[ 6] <= 32'd6;
            memory[ 7] <= 32'd7;
            memory[ 8] <= 32'd8;
            memory[ 9] <= 32'd9;
            memory[10] <= 32'd10;
            memory[11] <= 32'd11;
            memory[12] <= 32'd12;
            memory[13] <= 32'd13;
            memory[14] <= 32'd14;
            memory[15] <= 32'd15;
        end
        else if(MemRead)
        begin
            read_data <= memory[address];
        end
        else if(MemWrite)
        begin
            memory[address] <= write_data;
        end
    end

                    
    

endmodule
