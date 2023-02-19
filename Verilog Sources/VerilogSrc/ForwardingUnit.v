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
                                       rd,   // MEM/WB Rd
                      input            regw, // MEM/WB regwrite
                      output reg       forwardA,
                                       forwardB    );
                                    

      always @(*)
      begin
            
            if (regw && (rd != 0) && (rd == rs1)) begin
                forwardA = 1'b1;
            end else forwardA = 1'b0;
            if (regw && (rd != 0) && (rd == rs2)) begin
                forwardB = 1'b1;
            end else forwardB = 1'b0;     
      end
      
           
endmodule
