module part1(a, b, c_in, s, c_out);
	input [3:0] a, b;
	input c_in;
	output [3:0] s, c_out;

	fullAdder FA0(a[0], b[0], c_in, s[0], c_out[0]);
	fullAdder FA1(a[1], b[1], c_out[0], s[1], c_out[1]);
	fullAdder FA2(a[2], b[2], c_out[1], s[2], c_out[2]);
	fullAdder FA3(a[3], b[3], c_out[2], s[3], c_out[3]);
endmodule

module fullAdder(a, b, c_in, s, c_out);
	input a, b, c_in;
	output s, c_out;
	
	assign s = c_in ^ (a ^ b);
	assign c_out = (a & b) | (b & c_in) | (c_in & a);
endmodule