`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     00:57:30 03/04/2017 
// Design Name: 	Wishbone - Spi interface
// Module Name:     spi_if
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
module spi_if(
	// General input signals
	input 			clk,
	input 			rst,

	// Internal signals
	input 	[10:0] 	din, 		// Data from bus
	input 			cmd, 		// Modify settings
	input 			wr, 		// Write data
	input 			rd, 		// Read data

	output 	[ 8:0] 	dout, 		// Data to bus
	output 			ack, 		// Acknowledge
	output 			irq,		// Interrupt request

	// SPI signals 
    input  			SPI_MISO,	// Master-In-Slave-Out	
    output 			SPI_MOSI,	// Master-Out-Slave-In
    output 			SPI_SCK,	// Bus-Clock
    output 			SPI_nSS		// Slave-Select
);
//---------------------------------------------
// Registers for SPI
//---------------------------------------------
reg [7:0] SPICR;		//SPI CONTROL REGISTER 		[Global EN | Interrupt EN | Write EN | Read EN]	
reg [7:0] SPIBR;		//SPI BAUD-RATE Registers	[8bit] 
reg [7:0] SPISR;		//SPI STATUS REGISTER 		[BUSY (reg/wire??) | Interrupt Clear (state)? | ]
reg [7:0] SPIDR;		//SPI DATA REGISTER 		[]
//---------------------------------------------

//---------------------------------------------
// Register value settings
//---------------------------------------------
always @ (posedge clk) 
begin
	if(rst) begin
		SPICR <= 8'b0;
		SPIBR <= 8'b0;
	end
	else if(cmd) begin
		SPICR <= din[10:9];						// a bit kiosztást ki kell találni!!!
		SPIBR <= din[ 7:0];
	end
end
//---------------------------------------------

//---------------------------------------------
// SCK frequency divider module instantiation
//---------------------------------------------
wire spi_sck_rise, spi_sck_fall;
sckgen spi_sckgen (
	.clk(clk),
	.rst(rst),
	.en(~SPI_nSS),
	.baudrate(SPIBR),
	.sck(SPI_SCK),
	.sck_rise(spi_sck_rise),
	.sck_fall(spi_sck_fall)
);
//---------------------------------------------

//---------------------------------------------
// State logic + conditions???
//---------------------------------------------


//---------------------------------------------
// Acknowledge signal generation
//---------------------------------------------
reg ack_reg;
always @ (posedge clk)
begin
	if(rst)
		ack_reg <= 1'b0;
	else
		ack_reg <= ;							//feltétel?
end

assign ack = ack_reg;
//---------------------------------------------

//---------------------------------------------
// SPI shift register module instantiation
//---------------------------------------------
wire [7:0] spi_shr_dout;
shr spi_shr (
	.clk(clk),
	.rst(rst),
	.din(SPI_MISO),
	.sh(spi_shr_sh),
	.ld(spi_load),
	.ld_data(),									//mit tegyünk az ld_data-ba?
	.dout(SPI_MOSI),
	.dstr(spi_shr_dout)
);
//---------------------------------------------

//---------------------------------------------
// Slave select signal generation
//---------------------------------------------
reg spi_ss_reg; // active low
always @ (posedge clk)
begin
		if(rst)
			spi_ss_reg <= 1'b1;
		else if()								//mikor legyen az spi_ss 0/1 ?
			spi_ss_reg <= 1'b1;
		else if()
		spi_ss_reg <= 1'b0;
end

assign SPI_nSS = spi_ss_reg;
//---------------------------------------------

//---------------------------------------------
// Interrupt request signal generation
//---------------------------------------------
reg irq_reg;
always @ (posedge clk)
begin
	if(rst)
		irq_reg <= 1'b0;
	else
		irq_reg <= ;							// feltétel?
end

assign irq = irq_reg;
//---------------------------------------------
endmodule
