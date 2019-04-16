module and_A #(parameter N)
				(input logic [N-1:0] a, b,
				 output logic [N-1:0] s);
	assign s = a & b; // AND
endmodule