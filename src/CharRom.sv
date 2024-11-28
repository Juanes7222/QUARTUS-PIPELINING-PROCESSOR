module char_rom (
    input  logic [10:0] addr,  // Dirección de 11 bits para 4096 caracteres
    output logic [7:0] data    // Salida de 8 bits para el patrón de un carácter
);

    // Tamaño del ROM (4096 caracteres x 16 líneas por carácter)
    logic [7:0] rom [0:4095]; // ROM de 4096 caracteres y 16 líneas cada uno

    initial begin
        $readmemh("charRomF.hex", rom); // Cargar el archivo .hex en el ROM
    end

    always_comb begin
        data = rom[addr]; // Seleccionar el carácter y la línea
    end

endmodule
