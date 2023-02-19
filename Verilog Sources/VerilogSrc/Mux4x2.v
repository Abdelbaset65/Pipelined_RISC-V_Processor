`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 09:56:03 AM
// Design Name: 
// Module Name: Mux4x2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux4x2 #(parameter N=32)(input [1:0] load, input[N-1:0] m0, m1, m2, output reg [N-1:0]out);
always @(*)
begin
case(load)
2'b00: out <= m0;
2'b01: out <= m1;
2'b10: out <= m2;

endcase 
end
endmodule

