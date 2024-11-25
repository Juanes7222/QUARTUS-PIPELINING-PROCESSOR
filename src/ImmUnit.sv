module ImmUnit(
  input logic [24:0] Inst,
  input logic [2:0] ImmSrc,
  
  output logic [31:0] ImmExt
);
  
  always @(*)
    begin
      case(ImmSrc)
        3'b000: begin
          
          if(Inst[24] == 1) ImmExt <= -$signed(Inst[24:13]); //I negativo
          else if(Inst[24] == 0 && Inst[23] == 1) ImmExt <= -$signed(Inst[24:13]); //I positivo pero Func7[5] = 1;
          else ImmExt <= $signed(Inst[24:13]); //I positivo
          
        end
        
        3'b001: ImmExt <= $signed({Inst[24:18], Inst[4:0]}); //S
        3'b101: ImmExt <= $signed({Inst[24], Inst[0], Inst[23:18], Inst[4:1], 1'b0}); //B
        3'b010: ImmExt <= $signed(Inst[24:5]); //U
        3'b110: ImmExt <= $signed({Inst[24], Inst[12:5], Inst[13], Inst[23:14], 1'b0}); //J
       endcase
    end
endmodule