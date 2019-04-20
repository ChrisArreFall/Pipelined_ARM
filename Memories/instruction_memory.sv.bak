module instruction_memory(input logic [31:0] A,
								  output logic [31:0] RD);
								  
	//memoria de las instrucciones se hara de 31 instucciones por el momento	
	logic [31:0] memory [31:0];
	initial 
		$readmemh("C:\\Users\\Chris\\Documents\\TEC\\Taller\\Proyecto\\Processor\\ARMv4_Processor\\ARMV4\\instructions\\instrucciones1.mem",memory);
	//ya que la instruccion esta desfasada 8 bytes entonces eliminare los 
	//primeros 2 bits para lograr estar en la memoria actual
	//             31:2     xx
	// 1 ciclo A = ...00000000 -> memory[0]
	// 2 ciclo A = ...00000100 -> memory[1]
	// 3 ciclo A = ...00001000 -> memory[2]
	// 4 ciclo A = ...00001100 -> memory[3]
	// 5 ciclo A = ...00010000 -> memory[4]
	// 6 ciclo A = ...00010100 -> memory[5]
	
	assign RD = memory[A[31:2]];
endmodule