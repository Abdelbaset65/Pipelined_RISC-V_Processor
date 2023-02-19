 
 module DataMem
 (input clk, input MemRead, input MemWrite,
 input [5:0] addr, input [31:0] data_in, output [31:0] data_out);
 reg [31:0] mem [0:63];

assign data_out =  MemRead ? mem[addr]: 0;

initial begin
mem[0]=32'd17;
mem[1]=32'd9;
mem[2]=32'd25;

end 

always @(posedge clk)begin
if(MemWrite) mem[addr] <= data_in;
end
endmodule