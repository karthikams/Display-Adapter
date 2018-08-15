module frame_mux(FrameIn,B0,B1,SelBuf0,SelBlank,SelBuf1,clock);

output reg[7:0] FrameIn;
input[7:0] B0,B1;
input SelBuf0,SelBlank,SelBuf1,clock;


always@(*)
begin
	if(SelBuf0) FrameIn <= B0;
	if(SelBlank)FrameIn <= 8'b0;
	if(SelBuf1) FrameIn <= B1;

end
endmodule

