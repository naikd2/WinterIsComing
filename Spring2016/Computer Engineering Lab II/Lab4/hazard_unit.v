//////////////////////////////////////////////////////////////////////////////////
// Module Name:             forwarding_unit.v
// Create Date:             3/25/2016 
// Last Modification:       4/3/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             alu component located in execution stage
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module hazard_unit(mem_read, rs, rt1, rt2, PCWrite, IF_ID_Write, mux_out
    );

    input           [4:0]      	rs;
    input         	[4:0]      	rt1;
    input          	[4:0]       rt2;
	input		    [2:0]		mem_read;

 				
    output wire     [31:0]      PCWrite;
    output wire     [1:0]       IF_ID_Write;
	output wire					mux_out;
    
    
    
    
    assign PCWrite 		= (mem_read && !register_rd1 && register_rd1 == rs) ? 2'b10:
						  (regWrite2 && !register_rd2 && register_rd2 == rs) ? 2'b01:
						  2'b00;
                    
    assign IF_ID_Write 	= (regWrite1 && !register_rd1 && register_rd1 == rt) ? 2'b10:
						  (regWrite2 && !register_rd2 && register_rd2 == rt) ? 2'b01:
						  2'b00;
						  
	assign mux_out 		= (regWrite1 && !register_rd1 && register_rd1 == rt) ? 2'b10:
						  (regWrite2 && !register_rd2 && register_rd2 == rt) ? 2'b01:
						  2'b00;
    

endmodule
