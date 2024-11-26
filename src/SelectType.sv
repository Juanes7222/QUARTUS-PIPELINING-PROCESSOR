module SelectType(
	input [6:0] opcode,
	output [7:0] ascii
	);
	
	always @* begin
		case (opcode)
			7'b0110011: ascii = {4'b0,"R"};
			7'b0010011: ascii = {4'b0,"I"};
			7'b0000011: ascii = {"I","L"};
			7'b0100011: ascii = {4'b0,"S"};
			7'b1100011: ascii = {4'b0,"B"};
			7'b1101111: ascii = {4'b0,"J"};
			7'b1100111: ascii = {"I","J"};
			7'b0110111: ascii = {4'b0,"U"};
			default: ascii = "X";
		endcase
	end
endmodule