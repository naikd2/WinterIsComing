`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:35 04/06/2016
// Design Name:   data_memory
// Module Name:   C:/Users/kevin/Documents/CE_Lab/lab3/data_memory/data_memory_tb2.v
// Project Name:  data_memory
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: data_memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module data_memory_tb2;

	// Inputs
	reg clk;
	reg rst_n;
	reg MemRead;
	reg MemWrite;
	reg [31:0] address;
	reg [31:0] write_data;

	// Outputs
	wire [31:0] read_data;
    
    
    integer i;

	// Instantiate the Unit Under Test (UUT)
	data_memory uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.address(address), 
		.write_data(write_data), 
		.read_data(read_data)
	);

initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		MemRead = 0;
		MemWrite = 0;
		address = 0;
		write_data = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
        rst_n = 1;
        MemWrite = 1'b1;
        
        for(i = 0; i < 16; i = i + 1)
        begin
            address = address + 32'd1;
            write_data = 32'd10 + i;
            $display(address);
            #10 clk = ~clk;
            #10 clk = ~clk;
        end
		// Add stimulus here

	end
    
      
endmodule


