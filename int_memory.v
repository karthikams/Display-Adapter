module int_memory (clock,WE0, IncAddr0);

input clock, WE0, IncAddr0;

wire[31:0] WData;
wire[6:0] Addr0;
wire clock, WE0, IncAddr0;

file_read mem (WData, clock);
Addr0_Counter counter (Addr0,clock, ResetAddr0, IncAddr0);
buf0 buff(red_pix, green_pix, blue_pix, WData, RE0, WE0, Addr0, SelR0, SelG0, SelB0);


endmodule

