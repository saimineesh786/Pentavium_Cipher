module triv_key_stream_gen(keystream,iv,a1,b1,c1,clk);
	output reg [99:0] keystream;
	input [79:0] iv;
	input [92:0] a1 ;
	input [83:0] b1 ;
	input [110:0] c1 ;
	input clk; 
	reg [92:0] a ;
	reg [83:0] b ;
	reg [110:0] c ;
	reg t1,t2,t3;
	integer i=1;
	always @ (posedge clk)
	begin
		if(i <= 100)
		begin
			if(i == 1)
			begin
				a[92:0] = a1[92:0];
				b[83:0] = b1[83:0];
				c[110:0] = c1[110:0];
			end
			t1 = a[65] ^ a[92];
			t2 = b[68] ^ b[83];
			t3 = c[65] ^ c[110];
			keystream[i-1] = t1 ^ t2 ^ t3;
			t1 = t1 ^ (a[90] & a[91]) ^ b[76];
			t2 = t2 ^ (b[81] & b[82]) ^ c[87];
			t3 = t3 ^ (c[109] & c[110]) ^ a[68];
			a[92:1] = a[91:0] ;
			b[83:1] = b[82:0] ;
			c[110:1] = c[109:0] ;
			a[0] = t3 ;
			b[0] = t1 ;
			c[0] = t2 ;
		end
		i = i + 1;
	end
endmodule

module trivium_keystream_generation(keystream,iv,clk);
	output [99:0] keystream ;
	input [79:0] iv ;
	input clk ;
	reg [79:0] key ;
	reg [92:0] a ;
	reg [83:0] b ;
	reg [110:0] c ;
	triv_key_stream_gen k1 (keystream,iv,a,b,c,clk) ;
	always @ ( iv )
	begin
		key[79:0] = 80'b10011001001110101010011011110100101100111011000010111110101001100000001101110100 ;
		a[79:0] = key[79:0] ;
		a[92:80] = 0 ;
		b[79:0] = iv[79:0] ;
		b[83:80] = 0 ;
		c[107:0] = 0 ;
		c[110:108] = 3'b111 ;
	end
endmodule

