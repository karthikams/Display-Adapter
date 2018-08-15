module test_memory();

reg clock,WE0,IncAddr0;


int_memory mem (clock,WE0, IncAddr0);

initial
begin
	clock=0;
	forever #5 clock =~clock;
end

initial
begin
	WE0 = 1;
	IncAddr0 = 1;
	#1005 WE0 = 0;
end

endmodule
