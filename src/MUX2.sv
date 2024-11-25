module MUX2(
  input logic [31:0] A,
  input logic [31:0] B,
  
  input logic Selector,
  
  output logic [31:0] Result
);
  
  always @(*) begin
    case(Selector)
      1'b1: Result <= A;
      1'b0: Result <= B;
      default: Result <= B;
    endcase
  end
 
endmodule