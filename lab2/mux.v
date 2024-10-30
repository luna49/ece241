`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .m(LEDR[0])
        );
endmodule

module mux2to1 (x,y,s,m);
	input x, y, s;
	output m;

	wire nots, andxs, andys;

	v7404 notgate (
		.pin5(s),
		.pin6(nots)
	);
	v7408 andgate (
		.pin13(s),
		.pin12(y),
		.pin11(andys),
		.pin4(nots),
		.pin5(x),
		.pin6(andxs)
	);
	v7432 orgate (
		.pin4(andys),
		.pin5(andxs),
		.pin6(m)
	);
endmodule