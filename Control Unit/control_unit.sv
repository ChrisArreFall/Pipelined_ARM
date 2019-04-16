module  control_unit(input logic clk, reset, 
							input logic [31:12] Instr, 
							input logic [3:0] ALUFlags, 
							output logic [1:0] RegSrc, 
							output logic RegWrite, 
							output logic [1:0] immSrc, 
							output logic ALUSrc, 
							output logic [3:0] ALUControl, 
							output logic MemWrite, MemtoReg, 
							output logic PCSrc); 
		logic [1:0] FlagW; 
		logic PCS, RegW, MemW,NoWrite;
		//								Op					funct				Rd
		decoder decoder_unit(Instr[27:26], Instr[25:20], Instr[15:12], FlagW, PCS, RegW, MemW,NoWrite, MemtoReg, ALUSrc, immSrc, RegSrc, ALUControl); 
		conditional_logic conditional_logic_unit(clk, reset,NoWrite, Instr[31:28], ALUFlags,PCS,RegW,MemW,FlagW,PCSrc,RegWrite,MemWrite); 
endmodule