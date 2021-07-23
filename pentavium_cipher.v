/* 
	Date (Initial Commit) : 23/07/2002
	Pentavium_Sequentaial_HDL_CODE
	Uses Five Neighbourhood Cellular Automata with radius = 2
*/
module output_rule(out,rule,s_minus_2,s_minus_1,s,s_plus_1,s_plus_2);
	output reg out ;
	input [1:0] rule ;
	input s_minus_2,s_minus_1,s,s_plus_1,s_plus_2 ;
	always @ ( rule or s_minus_2 or s_minus_1 or s or s_plus_1 or s_plus_2 )
	begin
		case ( rule )
			2'b00 : out <= s_minus_2 ^ s_minus_1 ^ s_plus_1 ^ s_plus_2 ;
			2'b01 : out <= s_minus_2 ^ s_minus_1 ^ s ^ s_plus_1 ^ s_plus_2 ;
			2'b10 : out <= s_plus_2 ^ ( s_plus_1 & s ) ^ ( s_plus_1 & s_minus_1 ) ^ s ^ s_minus_2 ^ 1'b1 ;
			2'b11 : out <= s_plus_2 ^ ( s_plus_1 & s_minus_1 ) ^ ( s & s_minus_1 ) ^ s_minus_1 ^ s_minus_2 ;
		endcase
	end
endmodule

module apply_rule_blocks(tmpa,tmpb,tmpc,a,b,c,clk,clk1);
	output reg [92:0] tmpa;
	output reg [83:0] tmpb;
	output reg [110:0] tmpc;
	input [92:0] a;
	input [83:0] b;
	input [110:0] c;
	input clk;
	input clk1;
	reg [1:0] ca_rule [7:0] ;
	integer i = 0 ;
	reg [1:0] rule = 2'b10 ;
	reg set ;
	reg s_minus_2_a , s_minus_1_a , s_a , s_plus_1_a , s_plus_2_a ;
	reg s_minus_2_b , s_minus_1_b , s_b , s_plus_1_b , s_plus_2_b ;
	reg s_minus_2_c , s_minus_1_c , s_c , s_plus_1_c , s_plus_2_c ;
	wire out1 , out2 , out3 ;
	initial
	begin
		ca_rule[0] <= 2'b10 ;
		ca_rule[1] <= 2'b00 ;
		ca_rule[2] <= 2'b01 ;
		ca_rule[3] <= 2'b11 ;
		ca_rule[4] <= 2'b00 ;
		ca_rule[5] <= 2'b10 ;
		ca_rule[6] <= 2'b11 ;
		ca_rule[7] <= 2'b01 ;
		set = 1 ;
	end
	output_rule 
	o1 (out1,rule,s_minus_2_a,s_minus_1_a,s_a,s_plus_1_a,s_plus_2_a) ,
	o2 (out2,rule,s_minus_2_b,s_minus_1_b,s_b,s_plus_1_b,s_plus_2_b) ,
	o3 (out3,rule,s_minus_2_c,s_minus_1_c,s_c,s_plus_1_c,s_plus_2_c) ;
	always @ ( posedge clk1 )
	begin
		if( set == 0 && clk == 1 )
		begin
			set = 1 ;
		end
		if( set && i <= 111 )
		begin
			if( i == 0 )
			begin
				rule <= ca_rule[ i % 8 ] ;
				s_minus_2_a <= 1'b0 ; s_minus_1_a <= 1'b0 ; s_a <= a[0] ; s_plus_1_a <= a[1] ; s_plus_2_a <= a[2] ;
				s_minus_2_b <= 1'b0 ; s_minus_1_b <= 1'b0 ; s_b <= b[0] ; s_plus_1_b <= b[1] ; s_plus_2_b <= b[2] ;
				s_minus_2_c <= 1'b0 ; s_minus_1_c <= 1'b0 ; s_c <= c[0] ; s_plus_1_c <= c[1] ; s_plus_2_c <= c[2] ;
			end
			if( i > 0 )
			begin
				if ( i <= 93 )
					tmpa[i-1] = out1 ;
				if ( i <= 84 )
					tmpb[i-1] = out2 ;
				if ( i <= 111 ) 
					tmpc[i-1] = out3 ;
				rule <= ca_rule[ i % 8 ] ;
				if ( i < 93 )
				begin
					if( i == 1 )	s_minus_2_a <= 1'b0 ;
					else s_minus_2_a <= a[i-2] ;
					s_minus_1_a <= a[i-1] ;
					s_a <= a[i] ;
					if( i == 92 )
					begin
						s_plus_2_a <= 1'b0 ;s_plus_1_a <= 1'b0 ;
					end
					else if( i == 91 )
					begin
						s_plus_2_a <= 1'b0 ;s_plus_1_a <= a[i+1] ;
					end
					else
					begin
						s_plus_2_a <= a[i+2] ;s_plus_1_a <= a[i+1] ;
					end
				end
				if ( i < 84 )
				begin
					if( i == 1 )	s_minus_2_b <= 1'b0 ;
					else s_minus_2_b <= b[i-2] ;
					s_minus_1_b <= b[i-1] ;
					s_b <= b[i] ;
					if( i == 83 )
					begin
						s_plus_2_b <= 1'b0 ;s_plus_1_b <= 1'b0 ;
					end
					else if( i == 82 )
					begin
						s_plus_2_b <= 1'b0 ;s_plus_1_b <= b[i+1] ;
					end
					else
					begin
						s_plus_2_b <= b[i+2] ;s_plus_1_b <= b[i+1] ;
					end
				end
				if ( i < 111 )
				begin
					if( i == 1 )	s_minus_2_c <= 1'b0 ;
					else s_minus_2_c <= c[i-2] ;
					s_minus_1_c <= c[i-1] ;
					s_c <= c[i] ;
						if( i == 110 )
					begin
						s_plus_2_c <= 1'b0 ;s_plus_1_c <= 1'b0 ;
					end
					else if( i == 109 )
					begin
						s_plus_2_c <= 1'b0 ;s_plus_1_c <= c[i+1] ;
					end
					else
					begin
						s_plus_2_c <= c[i+2] ;s_plus_1_c <= c[i+1] ;
					end
				end
			end
			i = i + 1 ;	
			if( i == 112 )
			begin
				i = 0 ;
				set = 0 ;
			end
		end
	end
