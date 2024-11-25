module ExeStage(
  input logic clk, 
  input logic Clr1,
  input logic Clr2,
  
  input logic [31:0] PCP4_de,
  input logic [31:0] PC_de,
  
  input logic RUWr_de, 
  input logic ALUASrc_de, 
  input logic ALUBSrc_de, 
  input logic DMWr_de,
  input logic [1:0] RUDataWrSrc_de,
  input logic [2:0] DMCtrl_de,
  input logic [3:0] ALUOp_de,
  input logic [4:0] BrOp_de,
  
  input logic [31:0] RUrs1_de,
  input logic [31:0] RUrs2_de,
  
  input logic [31:0] ImmExt_de,
  
  input logic [4:0] RD_de,
  input logic [4:0] rs1_de,
  input logic [4:0] rs2_de,
  
  output logic [31:0] PCP4_ex,
  output logic [31:0] PC_ex,
  
  output logic RUWr_ex, 
  output logic ALUASrc_ex, 
  output logic ALUBSrc_ex, 
  output logic DMWr_ex,
  output logic [1:0] RUDataWrSrc_ex,
  output logic [2:0] DMCtrl_ex,
  output logic [3:0] ALUOp_ex,
  output logic [4:0] BrOp_ex,
  
  output logic [31:0] RUrs1_ex, 
  output logic [31:0] RUrs2_ex,
  
  output logic [31:0] ImmExt_ex,
  
  output logic [4:0] RD_ex,
  output logic [4:0] rs1_ex,
  output logic [4:0] rs2_ex
);
  
  always @(posedge clk) begin
    if(Clr1 === 1 || Clr2 === 1) begin
      PCP4_ex <= 32'bx;
      PC_ex <= 32'bx;
      RUWr_ex <= 1;
      ALUASrc_ex <= 0;
      ALUBSrc_ex <= 0;
      DMWr_ex <= 1'bx;
      DMCtrl_ex <= 3'bxxx;
      ALUOp_ex <= 4'b0000;
      BrOp_ex <= 5'b00xxx;
      RUDataWrSrc_ex <= 2'b00;
      
      RUrs1_ex <= 32'b0;
      RUrs2_ex <= 32'b0;
      
      ImmExt_ex <= 32'bx;
      
      RD_ex <= 5'b0;
      rs1_ex <= 5'b0;
      rs2_ex <= 5'b0;
    end else begin
      PCP4_ex <= PCP4_de;
      PC_ex <= PC_de;
      RUWr_ex <= RUWr_de;
      ALUASrc_ex <= ALUASrc_de;
      ALUBSrc_ex <= ALUBSrc_de;
      DMWr_ex <= DMWr_de;
      RUDataWrSrc_ex <= RUDataWrSrc_de;
      DMCtrl_ex <= DMCtrl_de;
      ALUOp_ex <= ALUOp_de;
      BrOp_ex <= BrOp_de;
      RUrs1_ex <= RUrs1_de;
      RUrs2_ex <= RUrs2_de;
      ImmExt_ex <= ImmExt_de;
      RD_ex <= RD_de;
      rs1_ex <= rs1_de;
      rs2_ex <= rs2_de;
    end
  end

endmodule