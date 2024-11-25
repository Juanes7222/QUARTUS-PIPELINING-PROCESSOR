module ForwardingUnit(
  input logic [4:0] rs1_ex,         // Dirección del primer registro fuente (rs1) en la etapa EX.
  input logic [4:0] rs2_ex,         // Dirección del segundo registro fuente (rs2) en la etapa EX.
  input logic [4:0] RD_me,          // Dirección del registro destino (RD) en la etapa MEM.
  input logic RUWr_me,              // Señal que indica si la instrucción en MEM escribe en el banco de registros.
  input logic [4:0] RD_wb,          // Dirección del registro destino (RD) en la etapa WB.
  input logic RUWr_wb,              // Señal que indica si la instrucción en WB escribe en el banco de registros.
  
  output logic [1:0] SelectorRUrs1, // Selector para multiplexar el valor de rs1 en la etapa EX:
                                    // 00: valor original del banco de registros.
                                    // 01: valor reenviado desde MEM.
                                    // 10: valor reenviado desde WB.
  output logic [1:0] SelectorRUrs2  // Selector para multiplexar el valor de rs2 en la etapa EX:
                                    // 00: valor original del banco de registros.
                                    // 01: valor reenviado desde MEM.
                                    // 10: valor reenviado desde WB.
);
  
  always @(*) begin
    // Verifica si `rs1_ex` coincide con `RD_me` y si MEM está escribiendo en registros.
    if (rs1_ex == RD_me && RUWr_me == 1 && RD_me !== 0) 
      SelectorRUrs1 <= 2'b01;       // Selecciona el dato reenviado desde MEM para rs1.
    else begin
      // Si no coincide con MEM, verifica si `rs1_ex` coincide con `RD_wb` y si WB está escribiendo en registros.
      if (rs1_ex == RD_wb && RUWr_wb == 1 && RD_wb !== 0) 
        SelectorRUrs1 <= 2'b10;     // Selecciona el dato reenviado desde WB para rs1.
      else 
        SelectorRUrs1 <= 2'b00;     // Si no coincide con MEM ni WB, usa el valor original del banco de registros.
    end
    
    // Verifica si `rs2_ex` coincide con `RD_me` y si MEM está escribiendo en registros.
    if (rs2_ex == RD_me && RUWr_me == 1 && RD_me !== 0) 
      SelectorRUrs2 <= 2'b01;       // Selecciona el dato reenviado desde MEM para rs2.
    else begin
      // Si no coincide con MEM, verifica si `rs2_ex` coincide con `RD_wb` y si WB está escribiendo en registros.
      if (rs2_ex == RD_wb && RUWr_wb == 1 && RD_wb !== 0) 
        SelectorRUrs2 <= 2'b10;     // Selecciona el dato reenviado desde WB para rs2.
      else 
        SelectorRUrs2 <= 2'b00;     // Si no coincide con MEM ni WB, usa el valor original del banco de registros.
    end
  end

endmodule

