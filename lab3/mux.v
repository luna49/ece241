`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, SW);
    input [8:0] SW;
    output [9:0] LEDR;

	// mapping ports to board for FPGA
    RCA RCA1(
        .a(SW[7:4]),
        .b(SW[3:0]),
        .c_in(SW[8]),
	.s(LEDR[3:0]),
        .c_out(LEDR[9])
        );
endmodule