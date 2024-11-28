module vga_controller(
  input logic clk_50MHz,  // Assumes DE1-SoC
  input logic reset,      // System reset
  output logic video_on,  // ON while pixel counts for x and y are within display area
  output logic hsync,     // Horizontal sync
  output logic vsync,     // Vertical sync
  output logic clk,       // 25MHz pixel/second rate signal (pixel tick)
  output logic [9:0] x,   // Pixel count/position of pixel x, max 0-799
  output logic [9:0] y    // Pixel count/position of pixel y, max 0-524
);

  // VGA 640x480 resolution parameters
  parameter int HD   = 640;  // Horizontal display area width in pixels
  parameter int HF   = 48;   // Horizontal front porch width in pixels
  parameter int HB   = 16;   // Horizontal back porch width in pixels
  parameter int HR   = 96;   // Horizontal retrace width in pixels
  parameter int HMAX = HD + HF + HB + HR - 1; // Max horizontal counter value

  parameter int VD   = 480;  // Vertical display area length in pixels
  parameter int VF   = 10;   // Vertical front porch length in pixels
  parameter int VB   = 33;   // Vertical back porch length in pixels
  parameter int VR   = 2;    // Vertical retrace length in pixels
  parameter int VMAX = VD + VF + VB + VR - 1; // Max vertical counter value

  // Clock division module to generate 25MHz signal
  logic w_25MHz;
  clock50_25 c(.clock50(clk_50MHz), .reset(reset), .clock25(w_25MHz));

  // Registers for counters and sync signals
  logic [9:0] h_count_reg, h_count_next;
  logic [9:0] v_count_reg, v_count_next;

  logic v_sync_next, h_sync_next;
  logic v_sync_reg, h_sync_reg;

  // Sequential logic for registers
  always_ff @(posedge clk_50MHz or posedge reset) begin
    if (reset) begin
      h_count_reg <= 10'd0;
      v_count_reg <= 10'd0;
      h_sync_reg  <= 1'b0;
      v_sync_reg  <= 1'b0;
    end else begin
      h_count_reg <= h_count_next;
      v_count_reg <= v_count_next;
      h_sync_reg  <= h_sync_next;
      v_sync_reg  <= v_sync_next;
    end
  end

  // Horizontal counter logic
  always_comb begin
    if (h_count_reg == HMAX) 
      h_count_next = 10'd0;
    else 
      h_count_next = h_count_reg + 10'd1;
  end

  // Vertical counter logic
  always_comb begin
    if (h_count_reg == HMAX) begin
      if (v_count_reg == VMAX)
        v_count_next = 10'd0;
      else
        v_count_next = v_count_reg + 10'd1;
    end else 
      v_count_next = v_count_reg;
  end

  // Horizontal sync signal generation
  assign h_sync_next = (h_count_reg >= (HD + HB)) && (h_count_reg < (HD + HB + HR));

  // Vertical sync signal generation
  assign v_sync_next = (v_count_reg >= (VD + VB)) && (v_count_reg < (VD + VB + VR));

  // Video ON/OFF - only ON while pixel counts are within the display area
  assign video_on = (h_count_reg < HD) && (v_count_reg < VD);

  // Outputs
  assign hsync = h_sync_reg;
  assign vsync = v_sync_reg;
  assign x     = h_count_reg;
  assign y     = v_count_reg;
  assign clk   = w_25MHz;

endmodule

