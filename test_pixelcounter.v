module test_pixel_counter();

reg clock,ResetPx,IncPx;
wire[3:0] PxOut;

Pixel_Counter px(PxOut,clock, ResetPx, IncPx);

initial
begin
clock=0;
forever #5 clock =~clock;
end

initial
begin
IncPx=0;
end

endmodule