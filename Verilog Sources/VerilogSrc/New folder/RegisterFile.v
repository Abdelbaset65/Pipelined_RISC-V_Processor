
module NbitMux32 #(parameter N=32)(input [4:0] ReadReg, input [N-1:0] Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12,
 Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31, output reg [N-1:0] ReadData);

always @(*)
begin
case(ReadReg)
5'b00000: ReadData <= Q0;
5'b00001: ReadData <= Q1;
5'b00010: ReadData <= Q2;
5'b00011: ReadData <= Q3;
5'b00100: ReadData <= Q4;
5'b00101: ReadData <= Q5;
5'b00110: ReadData <= Q6;
5'b00111: ReadData <= Q7;
5'b01000: ReadData <= Q8;
5'b01001: ReadData <= Q9;
5'b01010: ReadData <= Q10;
5'b01011: ReadData <= Q11;
5'b01100: ReadData <= Q12;
5'b01101: ReadData <= Q13;
5'b01110: ReadData <= Q14;
5'b01111: ReadData <= Q15;
5'b10000: ReadData <= Q16;
5'b10001: ReadData <= Q17;
5'b10010: ReadData <= Q18;
5'b10011: ReadData <= Q19;
5'b10100: ReadData <= Q20;
5'b10101: ReadData <= Q21;
5'b10110: ReadData <= Q22;
5'b10111: ReadData <= Q23;
5'b11000: ReadData <= Q24;
5'b11001: ReadData <= Q25;
5'b11010: ReadData <= Q26;
5'b11011: ReadData <= Q27;
5'b11100: ReadData <= Q28;
5'b11101: ReadData <= Q29;
5'b11110: ReadData <= Q30;
5'b11111: ReadData <= Q31;

endcase 
end

endmodule


module NbitRegister#(parameter N=32)(input clk, load, rst, input [N-1:0] data, output  [N-1:0] out);
    wire [N-1:0] D;
 
	genvar i;
	generate
		for (i = 0; i < N; i = i + 1) begin: generated_adders
        
        mux2x1 mux(load, out[i], data[i], D[i]);
        
        		end
    endgenerate
    
    
    	generate
        for (i = 0; i < N; i = i + 1) begin: generated_adders1
        
        DFlipFlop flip(clk, rst, D[i], out[i]);
        
                end
    endgenerate
        

endmodule 



module DFlipFlop (input clk, input rst, input D, output reg Q);

 always @ (posedge clk or posedge rst)
 if (rst) begin
 Q <= 1'b0;
 end else if(clk) begin
 Q = D;
 end
endmodule




module RegisterFile #(parameter N=32)(input clk, rst, RegWrite, input [N-1:0] WriteData, input [4:0] ReadReg1, ReadReg2, WriteReg, output[N-1:0] ReadData1, ReadData2 );

wire  [N-1:0] Q [0:N-1];
wire [N-1:0] load;
   
	genvar i;
	generate
		for (i = 0; i < N; i = i + 1) begin: generated_registers
 NbitRegister register(clk, load[i], rst, WriteData,  Q[i]); 
        		end
    endgenerate
    
    NbitMux32 mux1(ReadReg1, Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7], Q[8], Q[9], Q[10], Q[11], Q[12],
     Q[13], Q[14], Q[15], Q[16], Q[17], Q[18], Q[19], Q[20], Q[21], Q[22], Q[23], Q[24], Q[25], Q[26], Q[27], Q[28], Q[29], Q[30], Q[31], ReadData1);

    NbitMux32 mux2(ReadReg2, Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7], Q[8], Q[9], Q[10], Q[11], Q[12],
     Q[13], Q[14], Q[15], Q[16], Q[17], Q[18], Q[19], Q[20], Q[21], Q[22], Q[23], Q[24], Q[25], Q[26], Q[27], Q[28], Q[29], Q[30], Q[31], ReadData2);
     
     Decoder d(RegWrite, WriteReg, load);

endmodule


module Decoder #(parameter N=32)(input RegWrite, input [4:0] WriteReg, output reg [N-1:0] load);
always @(*) begin
if(RegWrite) begin
case(WriteReg)
5'b00000: load <= 32'b00000000000000000000000000000000;
5'b00001: load <= 32'b00000000000000000000000000000010;
5'b00010: load <= 32'b00000000000000000000000000000100;
5'b00011: load <= 32'b00000000000000000000000000001000;
5'b00100: load <= 32'b00000000000000000000000000010000;
5'b00101: load <= 32'b00000000000000000000000000100000;
5'b00110: load <= 32'b00000000000000000000000001000000;
5'b00111: load <= 32'b00000000000000000000000010000000;
5'b01000: load <= 32'b00000000000000000000000100000000;
5'b01001: load <= 32'b00000000000000000000001000000000;
5'b01010: load <= 32'b00000000000000000000010000000000;
5'b01011: load <= 32'b00000000000000000000100000000000;
5'b01100: load <= 32'b00000000000000000001000000000000;
5'b01101: load <= 32'b00000000000000000010000000000000;
5'b01110: load <= 32'b00000000000000000100000000000000;
5'b01111: load <= 32'b00000000000000001000000000000000;
5'b10000: load <= 32'b00000000000000010000000000000000;
5'b10001: load <= 32'b00000000000000100000000000000000;
5'b10010: load <= 32'b00000000000001000000000000000000;
5'b10011: load <= 32'b00000000000010000000000000000000;
5'b10100: load <= 32'b00000000000100000000000000000000;
5'b10101: load <= 32'b00000000001000000000000000000000;
5'b10110: load <= 32'b00000000010000000000000000000000;
5'b10111: load <= 32'b00000000100000000000000000000000;
5'b11000: load <= 32'b00000001000000000000000000000000;
5'b11001: load <= 32'b00000010000000000000000000000000;
5'b11010: load <= 32'b00000100000000000000000000000000;
5'b11011: load <= 32'b00001000000000000000000000000000;
5'b11100: load <= 32'b00010000000000000000000000000000;
5'b11101: load <= 32'b00100000000000000000000000000000;
5'b11110: load <= 32'b01000000000000000000000000000000;
5'b11111: load <= 32'b10000000000000000000000000000000;
endcase
end else load <=0;
end
endmodule
