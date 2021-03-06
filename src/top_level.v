//////////////////////////////////////////////////////////////////////////////////
// Company: 	
// Engineer: 	
// 
// Create Date:    13:29:27 04/16/2017 
// Design Name: 	Wishbone - Spi interface
// Module Name:    	top_level 
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
module top_level(
	//System
    input 			clk,		// System Clock
    input 			rst,		// System Reset
    output 			irq,		// Interrupt Request

    //Wishbone
    input 	[31:0] 	wb_addr,	// Address
    input 			wb_we,		// Write Enable
    input 			wb_stb,		// Strobe
    input 			wb_cyc,		// Bus Cycle
    input 	[31:0] 	wb_dout,	// Bus to Slave Data
    output 	[31:0] 	wb_din,		// Slave to Bus Data
    output 			wb_ack,		// Acknowledge

    //SPI 
    output 			spi_mosi,	// Master Out Slave In
    output 			spi_sck,	// Serial Clock
    output 			spi_ss,		// Slave Select
    input 			spi_miso	// Master In Slave Out
);

wire 		[11:0] 	dout;
wire 		[ 9:0] 	din;
wire 				cmd, wr, rd, ack;
//---------------------------------------------
// Wishbone interface module instantiation
//---------------------------------------------
wishbone_if wishbone_interface (
	.clk(clk),
	.rst(rst),
	.wb_addr(wb_addr),
	.wb_we(wb_we),
	.wb_stb(wb_stb),
	.wb_cyc(wb_cyc),
	.wb_dout(wb_dout),
	.wb_din(wb_din),
	.wb_ack(wb_ack),
	.dout(dout),
	.cmd(cmd),
	.wr(wr),
	.rd(rd),
	.din(din),
	.ack(ack)
);
//---------------------------------------------

//---------------------------------------------
// SPI Interface module instantiation
//---------------------------------------------
spi_if spi_interface(
	.clk(clk),
	.rst(rst),
	.din(dout),
	.cmd(cmd),
	.wr(wr),
	.rd(rd),
	.dout(din),
	.ack(ack),
	.irq(irq),
	.SPI_MOSI(spi_mosi),
	.SPI_SCK(spi_sck),
	.SPI_nSS(spi_ss),
	.SPI_MISO(spi_miso)
);
//---------------------------------------------
endmodule
