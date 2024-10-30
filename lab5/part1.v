module part1 (input Clock, input Enable, input Reset, output [7:0] CounterValue);
	wire w1, w2, w3, w4, w5, w6, w7;

	t_flip_flop u1(Enable, Clock, Reset, CounterValue[0]);
	assign w1 = CounterValue[0] & Enable;

	t_flip_flop u2(w1, Clock, Reset, CounterValue[1]);
	assign w2 = CounterValue[1] & Enable;

	t_flip_flop u3(w2, Clock, Reset, CounterValue[2]);
	assign w3 = CounterValue[2] & Enable;

	t_flip_flop u4(w3, Clock, Reset, CounterValue[3]);
	assign w4 = CounterValue[3] & Enable;

	t_flip_flop u5(w4, Clock, Reset, CounterValue[4]);
	assign w5 = CounterValue[4] & Enable;

	t_flip_flop u6(w5, Clock, Reset, CounterValue[5]);
	assign w6 = CounterValue[5] & Enable;

	t_flip_flop u7(w6, Clock, Reset, CounterValue[6]);
	assign w7 = CounterValue[6] & Enable;

	t_flip_flop u8(w7, Clock, Reset, CounterValue[7]);

endmodule

module t_flip_flop(input t, clk, reset, output reg q);
	always@(posedge clk or posedge reset) begin
		if(reset)
			q <= 1'b0;
		else if (t)
			q <= ~q;
	end
endmodule