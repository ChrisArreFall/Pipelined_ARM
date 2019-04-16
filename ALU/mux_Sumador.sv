module mux_Sumador #(parameter N)
				(input logic [N-1:0] B, NOT_B,
				 input logic [3:0] SELECTOR,
				 output logic [N-1:0] OUT);
				 
		always_comb
			case(SELECTOR)
				4'b0000: OUT = B;
				4'b0001: OUT = NOT_B;
				default: OUT = B;
			endcase
endmodule