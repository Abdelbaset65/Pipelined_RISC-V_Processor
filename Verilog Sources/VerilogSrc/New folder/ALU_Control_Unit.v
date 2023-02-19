

module ALUControlUnit #(parameter N=32)(input [1:0] ALUop, input [3:0] inst, output reg [3:0] sell);



always @(*)begin
case(ALUop)
2'b00: sell<= 4'b0010;
2'b01: sell<= 4'b0110;
2'b10: begin 

case(inst[2:0])
3'b000: if(inst[3]) sell<= 4'b0110; else  sell<= 4'b0010;
3'b111: if(~inst[3]) sell<= 4'b0000;
3'b110: if(~inst[3]) sell<= 4'b0001;
default: sell<=0;
endcase
end
endcase
end
endmodule
