module part2(Clock, Reset_b, Data, Function, ALUout);
	input wire Clock; 
	input wire Reset_b; // active-high reset
	input wire [3:0] Data; // input
	input wire [1:0] Function; // ALU control
	output wire [7:0] ALUout;

	reg [7:0] Pre_reg_ALUout;
	reg [3:0] ALUout_b;

	always@ (posedge Clock)
	begin
		if (Reset_b) // active high
		begin
			Pre_reg_ALUout <= 8'b0;
        		ALUout_b <= 4'b0;
		end
		else
		begin
			case (Function)
				2'b00: Pre_reg_ALUout <= Data + ALUout_b; // A + B
            			2'b01: Pre_reg_ALUout <= Data * ALUout_b; // A * B
            			2'b10: Pre_reg_ALUout <= ALUout_b << Data; // Left shift
            			2'b11: Pre_reg_ALUout <= Pre_reg_ALUout; // Hold value in the Register
            			default: Pre_reg_ALUout <= 8'b0;
			endcase
		end
	end

    	ALUout_b <= Pre_reg_ALUout[3:0]; // 4 least sig stored

	D_flip_flop Registar (.clk(Clock), .reset_b(ALUout_b), .d(Pre_reg_ALUout), .q(ALUout));

	assign ALUout = Pre_reg_ALUout[7:0];
endmodule

module D_flip_flop (input wire clk, input wire reset_b, input wire d, output reg q);
	always@ (posedge clk)
	begin
		if (reset_b) q <= 1’b0;
		else q <= d;
	end
endmodule