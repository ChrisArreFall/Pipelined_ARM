module top(input  logic clk, reset,
			  output logic [31:0] WriteData,
			  output logic [31:0] DataAdr,
			  output logic MemWrite);

    logic [31:0] PC, Instr, ReadData;

    pipelineARM  pipelineARM_Unit(clk, reset,Instr,ReadData,PC,MemWrite,DataAdr, WriteData);
    instruction_memory instruction_memory_Unit(PC, Instr);
    data_memory data_memory_Unit(clk, MemWrite, DataAdr, WriteData, ReadData);
endmodule