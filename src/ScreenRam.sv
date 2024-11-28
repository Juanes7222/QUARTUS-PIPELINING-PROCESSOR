module fixed_text_rom (
    input logic [11:0] address,  // Dirección para seleccionar el texto fijo
    output logic [7:0] data      // Código ASCII del carácter
);
    logic [7:0] fixed [0:4095];
	 
    initial begin
        $readmemh("screen_ram_file.hex", fixed);
    end
	 
    always_comb begin
        data = fixed[address];
    end
endmodule
