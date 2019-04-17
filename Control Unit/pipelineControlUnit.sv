module pipelineControlUnit(input logic clk, reset,
									input  logic [31:4] InstrF,
									input  logic [3:0] ALUFlags,
									input  logic stallD, flushD, flushE,
									output logic [1:0] RegSrcD,
									output logic RegWriteM, RegWriteW,
									output logic [1:0] ImmSrcD,
									output logic ALUSrcE,
									output logic [3:0] ALUControlE,
									output logic MemWriteM, MemtoRegW, MemtoRegE,PCSrcW,
									output logic BranchTakenE);
					
					
					
endmodule 
