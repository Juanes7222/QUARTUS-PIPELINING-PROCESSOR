module WBStage(
  input logic clk,
  
  input logic [31:0] PCP4_me,
  
  input logic RUWr_me,
  input logic [1:0] RUDataWrSrc_me,
  
  input logic [4:0] RD_me,
  
  input logic [31:0] ALURes_me,
  
  input logic [31:0] DMDataRd_me,
  
  output logic [31:0] PCP4_wb,

  output logic RUWr_wb,
  output logic [1:0] RUDataWrSrc_wb,

  output logic [4:0] RD_wb,

  output logic [31:0] ALURes_wb,

  output logic [31:0] DMDataRd_wb
);
  
  always @(posedge clk) begin
    PCP4_wb <= PCP4_me;
    RUWr_wb <= RUWr_me;
    RUDataWrSrc_wb <= RUDataWrSrc_me;
    RD_wb <= RD_me;
    ALURes_wb <= ALURes_me;
    DMDataRd_wb <= DMDataRd_me;
  end
endmodule