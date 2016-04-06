//////////////////////////////////////////////////////////////////////////////////
// Module Name:             mips_processor.v
// Create Date:             3/25/2016 
// Last Modification:       4/3/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             Top Module of MIPS processor
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module mips_processor(clk, rst_n, instr, pc_out, wr_dat, wr_reg
    );

    input                       clk;
    input                       rst_n;
    
    //input           [31:0]      pc_inp;             // Input PC value
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
    
    
    
    

    
    
    
    
    
    
//INSTRUCTION FETCH STEP
//--------------------------------------------------------------------------------------
    
    // clock PC. Reading instruction memory in test bench will not be clocked
    


    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            pc_out <= 32'd0;
        else if (PCSrc == 1'b0)     //if select bit is 0
            pc_out <= pc_reg[0]
        else                        //if select bit is 1
            pc_out <= pc_reg[2];
    end
    
    always @(*)
    begin
        pc_reg[0] <= pc_out + 32'd4;
        pc_reg[1] <= pc_reg[0];
    end
    
    
    //IF/ID Registers
    always @(*)
    begin
        instr_reg <= instr;
    end
    
    
    
    
    
//---------------------------------------------------------------------------------------- 








//INSTRUCTION DECODE STEP
//--------------------------------------------------------------------------------------

    //control module declaration
    control mips_control(
        .op_code            (),
        .RegDst             (),
        .ALUSrc             (),
        .MemtoReg           (),
        .RegWrite           (),
        .MemRead            (),
        .MemWrite           (),
        .Branch             (),
        .ALUOp1             (),
        .ALUOp0             ()
    );
    
    // Reading in the opcode and determining instruction type
    always @(posedge clk)
    begin
        op_code     <= instr_reg[31:26];
        rs          <= instr_reg[25:21];
        rt          <= instr_reg[20:16];
        rd          <= instr_reg[15:11];
        shamt       <= instr_reg[10: 6];
        funct       <= instr_reg[ 5: 0];
        immediate   <= instr_reg[15: 0]; 

    end    
    
    
    //Register module declaration
    registers mips_registers(
        .clk                (clk),
        .rst_n              (rst_n),
        .rs                 (rs),
        .rt                 (rt),
        .wr_reg             (),
        .wr_dat             (),
        .read_dat1          (read_data1),
        .read_dat2          (read_data2)
    );
    
    //sign-extend immediate value
    assign immed_ext = {16{immediate[15]}};
    
    
    
    //ID/EX Register values
    
    always @(*)
    begin
        pc_reg[2] <= pc_reg[1];
    end
    
    assign read_data1_reg = read_data1;
    assign read_data2_reg = read_data2;
    assign immed_ext_reg = immed_ext;
    assign rt_reg = rt;
    assign rd_reg = rd;
    
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
    
    
    
    //ALU control declaration
    alu_control aluControl(
        .ALUOp              (),
        .funct              (),
        .operation          ()
    );
    
    
    //ALU declaration
    alu alu1(
        .a                  (),
        .b                  (),
        .operation          (),
        .result             (),
        .zero               ()                       
    );
    
    
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

