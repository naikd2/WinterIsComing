//////////////////////////////////////////////////////////////////////////////////
// Module Name:             forwarding_unit.v
// Create Date:             3/25/2016 
// Last Modification:       4/3/2016
// Author:                  Kevin Cao, Dhruvit Naik
// Description:             alu component located in execution stage
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module forwarding_unit(rs, rt, register_rd1, register_rd2, regWrite1, regWrite2, forwardA, forwardB
    );

    input           [4:0]      	rs;
    input         	[4:0]      	rt;
    input          	[4:0]       register_rd1;
	input		    [4:0]		register_rd2;
	input						regWrite1;
	input					    regWrite2;
 				
    output wire     [1:0]       forwardA;
    output wire     [1:0]       forwardB;
    
    
    
    
    assign forwardA 	= (regWrite1 && !register_rd1 && register_rd1 == rs) ? 2'b10:
						  (regWrite2 && !register_rd2 && register_rd2 == rs) ? 2'b01:
						  2'b00;
                    
    assign forwardB 	= (regWrite1 && !register_rd1 && register_rd1 == rt) ? 2'b10:
						  (regWrite2 && !register_rd2 && register_rd2 == rt) ? 2'b01:
						  2'b00;
    

endmodule
