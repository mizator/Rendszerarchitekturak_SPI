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
	.irq(spi_dint)
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
	/* EEPROM write sequence */
	wishbone_write(32'h0000_0020, 32'hFFFF_FEFF); 	// Set baudrate, int clr =0, int en, global en, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0006); 	// Write enable instruction
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_F3FF); 	//clr interrupt, SS=1
	#70;
	wishbone_write(32'h0000_0020, 32'hFFFF_FEFF);   // SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0002); 	// Write command
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF); 	//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0010);		//write address
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF); 	//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_00F3);   //data
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF); 	//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0021);   //data
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF); 	//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0015);   //data
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_F7FF); 	//int clr, SS=1
	#6000000; 																			//minimum 5mS write cycle time

	/* EEPROM read sequence */
	wishbone_write(32'h0000_0020, 32'hFFFF_FEFF); 	//SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0003); 	// read instruction
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF); 	//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0010);		//read address
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF); 	//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0000);		//MOSI=0, data read
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF);		//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0000);		//MOSI=0, data read
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_FFFF);		//clr interrupt, SS=0
	wishbone_write(32'h0000_0010, 32'h0000_0000);		//MOSI=0, data read
	wait(wb_din[9]);	//wait for interrupt
	wishbone_write(32'h0000_0020, 32'hFFFF_F7FF); 	//int clr, SS=1
end
//---------------------------------------------
endmodule
