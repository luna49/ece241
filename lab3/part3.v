module part3 (A, B, Function, ALUout);
	parameter N = 4;
	input [N-1:0] A, B;
	input [1:0] Function;
	output reg [2*N-1:0] ALUout;
	
	wire [N-1:0] a1;
	wire a2;
	
	RCA RCA0(.a(A), .b(B), .c_in(1'b0), .s(a1), .c_out(a2));
	
	always@(*)
	begin
		case (Function)
		
			2'b00: ALUout = {A+B};

            		2'b01: ALUout = |(A|B);

            		2'b10: ALUout = &(A&B);

            		2'b11: ALUout = {A, B};

            		default: ALUout = 0;
		endcase
	end
endmodule 

module RCA (a, b, c_in, s, c_out);
	parameter N = 4;
	input [N-1:0] a, b;
	input c_in;
	output [N-1:0] s;
	output c_out;
	
	wire [N-2:0] c_out_i; //internal connections
	
	fullAdder FA0(a[0], b[0], c_in, s[0], c_out_i[0]);
	fullAdder FA1(a[1], b[1], c_out_i[0], s[1], c_out_i[1]);
	fullAdder FA2(a[2], b[2], c_out_i[1], s[2], c_out_i[2]);
	fullAdder FA3(a[3], b[3], c_out_i[2], s[3], c_out);
endmodule

module fullAdder(a, b, c_in, s, c_out);
	input a, b, c_in;
	output s, c_out;
	
	assign s = c_in ^ (a ^ b);
	assign c_out = (a & b) | (b & c_in) | (c_in & a);
endmodule