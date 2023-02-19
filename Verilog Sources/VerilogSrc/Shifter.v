
module Shifter (input [31:0] a, input [4:0] shamt, input [1:0] type,  output reg [31:0] r);

always @(*) begin
    case (type)
    2'b00: begin // SLLI
    for (integer i = 0; i < 32; i = i + 1) begin: generated_adders
        r[i+shamt]= a[i];
    end
    end

    2'b01: begin // SRLI
    for (integer i = 0; i < 32; i = i + 1) begin: generated_adders
        r[i]= a[i+shamt];
    end
    end

    2'b10: begin // SRAI
    for (integer i = 0; i < 31; i = i + 1) begin: generated_adders
        r[i]= a[i+shamt];
    end
    for (integer i = 32-shamt; i < 32; i = i+1) begin
        r[i]= a[31];
    end
    end
    endcase
end

endmodule