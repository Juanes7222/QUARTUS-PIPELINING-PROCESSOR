module CPU(
	input logic clk,
	
	output [31:0] PC_fe_vga, PC_de_vga, PC_ex_vga, PCP4_me_vga, PCP4_wb_vga, inst, imm, rs1, rs2, rd, a, b, res, wrb, addr, datard,
	output [31:0] Ru [0:31],
	output [2:0] ctrl,
	output [3:0] alu_ctrl, 
	output [4:0] BrOp_vga
	
	);
  
  //GLOBALES
  wire [31:0] NextPC;
  wire NextPCSrc;
  
  //FETCH
  wire [31:0] PC_fe, PCP4;
  wire [31:0] Inst;
  
  //DECODE
  wire [31:0] PC_de, PCP4_de, Inst_de;
  
  wire RUWr, ALUASrc, ALUBSrc, DMWr;
  wire [1:0] RUDataWrSrc;
  wire [2:0] ImmSrc, DMCtrl;
  wire [3:0] ALUOp;
  wire [4:0] BrOp;

  wire [31:0] RUrs1, RUrs2;
  
  wire [31:0] ImmExt;
  
  //Unidad de Detección (data hazard)
  wire ResultHazardUnit;
  
  //EXECUTE
  wire [31:0] PC_ex, PCP4_ex;
  
  wire RUWr_ex, ALUASrc_ex, ALUBSrc_ex, DMWr_ex;
  wire [1:0] RUDataWrSrc_ex;
  wire [2:0] DMCtrl_ex;
  wire [3:0] ALUOp_ex;
  wire [4:0] BrOp_ex;
  
  wire [31:0] RUrs1_ex, RUrs2_ex;
  
  wire [31:0] ImmExt_ex;
  
  wire [4:0] RD_ex;
  wire [4:0] rs1_ex;
  wire [4:0] rs2_ex;
  
 
  wire [31:0] A;  //MUXALUA
  
  wire [31:0] B;  //MUXALUB
  
  wire [31:0] ALURes;
  
  //Unidad de Adelantamientos (data hazard)
  wire [1:0] SelectorRUrs1; 
  wire [1:0] SelectorRUrs2;
  
  wire [31:0] RUrs1Selected; //MUX RUrs1 
  wire [31:0] RUrs2Selected; //MUX RUrs2
  
  //MEMORY
  wire [31:0] PCP4_me;
  
  wire RUWr_me, DMWr_me;
  wire [1:0] RUDataWrSrc_me;
  wire [2:0] DMCtrl_me;
  
  wire [31:0] RUrs2_me; 
  wire [4:0] RD_me;
  
  wire [31:0] ALURes_me;
  
  wire [31:0] DataRd;
  
  //WRITEBACK
  wire [31:0] PCP4_wb;
  
  wire RUWr_wb;
  wire [1:0] RUDataWrSrc_wb;
  
  wire [4:0] RD_wb;
  
  wire [31:0] ALURes_wb;
  
  wire [31:0] DMDataRd_wb;
 
  wire [31:0] DataWr;

  
  //FETCH
  
  FetchStage fetch(  
  .clk(clk),                  // Señal de reloj.
  .Enable(ResultHazardUnit),  // Habilita la ejecución en caso de no haber hazard.
  .PC(NextPC),                // Dirección del próximo PC calculado.
  .PC_fe(PC_fe)               // Dirección del PC actual en esta etapa.
  );

  
  Adder Adder(
  .PC(PC_fe),                 // Dirección del PC actual.
  .PCP4(PCP4)                 // Dirección del siguiente PC (PC+4).
  );

  
  InstMem InstMem(
  .PC(PC_fe),                 // Dirección del PC actual.
  .Inst(Inst)                 // Instrucción leída de memoria en esa dirección.
  );
  
  //DECODE
  
  DecodeStage decode(         //Si no hay hazard pasa las señales de fetch a decode
  .clk(clk),                  
  .Enable(ResultHazardUnit),  // Habilita el avance si no hay hazard.
  .Clr(NextPCSrc),            // Cuando hay un branch, se necesita limpiar cualquier instrucción que ya haya ingresado al pipeline y que no deba ejecutarse debido al cambio de flujo de control
  .PCP4_fe(PCP4),             // Dirección calculada de PC+4 desde FETCH.
  .PC_fe(PC_fe),              // Dirección del PC actual desde FETCH.
  .Inst_fe(Inst),             // Instrucción actual desde FETCH.
  .PCP4_de(PCP4_de),          // Dirección PC+4 pasada a DECODE.
  .PC_de(PC_de),              // Dirección del PC actual pasada a DECODE.
  .Inst_de(Inst_de)           // Instrucción actual pasada a DECODE.
  );

  
  HazardDetUnit HazardDetUnit(  // (DATA HAZARD DE MEMORIA) tipo load, donde el dato aún no está disponible en EXECUTE para ser reenviado.
  .rs1_de(Inst_de[19:15]),    // Primer registro fuente extraído de la instrucción.
  .rs2_de(Inst_de[24:20]),    // Segundo registro fuente extraído de la instrucción.
  .RD_ex(RD_ex),              // Registro destino de la etapa EXECUTE.
  .DMWr_ex(DMWr_ex),          // Señal de escritura en memoria desde EXECUTE.
  .Result(ResultHazardUnit)   // Señal que indica si hay hazard.
  );

  
  ControlUnit ControlUnit(
    .OpCode(Inst_de[6:0]),
    .Func3(Inst_de[14:12]),
    .Func7(Inst_de[31:25]),
    .RUWr(RUWr),
    .ALUOp(ALUOp),
    .ImmSrc(ImmSrc),
    .ALUASrc(ALUASrc),
    .ALUBSrc(ALUBSrc),
    .DMWr(DMWr),
    .DMCtrl(DMCtrl),
    .BrOp(BrOp),
    .RUDataWrSrc(RUDataWrSrc)
  );
  
  RegUnit RegUnit(
    .clk(clk),
    .Enable(ResultHazardUnit),  // Permite leer/escribir si no hay hazard.
    .RS1(Inst_de[19:15]),
    .RS2(Inst_de[24:20]),
    .RD(RD_wb),
    .DataWr(DataWr),
    .RUWr(RUWr_wb),
    .RU1(RUrs1),
    .RU2(RUrs2),
	 .Ru_vga(Ru)
  );
  
  ImmUnit ImmUnit(
    .Inst(Inst_de[31:7]),  //Parte de instruccion en decode
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
  );
  
  //EXECUTE
  
  ExeStage execute(   //si NO hay hazards pasamos las señales de decode a execution
    .clk(clk),
    .Clr1(ResultHazardUnit),  //data hazard
    .Clr2(NextPCSrc),   //control hazard
    .PCP4_de(PCP4_de),
    .PC_de(PC_de),
    .RUWr_de(RUWr),
    .ALUASrc_de(ALUASrc),
    .ALUBSrc_de(ALUBSrc),
    .DMWr_de(DMWr),
    .RUDataWrSrc_de(RUDataWrSrc),
    .DMCtrl_de(DMCtrl),
    .ALUOp_de(ALUOp),
    .BrOp_de(BrOp),
    .RUrs1_de(RUrs1),
    .RUrs2_de(RUrs2),
    .ImmExt_de(ImmExt),
    .RD_de(Inst_de[11:7]),
    .rs1_de(Inst_de[19:15]),
    .rs2_de(Inst_de[24:20]),
    
    .PCP4_ex(PCP4_ex),
    .PC_ex(PC_ex),
    .RUWr_ex(RUWr_ex),
    .ALUASrc_ex(ALUASrc_ex),
    .ALUBSrc_ex(ALUBSrc_ex),
    .DMWr_ex(DMWr_ex),
    .RUDataWrSrc_ex(RUDataWrSrc_ex),
    .DMCtrl_ex(DMCtrl_ex),
    .ALUOp_ex(ALUOp_ex),
    .BrOp_ex(BrOp_ex),
    .RUrs1_ex(RUrs1_ex),
    .RUrs2_ex(RUrs2_ex),
    .ImmExt_ex(ImmExt_ex),
    .RD_ex(RD_ex),
    .rs1_ex(rs1_ex),
    .rs2_ex(rs2_ex)
  );
  
     //Reenvío para resolver data hazards donde no debemos esperar hasta que se escriba en los registros si no que podemos extraer los valores
    ForwardingUnit ForwardingUnit(
      .rs1_ex(rs1_ex),               // Dirección del primer registro fuente (`rs1`) en la etapa EXECUTE.
      .rs2_ex(rs2_ex),               // Dirección del segundo registro fuente (`rs2`) en la etapa EXECUTE.
      .RD_me(RD_me),                 // Dirección del registro destino (`RD`) desde la etapa MEMORY.
      .RUWr_me(RUWr_me),             // Señal que indica si el registro destino en MEMORY se escribe.
      .RD_wb(RD_wb),                 // Dirección del registro destino (`RD`) desde la etapa WRITEBACK.
      .RUWr_wb(RUWr_wb),             // Señal que indica si el registro destino en WRITEBACK se escribe.
      .SelectorRUrs1(SelectorRUrs1), // Selector que indica de dónde tomar los datos para `rs1` (MEMORY, WRITEBACK o DECODE).
      .SelectorRUrs2(SelectorRUrs2)  // Selector que indica de dónde tomar los datos para `rs2` (MEMORY, WRITEBACK o DECODE).
    );

    // MUX3 para seleccionar el valor correcto de `rs1` tras resolver el hazard
    MUX3 MUXrs1(
      .A(DataWr),                // Opción 0: Datos reenviados desde la etapa WB (WriteBack).
      .B(ALURes_me),             // Opción 1: Datos reenviados desde la etapa MEM (Memory).
      .C(RUrs1_ex),              // Opción 2: Datos originales del banco de registros (etapa DECODE).
      .Selector(SelectorRUrs1),  // Selector generado por la ForwardingUnit según el hazard detectado.
      .Result(RUrs1Selected)     // Salida: dato seleccionado para `rs1` en la etapa EXECUTE.
    );

    // MUX3 para seleccionar el valor correcto de `rs2` tras resolver el hazard
    MUX3 MUXrs2(
      .A(DataWr),                // Opción 0: Datos reenviados desde la etapa WB (WriteBack).
      .B(ALURes_me),             // Opción 1: Datos reenviados desde la etapa MEM (Memory).
      .C(RUrs2_ex),              // Opción 2: Datos originales del banco de registros (etapa DECODE).
      .Selector(SelectorRUrs2),  // Selector generado por la ForwardingUnit según el hazard detectado.
      .Result(RUrs2Selected)     // Salida: dato seleccionado para `rs2` en la etapa EXECUTE.
    );

    // MUX2 para seleccionar el valor correcto de la entrada A en la ALU
    MUX2 MUXALUA(
      .A(PC_ex),                 // Opción 0: La dirección del PC (para operaciones de cálculo de salto).
      .B(RUrs1Selected),         // Opción 1: El valor final de `rs1` tras resolver hazards.
      .Selector(ALUASrc_ex),     // Selector que decide la fuente del operando A, generado por la Control Unit.
      .Result(A)                 // Salida: Operando A para la ALU.
    );

    // MUX2 para seleccionar el valor correcto de la entrada B en la ALU
    MUX2 MUXALUB(
      .A(ImmExt_ex),             // Opción 0: Valor inmediato extendido desde la instrucción.
      .B(RUrs2Selected),         // Opción 1: El valor final de `rs2` tras resolver hazards.
      .Selector(ALUBSrc_ex),     // Selector que decide la fuente del operando B, generado por la Control Unit.
      .Result(B)                 // Salida: Operando B para la ALU.
    );

    // Unidad de ejecución (ALU)
    ALU ALU(
      .A(A),                     // Operando A, seleccionado por MUXALUA.
      .B(B),                     // Operando B, seleccionado por MUXALUB.
      .ALUOp(ALUOp_ex),          // Operación que debe realizar la ALU, definida por la Control Unit.
      .ALURes(ALURes)            // Resultado de la operación realizada por la ALU.
    );

  
  BranchUnit BranchUnit(
    .RU1(RUrs1Selected),
    .RU2(RUrs2Selected),
    .BrOp(BrOp_ex),
    .NextPCSrc(NextPCSrc)
  );
  
  MUX2 MUXNextPC(
    .A(ALURes),
    .B(PCP4),
    .Selector(NextPCSrc),
    .Result(NextPC)
  );
  
  //MEMORY
  
  MemStage memory(  //(Su funcionamiento se basa únicamente en los datos que reciben y procesan)
    .clk(clk),
    .PCP4_ex(PCP4_ex),
    .RUWr_ex(RUWr_ex),
    .DMWr_ex(DMWr_ex),
    .RUDataWrSrc_ex(RUDataWrSrc_ex),
    .DMCtrl_ex(DMCtrl_ex),
    .RUrs2_ex(RUrs2_ex),
    .RD_ex(RD_ex),
    .ALURes_ex(ALURes),
    
    .PCP4_me(PCP4_me),
    .RUWr_me(RUWr_me),
    .DMWr_me(DMWr_me),
    .RUDataWrSrc_me(RUDataWrSrc_me),
    .DMCtrl_me(DMCtrl_me),
    .RUrs2_me(RUrs2_me),
    .RD_me(RD_me),
    .ALURes_me(ALURes_me)
  );
  
  DataMemory DataMemory(
    .Address(ALURes_me),
    .DataWr(RUrs2_me),
    .DMWr(DMWr_me),
    .DMCtrl(DMCtrl_me),
    .DataRd(DataRd)
  );
  
  //WRITE BACK (Su funcionamiento se basa únicamente en los datos que reciben y procesan)
  
  WBStage writeback(
    .clk(clk),
    .PCP4_me(PCP4_me),
    .RUWr_me(RUWr_me),
    .RUDataWrSrc_me(RUDataWrSrc_me),
    .RD_me(RD_me),
    .ALURes_me(ALURes_me),
    .DMDataRd_me(DataRd),
    
    .PCP4_wb(PCP4_wb),
    .RUWr_wb(RUWr_wb),
    .RUDataWrSrc_wb(RUDataWrSrc_wb),
    .RD_wb(RD_wb),
    .ALURes_wb(ALURes_wb),
    .DMDataRd_wb(DMDataRd_wb)
  );
    
  MUX3 MUXRUDataWr(
    .A(PCP4_wb),
    .B(DMDataRd_wb),
    .C(ALURes_wb),
    .Selector(RUDataWrSrc_wb),
    .Result(DataWr)
  );
  
  assign PC_fe_vga = PC_fe;
  assign PC_de_vga = PC_de;
  assign PC_ex_vga = PC_ex;
  assign PCP4_me_vga = PCP4_me;
  assign PCP4_wb_vga = PCP4_wb;
  
  assign inst = Inst;
  assign imm = ImmExt;
  assign rs1 = RUrs1;
  assign rs2 = RUrs2;
  assign rd = RD_wb;
  
  assign a = A;
  assign b = B;
  assign res = ALURes;
  
  assign wrb = DataWr;
  assign addr = ALURes_me;
  assign datard = DataRd;
  
  assign ctrl = DMCtrl_me;
  assign alu_ctrl = ALUOp_ex;
  assign BrOp_vga = BrOp_ex;
  
 endmodule