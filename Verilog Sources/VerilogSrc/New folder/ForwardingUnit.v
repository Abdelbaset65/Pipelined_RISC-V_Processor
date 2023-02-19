`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 09:09:53 AM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(input      [4:0] rs1,   // ID/EX Rs1
                                       rs2,   // ID/EX Rs2
                                       rd1,   // EX/MEM Rd
                                       rd2,   // MEM/WB Rd
                      input            regw1, // EX/MEM regwrite
                                       regw2, // MEM/WB regwrite         
                      output reg [1:0] forwardA,
                                       forwardB    );
                                    

      always @(*)
      begin
            
            
            
            if (regw1 && (rd1 != 0) && (rd1 == rs1)) begin
                forwardA = 2'b10;
            end else forwardA = 2'b00;
            if (regw1 && (rd1 != 0) && (rd1 == rs2)) begin
                forwardB = 2'b10;
            end else forwardB = 2'b00;
            if (regw2 && (rd2 != 0) && (rd2 == rs1) && !(regw1 && (rd1 != 0) && (rd1 == rs1))) begin
                forwardA = 2'b01;
            end
            if (regw2 && (rd2 != 0) && (rd2 == rs2) && !(regw1 && (rd1 != 0) && (rd1 == rs2))) begin
                forwardB = 2'b01;
            end     
      end
      
           
endmodule
