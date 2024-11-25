module DecodeStage(
  input logic clk, 
  input logic Enable,
  input logic Clr,
  
  input logic [31:0] PCP4_fe,
  input logic [31:0] PC_fe,
  input logic [31:0] Inst_fe,
  
  output logic [31:0] PCP4_de,
  output logic [31:0] PC_de,
  output logic [31:0] Inst_de
);
  
  always @(posedge clk) begin
  
    if(Clr === 1) begin    //Clr = 1 control hazard (indica un salto), la instrucción se reemplaza con NOP
      PCP4_de <= 32'bx;
      PC_de <= 32'bx;
      Inst_de <= 32'h00000033;
    end else if(Enable === 0) begin  // Si no hay data hazard (la instrucción puede avanzar normalmente en el pipeline).
      PCP4_de <= PCP4_fe;
      PC_de <= PC_fe;
      Inst_de <= Inst_fe;
    end
    
  end

endmodule