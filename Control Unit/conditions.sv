module conditions(input logic [3:0] Cond, flags,
						output logic result);
	//flags 3 2 1 0
	//      N Z C V
	logic N,Z,C,V;
	//we assign the flags recivied by the ALU to the variables created previously
	assign {N,Z,C,V} = flags;
	//Here we compare the condition obtained from the instruction(31:28)
	//and we return the result obtained by the ALU
	always_comb 
		case(Cond)
			4'b0000 : result = Z;					//EQ
			4'b0001 : result = ~Z;					//NE
			4'b0010 : result = C;					//CS/HS
			4'b0011 : result = ~C;					//CC/LO
			4'b0100 : result = N;					//MI
			4'b0101 : result = ~N;					//PL
			4'b0110 : result = V;					//VS
			4'b0111 : result = ~V;					//VC
			4'b1000 : result = C&~Z;				//HI
			4'b1001 : result = ~(C&~Z);			//LS
			4'b1010 : result = N==V;				//GE
			4'b1011 : result = ~(N==V);			//LT
			4'b1100 : result = ~Z&(N==V);			//GT
			4'b1101 : result = ~(~Z&(N==V));		//LE
			4'b1110 : result = 1'b1;				//AL
			default : result = 1'bx;
		endcase
endmodule 
