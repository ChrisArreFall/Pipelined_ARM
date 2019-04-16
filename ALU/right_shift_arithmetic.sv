module right_shift_arithmetic #(parameter N)
				(input logic signed [N-1:0] a,
				 output logic [N-1:0] s);
	assign s = a >>> 1;
endmodule