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
    

    
    
    localparam              AND = 3'b000;
    localparam              OR  = 3'b001;
    localparam              ADD = 3'b010;
    localparam              SUB = 3'b110;
    localparam              SLT = 3'b111;
    
    
    
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
    
    /*
    assign shift_immed = immediate_value << 2;
    
    always @(posedge clk)
    begin
        pc_reg[2]   <=  pc_reg[1] + shift_immed;
    end*/
    
    /*
        shiftBy2 of immediate value = immediate value << 2              //This is not clocked
        pc_reg[2] <= pc_reg[1] + shiftBy2 of immediate value            //This is clocked
    */
    
    
    always @(*)
    begin
        instr_reg <= instr;
    end
    
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
       

    
  /*  // R type instructions (opcode = 6'd0)
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        else if(op_code == 6'd0)
        begin
            
        end
    end*/
    
    
    
    
    
    
 //Instruction Fetch Step
 
 
 //Instruction Decode Step
    //Register module declaration
    //control module declaration
    wire                    immed_ext;              //sign extended immediate value
    
    
 //Execute Step
 
 
 //Memory Step
 
 
 //Writeback Step

endmodule

