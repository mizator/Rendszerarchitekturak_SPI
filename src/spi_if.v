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
// States
//---------------------------------------------
parameter S_IDLE = 3'b000; //Idle
parameter S_REG_RD = 3'b001; //Register read
parameter S_REG_WR = 3'b010; //Register write
parameter S_DOUT = 3'b011; //Data out
parameter S_DIN = 3'b100; //Data out
//---------------------------------------------

//---------------------------------------------
// Registers for SPI
//---------------------------------------------
reg [10:0] SPICR;		//SPI CONTROL REGISTER 		[Global EN | Interrupt EN | Interrupt Clear | baudrate[7:0]]
reg [9:0] SPISR;		//SPI STATUS REGISTER 		[IRQreg | BUSY reg | data[7:0] ]
//---------------------------------------------

//---------------------------------------------
// Register value settings
//---------------------------------------------
always @ (posedge clk)
begin
	if(rst) begin
		SPICR <= 8'b0;
	end
	else if(cmd) begin
		SPICR <= din;						// a bit kiosztást ki kell találni!!!
	end
	else if(wr) begin
		SPISR <= din;
		//todo: adatatvitel start
	end
	else if(rd) begin
	end
end

assign dout = SPISR;
assign ack = 1;
//---------------------------------------------
reg spi_ss_reg; // active low

// 0 - Idle
// 1 - start SS le, clk en
// 2:9 - tx
// 10 - stop SS fel, clk dis
reg [3:0] state = 0;
always @ (posedge clk)
begin
 if(rst) begin
	state <= 4'b0;
	spi_ss_reg <= 1;
 end
 else begin
 	if (state == 0) begin // idle
	 	if (wr && (SPICR[10])) begin
	 		state <= 4'h1;
			SPISR[8] <= 1; // BUSYreg
		end
	end
	else if  (state == 4'h1)  begin // start
		state <= 4'h2;
		spi_ss_reg <= 0;
	end
	else if ((state >= 4'h2) & ((state <= 4'h9))) begin // tx
		if (spi_sck_rise) begin // vagy fall?
			state <= state + 1;
		end
	end
	else if  (state == 4'hA)  begin // stop
		state <= 4'h0;
		if (SPICR[9] == 1) begin
			SPISR[9] <= 1; // IRQreg
		end
		SPISR[8] <= 0; // BUSYreg
		spi_ss_reg <= 1;
	end
 end
end

assign irq = (state == 4'hA);


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
// State logic instantiation
//---------------------------------------------
/*reg [2:0] spi_state;
statelogic statelogic (
 	.clk(clk), 		// System clock
	.rst(rst), 		// System reset
	.sck_rise(spi_sck_rise), // sck rising edge
 	.sck_fall(spi_sck_fall), // sck falling edge
	.cmd(cmd), 		// Modify settings
	.wr(wr), 		// Write data
	.rd(rd), 		// Read data
	.next_state_en(next_state_en), //inkább kellene egy transmit_finished flag vagy ilyesmi
	.state(spi_state)
);
//---------------------------------------------*/

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

assign SPI_nSS = spi_ss_reg;
//---------------------------------------------

//---------------------------------------------
endmodule
