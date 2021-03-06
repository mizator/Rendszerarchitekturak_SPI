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
	input 			clk, 		// System Clock
	input 			rst, 		// System Reset

	// Wishbone
	input 	[31:0] 	wb_addr, 	// Address
	input 			wb_we, 		// Write Enable
	input 			wb_stb, 	// Strobe
	input 			wb_cyc, 	// Bus Cycle
	input 	[31:0] 	wb_dout, 	// Bus to Slave
	output 	[31:0] 	wb_din, 	// Slave to Bus
	output 			wb_ack, 	// Acknowledge

	// Internal
	output 	[11:0] 	dout, 		// Bus to Slave
	output 			cmd, 		// Modify Settings
	output 			wr,			// Write Data
	output 			rd, 		// Read Data
	input 	[9:0] 	din, 		// Slave to Bus
	input 			ack 		// Acknowledge
    );

// Address decoder
parameter ADDR_DATA = 32'h0000_0010;
parameter ADDR_CMD = 32'h0000_0020;

wire select;
assign select = (wb_stb & wb_cyc);


// Assign outputs
assign wb_din = {22'b0, din};
assign wb_ack = ack;
assign dout = (select & wb_we) ? wb_dout[11:0] : 12'bZ;
assign cmd = ((wb_addr ^ ADDR_CMD) == 32'b0) &  ( wb_we);
assign wr = ((wb_addr ^ ADDR_DATA) == 32'b0) &  ( wb_we);
assign rd = ((wb_addr ^ ADDR_DATA) == 32'b0) &  (~wb_we);

endmodule
