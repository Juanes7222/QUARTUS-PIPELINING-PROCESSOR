module BranchUnit(
  input logic [31:0] RU1, 
  input logic [31:0] RU2,
  
   
  input logic [4:0] BrOp,
  
  output logic NextPCSrc
);
  
  always @(*)
    case(BrOp[4:3])
      2'b00: begin
        NextPCSrc <= 0;
      end
      
      2'b01: begin
        case(BrOp[2:0])
          3'b000: begin
            if(RU1 == RU2) begin NextPCSrc <= 1; end
            else begin NextPCSrc <= 0; end 
          end
          
          3'b001: begin
            if (RU1 != RU2) begin NextPCSrc <= 1; end
            else begin NextPCSrc <= 0; end
          end
          
          3'b100: begin
            if (RU1 < RU2) begin NextPCSrc <= 1; end
            else begin NextPCSrc = 0; end
          end
          
          3'b101: begin
            if (RU1 >= RU2) begin NextPCSrc <= 1; end
            else begin NextPCSrc <= 0; end
          end
          
          3'b110: begin
            if (RU1 < $unsigned(RU2)) begin NextPCSrc <= 1; end
            else begin NextPCSrc <= 0; end
          end
          
          3'b111: begin
            if (RU1 >= $unsigned(RU2)) begin NextPCSrc <= 1; end
            else begin NextPCSrc <= 0; end
          end
        endcase
        
      end
          
      2'b1x: begin
        NextPCSrc <= 1;
      end
    endcase
endmodule