module HazardDetUnit(
  input logic [4:0] rs1_de,
  input logic [4:0] rs2_de,
  input logic [4:0] RD_ex,
  
  input logic DMWr_ex, //SE ESCRIBE EN MEMORIA?
  
  output logic Result = 0
);
  
  always @(*) begin
    if(DMWr_ex === 1'b0) begin
      if(rs1_de == RD_ex || rs2_de == RD_ex) begin Result <= 1;  
    end
      else Result <= 0;  //Si DMWR_ex = 1, se da por hecho que esta escribiendo en la memoria por lo que no implica rd
    end else Result <= 0;
  end
  
endmodule
