module mux_ALU #(parameter N)
				(input logic [N-1:0] SUMA, RESTA, AND, OR, XOR, NOT, LEFT_SHIFT_ARITH, RIGHT_SHIFT_ARITH, LEFT_SHIFT_LOGIC, RIGHT_SHIFT_LOGIC,
				 input logic [3:0] SELECTOR,
				 output logic [N-1:0] OUT);
				 
		always_comb
			case(SELECTOR)
				4'b0000: OUT = SUMA;
				4'b0001: OUT = RESTA;
				4'b0010: OUT = AND;
				4'b0011: OUT = OR;
				4'b0100: OUT = XOR;
				4'b0101: OUT = NOT;
				4'b0110: OUT = LEFT_SHIFT_ARITH;
				4'b0111: OUT = RIGHT_SHIFT_ARITH;
				4'b1000: OUT = LEFT_SHIFT_LOGIC;
				4'b1001: OUT = RIGHT_SHIFT_LOGIC;
			default: OUT = 1'b0;
			endcase
endmodule