module flags#(parameter N_b=32)(	input logic [N_b-1:0] A,B,SUM,result,
											input logic Cout,
											input logic [3:0] ALUControl,
											output logic [3:0] FLAGS);
				//flags 3 2 1 0
				//      Z N C V
				logic Z,N,C,V;
				assign V = ~(ALUControl[0] ^ A[N_b-1] ^ B[N_b-1]) & (A[N_b-1]^SUM[N_b-1]) & (~ALUControl[1]);
				assign C = (~ALUControl[1]) & Cout;
				assign N = result[N_b-1];
				
				always_comb
					begin
						if(result==0)
								Z=1;
						else
								Z=0;
					end
				assign FLAGS = {Z,N,C,V};
endmodule
