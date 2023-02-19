`include "defines.v"

module ALUControlUnit #(parameter N=32)(input [1:0] ALUop, input [2:0] f3, input B, output reg [3:0] sell);

always @(*)begin
case(ALUop)
2'b00: sell<= 4'b0010;
2'b01: sell<= 4'b0110;
2'b11: sell<= ALU_LUI;

2'b10: begin 

case(f3)
3'b000: if(B)  sell<= ALU_ADD; else  sell<= ALU_SUB;
3'b001: if(~B) sell<= ALU_SLL;
3'b010: if(~B) sell<= ALU_SLT;
3'b011: if(~B) sell<= ALU_SLTU;
3'b100: if(~B) sell<= ALU_XOR;
3'b101: if(~B) sell<= ALU_SRL; else sell<= ALU_SRA;
3'b110: if(~B) sell<= ALU_OR;
3'b111: if(~B) sell<= ALU_AND;
default: sell<=0;
endcase
end
endcase
end
endmodule
