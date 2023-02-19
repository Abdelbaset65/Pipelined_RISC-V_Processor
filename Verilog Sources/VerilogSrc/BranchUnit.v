module BranchUnit (input [4:0] op_code, input [2:0] br, input cf, zf, vf, sf, output reg Branch);

always @(*) begin
if(op_code==5'b11000)begin
  case (br)
  3'b000: // BEQ
  if (zf)
  begin
    Branch <= 1;
  end
  3'b001: //BNE
    if (~zf)
    begin
    Branch <= 1;
    end
  3'b100: // BLT
    if (sf!=vf)
    begin
    Branch <= 1;
    end
  3'b101: // BGE
    if (sf==vf)
    begin
    Branch <= 1;
    end
  3'b110: // BLTU
    if (~cf)
    begin
    Branch <= 1;
    end
  3'b111: // BGEU
    if (cf)
    begin
    Branch <= 1;
    end
  endcase
end
else begin
    Branch <= 0;
end
end



endmodule