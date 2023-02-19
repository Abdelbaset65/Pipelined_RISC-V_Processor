`timescale 1ns/1ps

module RISCV_pipeline(
    input             clk, rst,
    input      [1:0]  ledSel,
    input      [3:0]  ssdSel,
    output reg [7:0]  LEDs,
    output reg [12:0] ssd);
    
    // wires declarations
    wire [31:0] pcIN;
    wire [31:0] pcOUT;
    wire [31:0] data_out, PC_mux_out;
    wire        Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Cout1, Cout2, cf, zf, vf, sf, jal, jump, s_clk, ecall;
    wire [1:0] ALUOp, jj, forwardA, forwardB;
    wire [7:0] control_out;
    wire [3:0] flush_out;
    wire [31:0] WriteData, ReadData1, ReadData2, imm_out, mux_out, shift_out, Sum1, Sum2, ALUout, dataMem_out, forwardA_mux_out, forwardB_mux_out;
    wire [3:0] sell;

    // Pipeline Registers
    // IF/ID
    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PC4;
    NbitRegister #(96) IF_ID (~s_clk, 1'b1, rst,
                             {Sum2, pcOUT, PC_mux_out},
                             {IF_ID_PC4, IF_ID_PC,IF_ID_Inst} );
    // ID/EX
    wire [31:0]  ID_EX_PC, ID_EX_PC4, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
    wire [10:0]  ID_EX_Ctrl;
    wire [3:0]   ID_EX_Func;
    wire [4:0]   ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    NbitRegister #(155) ID_EX (s_clk,1'b1,rst,
                              {IF_ID_PC4, control_out, IF_ID_PC, ReadData1, ReadData2, imm_out,
                              {IF_ID_Inst[30],IF_ID_Inst[14:12]}, IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7], IF_ID_Inst[6:2]},
                              {ID_EX_PC4, ID_EX_Ctrl, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_B30, ID_EX_Func, ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_OP} );
    // EX/MEM
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
    wire [4:0]  EX_MEM_Ctrl;
    wire [4:0]  EX_MEM_Rd;
    wire        EX_MEM_Branch;
    NbitRegister #(107) EX_MEM (~s_clk,1'b1,rst,
                               {{ID_EX_Ctrl[10], ID_EX_Ctrl[8:6], ID_EX_Ctrl[4]}, Sum1, ID_EX_PC4, Branch, ALUout, mux_out, ID_EX_Func, ID_EX_Rd },
                               {EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_PC4, EX_MEM_Branch, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Func, EX_MEM_Rd} );
    // MEM/WB
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_PC4;
    wire [2:0]  MEM_WB_Ctrl;
    wire [4:0]  MEM_WB_Rd;
    NbitRegister #(71) MEM_WB (s_clk,1'b1,rst,
                              {{EX_MEM_Ctrl[4], EX_MEM_Ctrl[2], EX_MEM_Ctrl[0]}, EX_MEM_PC4, loadMuxOutput, EX_MEM_ALU_out, EX_MEM_Rd},
                              {MEM_WB_Ctrl, MEM_WB_PC4, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd});
    
    DFlipFlop slowClk (clk, rst, ~s_clk, s_clk);

    Mux4x2 PC_j (ID_EX_Ctrl[1:0], pcIN, shift_out, ALUout, PC_jout);

    assign ecall = 1'b1;

    Ecall ec (data_out[7:2] , data_out[20], ecall);

    NbitRegister PC (s_clk, ecall, rst, PC_jout, pcOUT);

    mux2x1_32Bit flush1 (~ecall, data_out, 32'b0000000_00000_00000_000_00000_0110011, PC_mux_out);

    InstMem inst(pcOUT[7:2], data_out);
                             // 10    9      8         7        6         5        4       3 2    1 0
    ControlUnit c (IF_ID_Inst, jal, AUIPC, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, jump);
                                       
    mux2x1 #(11) flush2 (jalr_branch, {jal, AUIPC, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp, jump}, 0, control_out);      // ID_EX Flushing

    BranchUnit bu(ID_EX_OP, ID_EX_Func, cf, zf, vf, sf, Branch);

    assign jalr_branch = jal | EX_MEM_Branch;

    RegisterFile rf(~clk, rst, MEM_WB_Ctrl[0], WriteData2, IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd , ReadData1, ReadData2 );
   
    ImmGen ig(IF_ID_Inst, imm_out);
    
    mux2x1_32Bit m1(ID_EX_Ctrl[5],forwardB_mux_out , ID_EX_Imm, mux_out);
    
    mux2x1_32Bit m10(forwardA, ID_EX_RegR1, WriteData2, forwardA_mux_out);
    
    mux2x1_32Bit m11(forwardB, ID_EX_RegR2, WriteData2, forwardB_mux_out);
    
    NbitShiftLeft sh(ID_EX_Imm, shift_out);
    
    NBitAdder add1(ID_EX_PC, shift_out, Sum1, Cout1);
    
    NBitAdder add2(pcOUT, 32'd4, Sum2, Cout2);
       
    mux2x1_32Bit m2(EX_MEM_Branch, Sum2, EX_MEM_BranchAddOut, pcIN);

    ALUControlUnit aluc(ID_EX_Ctrl[3:2], ID_EX_Func, ID_EX_B30, sell);
       
    ForwardingUnit fu (ID_EX_Rs1, ID_EX_Rs2, MEM_WB_Rd, MEM_WB_Ctrl[0], forwardA, forwardB);
                                            
    mux2x1_32Bit auipc_mux (ID_EX_Ctrl[9] ,forwardA_mux_out, ID_EX_PC, auipc_mux_out);

    prv32_ALU alu (auipc_mux_out, mux_out, ID_EX_Rs2, ALUout, cf, zf, vf, sf, sell);
       
    DataMem dm(clk, EX_MEM_Ctrl[3], EX_MEM_Ctrl[1], EX_MEM_ALU_out[7:2], EX_MEM_RegR2, dataMem_out);
   
    muxLoad loadMx(dataMem_out, EX_MEM_Func, loadMuxOutput);

    mux2x1_32Bit m3(MEM_WB_Ctrl[1], MEM_WB_ALU_out, MEM_WB_Mem_out, WriteData);

    mux2x1_32Bit j (MEM_WB_Ctrl[2], WriteData, MEM_WB_PC4, WriteData2);
       
    always @(*)
    begin
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
   
       
    always @(*)
    begin
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
