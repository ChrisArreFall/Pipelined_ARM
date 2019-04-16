module ARMV4(input logic clk, reset, 
				 input logic [31:0] Instruction,ReadData,
				 output logic MemWrite, 
				 output logic [31:0] PC, ALUResult, WriteData);
		logic [3:0] ALUFlags,ALUControl; 
		logic RegWrite, ALUSrc, MemtoReg, PCSrc; 
		logic [1:0] RegSrc, ImmSrc;
		control_unit control_unit_unit(clk, reset, Instruction[31:12], ALUFlags, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, MemtoReg, PCSrc); 
		data_path datapath_unit(clk, reset, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemtoReg, PCSrc, Instruction, ReadData, ALUFlags, PC, ALUResult, WriteData); 
endmodule
