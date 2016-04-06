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
    
    input           [31:0]      instr;              // Instruction word

    output reg      [31:0]      pc_out;             // Output PC value    
    output reg      [31:0]      wr_dat;             // Write data
    output reg                  wr_reg;             // Write register
    
    reg             [ 5:0]      op_code;
    
    
    
    
    
    //Instruction decode variables
    reg             [ 4:0]      rs;
    reg             [ 4:0]      rt;
    reg             [ 4:0]      rd;
    reg             [ 4:0]      shamt;
    reg             [ 5:0]      funct;
    
    reg             [15:0]      immediate;
    
    
    wire                        RegDst;
    wire                        ALUSrc;
    wire                        MemtoReg;
    wire                        RegWrite;
    wire            [1:0]       MemRead;
    wire            [1:0]       MemWrite;
    wire            [1:0]       Branch;
    wire                        ALUOp1;
    wire                        ALUOp0;
    
    
    //Execute variables
    wire            [2:0]       alu_operation;
    wire            [31:0]      alu_result_reg;
    wire                        alu_zero_reg;
    
    //Mem variables
    wire                        PCSrc;
    wire                        mem_read_data;
    
    // Pipeline Registers
    reg             [31:0]      pc_reg[0:2];
    reg             [31:0]      instr_reg;
    

    wire            [31:0]      read_data1_reg;
    wire            [31:0]      read_data2_reg0;
    wire            [31:0]      read_data2_reg1;
    wire            [31:0]      immed_ext;          //sign extended immediate value
    wire            [31:0]      immed_shift;
    
    
    wire            [1:0]       Branch_reg;
    wire            [1:0]       MemRead_reg;
    wire            [1:0]       MemWrite_reg;
    
    

    
    
    
    
    
    
//INSTRUCTION FETCH STEP
//--------------------------------------------------------------------------------------
    
    // clock PC. Reading instruction memory in test bench will not be clocked
    


    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            pc_out <= 32'd0;
        else if (PCSrc == 1'b0)     //if select bit is 0
            pc_out <= pc_reg[0];
        else                        //if select bit is 1
            pc_out <= pc_reg[2];
    end
    
    always @(*)
    begin
        pc_reg[0] <= pc_out + 32'd4;
    end
    
    
    //IF/ID Registers
    always @(*)
    begin
        instr_reg <= instr;
    end
    
    always @(*)
    begin
        pc_reg[1] <= pc_reg[0];
    end
    
    
    
    
//---------------------------------------------------------------------------------------- 








//INSTRUCTION DECODE STEP
//--------------------------------------------------------------------------------------

    //control module declaration
    control mips_control(
        .op_code            (op_code),
        .RegDst             (RegDst),
        .ALUSrc             (ALUSrc),
        .MemtoReg           (MemtoReg),
        .RegWrite           (RegWrite),
        .MemRead            (MemRead),
        .MemWrite           (MemWrite),
        .Branch             (Branch),
        .ALUOp1             (ALUOp1),
        .ALUOp0             (ALUOp0)
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
        .wr_reg             (mux_RegDst),
        .wr_dat             (mux_wb),
        .read_dat1          (read_data1),
        .read_dat2          (read_data2)
    );
    
    //sign-extend immediate value
    assign immed_ext = {16{immediate[15]}};
    
    
    
    //ID/EX Pipeline Register values
    
    always @(*)
    begin
        pc_reg[2] <= pc_reg[1];
    end
    
    assign read_data1_reg = read_data1;
    assign read_data2_reg = read_data2;
    assign immed_ext_reg = immed_ext;
    assign rt_reg = rt;                     //[20:16]
    assign rd_reg = rd;                     //[15:11]
    
    assign RegDst_reg = RegDst;
    assign ALUSrc_reg = ALUSrc;
    assign ALUOp1_reg = ALUOp1;
    assign ALUOp0_reg = ALUOp0;
    assign Branch_reg[0] = Branch;
    assign MemRead_reg[0] = MemRead;
    assign MemWrite_reg[0] = MemWrite;
    assign RegWrite_reg = RegWrite;
    assign MemtoReg_reg = MemtoReg;
    
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
    alu_control mips_aluControl(
        .ALUOp              ({ALUOp1_reg, ALUOp0_reg}),
        .funct              (immed_ext[5:0]),
        .operation          (alu_operation)
    );
    
    assign mux_alu_b = (ALUSrc_reg == 1'b0) ?   read_data2_reg:
                                                immed_ext;
    
    //Probably need to redefine this sub-module and clock it
    //ALU declaration
    alu mips_alu(
        .a                  (read_data1_reg),
        .b                  (mux_alu_b),
        .operation          (alu_operation),
        .result             (alu_result_reg),
        .zero               (alu_zero_reg)                       
    );
    
    
    //Register Destination Mux
    assign mux_RegDst = (RegDst == 1'b0) ? rt_reg:
                                           rd_reg;
                                           
                                           
    // Execute Pipeline registers
    
    assign Branch_reg[1] = Branch_reg[0];
    assign MemRead_reg[1] = MemRead_reg[0];
    assign MemWrite_reg[1] = MemWrite_reg[0];
    assign read_data2_reg1 = read_data2_reg0;
    
//-------------------------------------------------------------------------------------- 
 
 
 
 
 
 
 
 
//MEMORY STEP
//--------------------------------------------------------------------------------------

    assign PCSrc = Branch_reg[1] & alu_zero_reg;        //define branch_out and zero_reg
    
    //memory is declared here. easier to connect wires, then declaring memory in test bench (wr_data, wr_reg)
    //clk, rst_n, MemRead, MemWrite, address, write_data, read_data
    data_memory mips_data_memory(
        .clk                (clk),
        .rst_n              (rst_n),
        .MemRead            (MemRead_reg[1]),
        .MemWrite           (MemWrite_reg[1]),
        .address            (alu_result_reg),
        .write_data         (read_data2_reg1),
        .read_data          (mem_read_data)
    );

    
//--------------------------------------------------------------------------------------
 
 
 
 
 
 
 
 
 
//WRITEBACK STEP
//--------------------------------------------------------------------------------------
    //POSSIBLY DEFINE MUX IN TESTBENCH
    
    
    //Write back mux
    assign mux_wb = (MemtoReg == 1'b0) ? mem_read_data:
                                         alu_result_reg;
    
    //step completed within registers.v sub-module
    
//--------------------------------------------------------------------------------------

endmodule

