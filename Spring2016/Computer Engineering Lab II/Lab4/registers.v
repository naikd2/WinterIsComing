//////////////////////////////////////////////////////////////////////////////////
// Module Name:             registers.v
// Create Date:             4/3/2016 
// Last Modification:       4/3/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             Contains all register values being read and written to
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module registers(clk, rst_n, rs, rt, wr_reg, wr_dat, read_dat1, read_dat2, RegWrite
    );
    
    input                       clk;
    input                       rst_n;
    
    input           [ 4:0]      rs;
    input           [ 4:0]      rt;
    input           [ 4:0]      wr_reg;
    input           [31:0]      wr_dat;
    input                       RegWrite;               //Control bit, specifies if to write to register
    
    output reg      [31:0]      read_dat1;
    output reg      [31:0]      read_dat2;
    
    //Registers
    
    localparam                  zero = 32'd0;            //zero constant, Value 0
    
    //Values for function and expression results
    reg             [31:0]      v0;                     //Value 2
    reg             [31:0]      v1;                     //Value 3
    
    //Arguments
    reg             [31:0]      a0;                     //Value 4
    reg             [31:0]      a1;                     //Value 5
    reg             [31:0]      a2;                     //Value 6
    reg             [31:0]      a3;                     //Value 7
    
    //Temporaries
    reg             [31:0]      t0;                     //Value 8
    reg             [31:0]      t1;                     //Value 9
    reg             [31:0]      t2;                     //Value 10
    reg             [31:0]      t3;                     //Value 11
    reg             [31:0]      t4;                     //Value 12
    reg             [31:0]      t5;                     //Value 13
    reg             [31:0]      t6;                     //Value 14
    reg             [31:0]      t7;                     //Value 15
    reg             [31:0]      t8;                     //Value 24
    reg             [31:0]      t9;                     //Value 25
    
    //Saved Temporaries
    reg             [31:0]      s0;                     //Value 16
    reg             [31:0]      s1;                     //Value 17
    reg             [31:0]      s2;                     //Value 18
    reg             [31:0]      s3;                     //Value 19
    reg             [31:0]      s4;                     //Value 20
    reg             [31:0]      s5;                     //Value 21
    reg             [31:0]      s6;                     //Value 22
    reg             [31:0]      s7;                     //Value 23
    
    always @(*)
    begin
        case(rs)
            0:  read_dat1 <= zero;
            2:  read_dat1 <= v0;
            3:  read_dat1 <= v1;
            4:  read_dat1 <= a0;
            5:  read_dat1 <= a1;
            6:  read_dat1 <= a2;
            7:  read_dat1 <= a3;
            8:  read_dat1 <= t0;
            9:  read_dat1 <= t1;
            10: read_dat1 <= t2;
            11: read_dat1 <= t3;
            12: read_dat1 <= t4;
            13: read_dat1 <= t5;
            14: read_dat1 <= t6;
            15: read_dat1 <= t7;
            16: read_dat1 <= s0;
            17: read_dat1 <= s1;
            18: read_dat1 <= s2;
            19: read_dat1 <= s3;
            20: read_dat1 <= s4;
            21: read_dat1 <= s5;
            22: read_dat1 <= s6;
            23: read_dat1 <= s7;
            24: read_dat1 <= t8;
            25: read_dat1 <= t9;
        endcase
    end
    
    
    always @(*)
    begin
        case(rt)
            0:  read_dat2 <= zero;
            2:  read_dat2 <= v0;
            3:  read_dat2 <= v1;
            4:  read_dat2 <= a0;
            5:  read_dat2 <= a1;
            6:  read_dat2 <= a2;
            7:  read_dat2 <= a3;
            8:  read_dat2 <= t0;
            9:  read_dat2 <= t1;
            10: read_dat2 <= t2;
            11: read_dat2 <= t3;
            12: read_dat2 <= t4;
            13: read_dat2 <= t5;
            14: read_dat2 <= t6;
            15: read_dat2 <= t7;
            16: read_dat2 <= s0;
            17: read_dat2 <= s1;
            18: read_dat2 <= s2;
            19: read_dat2 <= s3;
            20: read_dat2 <= s4;
            21: read_dat2 <= s5;
            22: read_dat2 <= s6;
            23: read_dat2 <= s7;
            24: read_dat2 <= t8;
            25: read_dat2 <= t9;
        endcase
    end
    
    //Part of the write back stage
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            v0 <= 32'd2;
            v1 <= 32'd3;
            
            a0 <= 32'd4;
            a1 <= 32'd5;
            a2 <= 32'd6;
            a3 <= 32'd7;
            
            t0 <= 32'd8;
            t1 <= 32'd9;
            t2 <= 32'd10;
            t3 <= 32'd11;
            t4 <= 32'd12;
            t5 <= 32'd13;
            t6 <= 32'd14;
            t7 <= 32'd15;
            t8 <= 32'd24;
            t9 <= 32'd25;
            
            s0 <= 32'd16;
            s1 <= 32'd17;
            s2 <= 32'd18;
            s3 <= 32'd19;
            s4 <= 32'd20;
            s5 <= 32'd21;
            s6 <= 32'd22;
            s7 <= 32'd22;
        end
        else if(RegWrite == 1'b1)
        begin
            case(wr_reg)
                5'b00010:  v0 <= wr_dat;
                5'b00011:  v1 <= wr_dat;
                5'b00100:  a0 <= wr_dat;
                5'b00101:  a1 <= wr_dat;
                5'b00110:  a2 <= wr_dat;
                5'b00111:  a3 <= wr_dat;
                5'b01000:  t0 <= wr_dat;
                5'b01001:  t1 <= wr_dat;
                5'b01010: t2 <= wr_dat;
                5'b01011: t3 <= wr_dat;
                5'b01100: t4 <= wr_dat;
                5'b01101: t5 <= wr_dat;
                5'b01110: t6 <= wr_dat;
                5'b01111: t7 <= wr_dat;
                5'b10000: s0 <= wr_dat;
                5'b10001: s1 <= wr_dat;
                5'b10010: s2 <= wr_dat;
                5'b10011: s3 <= wr_dat;
                5'b10100: s4 <= wr_dat;
                5'b10101: s5 <= wr_dat;
                5'b10110: s6 <= wr_dat;
                5'b10111: s7 <= wr_dat;
                5'b11000: t8 <= wr_dat;
                5'b11001: t9 <= wr_dat;
            endcase
        end
    end
        
endmodule
