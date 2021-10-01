`timescale 1ns/1ns
module stimulus_trivium();
	reg [79:0] iv;
	wire [99:0] keystream;
	reg clk ;
	initial
	begin
		clk=0;
	end
	always #1 clk = ~ clk ;
	initial
	begin
		iv=80'b00000100110111101000001000110000101101001111010101101011101111101010101011110010 ;
	end
	trivium_keystream_generation MUT (keystream,iv,clk);
endmodule
