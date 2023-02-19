module muxLoad(input [31:0] dataLoaded, input [2:0]fun3, output reg [31:0] dataOut);
always(*)begin
case(fun3)
3'b000:dataOut<={24'd0,dataLoaded[31:24]};
3'b001:dataOut<={16'd0,dataLoaded[31:16]};
3'b010:dataOut<=dataLoaded;
3'b100:dataOut<={20'd0,dataLoaded[30:24]};
3'b101:dataOut<={17'd0,dataLoaded[30:16]};
endcase
end
endmodule