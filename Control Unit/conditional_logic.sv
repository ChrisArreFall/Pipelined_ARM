module conditional_logic(input logic clk, reset,NoWrite,
								 input logic [3:0] Cond, ALUFlags,
								 input logic PCS,RegW,MemW,
								 input logic [1:0] FlagW,
								 output logic PCSrc,RegWrite,MemWrite);
	logic CondEx;
	logic [1:0] FlagWrite;
	logic [3:0] flags;
	//first we start by saving the ALUFlags result in 2 registers
	REG_EN reg_1(clk,reset,FlagWrite[0],ALUFlags[1:0],flags[1:0]);
	REG_EN reg_2(clk,reset,FlagWrite[1],ALUFlags[3:2],flags[3:2]);
	//after that we add the check the conditions
	conditions conditions_unit(Cond, ALUFlags,CondEx);
	//FlagWrite[0] will only be 1 if selected flag is 1 and condition enable is on
	//FlagWrite[0] will only be 1 if selected flag is 1 and condition enable is on and we are doing a ADD, SUB o CMP.
	assign FlagWrite = FlagW & {2{CondEx}}; 
	//RegWrite will only be 1 if we want to write to a register and if selected flag is 1 
	assign RegWrite = RegW & CondEx & ~NoWrite; 
	//MemWrite will only be 1 if we want to write to memory(ram) and if selected flag is 1
	assign MemWrite = MemW & CondEx; 
	//PCSrc will only be onw if we want to load an address in to the PC
	assign PCSrc = PCS & CondEx; 
endmodule
