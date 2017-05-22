`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:     13:52:01 04/16/2017
// Design Name: 	Wishbone - Spi interface
// Module Name:     sckgen
// Project Name: 	Wishbone - Spi interface
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module sckgen(
	input 			clk, 		// System clock
	input 			rst, 		// System reset
	input 			en, 		// Enable clock generator
	input 	[7:0] 	baudrate, 	// Baudrate divider
	output 			sck, 		// SPI sck
	output 			sck_rise, 	// sck rising edge
	output 			sck_fall 	// sck falling edge
);

//---------------------------------------------
// Counter
//---------------------------------------------
reg [7:0] cntr;
always @ (posedge clk)
begin
	if (rst)
		cntr <= 8'b0;
	else if(en) begin
		if(cntr == baudrate)
			cntr <= 8'b0;
		else
			cntr <= cntr + 1'b1;
	end
end
//---------------------------------------------

//---------------------------------------------
// SCK register
//---------------------------------------------
reg sck_reg;
always @ (posedge clk)
begin
	if (rst)
		sck_reg <= 1'b0;
	else if(~en)
		sck_reg <= 1'b0;
	else if(cntr == baudrate)
		sck_reg <= ~sck_reg;
end
//---------------------------------------------

//---------------------------------------------
// Output signal generation		
//---------------------------------------------
assign sck 		= (sck_reg & en);
assign sck_rise = (~sck_reg) & (cntr == baudrate) & (en);
assign sck_fall = ( sck_reg) & (cntr == baudrate) & (en);
//---------------------------------------------

endmodule
