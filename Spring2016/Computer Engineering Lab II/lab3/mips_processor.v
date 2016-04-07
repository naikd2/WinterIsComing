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
    output reg      [4:0]       wr_reg;             // Write register
    
                        
                        
                            
                                
                                        
                                        
    //Instruction decode variables
    wire            [ 5:0]      op_code;
    wire            [ 4:0]      rs;
    wire            [ 4:0]      rt;
    wire            [ 4:0]      rd;
    wire            [ 4:0]      shamt;
    wire            [ 5:0]      funct;
    
    wire            [15:0]      immediate;
    
    
    wire                        RegDst;
    wire                        ALUSrc;
    wire                        ALUOp1;
    wire                        ALUOp0;
    
    wire                        MemtoReg;
    wire                        RegWrite;
                        
    wire                        MemRead;
    wire                        MemWrite;
    wire                        Branch;
    
    
    //ID variables
    wire            [31:0]      read_data1;
    wire            [31:0]      read_data2;
    wire            [31:0]      immed_ext;          //sign extended immediate value
    
    //Execute variables
    wire            [2:0]       alu_operation;
    wire            [4:0]       mux_RegDst;
    wire            [31:0]      pc_adder;
    wire            [31:0]      mux_alu_data;
    
    wire                        alu_zero;
    wire            [31:0]      alu_result;
                        
                            
    //Mem variables
    wire                        PCSrc;
    wire            [31:0]      mem_read_data;
    reg             [31:0]      mem_read_data_reg;
    
    
    
    //WB variables
    wire            [31:0]      mux_wb;
    
    // Pipeline Registers
    
    reg             [31:0]      pc_reg[0:3];
    reg             [31:0]      instr_reg;
    
    
    // control pipeline registers
    reg                         RegDst_reg;
    reg                         ALUSrc_reg;
    reg                         ALUOp1_reg;
    reg                         ALUOp0_reg;
       
    reg                         Branch_reg[1:0];
    reg                         MemRead_reg[1:0];
    reg                         MemWrite_reg[1:0];
    
    reg                         RegWrite_reg[0:2];
    reg                         MemtoReg_reg[0:2];
    
    

    reg             [31:0]      read_data1_reg;
    reg             [31:0]      read_data2_reg[0:1];
    reg             [31:0]      immed_ext_reg;
    reg             [ 4:0]      rt_reg;
    reg             [ 4:0]      rd_reg;
    
    wire            [31:0]      immed_shift;
    
    reg                         alu_zero_reg;
    reg             [31:0]      alu_result_reg[0:1];
    
    reg             [ 4:0]      wr_data_reg[0:1];
    
    
    
    

    
    
    
    
    
    
//INSTRUCTION FETCH STEP
//--------------------------------------------------------------------------------------
    
    // clock PC. Reading instruction memory in test bench will not be clocked
    


    always @(*)
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
    always @(posedge clk)
    begin
        instr_reg <= instr;
        pc_reg[1] <= pc_reg[0];
    end
    
    
    
    
    
//---------------------------------------------------------------------------------------- 








//INSTRUCTION DECODE STEP
//--------------------------------------------------------------------------------------

    //control module declaration
    control mips_control(
        .op_code            (op_code),      //input
        .RegDst             (RegDst),       //output
        .ALUSrc             (ALUSrc),       //output
        .MemtoReg           (MemtoReg),     //output
        .RegWrite           (RegWrite),     //output
        .MemRead            (MemRead),      //output
        .MemWrite           (MemWrite),     //output
        .Branch             (Branch),       //output
        .ALUOp1             (ALUOp1),       //output
        .ALUOp0             (ALUOp0)        //output
    );
    
    

    assign op_code      =   instr_reg[31:26];
    assign rs           =   instr_reg[25:21];
    assign rt           =   instr_reg[20:16];
    assign rd           =   instr_reg[15:11];
    assign shamt        =   instr_reg[10: 6];
    assign funct        =   instr_reg[ 5: 0];
    assign immediate    =   instr_reg[15: 0]; 
    
    //Register module declaration
    registers mips_registers(
        .clk                (clk),              //input
        .rst_n              (rst_n),            //input
        .rs                 (rs),               //input
        .rt                 (rt),               //input
        .wr_reg             (mux_RegDst),       //input
        .wr_dat             (mux_wb),           //input
        .read_dat1          (read_data1),       //output
        .read_dat2          (read_data2),       //output
        .RegWrite           (RegWrite_reg[2])   //input
    );
    
    //sign-extend immediate value
    assign immed_ext = { {16{immediate[15]}}, immediate[15:0]};
    
    
    
    //ID/EX Pipeline Register values
    
    always @(posedge clk)
    begin
       //Ex
        RegDst_reg          <= RegDst;
        ALUSrc_reg          <= ALUSrc;
        ALUOp1_reg          <= ALUOp1;
        ALUOp0_reg          <= ALUOp0;
        
        //Mem
        Branch_reg[0]       <= Branch;
        MemRead_reg[0]      <= MemRead;
        MemWrite_reg[0]     <= MemWrite;
        
        //WB
        RegWrite_reg[0]     <= RegWrite;
        MemtoReg_reg[0]     <= MemtoReg;
        
        
        pc_reg[2]           <= pc_reg[1];
        read_data1_reg      <= read_data1;
        read_data2_reg[0]   <= read_data2;
        immed_ext_reg       <= immed_ext;
        rt_reg              <= rt;
        rd_reg              <= rd;
    end
    

    
