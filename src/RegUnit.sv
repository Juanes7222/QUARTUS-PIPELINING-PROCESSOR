module RegUnit(
  input clk,
  input Enable,
  
  input logic [4:0] RS1,
  input logic [4:0] RS2,
  input logic [4:0] RD,
  input logic [31:0] DataWr,
  input logic RUWr,
  
  output logic [31:0] RU1,
  output logic [31:0] RU2
);
  
  logic [31:0] RU [31:0];
  
  initial begin
    $readmemb ("RegFile.txt", RU);
  end

  always @(*) begin
    if(clk == 1) begin
      if(RUWr === 1 && RD !== 0) begin
        RU[RD] <= DataWr;
      end
      
      RU1 <= RU[RS1];
      RU2 <= RU[RS2];
    end
  end
  
endmodule