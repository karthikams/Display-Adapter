module file_read(WData,WE0, WE1,clock);

input clock,WE0,WE1;
reg [100:1] file_name;
output reg [31:0] WData;
reg [31:0] RAM [399:0];
reg[8:0] counter;
integer file;
integer i = 0;

initial begin
	$readmemb("data_ten.txt", RAM);
	counter <= 9'b00000000;
end


always@(clock)
begin
#1 if((WE0==1) || (WE1==1))
begin
	if(counter <= 9'b110010000) 
	begin
		WData = RAM[counter];
		counter = counter + 1;
	end
end
end

endmodule  


