module PROCESSOR(input logic clk, reset, 
					    output logic [31:0] WriteData, DataAdr, 
					    output logic MemWrite);
		logic [31:0] PC = 0, Instruction, ReadData;
		instruction_memory instruction_memory_unit(PC, Instruction); 
		ARMV4 ARMV4_unit(clk, reset,Instruction,ReadData,MemWrite,PC, DataAdr, WriteData);
		data_memory data_memory_unit(clk, MemWrite, DataAdr, WriteData, ReadData); 
endmodule
