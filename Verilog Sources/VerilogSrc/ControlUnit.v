

module ControlUnit #(parameter N=32)(input [N-1:0] inst, output reg jal, AUIPC, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, output reg [1:0] ALUOp, jump);

always @(*)begin

case(inst[6:2])
5'b01100: begin
 MemRead <= 0; 
 MemtoReg <= 0;
 MemWrite <= 0;
 ALUSrc <= 0;
 RegWrite <= 1;
 ALUOp <= 2'b10;
 jump <= 2'b00;
 AUIPC <= 1'b0;
 jal <= 1'b0;
end

5'b00100: begin
 MemRead <= 0; 
 MemtoReg <= 0;
 MemWrite <= 0;
 ALUSrc <= 1;
 RegWrite <= 1;
 ALUOp <= 2'b10;
 jump <= 2'b00;
 AUIPC <= 1'b0;
 jal <= 1'b0;
end

5'b00000: begin
MemRead <= 1; 
MemtoReg <= 1;
MemWrite <= 0;
ALUSrc <= 1;
RegWrite <= 1;
ALUOp <= 2'b00;
jump <= 2'b00;
AUIPC <= 1'b0;
jal <= 1'b0;
end

5'b01000: begin
MemRead <= 0; 
MemWrite <= 1;
ALUSrc <= 1;
RegWrite <= 0;
ALUOp <= 2'b00;
jump <= 2'b00;
AUIPC <= 1'b0;
jal <= 1'b0;
end

//LUI
5'b01101: begin
MemRead <= 0; 
MemWrite <= 0;
MemtoReg <= 0;
ALUSrc <= 1;
RegWrite <= 1;
ALUOp <= 2'b11;
jump <= 2'b00;
AUIPC <= 1'b0;
jal <= 1'b0;
end

5'b11000: begin
MemRead <= 0; 
MemWrite <= 0;
ALUSrc <= 0;
RegWrite <= 0;
ALUOp <= 2'b01;
jump <= 2'b00;
AUIPC <= 1'b0;
jal <= 1'b0;
end

// AUIPC
5'b00101: begin
  MemRead <= 0; 
  MemWrite <= 0;
  ALUSrc <= 1;
  RegWrite <= 1;
  ALUOp <= 2'b10;
  jump <= 2'b00;
  AUIPC <= 1'b1;
  jal <= 1'b0;
end
// jal
5'b11011: begin
  MemRead <= 0; 
  MemWrite <= 0;
  ALUSrc <= 0;
  RegWrite <= 1;
  ALUOp <= 2'b00;
  jump <= 2'b01;
  AUIPC <= 1'b0;
  jal <= 1'b1;
end
// jalr
5'b11001: begin
  MemRead <= 0; 
  MemWrite <= 0;
  ALUSrc <= 1;
  RegWrite <= 1;
  ALUOp <= 2'b00;
  jump <= 2'b10;
  AUIPC <= 1'b0;
  jal <= 1'b1;
end
// fence
5'b00011: begin
  MemRead <= 0; 
  MemWrite <= 0;
  ALUSrc <= 0;
  RegWrite <= 0;
  ALUOp <= 2'b00;
  jump <= 2'b00;
  AUIPC <= 1'b0;
  jal <= 1'b0;  
end

endcase
end
endmodule