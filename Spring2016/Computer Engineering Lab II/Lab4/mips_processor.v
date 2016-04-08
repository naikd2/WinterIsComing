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
    output wire     [31:0]      wr_dat;             // Write data
    output wire     [4:0]       wr_reg;             // Write register
    
                                 
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
	 reg				  [2:0]		  alu_operation1;
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
    
    reg             [31:0]      pc_reg0;
    reg             [31:0]      pc_reg1;
    reg             [31:0]      pc_reg1_5;
    reg             [31:0]      pc_reg2;
    reg             [31:0]      pc_reg3;
    reg             [31:0]      instr_reg;

    
    
    // control pipeline registers
    reg                         RegDst_reg;
    reg                         ALUSrc_reg;
    reg                         ALUOp1_reg;
    reg                         ALUOp0_reg;
       
    reg                         Branch_reg0;
    reg                         Branch_reg1;
    reg                         MemRead_reg0;
    reg                         MemRead_reg1;
    reg                         MemWrite_reg0;
    reg                         MemWrite_reg1;
    
    reg             		        RegWrite_reg0;
    reg             		        RegWrite_reg1;
    reg             		        RegWrite_reg2;
    reg                         MemtoReg_reg0;
    reg                         MemtoReg_reg1;
    reg                         MemtoReg_reg2;
    
    
    reg             [31:0]      read_data1_reg;
    reg             [31:0]      read_data2_reg0;
    reg             [31:0]      read_data2_reg1;
    reg             [31:0]      immed_ext_reg;
    reg             [ 4:0]      rt_reg;
    reg             [ 4:0]      rd_reg;
    
    wire            [31:0]      immed_shift;
    
    reg                         alu_zero_reg;
    reg             [31:0]      alu_result_reg0;
    reg             [31:0]      alu_result_reg1;
    
    reg             [ 4:0]      wr_data_reg0;
    reg             [ 4:0]      wr_data_reg1;
    
    
