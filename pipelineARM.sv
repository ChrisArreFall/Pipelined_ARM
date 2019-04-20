module pipelineARM(input  logic clk, reset,
						 input  logic [31:0] Instr,
						 input  logic [31:0] ReadData,
						 output logic [31:0] PC,
						 output logic MemWrite,
						 output logic [31:0] ALUResult, WriteData);
		
		logic [3:0]  ALUFlags;
		logic RegWriteM, RegWriteW, ALUSrc, MemtoRegW, MemtoRegE, PCSrcW, BranchLinkEn, BranchTakenE, PCW_DEM;
		logic [1:0]  RegSrc, ImmSrc;
		logic [3:0]  ALUControl;
		logic	stallD, stallF, flushD, flushE;
		logic [1:0]  forwardAE, forwardBE;
		logic [4:0]  match;

		pipelineControlUnit pipelineControlUnit_Unit(clk, reset, Instr, ALUFlags,
																	stallD, flushD, flushE,
																	RegSrc,RegWriteM, RegWriteW,ImmSrc,
																	ALUSrc,ALUControl,
																	MemWrite, MemtoRegW, MemtoRegE,PCSrcW,
																	BranchTakenE,PCW_DEM);
	
		pipelineDatapath pipelineDatapath_Unit(clk, reset, 
															RegSrc, RegWriteW, ImmSrc, 
															ALUSrc, ALUControl, 
															MemtoRegW, PCSrcW,
															BranchTakenE, 
															Instr, ReadData, 
															forwardAE, forwardBE,
															stallF, stallD, flushD, flushE, 
															ALUFlags, match,PC, ALUResult, WriteData);

		hazardUnit hazardUnit_Unit(match,PCSrcW,PCW_DEM,
											RegWriteM, RegWriteW, MemtoRegE, BranchTakenE,
											forwardAE, forwardBE,
											stallD, stallF, flushD, flushE);
endmodule
