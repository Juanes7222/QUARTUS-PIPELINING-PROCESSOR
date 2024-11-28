module bin_to_ascii_3 (
    input  logic [2:0] binary_in,  // Entrada binaria de hasta 3 bits
    output logic [23:0] ascii_out  // Salida ASCII (3 caracteres, 8 bits cada uno)
);

    always_comb begin
        // Inicializamos la salida a ceros
        ascii_out = 24'b0;

        // Convertir cada bit de la sección especificada a ASCII
        for (int i = 0; i < 3; i++) begin
            // Extraemos el bit específico y lo convertimos a ASCII
            if (binary_in[i])
                ascii_out[(i * 8) +: 8] = 8'h31; // ASCII de '1'
            else
                ascii_out[(i * 8) +: 8] = 8'h30; // ASCII de '0'
        end
    end

endmodule

