`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:     13:52:01 04/16/2017
// Design Name: 	Wishbone - Spi interface
// Module Name:   	statelogic
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
module statelogic(
	input 			clk, 		// System clock
	input 			rst, 		// System reset
	input 			sck_rise, // sck rising edge
	input 			sck_fall, // sck falling edge
	input 			cmd, 		// Modify settings
	input 			wr, 		// Write data
	input 			rd, 		// Read data
	input 			next_state_en,

	output 			[2:0] state 	// sck falling edge
);

reg [2:0] state_reg;
assign state = state_reg;

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
// Next state logic
//---------------------------------------------
always @ (posedge clk)
begin
	if (rst)
		state_reg <= S_IDLE;
	else if (next_state_en) //next_state_en: jump to next state
	begin
		case (state_reg)
			S_IDLE: begin
				if (cmd & rd & !wr)
					state_reg <= S_REG_RD;
				else if (cmd & !rd & wr)
					state_reg <= S_REG_WR;
				else if (!cmd & rd & !wr)
					state_reg <= S_DIN;
				else if (!cmd & !rd & wr)
					state_reg <= S_DOUT;
				else
					state_reg <= S_IDLE;
			end

			default: S_IDLE;
		endcase
end

//---------------------------------------------

//---------------------------------------------
// Output signal generation
//---------------------------------------------

//---------------------------------------------

endmodule
