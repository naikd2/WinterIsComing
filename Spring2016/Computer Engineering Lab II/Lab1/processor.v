
module processor(clk, rst_n, AC, mem_out, wr_en, M
    );
    
    input                               clk;            //Clock
    input                               rst_n;          //Reset
      
    input           [15:0]              M;              //Instruction and Data Input
    
    output          [15:0]              AC;             //Accumulator
    output          [15:0]              mem_out;        //Output data to be written to memory
    output                              wr_en;          //Memory write enable
                                
    reg             [15:0]              IR;             //Instruction Register
    reg             [15:0]              MD;             //Memory Data Register
    reg             [11:0]              PC;             //Program Counter
    reg             [11:0]              MA;             //Memory Address Register
    reg             [15:0]              AC;             //Accumulator

    
    reg                                 AM;             //AM bit (bit 12)      
    reg             [15:0]              mem_out;
    reg                                 wr_en;
    
    reg                                 C;              //Carry
   
    reg             [4:0]               PRstate;        //Present State
    reg             [4:0]               NXstate;        //Next State
    
	 
    //States
    localparam                          S0 = 5'd0;      //State 0
    localparam                          S1 = 5'd1;      //State 1
    localparam                          S2 = 5'd2;      //State 2
    localparam                          S3 = 5'd3;      //State 3
    localparam                          S4 = 5'd4;      //State 4
    localparam                          S5 = 5'd5;      //State 5
    localparam                          S6 = 5'd6;      //State 6
    localparam                          S7 = 5'd7;      //State 7
    localparam                          S8 = 5'd8;      //State 8
    localparam                          S9 = 5'd9;      //State 9
    localparam                          S10 = 5'd10;    //State 10
    localparam                          S11 = 5'd11;    //State 11
    localparam                          S12 = 5'd12;    //State 12
    localparam                          S13 = 5'd13;    //State 13
    localparam                          S14 = 5'd14;    //State 14
    localparam                          S15 = 5'd15;    //State 15
    localparam                          S16 = 5'd16;    //State 16
    
    //Opcodes
    localparam                          NOT = 3'b000;   //Not
    localparam                          ADC = 3'b001;   //Add with Carry
    localparam                          JPA = 3'b010;   //Jump
    localparam                          INC = 3'b011;   //Increment
    localparam                          STA = 3'b100;   //Store and Clear
    localparam                          LDA = 3'b101;   //Load Accumulator
    
    
    
    //Defining Present State of processor
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            PRstate <= S0;           
        else
		begin
            PRstate <= NXstate;
			IR 		<= IR;
            MD 		<= MD;
            AC 		<= AC;
            PC 		<= PC;
            MA 		<= MA;
            mem_out <= mem_out;
            wr_en 	<= wr_en;
		end
    end


    //Defining Next state of processor
    always @(*)
    begin
            case(PRstate)
            S0: NXstate <= S1;
            S1: begin
                    if(IR[15:13] == NOT)
                        NXstate <= S2;
                    else if(IR[15:13] == INC)
                        NXstate <= S3;
                    else if(IR[15:13] == JPA)
                    begin
                        if(AC > 0)
                        begin
                            if(IR[12] == 1'b1)              // AM = 1 		   
                                NXstate <= S4;
                            else
                                NXstate <= S7;
                        end
                        else
                            NXstate <= S0;
                    end
                    else
                        NXstate <= S8;
                end
            S2: NXstate <= S0;
            S3: NXstate <= S0;
            S4: NXstate <= S5;
            S5: NXstate <= S6;
            S6: NXstate <= S0;
            S7: NXstate <= S0;
            S8: begin
                    if(IR[15:13] == STA)
                    begin
                        if(AM)
                            NXstate <= S9;
                        else
                            NXstate <= S11;
                    end
                    else
                        NXstate <= S12;
                end
            S9: NXstate <= S10;
            S10: NXstate <= S11;
            S11: NXstate <= S0;
            S12: begin
                    if(AM)
                        NXstate <= S13;
                    else if(IR[15:13] == ADC)
                        NXstate <= S15;
                    else
                        NXstate <= S16;
                 end
            S13: NXstate <= S14;
            S14: begin
                    if(IR[15:13] == ADC)
                        NXstate <= S15;
                    else
                        NXstate <= S16;
                 end
            S15: NXstate <= S0;
            S16: NXstate <= S0;
            endcase
    end
    
    
    //Defining instructions for different states
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            IR 		<= 16'd0;
            MD 		<= 16'd0;
            AC 		<= 16'd0;
            PC 		<= 12'd0;
            MA 		<= 12'd0;
            mem_out <= 16'd0;
            wr_en 	<= 1'd0;
			C	    <= 1'd0;
			AM 	    <= 1'd0;
        end
		  
        else if(PRstate == S0)
        begin
            IR[15:0] <= M[15:0];                                    //IR <= M[PC];
            wr_en <= 1'd0;
        end
        else if(PRstate == S1)
        begin
            PC <= PC + 1'b1;
            AM <= IR[12];
        end
        else if(PRstate == S2)
        begin
            AC <= ~AC;
        end
        else if(PRstate == S3)
        begin
            {C, AC} <= AC + 1'b1;
        end
        else if(PRstate == S4)
        begin
            MA <= IR[11:0];
        end
        else if(PRstate == S5)
        begin
            MD <= M;
        end
        else if(PRstate == S6)
        begin
            PC <= MD[11:0];                     
        end
        else if(PRstate == S7)
        begin
            PC <= IR[11:0]; 
        end
        else if(PRstate == S8)
        begin
            MA <= IR[11:0];
        end
        else if(PRstate == S9)
        begin
            MD <= M;
        end
        else if(PRstate == S10)
        begin	
            MA <= MD[11:0];           
        end
        else if(PRstate == S11)
        begin
            mem_out <= AC;
            wr_en <= 1'b1;
            AC <= 16'b0;
        end
        else if(PRstate == S12)
        begin
            MD <= M;
        end
        else if(PRstate == S13)
        begin
            MA <= MD[11:0];
        end
        else if(PRstate == S14)
        begin
            MD <= M;
        end
        else if(PRstate == S15)
        begin
            {C, AC} <= AC + MD + C;
				
        end
        else 
        begin
            AC <= MD;
        end
    end
    
    
endmodule
