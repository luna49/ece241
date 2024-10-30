//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire iClock;
   output wire [7:0] oX;          // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire oPlot;       		 // Pixel draw enable
   output wire oDone;       		 // goes high when finished drawing frame

   //
   // Your code goes here
	wire ld_x, ld_y, blackout, start_plot;
	wire [1:0] incx;
	wire [1:0] incy;
	wire [5:0] topLeftCornerX;
	wire [4:0] topLeftCornerY;
	
	control c0(
			.clk(iClock), 
			.reset(iResetn), 
			.iLoadX(iLoadX), 
			.iPlotBox(iPlotBox), 
			.iBlack(iBlack), 
			.ld_x(ld_x), 
			.ld_y(ld_y), 
			.blackout(blackout), 
			.start_plot(start_plot), 
			.oPlot(oPlot), 
			.oDone(oDone),
			.incx(incx),
			.incy(incy),
			.topLeftCornerX(topLeftCornerX),
			.topLeftCornerY(topLeftCornerY)
	);
			
	dataPath d0(
			.clk(iClock), 
			.reset(iResetn), 
			.color(iColour), 
			.coord(iXY_Coord), 
			.ld_x(ld_x), 
			.ld_y(ld_y), 
			.blackout(blackout), 
			.start_plot(start_plot), 
			.oX(oX), 
			.oY(oY), 
			.oColor(oColour),
			.incx(incx),
			.incy(incy),
			.topLeftCornerX(topLeftCornerX),
			.topLeftCornerY(topLeftCornerY)
   );
   //

endmodule // part2

