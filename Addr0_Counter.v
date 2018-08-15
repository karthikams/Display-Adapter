module Addr0_Counter(Addr0,clock, ResetAddr0, IncAddr0);
input clock,ResetAddr0,IncAddr0;
output reg[6:0] Addr0;

initial
begin
	Addr0 = 7'b0000000;
end

always @(posedge clock)
begin
	if(ResetAddr0) Addr0 <= 7'b0;
	else if(IncAddr0)  
        begin
       	Addr0 <= Addr0 + 7'b01;
	end
end
endmodule

