module decoder(input logic [1:0] Op,
					input logic [5:0] funct,
					input logic [3:0] Rd,
					output logic[1:0] FlagW,
					output logic PCS,RegW,MemW,NoWrite,MemtoReg,ALUSrc,
					output logic [1:0] immSrc,RegSrc,
					output logic [3:0]ALUControl);
	logic branch,dataProcesing;
	always_comb
		//first we check what type of operation code we have
		begin
			//if it is data procesing type (Op)
			if(Op==2'b00)//ADD, SUB 
				//we want to check if the second source is an immediate
				//ADD R1, R2, #3
				if(funct[5])//if it is an immediate
					//ADDEQ,SUBLT
					begin
						RegSrc        = 2'b00;//we want Rn and Rm
						immSrc        = 2'b00;//tell extend its a data procesing instruction
						ALUSrc  		  = 1'b1;//we want Src B of ALU to be an immediate
						MemtoReg      = 1'b0;//we want the Result to be the ALUResult
						RegW          = 1'b1;//
						MemW          = 1'b0;//
						branch        = 1'b0;//its not a branch instruction
						dataProcesing = 1'b1;//it is a data procesing instruction 
					end
				//ADD R1, R2, R3
				else//else if its not an immediate
					//ADD,SUB
					begin
						RegSrc        = 2'b00;//we want Rn and Rm
						immSrc        = 2'b00;//tell extend its a data procesing instruction
						ALUSrc  		  = 1'b0;//we want Src B of ALU to be a register
						MemtoReg      = 1'b0;//we want the Result to be the ALUResult
						RegW          = 1'b1;
						MemW          = 1'b0;
						branch        = 1'b0;//its not a branch instruction
						dataProcesing = 1'b1;//it is a data procesing instruction 
					end
			//if it is memory type (Op) (LDR,STR)
			else if (Op==2'b01)
				//we check if we want to set the condition (S)
				if(funct[0])//if it is S=1
					//LDR
					begin
						RegSrc        = 2'b00;//we want Rn and Rm
						immSrc        = 2'b01;//tell extend its a memory instruction
						ALUSrc  		  = 1'b1;//we want Src B of ALU to be an immediate
						MemtoReg      = 1'b1;//we want the Result to come from memory(RAM)
						RegW          = 1'b1;//
						MemW          = 1'b0;//
						branch        = 1'b0;//its not a branch instruction
						dataProcesing = 1'b0;//its not a data procesing instruction
					end
				else//if it isnt S=0
					//STR
					begin
						RegSrc        = 2'b10;//we want R15 and Rm
						immSrc        = 2'b01;//tell extend its a memory instruction
						ALUSrc  		  = 1'b1;//we want Src B of ALU to be an immediate
						MemtoReg      = 1'b1;//we want the Result to come from memory(RAM)
						RegW          = 1'b0;//
						MemW          = 1'b1;//
						branch        = 1'b0;//its not a branch instruction
						dataProcesing = 1'b0;//its not a data procesing instruction
					end
			//if it is branch type (Op)
			else if (Op==2'b10)
				begin
						RegSrc        = 2'b01;//we want Rn and Rd
						immSrc        = 2'b10;//tell extend its a branch instruction
						ALUSrc  		  = 1'b1;//we want Src B of ALU to be an immediate
						MemtoReg      = 1'b0;//we want the Result to be the ALUResult
						RegW          = 1'b0;
						MemW          = 1'b0;
						branch        = 1'b1;//its a branch instruction
						dataProcesing = 1'b0;//its not a data procesing instruction
				end
			else
				begin
						RegSrc        = 2'bxx;
						immSrc        = 2'bxx;
						ALUSrc  		  = 1'bx;
						MemtoReg      = 1'bx;
						RegW          = 1'bx;
						MemW          = 1'bx;
						branch        = 1'bx;
						dataProcesing = 1'bx;
				end
		end
	always_comb
		//if we are in a data procesing instruction
		if(dataProcesing)
			begin
				case(funct[4:1])
					4'b0000: ALUControl = 4'b0010;//AND
					4'b1100: ALUControl = 4'b0011;//OR
					4'b0100: ALUControl = 4'b0000;//ADD
					4'b0010: ALUControl = 4'b0001;//SUB
					4'b1010: ALUControl = 4'b0001;//CMP
					default: ALUControl = 2'bx;
				endcase
				//if we are doing a CMP NoWrite is 1 else NoWrite is 0
				NoWrite = (funct[4:1]==4'b1010) ? 1'b1 : 1'b0;
				//If our S bit or condition enable is on 
				FlagW[1] = funct[0]; 
				//If our S bit or condition enable is on and we are doing a ADD, SUB o CMP.
				FlagW[0] = funct[0] & (ALUControl == 4'b0000 | ALUControl == 4'b0001); 
			end
		else
			begin
				ALUControl = 2'b00;
				NoWrite = 1'b0;
				FlagW = 2'b00;
			end
		//finally we check to see if our destination register(Rd) is register 15
		//and we check to see if we want to write to register(WE = 1)
		//we also check to see if we are in a branch instruction
		assign PCS = ((Rd == 4'b1111) & RegW) | branch; 
endmodule 
