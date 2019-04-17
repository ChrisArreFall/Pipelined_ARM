module pipelineControlUnit(input logic clk, reset,
									input  logic [31:0] InstrF,
									input  logic [3:0] ALUFlags,
									input  logic stallD, flushD, flushE,
									output logic [1:0] RegSrcD,
									output logic RegWriteM, RegWriteW,
									output logic [1:0] ImmSrcD,
									output logic ALUSrcE,
									output logic [3:0] ALUControlE,
									output logic MemWriteM, MemtoRegW, MemtoRegE,PCSrcW,
									output logic BranchTakenE,PCW_DEM);
				//Va a estar dividido en Fetch(F) Decode(D) Execute(E) Memory(M) Writeback(W)
				//Empezamos inicializando variables necesarias para el funcionamiento del Control Unit
				//Empezamos con la instruccion de entrada y salida de el registro que conecta el stage Fetch y Decode
				logic [31:0] InstFtoInstD_IN, InstFtoInstD_OUT;
				logic [20:0] DtoEReg_IN, DtoEReg_OUT;
				logic [3:0]  ALUControlD, Flags, EtoMReg_IN, EtoMReg_OUT;
				logic [2:0] MtoWBReg_IN, MtoWBReg_OUT;
				logic [1:0]	 FlagWriteD, FlagWrite;
				logic			 PCSrcD, RegWriteD, MemWriteD,NoWrite, MemtoRegD, ALUSrcD, 
								 BranchD, CondEx, RegWriteE, MemWriteE, PCSrcE;
				//---------------------------------------Fetch a Decode---------------------------------------------------------------------------------
				//asignamos la entrada del registro a la instruccion obtenida del instruction memory
				assign InstFtoInstD_IN = { InstrF };
				//obtenemos la salida del primer registro del pipeline 
				pipelineRegFtoD  #(32) pipelineRegFtoD_Unit( clk, reset, ~stallD, flushD, InstFtoInstD_IN, InstFtoInstD_OUT);
				//Inicializamos el decoder para la instruccion
				//								Op					     funct				           Rd						
				pipelineDecoder pipelineDecoder_Unit(.Op(InstFtoInstD_OUT[27:26]), .Funct(InstFtoInstD_OUT[25:20]), .Rd(InstFtoInstD_OUT[15:12]),
																 .FlagW(FlagWriteD), .PCS(PCSrcD), .RegW(RegWriteD), .MemW(MemWriteD),.NoWrite(NoWrite), .MemtoReg(MemtoRegD), 
																 .ALUSrc(ALUSrcD), .ImmSrc(ImmSrcD), .RegSrc(RegSrcD), .ALUControl(ALUControlD), .BranchD(BranchD));
				//---------------------------------------Decode a Execute---------------------------------------------------------------------------------
				//Ahora seguimos con la etapa de Decode a Execute
				//							    4       1        1          1         1         1           4          1        1         1                 4    
				//                   [20:17]   [16]     [15]       [14]      [13]      [12]       [11:8]       [7]      [6]      [5:4]             [3:0]
				assign DtoEReg_IN = { Flags, PCSrcD, RegWriteD, MemtoRegD, NoWrite, MemWriteD, ALUControlD, BranchD, ALUSrcD, FlagWriteD, InstFtoInstD_OUT[31:28]};
				pipelineRegDtoE #(21) pipelineRegDtoE_Unit( clk, reset, flushE, DtoEReg_IN, DtoEReg_OUT );
				//DtoEReg_OUT = FlagsE PCSrcE RegWriteE MemtoRegE NoWrite MemWriteE ALUControlE BranchE ALUSrcE FlagWriteE CondE
				//					   4      1       1         1          1       1          4         1       1         1       4    
				//             [20:17] [16]    [15]      [14]       [13]    [12]      [11:8]      [7]     [6]      [5:4]   [3:0]
				
				//Para el caso del procesador uniciclo, se creo un modulo para la parte condicional, sin embargo 
				//para agregarle el pipeline, es mas siple hacerlo aqui mismo
				//Se inicia guardando el valor de los flags
				flipflopD #(2)flagReg1( clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]);
				flipflopD #(2)flagReg0( clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]);
				
				//                             FlagsE               CondE
				conditions conditions_Unit( DtoEReg_OUT[3:0], DtoEReg_OUT[20:17], CondEx);
				
				//									 FlagWriteE
				assign FlagWrite  		= DtoEReg_OUT[5:4] & {2{CondEx}};
				//									 RegWriteE                     NoWrite
				assign RegWriteE  		= DtoEReg_OUT[15]  & CondEx & ~DtoEReg_OUT[13];
				//									 MemWriteE
				assign MemWriteE  		= DtoEReg_OUT[12]  & CondEx;
				//                           PCSrcE
				assign PCSrcE     		= DtoEReg_OUT[16]  & CondEx;
				//									  BranchE
				assign BranchTakenE    	= DtoEReg_OUT[7]  & CondEx;
				//                           ALUSrcE
				assign ALUSrcE 		 	= DtoEReg_OUT[6];			// ALUSrcE llega al Mux que esta antes de la ALU en el datapath
				//									ALUControlE
				assign ALUControlE		= DtoEReg_OUT[11:8];		// ALUControlE que esta conectado a la ALU en el datapath		
				//									 MemtoRegE
				assign MemtoRegE   		= DtoEReg_OUT[14]; 		// MemtoRegE al hazard Unit
				
				//---------------------------------------Execute a Memory---------------------------------------------------------------------------------
				//
				assign EtoMReg_IN = {PCSrcE, RegWriteE, MemtoRegE, MemWriteE};
				pipelineRegEtoM #(4) pipelineRegEtoM_Unit( clk, reset, EtoMReg_IN, EtoMReg_OUT ); 
				//EtoMReg_OUT = PCSrcM RegWriteM MemtoRegM MemWriteM
				assign MemWriteM = EtoMReg_OUT[0]; 			// MemWrite a la memoria de datos		
				assign RegWriteM = EtoMReg_OUT[2];			// RegWriteM al hazard Unit
																					
				//---------------------------------------Memory a Writeback---------------------------------------------------------------------------------
				//								 PCSrcW          RegWriteW       MemtoRegW
				assign MtoWBReg_IN = {EtoMReg_OUT[3], EtoMReg_OUT[2], EtoMReg_OUT[1]}; 
				
				pipelineRegMtoWB #(3) pipelineRegMtoWB_Unit( clk, reset, MtoWBReg_IN, MtoWBReg_OUT );
				
				assign PCSrcW 		 = MtoWBReg_OUT[2];					// PCSrc al mux antes del PC
				assign RegWriteW   = MtoWBReg_OUT[1];					// RegWriteW a la memoria de registros y hazard UNit
				assign MemtoRegW   = MtoWBReg_OUT[0];					// MemtoRegW al mux final del datapath
				
				// si PCW_DEM = 1 entonces se esta reescribiendo el PC en alguna de las etapas de Decode, Execute o Memory		
				assign PCW_DEM = PCSrcD + PCSrcE + EtoMReg_OUT[3]; 	
								
					
endmodule 
