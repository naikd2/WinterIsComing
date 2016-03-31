`timescale 1ns / 1ps

module mips_processor(instr, wr_dat, wr_reg
    );

    input                       clk;
    input                       rst_n;
    
    input           [31:0]      pc_inp;             // Input PC value
    input           [31:0]      instr;              // Instruction word

    output reg      [31:0]      pc_out;             // Output PC value    
    output reg      [31:0]      wr_dat;             // Write data
    output reg                  wr_reg;             // Write register
    
    reg             [ 5:0]      op_code;
    
    // Instruction format values
    reg             [ 4:0]      rs;
    reg             [ 4:0]      rt;
    reg             [ 4:0]      rd;
    reg             [ 4:0]      shamt;
    reg             [ 5:0]      funct;
    
    reg             [15:0]      immediate;
    
    // IF/ID Registers
    reg             [31:0]      pc_reg
    reg             [31:0]      instr_reg
    
    // ID/EX Registers
    
    // EX/MEM Registers
    
    // MEM/WB Registers
    
    
    localparam              AND = 3'b000;
    localparam              OR  = 3'b001;
    localparam              ADD = 3'b010;
    localparam              SUB = 3'b110;
    localparam              SLT = 3'b111;
    
    // Reading in instructions
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            pc_out <= 32'd0;
        else
            pc_out <= pc_inp + 32'd4;
    end
    
    // Reading in the opcode and determining instruction type
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            op_code <= 6'd0;
        else
            op_code <= instr [31:26];
    end
    
    // R type instructions (opcode = 6'd0)
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        else if(op_code == 6'd0)
        begin
            
        end
    end

endmodule
