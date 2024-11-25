module FetchStage(
  input logic clk, 
  input logic Enable,
  
  input logic [31:0] PC,
  
  output logic [31:0] PC_fe = 32'b0
);
  
  always @(posedge clk)
    if(Enable === 0) PC_fe <= PC;  //Si no hay data hazard
    
endmodule