`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:32:23 04/06/2016
// Design Name:   mips_processor
// Module Name:   C:/Users/kevin/Documents/CE_Lab/lab3/lab3/mips_processor_tb.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips_processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_processor_tb;

	// Inputs
	reg clk;
	reg rst_n;
	reg [31:0] instr;

	// Outputs
	wire [31:0] pc_out;
	wire [31:0] wr_dat;
	wire [4:0] wr_reg;
    
    
    reg     [31:0]      instr_mem [0:32];

	// Instantiate the Unit Under Test (UUT)
	mips_processor uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.instr(instr), 
		.pc_out(pc_out), 
		.wr_dat(wr_dat), 
		.wr_reg(wr_reg)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		
		
        //ADD $s0 $t0 $t1
        instr_mem[0] = 32'h01098020;				//add  == 17
																//t0 = 8 | t1 = 9	| s0 = 16
		  //SUB $s1 $t2 $t3
        instr_mem[4] = 32'h014B8822;            //sub  == -1
																//t2 = 10 | t3 = 11	| s1 = 17
		  //AND $s2 $t4 $t5
        instr_mem[8] = 32'h018D9024;            //and == 12
																//t4 = 12 | t5 = 13	| s2 = 18														
		  //OR $s3 $t6 $t7
        instr_mem[12] = 32'h01CF9825;           //or == 15
																//t6 = 14 | t7 = 15	| s3 = 19
		  //SLT $s4 $t8 $t9
        instr_mem[16] = 32'h0319A02A;           //slt == 1
																//t8 = 24 | t9 = 25	| s4 = 20
			  instr_mem[20] = 32'h12D70002;		//beq													
		  //LW $t2 0x0000 $t0	
		  instr_mem[24] = 32'h8d0a0000;		//LW $t2 0x0000 $t0 | $t2 <- memory[$t0]
		  instr_mem[28] = 32'hADC90000;		//SW
		
		   instr_mem[32] = 32'h01098020;
			instr_mem[36] = 32'h014B8822;
		//instr_mem[0] = 32'hac0a0000;
		 //instr_mem[4] = 32'h08000000;
		 //instr_mem[0] = 32'h8d0a0004;
		// Wait 100 ns for global reset to finish
		
		#10;
        rst_n = 1;

	end
    
    always
    begin
        forever
        begin
            #10 clk = ~clk;
        end
    end
    
    
    always @(posedge clk)
    begin
        instr <= instr_mem[pc_out];
    end
      
endmodule

