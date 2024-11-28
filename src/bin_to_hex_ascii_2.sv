module bin_to_hex_ascii_2 (
    input logic [7:0] bin_in,         // Valor binario de 8 bits
    input logic enable,               // Señal de habilitación
    output logic [15:0] ascii_out     // Salida ASCII de 16 bits (2 caracteres x 8 bits)
);

    logic [15:0] ascii;

    // Mapeo de cada dígito hexadecimal de bin_in a su representación ASCII
    to_ascii digit1(.hex_digit(bin_in[7:4]), .ascii(ascii[15:8]));
    to_ascii digit0(.hex_digit(bin_in[3:0]), .ascii(ascii[7:0]));

    always_comb begin
        if (~enable) begin
            ascii_out = {bin_in, 8'b0};
        end else begin
            ascii_out = ascii;
        end
    end

endmodule
