module tb_instruction_memory();
	logic [31:0] A = 0, RD;
	// instantiate device to be tested 
	instruction_memory dut(A,RD);
	// initialize test 
	initial begin  
		A        <= 8'b0000;
	end
	always 
	begin 
		# 5; 
		A <= A+4; 
		# 5; 
		A <= A+4; 
		# 5; 
		A <= A+4; 
		# 5;
		A <= A+4; 
		# 5;
	end
endmodule

