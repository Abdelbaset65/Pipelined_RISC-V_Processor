module Ecall (input [4:0] OPCode, input Break, output reg ecall);

    always @(*)
    begin
    if (OPCode == 11100) 
    begin
        //ecall = Break;
        case (Break)
        1'b0: ecall = 1'b0;
        1'b1: ecall = 1'b1;
        endcase
    end        
    end

endmodule