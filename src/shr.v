`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     13:52:01 04/16/2017 
// Design Name: 	Wishbone - Spi interface
// Module Name:     shr 
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
module shr(
	input clk,
	input rst,

	input din, 				// Data in
	input sh, 				// Shift signal
	input ld,				// Load signal
	input [7:0] ld_data, 	// Data to load

	output dout, 			// Data out
	output [7:0] dstr 		// Data to store
);

//---------------------------------------------
// Shift-register block		
//---------------------------------------------
reg [7:0] shr;
always @ (posedge clk)
begin
	if(rst)
		shr <= 8'b0;
	else if(ld)
		shr <= ld_data;
	else if(sh)
		shr <= {din, shr[7:1]};					
end
//---------------------------------------------

//---------------------------------------------
// Output signal generation		
//---------------------------------------------
assign dstr = {din, shr[7:1]};					
assign dout = shr[0];
//---------------------------------------------
endmodule
