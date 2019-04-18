module hazardUnit(input  logic [4:0]  match,
					   input  logic	RegWriteM, RegWriteW, MemtoRegE, 
					   output logic [1:0]  forwardAE, forwardBE,
					   output logic stallD, stallF, flushD, flushE);		
				logic LDRstall;
				//-----------------------------Forwarding--------------------------------
				//Some data hazards can be solved by forwarding (also called bypassing) a
				//result from the Memory or Writeback stage to a dependent instruction in
				//the Execute stage. 
				assign forwardAE = ( match[3] & RegWriteM ) ? 2'b10 :	// SrcAE = ALUOutM
										 ( match[1] & RegWriteW ) ? 2'b01 :	// SrcAE = ResultW
																			 2'b00 ;	// SrcAE  from regfile
																	
				assign forwardBE = ( match[2] & RegWriteM ) ? 2'b10 :	// SrcBE = ALUOutM
										 ( match[0] & RegWriteW ) ? 2'b01 :	// SrcBE = ResultW
																			 2'b00 ;	// SrcBE  from regfile	
				//-------------------------------Stalls----------------------------------															 
				//The alternative solution is to stall the pipeline, holding up operation
				//until the data is available.
				//For data hazards.
				assign LDRstall    = ( match[4] & MemtoRegE );			// MemtoReg signal asserted for LDR instruction
				 
				//For control hazards.    
				assign stallD = LDRstall;							    		// stall decode if ldrstall
				assign stallF = LDRstall + PCWrPendingF;					// stall fetch if PCWrPendingF
				assign flushE = LDRstall + BranchTakenE;					// flush execute register if branch taken
				assign flushD = PCWrPendingF + PCSrcW + BranchTakenE;	// flush decode register if PCWrPendingF OR PC is written in writeback OR branch is taken.			
endmodule 