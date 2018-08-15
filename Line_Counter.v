module Line_Counter(LineOut, clock, ResetLine, IncLine);
input clock,ResetLine,IncLine;
output reg[3:0] LineOut;

initial
begin
	LineOut = 4'b0;
end

always @(posedge clock)
begin
	if(ResetLine) LineOut <= 4'b0;
	else if(IncLine)LineOut <= LineOut+4'b0001; 
end

endmodule
