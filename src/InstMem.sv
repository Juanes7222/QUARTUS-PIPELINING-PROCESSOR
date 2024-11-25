module InstMem(
  input logic [31:0] PC,
  output logic [31:0] Inst
);
  
  logic [7:0] mem [1024:0];
  
  initial begin
    $readmemb ("InstFile.txt", mem);
  end

  
  always @(*) begin
    Inst <= {mem[PC], mem[PC+1], mem[PC+2], mem[PC+3]};
  end
    
endmodule