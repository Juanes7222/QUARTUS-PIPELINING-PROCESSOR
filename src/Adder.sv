module Adder(
  input logic [31:0] PC, 
  
  output logic [31:0] PCP4
);
  
  assign PCP4 = PC + 3'h4;

endmodule