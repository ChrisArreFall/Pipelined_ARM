module PC_REG(input logic clk,reset,
				  input logic [31:0] PC_in,
				  output logic [31:0] PC_out);
	always_ff@(posedge clk, posedge reset)
		if(reset)
			PC_out <= 0;
		else
			PC_out <= PC_in;
					
endmodule 