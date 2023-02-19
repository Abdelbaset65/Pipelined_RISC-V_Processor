`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2020 01:14:27 AM
// Design Name: 
// Module Name: RiscV
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


module Riscv(input clk, rst, input [1:0] ledSel, input [3:0] ssdSel, output reg [7:0] LEDs, output reg[12:0] ssd);
    wire [31:0] pcIN;
    wire [31:0] pcOUT;
    wire [31:0] data_out;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Cout1, Cout2, Cout3, andSignal, ZeroFlag;
    wire [1:0] ALUOp;
    wire [31:0] WriteData, ReadData1, ReadData2, imm_out, mux_out, shift_out, Sum1, Sum2, ALUout, dataMem_out;
    wire [3:0] sell;
    NbitRegister PC(clk,1'b1,rst,pcIN,pcOUT);
    //module NbitRegister#(parameter N=32)(input clk, load, rst, input [N-1:0] data, output  [N-1:0] out);
    InstMem inst(pcOUT[7:2], data_out);
    
    ControlUnit c(data_out,  Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp );
    
    RegisterFile rf(clk, rst, RegWrite, WriteData, data_out[19:15], data_out[24:20], data_out[11:7], ReadData1, ReadData2 );

    ImmGen ig(data_out, imm_out);
    
    mux2x1_32Bit m1(ALUSrc, ReadData2, imm_out, mux_out);
    
    NbitShiftLeft sh(imm_out, shift_out);
    
    NBitAdder add1(pcOUT, shift_out, Sum1, Cout1);
    
    NBitAdder add2(pcOUT, 32'd4, Sum2, Cout2);
    
    mux2x1_32Bit m2(andSignal, Sum2, Sum1, pcIN);
    
    ALUControlUnit aluc(ALUOp, data_out, sell);
    
    NbitALU alu( sell,ReadData1, mux_out, Cout3, ZeroFlag,  ALUout);
    
    //and (ZeroFlag, Branch, andSignal);
    assign andSignal= ZeroFlag & Branch;
    DataMem dm(clk, MemRead, MemWrite, ALUout[7:2], ReadData2, dataMem_out);

    mux2x1_32Bit m3(MemtoReg, ALUout, dataMem_out, WriteData);
    
    always @(*)begin
    case(ledSel)
    00: begin 
     LEDs[7]<= RegWrite;
     LEDs[6]<= ALUSrc;
     LEDs[5]<= ALUOp[1];
     LEDs[4]<= ALUOp[0];
     LEDs[3]<= MemRead;
     LEDs[2]<= MemWrite;
     LEDs[1]<= MemtoReg;
     LEDs[0]<= Branch;
    end
    01: begin 
     LEDs[7]<= sell[3];
     LEDs[6]<= sell[2];
     LEDs[5]<= sell[1];
     LEDs[4]<= sell[0];
     LEDs[3]<= ZeroFlag;
     LEDs[2]<= andSignal;
    end
    
    endcase
    end

    
    always @(*)begin
    case(ssdSel)
    4'b0000: ssd <= pcOUT;
    4'b0001: ssd <= Sum2;
    4'b0010: ssd <= Sum1;
    4'b0011: ssd <= pcIN;
    4'b0100: ssd <= ReadData1;
    4'b0101: ssd <= ReadData2;
    4'b0110: ssd <= WriteData;
    4'b0111: ssd <= imm_out;
    4'b1000: ssd <= shift_out;
    4'b1001: ssd <= mux_out;
    4'b1010: ssd <= ALUout;
    4'b1011: ssd <= ReadData2;
    endcase
    end


    
endmodule