//--------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    
//EXECUTE STEP
//--------------------------------------------------------------------------------------    
    

    
    assign immed_shift = immed_ext_reg << 2;
    assign pc_adder = pc_reg[2] + immed_shift;
    

    
    //mux leading to ALU
    assign mux_alu_data = (ALUSrc_reg == 1'b0) ?    read_data2_reg[0]:         //Need to define ALUSrc and read_data2
                                                    immed_ext_reg;
    
    
    
    //ALU control declaration
    alu_control mips_aluControl(
        .ALUOp              ({ALUOp1_reg, ALUOp0_reg}),     //input
        .funct              (immed_ext[5:0]),               //input
        .operation          (alu_operation)                 //output
    );
    

    
    //Probably need to redefine this sub-module and clock it
    //ALU declaration
    alu mips_alu(
        .a                  (read_data1_reg),               //input
        .b                  (mux_alu_data),                    //input
        .operation          (alu_operation),                //input
        .result             (alu_result),                   //output
        .zero               (alu_zero)                      //output
    );
    
    
    //Register Destination Mux
    assign mux_RegDst = (RegDst_reg == 1'b0) ? rt_reg:
                                               rd_reg;
                                           
                                           
    // Execute Pipeline registers
    always @(posedge clk)
    begin
        Branch_reg[1] <= Branch_reg[0];
        MemRead_reg[1] <= MemRead_reg[0];
        MemWrite_reg[1] <= MemWrite_reg[0];
        
        RegWrite_reg[1] <= RegWrite_reg[0];
        MemtoReg_reg[1] <= MemtoReg_reg[0];
        
        pc_reg[3] <=  pc_adder;
        
        alu_zero_reg <= alu_zero;
        alu_result_reg[0] <= alu_result;
        
        read_data2_reg[1] <= read_data2_reg[0];
        
        wr_data_reg[0] <= mux_RegDst;
    end
    
    
//-------------------------------------------------------------------------------------- 
 
 
 
 
 
 
 
 
//MEMORY STEP
//--------------------------------------------------------------------------------------

    assign PCSrc = Branch_reg[1] & alu_zero_reg;        //define branch_out and zero_reg
    
    //memory is declared here. easier to connect wires, then declaring memory in test bench (wr_data, wr_reg)
    //clk, rst_n, MemRead, MemWrite, address, write_data, read_data
    data_memory mips_data_memory(
        .clk                (clk),                      //input
        .rst_n              (rst_n),                    //input
        .MemRead            (MemRead_reg[1]),           //input
        .MemWrite           (MemWrite_reg[1]),          //input
        .address            (alu_result_reg[0]),        //input
        .write_data         (read_data2_reg[1]),        //input
        .read_data          (mem_read_data)             //output
    );

    always @(posedge clk)
    begin
        RegWrite_reg[2] <= RegWrite_reg[1];
        MemtoReg_reg[2] <= MemtoReg_reg[1];
    
        mem_read_data_reg <= mem_read_data;
        alu_result_reg[1] <= alu_result_reg[0];
        
        wr_data_reg[1] <= wr_data_reg[0];
    end
    
//--------------------------------------------------------------------------------------
 
 
 
 
 
 
 
 
 
//WRITEBACK STEP
//--------------------------------------------------------------------------------------
    //POSSIBLY DEFINE MUX IN TESTBENCH
    
    
    //Write back mux
    assign mux_wb = (MemtoReg_reg[2] == 1'b0) ? mem_read_data_reg:
                                            alu_result_reg[1];
    
    //step completed within registers.v sub-module
    
//--------------------------------------------------------------------------------------



endmodule

