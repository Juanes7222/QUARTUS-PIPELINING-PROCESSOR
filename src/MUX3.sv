module MUX3(
  input logic [31:0] A,
  input logic [31:0] B,
  input logic [31:0] C,
  
  input logic [1:0] Selector,
  
  output logic [31:0] Result
);
  
  always @(*)
    case(Selector)
      2'b10: Result <= A;
      2'b01: Result <= B;
      2'b00: Result <= C;
      default: Result <= C;
    endcase
 
endmodule