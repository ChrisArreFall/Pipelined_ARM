module pipelineDatapath( input logic clk, reset, 
								 input logic [1:0] RegSrcD, 
								 input logic RegWriteW, 
								 input logic [1:0] ImmSrcD, 
								 input logic ALUSrcE, 
								 input logic [3:0] ALUControlE, 
								 input logic MemtoRegW, 
								 input logic PCSrcW,
								 input logic BranchTakenE, 
								 input logic [31:0] InstrF,
								 input logic [31:0] ReadData,
								 input  logic [1:0]  ForwardAE, ForwardBE,
								 input  logic  StallF, stallD, flushD, flushE, 
								 output logic [3:0] ALUFlags,
								 output logic [4:0]  match,
								 output logic [31:0] PCF, 
								 output logic [31:0] ALUOutM, WriteData);
					logic [31:0]  InstFtoInstD_IN, InstFtoInstD_OUT;		
					logic [107:0] DtoEReg_IN, DtoEReg_OUT;
					logic [67:0]  EtoMReg_IN, EtoMReg_OUT;
					logic [67:0]  MtoWBReg_IN, MtoWBReg_OUT;
					logic [31:0]  muxPC_Out, PCF, PCPlus4, ExtImm, WriteDataE, SrcAE, SrcBE,RD1,RD2, ResultW, ALUResultE;
					logic [3:0]   WA3W, WA3E, WA3M;
					logic [3:0]   RA1E, RA2E;		
							
							
					logic match_1e_m, match_2e_m, match_1e_w, match_2e_w, match_12d_e;
					
					//Iniciamos con los 2 mux detras del PC'
					//En el primero van conectados PC + 4 y el ResultW
					//						  S       A      B
					muxARM #(32)muxPC(PCSrcW,PCPlus4,ResultW,muxPC_Out);
					//En el segundo van conectado el resultado del mux anterior y ALUResultE
					muxARM #(32)muxBR(BranchTakenE,muxPC_Out,ALUResultE,PC);
					
					//Ahora proseguimos con el registro del PC
					pipelinePCReg #(32) pipelinePCReg_Unit(clk, reset, ~stallF, PC, PCF);	
					//Creamos el sumador del PCPlus4F
					adderARM #(32) adderARM_Unit(PC, 3'b100, PCPlus4);
					
					//--------------------------------------Registro de Fetch a Decode-----------------------------------------------------------
					assign InstFtoInstD_IN = {InstrF};
					pipelineRegFtoD  #(64) pipelineRegFtoD_Unit( clk, reset, ~stallD, flushD, InstFtoInstD_IN, InstFtoInstD_OUT);  //###################################################
					
					//Ahora proseguimos con la parte antes de la memoria de registros
					//El primer mux le entra Rn(Instr[19:16]) y el numero 15 ademas el selector seria el RegSrcD[0]
					MUX_2 #(4)  RA1DMux_Unit(InstFtoInstD_OUT[19:16], 4'b1111, RegSrc[0], RA1D);
					//El primer mux le entra Rm(Instr[3:0]) y el Rd(Inst[15:12]) el selector seria el RegSrcD[1]
					MUX_2 #(4)  RA2DMux_Unit(InstFtoInstD_OUT[3:0], InstFtoInstD_OUT[15:12], RegSrc[1], RA2D);
					//Ahora proseguimos con la memoria de registros
					register_file register_file_unit(clk, 				//CLK
																RegWriteW,		//WE3
																RA1D,				//A1
																RA2D,				//A2
																WA3W,				//A3
																ResultW,			//WD3
																PCPlus4,			//R15
																RD1,				//RD1
																RD2);				//RD2
												
												
					//Ahora el extend
					extend extend_unit(ImmSrc,
											 InstFtoInstD_OUT[23:0],
											 ExtImm);
					//--------------------------------------Registro de Decode a Execute-----------------------------------------------------------
					//Proseguimos a crear la variable de entrada, la cual contiene las variables necesarias para la siguiente etapa
					//							RA2D  RA1D  RD1  RD2       Rd(Inst[15:12])   Salida del extend   
					//							 4     4     32   32             4               32
					assign DtoEReg_IN = {RA2D, RA1D, RD1, RD2, InstFtoInstD_OUT[15:12], ExtImm};
					
					pipelineRegDtoE #(108) pipelineRegDtoE_Unit(clk, reset, flushE, DtoEReg_IN, DtoEReg_OUT);  //###################################################
					//DtoEReg_OUT =   RA2E      RA1E    RD1E       RD2E   WA3E(InstrE[15:12])  ExtImmE
					//					[107:104] [103:100] [99:68]   [67:36]      [35:32]          [31:0]
					
					//Ahora agregamos los mux que dan como resultado SrcAE y SrcBE
					//										RD1E(00)		  ResultW(01)  ALUOutM(10)
					MUX_3 #(32) srcAEMux_Unit(DtoEReg_OUT[99:68], ResultW,      ALUOutM, forwardAE, SrcAE);
					//										  RD2E(00)		  ResultW(01)	ALUOutM(10)
					MUX_3 #(32) WriteDataMux_Unit(DtoEReg_OUT[67:36], ResultW,  ALUOutM, forwardBE, WriteDataE);	
					//
					MUX_2 #(32) SrcBEMux_Unit(WriteDataE, DtoEReg_OUT[31:0], ALUSrcE, SrcBE);
						
					// ALU logic
					ALU_N_bits #(32) aALU_N_bits_Unit(SrcAE, SrcBE, ALUControl, ALUFlags, ALUResultE);
					
					//--------------------------------------Registro de Execute a Memory-----------------------------------------------------------
					//																	WAsE
					//								 32			 32					4
					assign EtoMReg_IN = {ALUResultE, WriteDataE, DtoEReg_OUT[35:32]};
					
					pipelineRegEtoM #(68) pipelineRegEtoM_Unit( clk, reset, EtoMReg_IN, EtoMReg_OUT );  //###################################################
					//EtoMReg_OUT = ALUOutM   WD    WA3M
					//					 [67:36]	[35:4] [3:0]
					
					assign ALUOutM = EtoMReg_OUT[67:36]; 
					assign WriteData = EtoMReg_OUT[35:4];
						
					//--------------------------------------Registro de Memory a Writeback-----------------------------------------------------------
					//															WA3M
					assign MtoWBReg_IN = {ReadData, ALUOutM, EtoMReg_OUT[3:0]};	
					
					pipelineRegMtoWB #(68) pipelineRegMtoWB_Unit( clk, reset, MtoWBReg_IN, MtoWBReg_OUT);  //###################################################
					//MtoWBReg_OUT = ReadDataW  ALUOutW  WA3W
					//					   [67:36]	 [35:4]  [3:0]
					
					MUX_2 #(32) ResultWMux_Unit(MtoWBReg_OUT[35:4], MtoWBReg_OUT[67:36], MemtoRegW, ResultW);
									
					assign RA1E = DtoEReg_OUT[103:100];		
					assign RA2E = DtoEReg_OUT[107:104];
					assign WA3E = DtoEReg_OUT[35:32];
					assign WA3M = EtoMReg_OUT[3:0];
					assign WA3W = MtoWBReg_OUT[3:0];
					
					
					assign match_1e_m = ( RA1E == WA3M );   
					assign match_2e_m = ( RA2E == WA3M );   
					assign match_1e_w = ( RA1E == WA3W );   
					assign match_2e_w = ( RA2E == WA3W );   
					assign match_12d_e = ( RA1D == WA3E ) + ( RA2D == WA3E );	
					assign match = { match_12d_e, match_1e_m, match_2e_m, match_1e_w, match_2e_w };
								 
endmodule
