module tb_data_memory();
	logic clk,WE;
	logic [31:0] A,WD,RD;
	// instantiate device to be tested 
	data_memory dut(clk,WE,A,WD,RD);
	// initialize test 
	initial 
		begin  
			A <= 0;
		end
	always 
		begin 
			clk <= 1; 
			# 5; 
			clk <= 0; 
			# 5;
		end
	always 
		begin  
			# 10; 
			A  <= 32'b0;
			WE <= 0;
			WD <= 0;
			# 10; 
			A  <= 32'b0;
			WE <= 1;
			WD <= 32'b11111111;
			# 10; 
			A  <= 32'b0;
			WE <= 0;
			WD <= 0;
			# 10; 
			A  <= 32'b100;
			WE <= 1;
			WD <= 32'b10101010;
			# 10; 
			A  <= 32'b100;
			WE <= 0;
			WD <= 32'b11110000;
			# 10; 
			A  <= 32'b1000;
			WE <= 1;
			WD <= 32'b11001100;
			# 10; 
			A  <= 32'b1000;
			WE <= 0;
			WD <= 32'b11110000;
		end

endmodule 