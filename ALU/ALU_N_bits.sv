module ALU_N_bits#(parameter N=32) (input logic [N-1:0] A, B,
											input logic [3:0] ALUControl,
											output logic [3:0] flags,
											output logic [N-1:0] RESULT);
											
					//flags 3 2 1 0
					//      Z N C V

					//ALUControl 
					//0000 suma
					//0001 resta
					//0010 and
					//0011 or
					//0100 xor
					//0101 not
					//0110 left shift aritmetico
					//0111 right shift aritmetico
					//1000 left shift logico
					//1001 right shift logico
					initial begin
						flags = 4'b0;
					end
					logic cout;
					logic [N-1:0] suma_R,and_R ,or_R ,not_R ,xor_R , lsl_R, rsl_R, lsa_R, rsa_R, res_Mux;
					mux_Sumador #(N) mux_S(B,~B,ALUControl,res_Mux); 			// suma y
					sumador #(N) suma_F(A,res_Mux,ALUControl[0],suma_R,cout);// resta
					and_A #(N) and_F(A,B,and_R); 										// and
					or_A #(N) or_F(A,B,or_R); 											// or
					xor_A #(N) xor_F(A,B,xor_R); 										// xor
					not_A #(N) not_F(A,not_R); 										// not
					left_shift_arithmetic #(N) lsa(A,lsa_R); 						// left shift aritmetico
					right_shift_arithmetic #(N) rsa(A,rsa_R); 					// right shift aritmetico
					left_shift_logic #(N) lsl(A,lsl_R); 							// left shift logico
					right_shift_logic #(N) rsl(A,rsl_R); 							// right shift logico
					
					//MUX de la alu
					mux_ALU #(N) mux_F(suma_R ,suma_R ,and_R ,or_R ,xor_R ,not_R , lsa_R, rsa_R, lsl_R, rsl_R, ALUControl, RESULT);
					
					//Calcula las flags
					flags #(N) flags_F(A,B,suma_R,RESULT,cout,ALUControl,flags);
					
					
											
											
											
											
endmodule 
	  