module control (clk, reset, iLoadX, iPlotBox, iBlack,ld_x, ld_y, blackout, start_plot, oPlot, oDone, incx, incy, topLeftCornerX, topLeftCornerY);

	input clk, reset, iLoadX, iPlotBox, iBlack;
	
	output reg ld_x, ld_y, blackout, start_plot, oPlot, oDone;
	
	output reg [1:0] incx;
	output reg [1:0] incy;
	
	output reg [5:0] topLeftCornerX;
	output reg [4:0] topLeftCornerY;
	
	reg [3:0] current, next;
	
	localparam  WAIT_X        = 4'd0,
               LOAD_X   	  = 4'd1,
               WAIT_PLOT     = 4'd2,
               LOAD_PLOT     = 4'd3,
               WAIT_DRAW     = 4'd4,
					DRAW			  = 4'd5,
					DRAWBLACK	  = 4'd6,
					DRAWREST		  = 4'd7,
					CLEANUP		  = 4'd8;
					
	//state table
	always@(*)
		begin
		
			case (current)
				WAIT_X: 
				begin
					if (iLoadX == 1'b1) 
					begin
						next <= LOAD_X;
					end
					else if (iBlack == 1'b1) 
					begin
						next <= DRAWBLACK;
					end
					else if (iLoadX == 1'b0) 
					begin
						next <= WAIT_X;
					end
				end
				LOAD_X: next <= iLoadX ? LOAD_X : WAIT_PLOT;
				WAIT_PLOT: next <= iPlotBox ? LOAD_PLOT : WAIT_PLOT;
				LOAD_PLOT: next <= iPlotBox ? LOAD_PLOT : WAIT_DRAW;
				WAIT_DRAW: next <= DRAW;
				DRAW: next <= DRAWREST;
				DRAWREST: 
				begin 
					if (blackout)
					begin
						if (topLeftCornerX == 39 && topLeftCornerY == 29) 
						begin
							next <= CLEANUP;
						end
						else 
						begin
							next <= DRAWREST;
						end
					end
					else if (incx == 3 && incy == 3) 
					begin
						next <= CLEANUP;
					end
					else 
					begin
						next <= DRAWREST;
					end
				end
				CLEANUP: next <= WAIT_X;
				DRAWBLACK: next <= DRAWREST;
			default: next <= WAIT_X;
			endcase
		end
		
	always @(posedge clk)
		begin
			
			ld_x <= 1'b0;
			ld_y <= 1'b0;
			start_plot <= 1'b0;
			
			case (current)
				WAIT_X: begin
					ld_x <= 1'b1;
					oDone <= 1'b0;
					oPlot <= 1'b0;
					incx <= 0;
					incy <= 0;
					blackout <= 0;
					topLeftCornerX <= 0;
					topLeftCornerY <= 0;
				end	
				LOAD_X: begin
					ld_x <= 1'b0;
					incx <= 0;
					incy <= 0;
				end
				WAIT_PLOT: begin
					ld_y <= 1'b1;
				end
				WAIT_DRAW: begin
					start_plot <= 1'b1;
					oPlot <= 1'b0;
				end
				DRAW: begin
					start_plot <= 1'b1;					
					oPlot <= 1'b0;
					oDone <= 1'b0;
				end
				DRAWREST: begin
					start_plot <= 1'b1;
					oPlot <= 1'b1;
					
					
					if (blackout && incx == 3 && incy == 3) 
					begin
						incx <= 0;
						incy <= 0;
						if (topLeftCornerX < 39) 
						begin
							topLeftCornerX <= topLeftCornerX + 1;
						end
						else if (topLeftCornerY < 29) 
						begin
							topLeftCornerX <= 0;
							topLeftCornerY <= topLeftCornerY + 1;
						end	
					end
					else 
					begin
						if (incx < 3) 
						begin
							incx <= incx + 1;
						end
						else 
						begin
							incy <= incy + 1;
							incx <= 0;
						end
					end
				end
				DRAWBLACK: 
				begin
					start_plot <= 1'b1;
					oPlot <= 1'b0;
					oDone <= 1'b0;
					blackout <= 1'b1;
				end
				CLEANUP: 
				begin
					oDone <= 1'b1;
					oPlot <= 1'b0;
					blackout <= 1'b0;
				end
			endcase
		end
	
	always @(posedge clk)
		begin
		
			if (reset == 1'b0) 
			begin
				current <= WAIT_X;
			end
			else if (iBlack && !blackout) 
			begin
				current <= DRAWBLACK;
			end
			else 
			begin
				current <= next;
			end
		end
		
endmodule
					
		
	
	

module dataPath (clk, reset, color, coord, ld_x, ld_y, blackout, start_plot, oX, oY, oColor, incx, incy, topLeftCornerX, topLeftCornerY);

	input clk, reset, ld_x, ld_y, blackout, start_plot;
	input [2:0] color;
	input [6:0] coord;
	input [1:0] incx;
	input [1:0] incy;
	
	input [5:0] topLeftCornerX;
	input [4:0] topLeftCornerY;
	
	output reg [7:0] oX;
	output reg [6:0] oY;
	output reg [2:0] oColor;
	
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] c;
	
	
	always @(posedge clk) 
		begin
			
			if (!reset) 
			begin
				x <= 8'b0;
				y <= 7'b0;
				c <= 3'b0;
			end
			else if (blackout) 
			begin
				x <= {1'b0, 4*topLeftCornerX};
				y <= 4*topLeftCornerY;
				c <= 3'd0;
			end
			else begin
				if (ld_x) 
				begin
					x <= {1'b0, coord};
				end
				if (ld_y) 
				begin
					y <= coord;			
					c <= color;
				end
			end
		end
		
	always @(posedge clk)
		begin
			
			if (!reset) 
			begin
				oX <= 8'b0;
				oY <= 7'b0;
				oColor <= 3'b0;
			end
			else 
			begin
				if (start_plot) 
				begin
					if (incx == 2'd0) 
					begin
						oX <= x;
					end else if (incx == 2'd1) 
					begin
						oX <= x + incx;
					end else if (incx == 2'd2) 
					begin
						oX <= x + incx;
					end else if (incx == 2'd3) 
					begin
						oX <= x + incx;
					end
					
					if (incy == 2'd0) 
					begin
						oY <= y;
					end else if (incy == 2'd1) 
					begin
						oY <= y + incy;
					end else if (incy == 2'd2) 
					begin
						oY <= y + incy;
					end else if (incy == 2'd3) 
					begin
						oY <= y + incy;
					end
					
					oColor <= c;
				end
			end
		end
		
endmodule
