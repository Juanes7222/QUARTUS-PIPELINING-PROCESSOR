module ControlUnit(
  input logic [6:0] OpCode,
  input logic [2:0] Func3,
  input logic [6:0] Func7,
  
  output logic RUWr,
  output logic [3:0] ALUOp,
  output logic [2:0] ImmSrc,
  output logic ALUASrc,
  output logic ALUBSrc,
  output logic DMWr,
  output logic [2:0] DMCtrl,
  output logic [4:0] BrOp,
  output logic [1:0] RUDataWrSrc
);
  
  always @(*)
    case(OpCode)
      
      7'b0110011: begin //Tipo R
        RUWr = 1;
        ALUOp = {Func7[5], Func3};
        ImmSrc = 3'bxxx;
        ALUASrc = 0;
        ALUBSrc = 0;
        DMWr = 1'bx;
        DMCtrl = 3'bxxx;
        BrOp = 5'b00xxx;
        RUDataWrSrc = 2'b00;       
      end
      
      7'b0010011: begin //Tipo I
        RUWr = 1;
        ALUOp = {Func7[5], Func3};
        ImmSrc = 3'b000;
        ALUASrc = 0;
        ALUBSrc = 1;
        DMWr = 1'bx;
        DMCtrl = 3'bxxx;
        BrOp = 5'b00xxx;
        RUDataWrSrc = 2'b00;      
      end
      
      7'b0000011: begin //Tipo I-Carga
        RUWr = 1;
        ALUOp = 4'b0000;
        ImmSrc = 3'b000;
        ALUASrc = 0;
        ALUBSrc = 1;
        DMWr = 0;
        DMCtrl = Func3;
        BrOp = 5'b00xxx;
        RUDataWrSrc = 2'b01;     
      end
      
      7'b0100011: begin //Tipo S
        RUWr = 0;
        ALUOp = 4'b0000;
        ImmSrc = 3'b001;
        ALUASrc = 0;
        ALUBSrc = 1;
        DMWr = 1;
        DMCtrl = Func3;
        BrOp = 5'b00xxx;
        RUDataWrSrc = 2'bxx;      
      end
      
      7'b1100011: begin //Tipo B
        RUWr = 0;
        ALUOp = 4'b0000;
        ImmSrc = 3'b101;
        ALUASrc = 1;
        ALUBSrc = 1;
        DMWr = 1'bx;
        DMCtrl = 3'bxxx;
        BrOp = {2'b01, Func3};
        RUDataWrSrc = 2'bxx;       
      end
      
      7'b1101111: begin //Tipo J
        RUWr = 1;
        ALUOp = 4'b0000;
        ImmSrc = 3'b110;
        ALUASrc = 1;
        ALUBSrc = 1;
        DMWr = 1'bx;
        DMCtrl = 3'bxxx;
        BrOp = 5'b1xxxx;
        RUDataWrSrc = 2'b10;      
      end
      
      7'b1100111: begin //Tipo I-Salto
        RUWr = 1;
        ALUOp = 4'b0000;
        ImmSrc = 3'b000;
        ALUASrc = 0;
        ALUBSrc = 1;
        DMWr = 1'bx;
        DMCtrl = 3'bxxx;
        BrOp = 5'b1xxxx;
        RUDataWrSrc = 2'b10;      
      end
      
      7'b0110111: begin //Tipo U
        RUWr = 0;
        ALUOp = 4'b0111;
        ImmSrc = 3'b010;
        ALUASrc = 1'bx;
        ALUBSrc = 1;
        DMWr = 1'bx;
        DMCtrl = 3'bxxx;
        BrOp = 5'b00xxx;
        RUDataWrSrc = 2'b00;      
      end
      
    endcase
endmodule