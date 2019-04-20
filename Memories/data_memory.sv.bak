module data_memory(input logic clk, WE,
						 input logic [31:0] A,WD,
						 output logic [31:0] RD);
	logic [31:0] memory [31:0];
	initial 
		$readmemh("RAM.mem",memory);
	
	always_ff@(posedge clk)
		if(WE)
			memory[A[31:2]] <= WD;
	assign RD = memory[A[31:2]];
			
			
endmodule
