//////////////////////////////////////////////////////////////////////////////////
// Module Name:             mips_processor.v
// Create Date:             3/25/2016 
// Last Modification:       4/3/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             Top Module of MIPS processor
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module mips_processor(clk, rst_n, instr, pc_inp, pc_out, wr_dat, wr_reg
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
    
    // Pipeline Registers
    reg             [31:0]      pc_reg[0:2];
    reg             [31:0]      instr_reg;
    

    
    wire            [31:0]      immed_ext;          //sign extended immediate value
    wire            [31:0]      immed_shift;
    
    // Reading in instructions
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            pc_reg[0] <= 32'd0;
        else
            pc_reg[0] <= pc_inp + 32'd4;
    end
    
    always @(*)
    begin
        pc_reg[1]   <= pc_reg[0];
        if(branch_value)                //need to define branch_value in mem stage
            pc_out  <= pc_reg[2];
        else
            pc_out  <= pc_inp + 32'd4;
    end
    
    
    

    
    
    
    
    
    
//INSTRUCTION FETCH STEP
//--------------------------------------------------------------------------------------

    always @(*)
    begin
        instr_reg <= instr;
    end
    
    
    
//---------------------------------------------------------------------------------------- 








//INSTRUCTION DECODE STEP
//--------------------------------------------------------------------------------------
    //Register module declaration
    //control module declaration

    
    // Reading in the opcode and determining instruction type
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            op_code     <= 6'd0;
            rs          <= 5'd0;
            rt          <= 5'd0;
            rd          <= 5'd0;
            shamt       <= 5'd0;
            funct       <= 6'd0;
            immediate   <= 15'd0; 
        end
        else
        begin
            op_code     <= instr_reg[31:26];
            rs          <= instr_reg[25:21];
            rt          <= instr_reg[20:16];
            rd          <= instr_reg[15:11];
            shamt       <= instr_reg[10: 6];
            funct       <= instr_reg[ 5: 0];
            immediate   <= instr_reg[15: 0]; 
        end
    end    
    
    assign immed_ext = {16{immediate[15]}};
//--------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    
//EXECUTE STEP
//--------------------------------------------------------------------------------------    
    

    
    assign immed_shift = immed_ext << 2;
    
    always @(posedge clk)
    begin
        pc_reg[2] <=  pc_reg[1] + immed_shift;
    end
    
    //mux leading to ALU
    //assign mux_alu = (ALUSrc == 1'b0) ? read_data2:         //Need to define ALUSrc and read_data2
    //                 immed_ext;
    
    //ALU declaration
    //ALU control declaration
    
    
    //Register Destination Mux
    //assign mux_RegDst = (RegDst == 1'b0) ? instruction[20:16]:
    //                    instruction[15:11];
    
//-------------------------------------------------------------------------------------- 
 
 
 
 
 
 
 
 
//MEMORY STEP
//--------------------------------------------------------------------------------------

    //assign branch_out = Branch & zero_reg;        //define branch_out and zero_reg
    
    //Declare memory in test bench. Change outputs to address and wr_data in this module

//--------------------------------------------------------------------------------------
 
 
 
 
 
 
 
 
 
//WRITEBACK STEP
//--------------------------------------------------------------------------------------
    //POSSIBLY DEFINE MUX IN TESTBENCH
    
    
    //Write back mux
    //assign mux_wb = (MemtoReg == 1'b0) ? read_data:
    //                address;
    
    //step completed within registers.v sub-module
    
//--------------------------------------------------------------------------------------

endmodule

