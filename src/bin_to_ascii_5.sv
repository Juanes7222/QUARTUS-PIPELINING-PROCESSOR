module bin_to_ascii_5 (
    input  logic [4:0] binary_in,  // Entrada binaria de 5 bits
    output logic [39:0] ascii_out  // Salida ASCII (5 caracteres, 8 bits cada uno)
);

    always_comb begin
        // Inicializamos la salida a ceros
        ascii_out = 40'b0;

        // Convertir cada bit de `binary_in` a su equivalente en ASCII
        for (int i = 0; i < 5; i++) begin
            if (binary_in[i])
                ascii_out[(i * 8) +: 8] = 8'h31; // ASCII de '1'
            else
                ascii_out[(i * 8) +: 8] = 8'h30; // ASCII de '0'
        end
    end

endmodule
