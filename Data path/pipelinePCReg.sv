module pipelinePCReg#(parameter WIDTH = 32)(input logic clk, reset, enable,
														  input logic [WIDTH-1:0] PC_IN,
														  output logic [WIDTH-1:0] PC_OUT);

			always_ff @( posedge clk, posedge reset )
				begin
					if (reset) 	
						PC_OUT <= 0;
					else if (enable) 
						PC_OUT <= PC_IN;
				end
endmodule