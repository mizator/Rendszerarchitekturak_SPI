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

	input clk,
	input rst,

	// Internal signals
	input [10:0] din, 	// Data from bus
	input cmd, 			// Modify settings
	input wr, 			// Write data
	input rd, 			// Read data

	output [ 8:0] dout, // Data to bus
	output ack, 		// Acknowledge
	output irq,			// Interrupt request

	// SPI signals 
    input  SPI_MISO,	// Master-In-Slave-Out	
    output SPI_MOSI,	// Master-Out-Slave-In
    output SPI_CLK,		// Bus-Clock
    output SPI_nSS,		// Slave-Select

	//input  [7:0] in, 
	//output [7:0] out

    );
//---------------------------------------------
// Registers for SPI
//---------------------------------------------
reg [7:0] SPICR;		//SPI CONTROL REGISTER 		[Global EN | Interrupt EN | Write EN | Read EN]	
reg [7:0] SPIBR;		//SPI BAUD-RATE Registers	[4bit ]
reg [7:0] SPISR;		//SPI STATUS REGISTER 		[BUSY (reg/wire??) | Interrupt Clear (state)? | ]
reg [7:0] SPIDR;		//SPI DATA REGISTER 		[]
//---------------------------------------------

endmodule
