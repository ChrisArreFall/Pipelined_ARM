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
								 output logic [31:0] ALUResult, WriteData);
								 
								 
								 
								 
								 
								 
endmodule
