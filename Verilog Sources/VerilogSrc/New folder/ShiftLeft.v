
module NbitShiftLeft #(parameter N=32) (input [N-1:0] in, output [N-1:0]out);

assign out[0]= 0;
	genvar i;
generate
    for (i = 0; i < N; i = i + 1) begin: generated_adders
     assign out[i+1]= in[i];
    end
endgenerate

endmodule