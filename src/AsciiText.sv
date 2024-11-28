module AsciiText(
    input  logic        clk,
    input  logic        video_on,
    input  logic [7:0]  ascii_char,
    input  logic [9:0]  x, y,
    input  logic        reset,
    output logic [7:0]  VGA_R,       // Salida del color rojo
    output logic [7:0]  VGA_G,       // Salida del color verde
    output logic [7:0]  VGA_B        // Salida del color azul
);
    
    // Signal declarations
    logic [10:0] rom_addr;         // 11-bit text ROM address
    logic [3:0]  char_row;         // 4-bit row of ASCII character
    logic [2:0]  bit_addr;         // Column number of ROM data
    logic [7:0]  rom_data;         // 8-bit row data from text ROM
    logic        ascii_bit;        // ROM bit
    logic        ascii_bit_on;     // Status signal
    
    // Instantiate ASCII ROM
    char_rom rom(.addr(rom_addr), .data(rom_data));
      
    // ASCII ROM interface
    assign rom_addr = {ascii_char, char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // Reverse bit order
    assign char_row = y[3:0];                   // Row number of ASCII character ROM
    assign bit_addr = x[2:0];                   // Column number of ASCII character ROM
    assign ascii_bit_on = video_on ? ascii_bit : 1'b0;
	 
    localparam logic [7:0] COLOR_BLACK = 8'h00; // Negro
    localparam logic [7:0] COLOR_WHITE = 8'hFF; // Blanco
    
    // RGB multiplexing circuit
    always_comb begin
        if (reset || ~video_on || ~ascii_bit_on) begin
            VGA_R = COLOR_BLACK;
            VGA_B = COLOR_BLACK;
            VGA_G = COLOR_BLACK;
        end else begin
            VGA_R = COLOR_WHITE;
            VGA_B = COLOR_WHITE;
            VGA_G = COLOR_WHITE;
        end
    end

endmodule
