module Addr1_Counter(Addr1,clock, ResetAddr1, IncAddr1);
input clock,ResetAddr1,IncAddr1;
output reg[6:0] Addr1;

initial
begin
	Addr1 = 7'b0000000;
end

always @(posedge clock)
begin
	if(ResetAddr1) Addr1 <= 7'b0000000;
	else if(IncAddr1)  
        begin
       	Addr1 <= Addr1 + 7'b01;
	end
end
endmodule
