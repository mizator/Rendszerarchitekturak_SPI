`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:00:02 05/06/2017 
// Design Name: 
// Module Name:    sckgen_tb
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
module spi_if_tb;
// Inputs
	reg 			clk;
    reg 			rst;
    reg 			r_en;
    reg 	[7:0] 	baudrate_data;
	wire 	[7:0] 	baudrate;
	wire 			sck;

// Instantiate the Unit Under Test (UUT)
spi_if uut(
	// General input signals
.clk(clk),
.rst(rst),

	// Internal signals
.din(spi_din), 		// Data from bus
.cmd(spi_cmd), 		// Modify settings
.wr(spi_wr), 		// Write data
.rd(spi_rd), 		// Read data

.dout(spi_dout), 		// Data to bus
.ack(spi_ack), 		// Acknowledge
.irq(spi_irq),		// Interrupt request

	// SPI signals
.SPI_MISO(miso),	// Master-In-Slave-Out
.SPI_MOSI(mosi),	// Master-Out-Slave-In
.SPI_SCK(sck),	// Bus-Clock
.SPI_nSS(nss)		// Slave-Select
);

initial begin
	// Initialize Inputs
	clk = 1;
	 r_en = 0;
    rst = 1;
    baudrate_data = 8'b1;
    #102 rst = 0; 
    #20 r_en = 1;
end

always #10 clk = ~clk;

reg [4:0] cntr = 5'b0;
always @ (posedge sck)
begin 
	cntr = cntr + 1'b1;
	if (cntr == 5'b11111)
	baudrate_data = baudrate_data + 1'b1; 
end

assign baudrate = baudrate_data;
assign en = r_en;
endmodule
