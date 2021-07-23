`timescale 1ns/1ns
module stimulus_pentavium();
	reg [79:0] iv;
	wire [99:0] keystream;
	reg clk1,clk ;
	initial
	begin
		clk=0;
		clk1=0;
	end
	always #1 clk1 = ~ clk1 ;
	always #230 clk = ~ clk ;
	initial
	begin
		iv=80'b00000100110111101000001000110000101101001111010101101011101111101010101011110010 ;
	end
	pentavium_keystream_generation MUT (keystream,iv,clk,clk1);
endmodule
