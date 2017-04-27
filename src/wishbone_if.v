`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:01 04/16/2017 
// Design Name: 
// Module Name:    wishbone_if 
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
module wishbone_if(
	//System
	input clk, 				// System Clock
	input rst, 				// System Reset

	// Wishbone
	input [31:0] wb_addr, 	// Address
	input wb_we, 			// Write Enable
	input wb_stb, 			// Strobe
	input wb_cyc, 			// Bus Cycle
	input [31:0] wb_dout, 	// Bus to Slave
	output [31:0] wb_din, 	// Slave to Bus
	output wb_ack, 			// Acknowledge
	
	// Internal
	output [10:0] dout, 	// Bus to Slave
	output cmd, 			// Modify Settings
	output wr,				// Write Data
	output rd, 				// Read Data
	input [ 8:0] din, 		// Slave to Bus
	input ack 				// Acknowledge
    );

// Address decoder
parameter ADDR_DATA = 32'h0000_0010;
parameter ADDR_CMD = 32'h0000_0020;

// Check for Strobe and Bus Cycle rising edge
wire select;
assign select = (wb_stb & wb_cyc);

reg [1:0] select_reg;
always @ (posedge clk)
begin
	if(rst)
		select_reg <= 2'b0;	
	else
		select_reg <= {select_reg[0], select};
end

wire select_rise;
assign select_rise = ( select_reg == 2'b01 );

// Assign outputs
assign wb_din = (select & ~wb_we & ack) ? {23'b0, din} : 32'bZ;
assign wb_ack = (select) ? ack : 1'bZ;
assign dout = (select & wb_we) ? wb_dout[10:0] : 11'bZ;
assign cmd = ((wb_addr ^ ADDR_CMD) == 32'b0) & (select_rise) & ( wb_we);
assign wr = ((wb_addr ^ ADDR_DATA) == 32'b0) & (select_rise) & ( wb_we);
assign rd = ((wb_addr ^ ADDR_DATA) == 32'b0) & (select_rise) & (~wb_we);

endmodule
