module buf0(red_pix0, green_pix0, blue_pix0, row0, WData, RE0, WE0, Addr0, clock);

output reg [7:0] red_pix0, green_pix0, blue_pix0;
output reg [6:0] row0;
input [31:0] WData;
input RE0, WE0, clock;
input [6:0] Addr0;
reg [23:0] buff0 [99:0];
reg[23:0] out_data;
integer i = 0;

always@(posedge clock)
begin
	if(RE0)
	begin
		out_data = buff0[Addr0];
		red_pix0 =  out_data[23:16];
		green_pix0 = out_data[15:8];
		blue_pix0 = out_data[7:0];
	end
end

always@(clock)
begin

	if(WE0 &&(WData >= 32'b0))
	begin
		row0 <= i;		
		buff0[i] <= WData[23:0];
		if (i == 7'b1100011)
		begin
			 i <= 7'b0;
		end
		else i = i+1;
		
	end

if(row0 == 7'b1100011) row0 = i;
end
endmodule


