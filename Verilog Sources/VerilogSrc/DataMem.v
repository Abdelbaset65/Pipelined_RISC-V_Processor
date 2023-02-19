 
 module DataMem
 (input clk, input MemRead, input MemWrite, input [2:0] func,
 input [5:0] addr, input [31:0] data_in, output [31:0] data_out);
 reg [7:0] mem [0:63];

assign data_out =  MemRead ? {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]}: 0;

initial begin
 mem[0]=8'd25;
 mem[1]=8'd25;
end 

always @(posedge clk)begin
if(MemWrite)
case(func)
3'b000:mem[addr] <= data_in[7:0];
3'b001:{mem[addr], mem[addr+1]} <= data_in[15:0];
3'b010:{mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} <= data_in;
endcase 
end
endmodule