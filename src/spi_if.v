`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:57:30 03/04/2017 
// Design Name: 
// Module Name:    spi 
// Project Name: 
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
module spi(
    input MISO,
    output MOSI,
    output CLK,
    output nSS,
// in/out for wishbone??	

	input  [7:0] in, 
	output [7:0] out

    );
//---------------------------------------------
// Registers for SPI
//---------------------------------------------
reg [7:0] SPICR1;			//SPI CONTROL REGISTER 1
reg [7:0] SPICR2;			//SPI CONTROL REGISTER 2
reg [7:0] SPIBR;			//SPI BAUD-RATE REGISTER
reg [7:0] SPISR;			//SPI STATUS REGISTER
reg [7:0] SPIDR;			//SPI DATA REGISTER
//---------------------------------------------

endmodule
