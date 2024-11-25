module MemStage(
  input logic clk, 
  
  input logic [31:0] PCP4_ex,
  
  input logic RUWr_ex,
  input logic DMWr_ex,
  input logic [1:0] RUDataWrSrc_ex,
  input logic [2:0] DMCtrl_ex,
  
  input logic [31:0] RUrs2_ex,
  
  input logic [4:0] RD_ex,
  
  input logic [31:0] ALURes_ex,
  
  output logic [31:0] PCP4_me,
  
  output logic RUWr_me,
  output logic DMWr_me,
  output logic [1:0] RUDataWrSrc_me,
  output logic [2:0] DMCtrl_me,
  
  output logic [31:0] RUrs2_me,
  
  output logic [4:0] RD_me,
  
  output logic [31:0] ALURes_me
);
  
  always @(posedge clk) begin
    PCP4_me <= PCP4_ex;
    RUWr_me <= RUWr_ex;
    DMWr_me <= DMWr_ex;
    RUDataWrSrc_me <= RUDataWrSrc_ex;
    DMCtrl_me <= DMCtrl_ex;
    RUrs2_me <= RUrs2_ex;
    RD_me <= RD_ex;
    ALURes_me <= ALURes_ex;
  end

endmodule