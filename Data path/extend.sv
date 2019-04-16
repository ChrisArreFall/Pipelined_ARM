module extend(input logic [1:0] immSrc,
				  input logic [23:0] second_source_register,
				  output logic [31:0] extImm);
	
	//hay que tener un caso para cada uno de los tipos de OP(data type, memory, branch)
	always_comb
		case(immSrc)
			//data procesing(ADD,SUB)
			2'b00 : extImm = second_source_register[7:0];
			//memory (LDR,STR)
			2'b01 : extImm = second_source_register[11:0];
			//por signo se usa el ultimo bit del inmediato
			2'b10 : extImm = {{6{second_source_register[23]}},second_source_register[23:0],2'b00};
			default : extImm = 32'bx;
		endcase
endmodule
