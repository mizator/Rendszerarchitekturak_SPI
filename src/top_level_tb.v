`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:00:02 05/06/2017 
// Design Name:		Wishbone - Spi interface
// Module Name:     top_level_tb
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
module top_level_tb;
// Inputs
reg 			clk;
reg 			rst;
reg 	[31:0] 	wb_addr;
reg 			wb_we;
reg 			wb_stb;
reg 			wb_cyc;
reg 	[31:0] 	wb_dout;
// Outputs
wire 	[31:0] 	wb_din;
wire 			wb_ack;
wire 			spi_dint;
// Internal
wire 			spi_mosi;
wire 			spi_miso;
wire 			spi_sck;
wire 			spi_ss;

//---------------------------------------------
// Wishbone-SPI interface module instantiation
//---------------------------------------------
top_level uut (
	.clk(clk),
	.rst(rst),
	.wb_addr(wb_addr),
	.wb_we(wb_we),
	.wb_stb(wb_stb),
	.wb_cyc(wb_cyc),
	.wb_dout(wb_dout),
	.wb_din(wb_din),
	.wb_ack(wb_ack),
	.spi_mosi(spi_mosi),
	.spi_sck(spi_sck),
	.spi_ss(spi_ss),
	.spi_miso(spi_miso),
	.spi_dint(spi_dint)
);
//---------------------------------------------

//---------------------------------------------
// M25LC020A SPI EEPROM instantiation
//---------------------------------------------
M25LC020A spi_eeprom (
	.SI(spi_mosi),
	.SO(spi_miso),
	.SCK(spi_sck),
	.CS_N(spi_ss),
	.WP_N(1'b1),
	.HOLD_N(1'b1),
	.RESET(rst)
);
//---------------------------------------------

//---------------------------------------------
// Bus write cycle
//---------------------------------------------
task wishbone_write (input [31:0] wr_addr, input [31:0] wr_data);
begin
	#10 wb_addr <= wr_addr;
		wb_dout <= wr_data;
		wb_stb <= 1'b1;
		wb_cyc <= 1'b1;
		wb_we <= 1'b1;
	wait(wb_ack);
	#10 wb_stb <= 1'b0;
		wb_cyc <= 1'b0;
		wb_we <= 1'b0;
end
endtask
//---------------------------------------------

//---------------------------------------------
// Bus read cycle
//---------------------------------------------
task wishbone_read (input [31:0] rd_addr);
begin
	#10 wb_addr <= rd_addr;
		wb_stb <= 1'b1;
		wb_cyc <= 1'b1;
		wb_we <= 1'b0;
	wait(wb_ack);
	#10 wb_stb <= 1'b0;
		wb_cyc <= 1'b0;
		wb_we <= 1'b0;
end
endtask
//---------------------------------------------

//---------------------------------------------
// Initialize Inputs
//---------------------------------------------
initial begin
	clk = 0;
	rst = 0;
	wb_addr = 0;
	wb_we = 0;
	wb_stb = 0;
	wb_cyc = 0;
	wb_dout = 0;
end

//---------------------------------------------
// Generate clock
//---------------------------------------------
always #5 begin
	clk = ~clk;
end
//---------------------------------------------

//---------------------------------------------
initial 
begin
	/* RESET */
		#200;
		rst = 1'b1;
		#200;
		rst = 1'b0;
		#5;
	/* Push data */
	wishbone_write(32'h0000_0020, 32'h0000_0203); // Set baudrate
	wishbone_write(32'h0000_0010, 32'h0000_0306); // Write enable instruction
	wishbone_write(32'h0000_0010, 32'h0000_0102); // Write instruction
	wishbone_write(32'h0000_0010, 32'h0000_00FE); // Write address
	wishbone_write(32'h0000_0010, 32'h0000_02D3); // Write data
	// Wait for the SPI write to end
	while(~(wb_din === 32'h0000_0000))
	begin
		wishbone_write(32'h0000_0010, 32'h0000_0105); // Read status
		wishbone_write(32'h0000_0010, 32'h0000_0600); // Receive answer
		wait(spi_dint); // Wait for the answer
		wishbone_read (32'h0000_0010); // Read answer
	end
		wishbone_write(32'h0000_0010, 32'h0000_0103); // Read instruction
		wishbone_write(32'h0000_0010, 32'h0000_00FE); // Read address
		wishbone_write(32'h0000_0010, 32'h0000_0600); // Receive answer
		wait(spi_dint); // Wait for the answer
		wishbone_read (32'h0000_0010); // Read answer
end
//---------------------------------------------
endmodule
