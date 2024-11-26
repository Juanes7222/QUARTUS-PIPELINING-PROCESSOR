module bin_to_hex_ascii_2(
    input [7:0] bin_in,         // Valor binario de 8 bits
	 input enable,
    output [15:0] ascii_out      // Salida ASCII de 15 bits (2 caracteres x 8 bits)
);
    
	 reg [15:0] ascii;
    // Mapeo de cada dígito hexadecimal de bin_in a su representación ASCII
    
    to_ascii digit1(.hex_digit(bin_in[7:4]),   .ascii(ascii[15:8]));
    to_ascii digit0(.hex_digit(bin_in[3:0]),   .ascii(ascii[7:0]));
	 
	 always @* begin
		if (~enable) begin
			ascii_out <= {bin_in, 8'b0};
		end else begin
			ascii_out <= ascii;
		end
	 end

endmodule