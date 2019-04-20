module tb_register_file();
	logic clk,WE;
	logic [3:0] first_source_register;
	logic [3:0] second_source_register;
	logic [3:0] destination_register;
	logic [31:0] WD,R15;
	logic [31:0] RD1,RD2;
	
	
	// instantiate device to be tested 
	register_file dut(clk,WE,
							first_source_register,
							second_source_register,
							destination_register,
							WD,R15,
							RD1,RD2);
	// initialize test 
	initial 
		begin  
			WE <= 0;
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
			WE                      <= 1;
			first_source_register	<= 0;
			second_source_register	<= 0;
			destination_register		<= 4'b0000;
			WD								<= 32'b11111111;
			R15							<= 0;
			# 10; 
			WE                      <= 0;
			first_source_register	<= 4'b0000;
			second_source_register	<= 0;
			destination_register		<= 0;
			WD								<= 0;
			R15							<= 4;
			# 10; 
			WE                      <= 1;
			first_source_register	<= 0;
			second_source_register	<= 0;
			destination_register		<= 4'b0001;
			WD								<= 32'b11110000;
			R15							<= 8;
			# 10; 
			WE                      <= 0;
			first_source_register	<= 0;
			second_source_register	<= 1;
			destination_register		<= 0;
			WD								<= 0;
			R15							<= 12;
			# 10; 
			WE                      <= 1;
			first_source_register	<= 0;
			second_source_register	<= 0;
			destination_register		<= 3;
			WD								<= 32'b1111;
			R15							<= 16;
			# 10; 
			WE                      <= 0;
			first_source_register	<= 4'b1111;
			second_source_register	<= 3;
			destination_register		<= 0;
			WD								<= 0;
			R15							<= 20;
			# 10; 
			WE                      <= 0;
			first_source_register	<= 1;
			second_source_register	<= 4'b1111;
			destination_register		<= 0;
			WD								<= 0;
			R15							<= 24;
		end




endmodule
