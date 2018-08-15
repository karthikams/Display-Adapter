module Pixel_Counter(PxOut,clock, ResetPx, IncPx);

/*
   inputs:   
   ResetPx: Signal for Reseting the output of pixel counter.
   IncPx: Signal for incrementing the pixel counter.
   clock: For synchronizing the module with the input clock
*/
input clock,ResetPx,IncPx;
output reg[3:0] PxOut;

/*
   Initializing PixelOut to zero
*/
initial
begin
	PxOut = 4'b0000;
end

/*
  Validating the PxOut values when ResetPx or IncPx goes high.
  Expected behavior: 
  ResetPx = 1: PxOut is set to zero;
  IncPx = 1: PxOut is incremented by one.
*/
always @(posedge clock)
begin
	if(ResetPx) PxOut <= 4'b0000;
	else if(IncPx) PxOut <= PxOut+4'b0001;
end
endmodule

