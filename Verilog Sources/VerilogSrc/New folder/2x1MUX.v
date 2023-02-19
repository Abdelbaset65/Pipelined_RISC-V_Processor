`timescale 1ns / 1ps
module mux2x1 #(parameter N=1)(input load, input[N-1:0] m0, m1, output reg[N-1:0] out);
always @(*)
begin
case(load)
1'b0: out <= m0;
1'b1: out <= m1;
endcase 
end
endmodule

module mux2x1_32Bit (input load, input [31:0] m0, m1, output reg [31:0] out);
always @(*)
begin
case(load)
1'b0: out <= m0;
1'b1: out <= m1;
endcase 
end
endmodule