module pipelineRegFtoD #(parameter WIDTH = 32)(input logic clk, reset, enable, FlushD,
															  input logic  [WIDTH-1:0] InstrF,
															  output logic [WIDTH-1:0] InstrD)
	// Este es el registro que divide la parte de Fetch y Decode
	always_ff @( posedge clk, posedge reset )
	begin
		//como siempre, al ser un flipflop, si hay un reset se resetea en 0
		if (reset)
			q <= 0;
		else
			//si el reset no esta activado seguimos normalmente
			begin
				//Si el hazardUnit nos esta diciendo que hagamos un flush
				if (flush)
					//devolvemos una cadena de 32 0s
					InstrD <= 0;
				//si en cambio, el StallD esta en 0, entonces al estar negada la entrada nos da un 1, por lo que damos como resultado 
				//la instruccion de entrada 
				else if (enable)
					InstrD <= InstrF;
		end
	end
endmodule 