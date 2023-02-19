

module NbitALU #(parameter N=32)(input [3:0] sell, input [N-1:0]A, B, output Cout, output reg ZeroFlag, output[N-1:0] ALUout);

wire [N-1:0] Sum, And, Or;

 NBitAdder addSub(A, (sell[2])? ~B+1: B, Sum, Cout);
 
assign And= A&B;
assign Or= A|B;

always@(*)begin
if(Sum==0)
ZeroFlag<=1;
else ZeroFlag<=0;

end

NbitMux16 #(.N(32)) mux16( sell, Sum, And, Or, ALUout);
endmodule

module NbitMux16 #(parameter N=16)(input [3:0] sell, input [N-1:0] sum, And, Or, output reg [N-1:0] out);

always @(*)
begin
case(sell)
4'b0000: begin  out <= And; end
4'b0001: begin  out <= Or; end
4'b0010: begin  out <= sum; end
4'b0110: begin  out <= sum; end
default: begin  out<=0; end
endcase 
end

endmodule
