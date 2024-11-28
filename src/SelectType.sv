module SelectType (
    input logic [6:0] opcode,
    output logic [7:0] ascii
);
    always_comb begin
        case (opcode)
            7'b0110011: ascii = 8'h52;  // "R"
            7'b0010011: ascii = 8'h49;  // "I"
            7'b0000011: ascii = 8'h4C;  // "L" (solo primer carácter de IL)
            7'b0100011: ascii = 8'h53;  // "S"
            7'b1100011: ascii = 8'h42;  // "B"
            7'b1101111: ascii = 8'h4A;  // "J"
            7'b1100111: ascii = 8'h49;  // "I" (solo primer carácter de IJ)
            7'b0110111: ascii = 8'h55;  // "U"
            default: ascii = 8'h58;     // "X"
        endcase
    end
endmodule
