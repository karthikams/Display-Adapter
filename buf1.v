module buf1(red_pix1, green_pix1, blue_pix1, row1, WData, RE1, WE1, Addr1, clock);

output reg [7:0] red_pix1, green_pix1, blue_pix1;
output reg [6:0] row1;
input [31:0] WData;
input RE1, WE1, clock;
input [6:0] Addr1;
reg [23:0] buff1 [99:0];
reg[23:0] out_data;
integer i = 0;

always@(posedge clock)
begin
	if(RE1)
	begin
		out_data = buff1[Addr1];
		red_pix1 =  out_data[23:16];
		green_pix1 = out_data[15:8];
		blue_pix1 = out_data[7:0];
	end
end

always@(clock)
begin

#1	if(WE1 &&(WData >= 32'b0))
	begin
		row1 <= i;		
		buff1[i] <= WData[23:0];
		if (i == 7'b1100011)
		begin
			 i <= 7'b0;
		end
		else i = i+1;
		
	end

if(row1 == 7'b1100011) row1 = i;
end
endmodule


