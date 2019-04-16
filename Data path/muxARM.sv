module muxARM #(parameter N = 8)(input logic selector,
										   input logic [N-1:0] A,B,
										   output logic [N-1:0] out);
	always_comb
		case(selector)
			1'b0 : out = A;
			1'b1 : out = B;
		endcase
endmodule