//INSTRUCTION FETCH STEP
//--------------------------------------------------------------------------------------
    
    // clock PC. Reading instruction memory in test bench will not be clocked
    


    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            pc_out <= 32'd0;
        end
        else if(PCSrc == 1'b0)     //if select bit is 0
            pc_out <= pc_reg0;
        else if(PCSrc == 1'b1)     //if select bit is 1
            pc_out <= pc_reg3;
    end
    
    always @(*)
    begin
        pc_reg0 <= pc_out + 32'd4;
    end
    
    //IF/ID Registers
    always @(posedge clk)
    begin
        instr_reg <= instr;
        pc_reg1 <= pc_reg0;
		  //pc_reg1_5 <= pc_reg1;
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
	 
//	 assign op_code      =   instr[31:26];
//    assign rs           =   instr[25:21];
//    assign rt           =   instr[20:16];
//    assign rd           =   instr[15:11];
//    assign shamt        =   instr[10: 6];
//    assign funct        =   instr[ 5: 0];
//    assign immediate    =   instr[15: 0]; 
    
    //Register module declaration
    registers mips_registers(
        .clk                (clk),              //input
        .rst_n              (rst_n),            //input
        .rs                 (rs),               //input
        .rt                 (rt),               //input
        .wr_reg             (wr_reg),       //input
        .wr_dat             (wr_dat),           //input
        .read_dat1          (read_data1),       //output
        .read_dat2          (read_data2),       //output
        .RegWrite           (RegWrite_reg2)   //input
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
        Branch_reg0       <= Branch;
        MemRead_reg0      <= MemRead;
        MemWrite_reg0     <= MemWrite;
        
        //WB
        RegWrite_reg0     <= RegWrite;
        MemtoReg_reg0     <= MemtoReg;
        
        
        //pc_reg2             <= pc_reg1_5;
        pc_reg2             <= pc_reg1;
        read_data1_reg      <= read_data1;
        read_data2_reg0		 <= read_data2;
        immed_ext_reg       <= immed_ext;
        rt_reg              <= rt;
        rd_reg              <= rd;
    end
    

    
//--------------------------------------------------------------------------------------
    

//EXECUTE STEP
//--------------------------------------------------------------------------------------    
    

    
    assign immed_shift = immed_ext_reg << 2;
    assign pc_adder = pc_reg2 + immed_shift;
    

    
    //mux leading to ALU
    assign mux_alu_data = (ALUSrc_reg == 1'b0) ?    read_data2_reg0:         //Need to define ALUSrc and read_data2
                                                    immed_ext_reg;
    
    
    
    //ALU control declaration
    alu_control mips_aluControl(
        .ALUOp              ({ALUOp1_reg, ALUOp0_reg}),     //input
        .funct              (immed_ext[5:0]),               //input
        .operation          (alu_operation)                 //output
    );
    
	always @(posedge clk)
	begin
		alu_operation1 <= alu_operation;
	end
    
    //Probably need to redefine this sub-module and clock it
    //ALU declaration
    alu mips_alu(
        .a                  (read_data1_reg),               //input
        .b                  (mux_alu_data),                 //input
        .operation          (alu_operation1),                //input
        .result             (alu_result),                   //output
        .zero               (alu_zero)                      //output
    );
    
    
    //Register Destination Mux
    assign mux_RegDst = (RegDst_reg == 1'b0) ? rt_reg:
                                               rd_reg;
                                           
                                           
    // Execute Pipeline registers
    always @(posedge clk)
    begin
        Branch_reg1 <= Branch_reg0;
        MemRead_reg1 <= MemRead_reg0;
        MemWrite_reg1 <= MemWrite_reg0;
        
        RegWrite_reg1 <= RegWrite_reg0;
        MemtoReg_reg1 <= MemtoReg_reg0;
        
        pc_reg3 <=  pc_adder;
        
        alu_zero_reg <= alu_zero;
        alu_result_reg0 <= alu_result;
        
        read_data2_reg1 <= read_data2_reg0;
        
        wr_data_reg0 <= mux_RegDst;
    end
    
    
//-------------------------------------------------------------------------------------- 
 
 
 
 
 
 
 
 
//MEMORY STEP
//--------------------------------------------------------------------------------------

    assign PCSrc = Branch_reg1 & alu_zero_reg;        //define branch_out and zero_reg
    
    //memory is declared here. easier to connect wires, then declaring memory in test bench (wr_data, wr_reg)
    //clk, rst_n, MemRead, MemWrite, address, write_data, read_data
    data_memory mips_data_memory(
        .clk                (clk),                      //input
        .rst_n              (rst_n),                    //input
        .MemRead            (MemRead_reg1),           //input
        .MemWrite           (MemWrite_reg1),          //input
        .address            (alu_result_reg0),        //input
        .write_data         (read_data2_reg1),        //input
        .read_data          (mem_read_data)             //output
    );

    always @(posedge clk)
    begin
        RegWrite_reg2 <= RegWrite_reg1;
        MemtoReg_reg2 <= MemtoReg_reg1;
    
        mem_read_data_reg <= mem_read_data;
        alu_result_reg1 <= alu_result_reg0;
        
        wr_data_reg1 <= wr_data_reg0;
    end
    
//--------------------------------------------------------------------------------------
 
 
 
 
 
 
 
 
 
//WRITEBACK STEP
//--------------------------------------------------------------------------------------
    //POSSIBLY DEFINE MUX IN TESTBENCH
    
    
    //Write back mux
//	 if (MemtoReg_reg2 == 1'b0)
//		assign mux_wb = mem_read_data_reg;
//	 else
//		assign mux_wb = alu_result_reg1;
    assign mux_wb = (MemtoReg_reg2 == 1'b1) ? mem_read_data_reg:
                    (MemtoReg_reg2 == 1'b0) ?                        alu_result_reg1:
																mux_wb;
   // assign mux_wb = alu_result_reg[1];
    //step completed within registers.v sub-module
    
//--------------------------------------------------------------------------------------

    assign wr_reg = wr_data_reg1;
    assign wr_dat = mux_wb;


endmodule

