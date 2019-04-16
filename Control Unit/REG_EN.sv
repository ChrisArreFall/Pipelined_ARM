module REG_EN(input logic clk,reset,enable,
				  input logic [1:0] in,
				  output logic [1:0] out);
	always_ff@(posedge clk,posedge reset)
		if(reset)
			out <= 0;
		else
			if(enable)
				out <= in;
endmodule
