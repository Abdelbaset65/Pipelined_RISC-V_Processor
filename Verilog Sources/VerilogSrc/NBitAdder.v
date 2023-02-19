module rippleAdder(input a, b, cIn,
     output sum, cOut
    );
    
    assign {cOut, sum}= a + b + cIn;
    
endmodule


module NBitAdder #(parameter N=32)(input [N-1:0]A,B,
        output [N-1:0]Sum, output Cout);
	
	wire [N:0]carry;
	
	assign carry[0] = 1'b0;
	
	genvar i;
	generate
		for (i = 0; i < N; i = i + 1) begin: generated_adders
         
         rippleAdder s(A[i], B[i], carry[i], Sum[i], carry[i+1]);
         
		end
	endgenerate
	
	assign Cout = carry[N];

endmodule 



