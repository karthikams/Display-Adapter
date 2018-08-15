module mem_save(FrameIn,CSDisplay, clock);

input clock, CSDisplay;
input [7:0] FrameIn;
reg [31:0] RAM1 [199:0];
integer i = 0;
reg[1:0] counter = 2'b0;
reg[31:0] result;
reg [7:0] red, green, blue;
integer f;

initial
begin
f = $fopen("result.txt");
end


always@(posedge clock)
begin
if(CSDisplay == 1)
	begin
		#2 ;
		if(counter == 2'b0) 
		begin
			red = FrameIn;
			counter = counter+1;
		end
		else if(counter == 2'b1)
		begin
			green = FrameIn;
			counter = counter + 1;
		end
		else if(counter == 2'b10)
		begin
			blue = FrameIn;
			counter <= 2'b0;
			result = {8'b0, red, green ,blue};
			RAM1[i] = result;
			$fdisplayb(f, result);
			i = i+1;
		end
	end

end

endmodule  


