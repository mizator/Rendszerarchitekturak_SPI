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
module sckgen_tb;
// Inputs
	reg clk = 1;
    reg rst;
    reg r_en;
    reg [7:0] baudrate_data;
	wire [7:0] baudrate;
	wire sck;

	// Instantiate the Unit Under Test (UUT)
	sckgen uut (
		.clk(clk), 
        .rst(rst),
		.en(en),
		.baudrate(baudrate), 
		.sck(sck), 
		.sck_rise(sck_rise), 
		.sck_fall(sck_fall)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
        rst = 1;
        baudrate_data = 8'b0;
        #102 rst = 0; 
        #20 r_en = 1;
	end

always #10 clk = ~clk;

reg [2:0] cntr = 3'b0;
always @ (posedge sck)
begin 
	cntr = cntr + 1'b1;
	if (cntr == 3'b111)
	baudrate_data = baudrate_data + 1'b1; 
end

assign baudrate = baudrate_data;
assign en = r_en;
endmodule
