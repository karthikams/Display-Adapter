module int_controller(CSDisplay,VBOut,AILOut,AIPOut,clock, reset);

input clock, reset,CSDisplay;
input[3:0] VBOut,AILOut,AIPOut;

wire clock,CSDisplay,reset;
wire [3:0] PxOut, LineOut, VBOut, AIPOut, AILOut ;
wire IncPx, ResetPx, IncLine, ResetLine,ResetAddr0,IncAddr0,ResetAddr1, IncAddr1,RE0, WE0, SelR0, SelG0, SelB0, RE1, WE1, SelR1, SelG1, SelB1, SelBuf0,SelBlank,SelBuf1;
wire[6:0] Addr0, Addr1, row0, row1;
wire[31:0] WData;
wire[7:0] B0, B1, FrameIn, red_pix0, green_pix0, blue_pix0, red_pix1, green_pix1, blue_pix1;

Pixel_Counter pc (PxOut,clock, ResetPx, IncPx);
Line_Counter  lc (LineOut, clock, ResetLine, IncLine);

file_read mem (WData,WE0, WE1,clock);

Addr0_Counter ac0(Addr0,clock, ResetAddr0, IncAddr0);

buf0 b0 (red_pix0, green_pix0, blue_pix0, row0, WData, RE0, WE0, Addr0, clock);
mux_buf0 mb0 (B0,SelR0, SelG0, SelB0, red_pix0, green_pix0, blue_pix0);

//buf0 b0 (B0, row0, WData, RE0, WE0, Addr0,SelR0, SelG0, SelB0, clock);

Addr1_Counter ac1(Addr1,clock, ResetAddr1, IncAddr1);
buf1 b1 (red_pix1, green_pix1, blue_pix1, row1, WData, RE1, WE1, Addr1, clock);
mux_buf1 mb1 (B1,SelR1, SelG1, SelB1, red_pix1, green_pix1, blue_pix1);

frame_mux fm (FrameIn,B0,B1,SelBuf0,SelBlank,SelBuf1,clock);

mem_save mem2(FrameIn,CSDisplay, clock);

 controller_buff0 cb(RE0, WE0, RE1, WE1, SelR0, SelG0, SelB0, SelR1, SelG1, SelB1, SelBuf0, SelBlank, SelBuf1, IncPx, ResetPx, IncLine, ResetLine, SyncVB, Buf0Empty, Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1, row0, row1,
			PxOut, LineOut, VBOut, AIPOut, AILOut, CSDisplay, clock, reset);


endmodule


