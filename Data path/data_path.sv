module data_path(input logic clk, reset, 
								 input logic [1:0] RegSrc, 
								 input logic RegWrite, 
								 input logic [1:0] ImmSrc, 
								 input logic ALUSrc, 
								 input logic [3:0] ALUControl, 
								 input logic MemtoReg, 
								 input logic PCSrc, 
								 input logic [31:0] Instruction,
								 input logic [31:0] ReadData, 
								 output logic [3:0] ALUFlags, 
								 output logic [31:0] PC_out, 
								 output logic [31:0] ALUResult, WriteData);
	logic [31:0] PC_in, PCPLUS4, PCPLUS8; 
	logic [31:0] ExtImm, SrcA, SrcB, Result; 
	logic [3:0] RA1, RA2;
	initial begin
		Result <= 0;
		PC_in <= 0;
		PCPLUS4 <= 0;
		PCPLUS8 <= 0;
	end
	//primero nos encargamos de la logica del mux que va 
	//conectado al pc register que va conectado al instruction
	//mem
	muxARM #(32)muxPC(PCSrc,PCPLUS4,Result,PC_in);
	PC_REG PC_REG_unit(clk,reset,PC_in,PC_out);
	//ahora hay que hacer el PCPLUS4
	adderARM #(32) adderPCPLUS4(PC_out,32'b100,PCPLUS4);
	//ahora el PCPLUS8
	adderARM #(32) adderPCPLUS8(PCPLUS4,32'b100,PCPLUS8);
	//ahora los mux que reciben los registros de la instruccion
	muxARM #(4) muxRA1(RegSrc[0],Instruction[19:16],4'b1111,RA1);
	muxARM #(4) muxRA2(RegSrc[1],Instruction[3:0],Instruction[15:12],RA2);
	//ahora instanceo el register file
	register_file register_file_unit(clk,
											   RegWrite,
											   RA1,
											   RA2,
											   Instruction[15:12],
											   Result,
											   PCPLUS8,
											   SrcA,
											   WriteData);
	
	//para terminar hay que incluir el ultimo mux
	muxARM #(32) muxRam(MemtoReg,ALUResult,ReadData,Result);
	//continuo con el extended
	extend extend_unit(ImmSrc,
							 Instruction[23:0],
							 ExtImm);
	//posteriormente el mux para el srcbde la ALU
	muxARM #(32) muxALU(ALUSrc,WriteData,ExtImm,SrcB);
	//ALU
	ALU_N_bits#(32) ALU(SrcA, 
							  SrcB,
							  ALUControl,
							  ALUFlags,
							  ALUResult);

endmodule
