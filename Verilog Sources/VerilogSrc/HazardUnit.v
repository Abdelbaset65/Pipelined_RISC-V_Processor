`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 09:54:26 AM
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(input[4:0] rs1, rs2, rd, input memread, output reg stall);

always @(*)
begin
    if (((rs1 == rd) | (rs2 == rd) ) & memread & (rd != 0))
    begin
        stall = 1;
    end
    else begin
        stall = 0;
    end
end


endmodule