endmodule

module key_stream_gen(keystream,iv,a1,b1,c1,clk,clk1);
	output reg [99:0] keystream ;
	input [79:0] iv ;
	input [92:0] a1 ;
	input [83:0] b1 ;
	input [110:0] c1 ; 
	wire [92:0] tmpa_init ,tmpa ;
	wire [83:0] tmpb_init ,tmpb ;
	wire [110:0] tmpc_init ,tmpc ;
	reg [92:0] a ;
	reg [83:0] b ;
	reg [110:0] c ;
	reg t1 ,t2, t3 ;
	input clk ,clk1 ;
	integer i = 0 ;
	apply_rule_blocks apply_init (tmpa_init,tmpb_init,tmpc_init,a1,b1,c1,clk,clk1) ;
	apply_rule_blocks apply_iter (tmpa,tmpb,tmpc,a,b,c,clk,clk1) ;
	always @ ( posedge clk )
	begin
		if( i == 0 )
		begin
			a[92:0] = a1[92:0] ;
			b[83:0] = b1[83:0] ;
			c[110:0] = c1[110:0] ;
			i = i + 1 ;
		end
		if( i <= 100 )
		begin
			t1 = a[65] ^ a[92] ;	
			t2 = b[68] ^ b[83] ;
			t3 = c[65] ^ c[110] ;
			keystream[i-1] = t1 ^ t2 ^ t3 ;
			t1 = t1 ^ ( a[90] & a[91] ) ^ b[76] ;
			t2 = t2 ^ ( b[81] & b[82] ) ^ c[87] ;
			t3 = t3 ^ ( c[109] & c[110] ) ^ a[68] ;
		end
		if( i == 1 )	
		begin
			a[92:1] = tmpa_init[91:0] ;
			b[83:1] = tmpb_init[82:0] ;
			c[110:1] = tmpc_init[109:0] ;
			a[0] = t3 ;
			b[0] = t1 ;
			c[0] = t2 ;
		end
		else 
		begin
			a[92:1] = tmpa[91:0] ;
			b[83:1] = tmpb[82:0] ;
			c[110:1] = tmpc[109:0] ;
			a[0] = t3 ;
			b[0] = t1 ;
			c[0] = t2 ;
		end
		i = i + 1 ;
	end
endmodule

module pentavium_keystream_generation(keystream,iv,clk,clk1);
	output [99:0] keystream ;
	input [79:0] iv ;
	input clk,clk1 ;
	reg [79:0] key ;
	reg [92:0] a ;
	reg [83:0] b ;
	reg [110:0] c ;
	key_stream_gen k1 (keystream,iv,a,b,c,clk,clk1) ;
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
