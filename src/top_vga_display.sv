module top_vga_display (
    input reset,                  // Reset del sistema
    input [31:0] inst, imm, rs1, rs2, rd, a, b, res, wrb, PC_fe, PC_de, PC_ex, PCP4_me, PCP4_wb, address, DataRd,
	 input [31:0] Ru [0:31],
	 input [2:0] ctrl,
	 input [3:0] alu_ctrl, BrOp,
	 input [9:0] x,
	 input [9:0] y, 
	 input logic NextPCSrc,
    input video_on,              // ON mientras se cuentan los píxeles
    input clk,                   // Reloj de 25 MHz
	 output [7:0] VGA_R,       // Salida del color rojo
    output [7:0] VGA_G,       // Salida del color verde
    output [7:0] VGA_B        // Salida del color azul
);

	 reg [7:0] ascii;
	 reg [31:0] value;
  wire [63:0] value_ascii;
  wire [15:0] value_ascii_2;
  wire [7:0] value_ascii_1;
  wire [55:0] value_ascii_bin;
  wire [39:0] value_ascii_bin_5;
  wire [23:0] value_ascii_bin_3;
  reg [2:0] index;
  reg [2:0] x_counter;
  reg enable;
  wire [7:0] type_;
  
	 
	 wire [7:0] fixed_ascii;
	 reg [1:0] case_;
	 reg [1:0] case_2;
  
  initial begin
    index <= 3'b000;
    x_counter <= 3'b000;
  end
  
  SelectType st(
	.opcode(inst[6:0]),
	.ascii(type_)
	);
	

	 bin_to_hex_ascii to_hex(
		.bin_in(value),
       .ascii_out(value_ascii)
		);
		
	bin_to_hex_ascii_2 to_hex_2(
		.bin_in(value[7:0]),
       .ascii_out(value_ascii_2)
		);
		
	bin_to_ascii to_ascii(
		.binary_in(value),
		.ascii_out(value_ascii_bin)
	);
	
	bin_to_ascii_5 to_ascii_5(
		.binary_in(value),
		.ascii_out(value_ascii_bin_5)
	);
	
	bin_to_ascii_3 to_ascii_3(
		.binary_in(value),
		.ascii_out(value_ascii_bin_3)
	);
	
	to_ascii hex(
		.hex_digit(value[3:0]),
		.ascii(value_ascii_1)
	);
	
		
	fixed_text_rom fixed_rom(
      .address({ y[8:4], x[9:3]}),
		.data(fixed_ascii)
		);
		
	AsciiText text(
      .clk(clk),
		 .video_on(video_on),
		 .ascii_char(ascii),
		 .x(x),
		 .y(y),
		 .reset(reset),
		 .VGA_R(VGA_R),
		 .VGA_G(VGA_G),
		 .VGA_B(VGA_B)
	);
	

	 
  always @(posedge clk or posedge reset) begin
    // Resetear el contador y el índice si hay un reset
    if (reset) begin
        index <= 3'b000;
        x_counter <= 3'b000;
    end else if (fixed_ascii == 8'h0) begin
        // Incrementar el contador de 0 a 7
        x_counter <= x_counter + 1;

        // Cada vez que el contador alcanza 8, actualizamos el índice
        if (x_counter == 3'b111) begin
            x_counter <= 3'b000;   // Reiniciar el contador
            index <= index + 1;    // Avanzar al siguiente segmento de 8 bits

            // Si el índice alcanza 7, reiniciarlo a 0
            if (index == 3'b111) begin
                index <= 3'b000;
            end
			end
		end else begin
		  index <= 3'b000;
        x_counter <= 3'b000;
		end
	end
	
	
  always @* begin
    if (~reset) begin
			case_ = 2'b00;
			case_2 = 2'b11;
			if (fixed_ascii == 8'h0) begin  
				if (x >= 96 && x < 160 && y >= 16 && y < 32) begin
					value = PC_fe;
					case_ = 2'b00;
				end else if (x >= 272 && x < 336 && y >= 16 && y < 32) begin
					value = PC_de;
					case_ = 2'b00;
				end else if (x >= 496 && x < 560 && y >= 16 && y < 32) begin
					value = PC_ex;
					case_ = 2'b00;
					
					
				end else if (x >= 104 && x < 168 && y >= 32 && y < 48) begin
					value = inst;
					case_ = 2'b00;
				end else if (x >= 288 && x < 304 && y >= 32 && y < 48) begin
					value = type_;
					case_ = 2'b10;
					enable = 1'b0;
				end else if (x >= 544 && x < 552 && y >= 32 && y < 48) begin
					value = alu_ctrl;
					case_ = 2'b11;
				
				end else if (x >= 120 && x < 176 && y >= 48 && y < 64) begin
					value = inst[31:25];
					case_ = 2'b01;
					case_2 = 2'b00;
				end else if (x >= 256 && x < 272 && y >= 48 && y < 64) begin
					value = inst[19:15];
					case_ = 2'b10;
				end else if (x >= 288 && x < 352 && y >= 48 && y < 64) begin
					value = rs1;
					case_ = 2'b00;
				end else if (x >= 512 && x < 576 && y >= 48 && y < 64) begin
					value = res;
					case_ = 2'b00;
				
				
				end else if (x >= 112 && x < 168 && y >= 64 && y < 80) begin
					value = inst[31:25];
					case_ = 2'b01;
					case_2 = 2'b00;
				end else if (x >= 256 && x < 272 && y >= 64 && y < 80) begin
					value = inst[24:20];
					case_ = 2'b10;
				end else if (x >= 288 && x < 352 && y >= 64 && y < 80) begin
					value = rs2;
					case_ = 2'b00;
				end else if (x >= 560 && x < 568 && y >= 64 && y < 80) begin
					value = BrOp;
					case_ = 2'b11;
					
				end else if (x >= 128 && x < 152 && y >= 80 && y < 96) begin
					value = inst[14:12];
					case_ = 2'b01;
					case_2 = 2'b10;
				end else if (x >= 256 && x < 272 && y >= 80 && y < 96) begin
					value = inst[11:7];
					case_ = 2'b10;
				end else if (x >= 288 && x < 352 && y >= 80 && y < 96) begin
					value = rd;
					case_ = 2'b00;
				end else if (x >= 544 && x < 552 && y >= 80 && y < 96) begin
					value = NextPCSrc;
					case_ = 2'b11;
					
					
				end else if (x >= 288 && x < 352 && y >= 96 && y < 112) begin
					value = imm;
					case_ = 2'b00;
				end else if (x >= 424 && x < 488 && y >= 96 && y < 112) begin
					value = a;
					case_ = 2'b00;
				end else if (x >= 552 && x < 616 && y >= 96 && y < 112) begin
					value = b;
					case_ = 2'b00;
					
					
				end else if (x >= 144 && x < 208 && y >= 160 && y < 176) begin
					value = PCP4_me-4;
					case_ = 2'b00;
				end else if (x >= 464 && x < 528 && y >= 160 && y < 176) begin
					value = PCP4_wb-4;
					case_ = 2'b00;
					
					
				end else if (x >= 160 && x < 224 && y >= 176 && y < 192) begin
					value = address;
					case_ = 2'b00;
				end else if (x >= 440 && x < 504 && y >= 176 && y < 192) begin
					value = wrb;
					case_ = 2'b00;
				
				
				end else if (x >= 160 && x < 224 && y >= 192 && y < 208) begin
					value = DataRd;
					case_ = 2'b00;
					
					
				end else if (x >= 184 && x < 192 && y >= 208 && y < 224) begin
					value = ctrl;
					case_ = 2'b11;
					
				
				end else if (x >= 48 && x < 112 && y >= 240 && y < 256) begin
					value = Ru[0];
					case_ = 2'b00;
				end else if (x >= 144 && x < 208 && y >= 240 && y < 256) begin
					value = Ru[1];
					case_ = 2'b00;
				end else if (x >= 240 && x < 304 && y >= 240 && y < 256) begin
					value = Ru[2];
					case_ = 2'b00;
				end else if (x >= 336 && x < 400 && y >= 240 && y < 256) begin
					value = Ru[3];
					case_ = 2'b00;
				end else if (x >= 432 && x < 496 && y >= 240 && y < 256) begin
					value = Ru[4];
					case_ = 2'b00;
				end else if (x >= 528 && x < 592 && y >= 240 && y < 256) begin
					value = Ru[5];
					case_ = 2'b00;
					
				
				end else if (x >= 40 && x < 104 && y >= 256 && y < 272) begin
					value = Ru[6];
					case_ = 2'b00;
				end else if (x >= 136 && x < 200 && y >= 256 && y < 272) begin
					value = Ru[7];
					case_ = 2'b00;
				end else if (x >= 232 && x < 296 && y >= 256 && y < 272) begin
					value = Ru[8];
					case_ = 2'b00;
				end else if (x >= 328 && x < 392 && y >= 256 && y < 272) begin
					value = Ru[9];
					case_ = 2'b00;
				end else if (x >= 432 && x < 496 && y >= 256 && y < 272) begin
					value = Ru[10];
					case_ = 2'b00;
				end else if (x >= 536 && x < 600 && y >= 256 && y < 272) begin
					value = Ru[11];
					case_ = 2'b00;
				
				
				end else if (x >= 96 && x < 160 && y >= 272 && y < 288) begin
					value = Ru[12];
					case_ = 2'b00;
				end else if (x >= 200 && x < 264 && y >= 272 && y < 288) begin
					value = Ru[13];
					case_ = 2'b00;
				end else if (x >= 304 && x < 368 && y >= 272 && y < 288) begin
					value = Ru[14];
					case_ = 2'b00;
				end else if (x >= 408 && x < 472 && y >= 272 && y < 288) begin
					value = Ru[15];
					case_ = 2'b00;
				end else if (x >= 512 && x < 576 && y >= 272 && y < 288) begin
					value = Ru[16];
					case_ = 2'b00;
					
					
				end else if (x >= 96 && x < 160 && y >= 288 && y < 304) begin
					value = Ru[17];
					case_ = 2'b00;
				end else if (x >= 200 && x < 264 && y >= 288 && y < 304) begin
					value = Ru[18];
					case_ = 2'b00;
				end else if (x >= 304 && x < 368 && y >= 288 && y < 304) begin
					value = Ru[19];
					case_ = 2'b00;
				end else if (x >= 408 && x < 472 && y >= 288 && y < 304) begin
					value = Ru[20];
					case_ = 2'b00;
				end else if (x >= 512 && x < 576 && y >= 288 && y < 304) begin
					value = Ru[21];
					case_ = 2'b00;
					
				
				end else if (x >= 96 && x < 160 && y >= 304 && y < 320) begin
					value = Ru[22];
					case_ = 2'b00;
				end else if (x >= 200 && x < 264 && y >= 304 && y < 320) begin
					value = Ru[23];
					case_ = 2'b00;
				end else if (x >= 304 && x < 368 && y >= 304 && y < 320) begin
					value = Ru[24];
					case_ = 2'b00;
				end else if (x >= 408 && x < 472 && y >= 304 && y < 320) begin
					value = Ru[25];
					case_ = 2'b00;
				end else if (x >= 512 && x < 576 && y >= 304 && y < 320) begin
					value = Ru[26];
					case_ = 2'b00;
				
				
				end else if (x >= 96 && x < 160 && y >= 320 && y < 336) begin
					value = Ru[27];
					case_ = 2'b00;
				end else if (x >= 200 && x < 264 && y >= 320 && y < 336) begin
					value = Ru[28];
					case_ = 2'b00;
				end else if (x >= 304 && x < 368 && y >= 320 && y < 336) begin
					value = Ru[29];
					case_ = 2'b00;
				end else if (x >= 408 && x < 472 && y >= 320 && y < 336) begin
					value = Ru[30];
					case_ = 2'b00;
				end else if (x >= 512 && x < 576 && y >= 320 && y < 336) begin
					value = Ru[31];
					case_ = 2'b00;
				end
				
				
					if (case_ == 2'b00) begin
						ascii = value_ascii[63 - index*8 -: 8];
					end else if (case_ == 2'b01) begin
						if(case_2 == 2'b00) begin 
							ascii = value_ascii_bin[55 - index*8 -: 8];
						end else if (case_2 == 2'b01) begin
							ascii = value_ascii_bin_5[39 - index*8 -: 8];
						end else if (case_2 == 2'b10) begin
							ascii = value_ascii_bin_3[23 - index*8 -: 8];
						end
					end else if (case_ == 2'b10) begin
						ascii = value_ascii_2[15 - index*8 -:8];
					end else if (case_ == 2'b11) begin
						ascii = value_ascii_1;
					end 
			end else begin
				ascii = fixed_ascii;
			end
    end
		
  end
 
	 

endmodule