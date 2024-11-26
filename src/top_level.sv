module top_level(
	input wire clk,
    input wire clk_fpga,
	 input wire reset,
	 input reset_core,
    output wire [7:0] VGA_R,       // Salida color rojo (8 bits)
    output wire [7:0] VGA_G,       // Salida color verde (8 bits)
    output wire [7:0] VGA_B,       // Salida color azul (8 bits)
    output wire VGA_CLK,           // Reloj VGA
    output wire VGA_SYNC_N,        // Sincronización VGA (siempre en bajo)
    output wire VGA_BLANK_N,       // Señal de blanking
    output wire VGA_HS,            // Sincronización horizontal
    output wire VGA_VS             // Sincronización vertical
);

	wire [31:0] PC_fe_vga, PC_de_vga, PC_ex_vga, PCP4_me_vga, PCP4_wb_vga, inst, imm, rs1, rs2, rd, a, b, res, wrb, addr, datard;
	wire [31:0] Ru [0:31];
	wire [2:0] ctrl;
	wire [3:0] alu_ctrl, BrOp_vga;
	wire [9:0] x, y;
	wire video_on, clk_25;

	CPU cpu(
		.clk(clk),
		
		.PC_fe_vga(PC_fe_vga),
		.PC_de_vga(PC_de_vga),
		.PC_ex_vga(PC_ex_vga),
		.PCP4_me_vga(PCP4_me_vga),
		.PCP4_wb_vga(PCP4_wb_vga),
		.inst(inst),
		.imm(imm),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.a(a),
		.b(b),
		.res(res),
		.wrb(wrb),
		.addr(addr),
		.datard(datard),
		.Ru(Ru),
		
		.ctrl(ctrl),
		.alu_ctrl(alu_ctrl),
		.BrOp_vga(BrOp_vga)
		);
		
	vga_controller VgaController(
			.clk_50MHz(clk_fpga),
			.reset(reset),
			.video_on(video_on),
			.hsync(VGA_HS),
			.vsync(VGA_VS),
			.clk(clk_25),
			.x(x),
			.y(y)
		);
		
	top_vga_display display(
		.clk(clk_25),
		
		.PC_fe(PC_fe_vga),
		.PC_de(PC_de_vga),
		.PC_ex(PC_ex_vga),
		.PCP4_me(PCP4_me_vga),
		.PCP4_wb(PCP4_wb),
		.inst(inst),
		.imm(imm),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.a(a),
		.b(b),
		.res(res),
		.Ru(Ru),
		.wrb(wrb),
		.address(addr),
		.DataRd(datard),
		.ctrl(ctrl),
		.alu_ctrl(alu_ctrl),
		.BrOp(BrOp_vga),
		.x(x),
		.y(y),
		.video_on(video_on),
		
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B)

		);

endmodule