module simpleAdder#(parameter N = 8)(input clk,reset,
												 input [N-1:0] in,
												 output [N-1:0] out);
					always_ff @(posedge clk, posedge reset) 
						if (reset) 
							out <= 1'b0; 
						else 
							out <= out + 1'b1; 

endmodule
