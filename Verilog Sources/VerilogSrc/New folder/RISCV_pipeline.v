`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 06:48:17 AM
// Design Name: 
// Module Name: RISCV_pipeline
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


module RISCV_pipeline(
input clk, rst, input [1:0] ledSel, input [3:0] ssdSel, output reg [7:0] LEDs, output reg[12:0] ssd
    );
    
          wire [31:0] pcIN;
          wire [31:0] pcOUT;
          wire [31:0] data_out, PC_mux_out;
          wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Cout1, Cout2, Cout3, andSignal, ZeroFlag;
          wire [1:0] ALUOp;
          wire [31:0] WriteData, ReadData1, ReadData2, imm_out, mux_out, shift_out, Sum1, Sum2, ALUout, dataMem_out;
          wire [3:0] sell;
          wire [1:0] forwardA, forwardB;
          wire [31:0] forwardA_mux_out, forwardB_mux_out;
          wire stall;
     // wires declarations
    // the module "Register" is an n-bit register module with n as a parameter
   // and with I/O's (clk, rst, load, data_in, data_out) in sequence
   wire [31:0] IF_ID_PC, IF_ID_Inst;
    NbitRegister #(64) IF_ID (clk, ~stall,rst,
    {pcOUT, data_out},
    {IF_ID_PC,IF_ID_Inst} );
   
   wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
   wire [7:0] ID_EX_Ctrl;
   wire [3:0] ID_EX_Func;
   wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    NbitRegister #(155) ID_EX (clk,1'b1,rst,
    {RegWrite, MemtoReg, Branch, MemRead, MemWrite, ALUSrc, ALUOp, IF_ID_PC
    ,ReadData1, ReadData2, imm_out, {IF_ID_Inst[30],IF_ID_Inst[14:12]}, IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7]},
    {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
    ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd} );
    // Rs1 and Rs2 are needed later for the forwarding unit
   
   wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
   wire [4:0] EX_MEM_Ctrl;
   wire [4:0] EX_MEM_Rd;
   wire EX_MEM_Zero;
    NbitRegister #(107) EX_MEM (clk,1'b1,rst,
    {ID_EX_Ctrl[7:3], Sum1, ZeroFlag, ALUout, 
    forwardB_mux_out ,ID_EX_Rd },
    {EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero,
    EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd} );
   
   wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
   wire [1:0] MEM_WB_Ctrl;
   wire [4:0] MEM_WB_Rd;
    NbitRegister #(71) MEM_WB (clk,1'b1,rst,
    {EX_MEM_Ctrl[4:3], dataMem_out, EX_MEM_ALU_out, EX_MEM_Rd },
    {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
    MEM_WB_Rd} );
    
    
   

       NbitRegister PC(clk,~stall,rst,pcIN,pcOUT);
       //module NbitRegister#(parameter N=32)(input clk, load, rst, input [N-1:0] data, output  [N-1:0] out);
       InstMem inst(pcOUT[7:2], data_out);
       
       ControlUnit c(IF_ID_Inst,  Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp );
       
       //module RegisterFile #(parameter N=32)(input clk, rst, RegWrite, input [N-1:0] WriteData, input [4:0] ReadReg1, ReadReg2, WriteReg, output[N-1:0] ReadData1, ReadData2 );

       RegisterFile rf(~clk, rst, MEM_WB_Ctrl[1], WriteData, IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd , ReadData1, ReadData2 );
   
       ImmGen ig(IF_ID_Inst, imm_out);
       
       mux2x1_32Bit m1(ID_EX_Ctrl[2],forwardB_mux_out , ID_EX_Imm, mux_out);
       
       Mux4x2 m10(forwardA, ID_EX_RegR1, WriteData, EX_MEM_ALU_out, forwardA_mux_out);
       
       Mux4x2 m11(forwardB, ID_EX_RegR2, WriteData, EX_MEM_ALU_out, forwardB_mux_out);
       
       NbitShiftLeft sh(ID_EX_Imm, shift_out);
       
       NBitAdder add1(ID_EX_PC, shift_out, Sum1, Cout1);
       
       NBitAdder add2(pcOUT, 32'd4, Sum2, Cout2);
       
       mux2x1_32Bit m2(andSignal, Sum2, EX_MEM_BranchAddOut, pcIN);
       
       ALUControlUnit aluc(ID_EX_Ctrl[1:0], ID_EX_Func, sell);
       
       ForwardingUnit fu (ID_EX_Rs1,ID_EX_Rs2,EX_MEM_Rd,MEM_WB_Rd, EX_MEM_Ctrl[4], MEM_WB_Ctrl[1], forwardA, forwardB);
       
        HazardUnit hu (IF_ID_Inst[19:15], IF_ID_Inst[24:20], ID_EX_Rd, ID_EX_Ctrl[4], stall);
       
       // assign flushSignal = stall | andSignal;
       
       // mux2x1 #(8) flush2 (flushSignal, { Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp}, 0, control_out);      // ID_EX Flushing
         
       // mux2x1_32Bit flush1 (andSignal, data_out, 32'b0000000_00000_00000_000_00000_0110011, PC_mux_out);     // IF_ID Flushing
       
       // mux2x1 #(5) flush3 (andSignal, EX_MEM_Ctrl, 0, flush_out);    // EX_MEM Flushing
       
       // control_out, PC_mux_out, and flush_out not yet used
       
       NbitALU alu( sell, forwardA_mux_out, mux_out, Cout3, ZeroFlag,  ALUout);
       
       //and (ZeroFlag, Branch, andSignal);
       assign andSignal= EX_MEM_Zero & EX_MEM_Ctrl[2];
       DataMem dm(clk, EX_MEM_Ctrl[1], EX_MEM_Ctrl[0], EX_MEM_ALU_out[7:2], EX_MEM_RegR2, dataMem_out);
   
       mux2x1_32Bit m3(MEM_WB_Ctrl[0], MEM_WB_ALU_out, MEM_WB_Mem_out, WriteData);
       
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
       4'b1100: ssd <= MEM_WB_Rd;
       endcase
       end

    
endmodule
