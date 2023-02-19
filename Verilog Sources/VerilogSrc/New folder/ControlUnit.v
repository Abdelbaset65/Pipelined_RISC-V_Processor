

module ControlUnit #(parameter N=32)(input [N-1:0] inst, output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, output reg [1:0] ALUOp );

always @(*)begin
case(inst[6:2])
5'b01100: begin
 Branch <= 0;
 MemRead <= 0; 
 MemtoReg <= 0;
 MemWrite <= 0;
 ALUSrc <= 0;
 RegWrite <= 1;
 ALUOp <= 2'b10;
end

5'b00000: begin
Branch <= 0;
MemRead <= 1; 
MemtoReg <= 1;
MemWrite <= 0;
ALUSrc <= 1;
RegWrite <= 1;
ALUOp <= 2'b00;

end

5'b01000: begin
 Branch <= 0;
MemRead <= 0; 
MemWrite <= 1;
ALUSrc <= 1;
RegWrite <= 0;
ALUOp <= 2'b00;

end

5'b11000: begin
Branch <= 1;
MemRead <= 0; 
MemWrite <= 0;
ALUSrc <= 0;
RegWrite <= 0;
ALUOp <= 2'b01;

end


endcase
end
endmodule