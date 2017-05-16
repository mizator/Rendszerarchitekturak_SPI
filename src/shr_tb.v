`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:00:02 05/06/2017 
// Design Name:    Wishbone - Spi interface
// Module Name:    shr_tb 
// Project Name:   Wishbone - Spi interface
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
module shr_tb;
// Inputs
	reg 			clk;
    reg 			rst;
    reg 			sh;
    reg 			ld;


    // for feedback with dout
    //wire 			din;
    // comment out for feedback
    reg 			din;
        		
    wire 			dout;
    wire 	[7:0] 	dstr;
    reg 	[7:0] 	load_data;
    wire 	[7:0] 	ld_data;

	// Instantiate the Unit Under Test (UUT)
	shr uut (
		.clk(clk), 
        .rst(rst),
		.din(din),
		.sh(sh), 
		.ld(ld), 
		.ld_data(ld_data), 
		.dout(dout),
		.dstr(dstr)		
	);

	initial begin
		// Initialize Inputs
		clk = 1;
        rst = 1;
        load_data = 8'b0;
        sh = 0;
        ld = 0;
        #100 rst = 0;

        // comment out for feedback
        din = 0;

	end

always #10 clk = ~clk;


reg [3:0] cntr = 4'b0;
always @ (posedge clk)
begin
	if (~(rst == 1'b1)) begin
		cntr = cntr + 1'b1;

		if (cntr == 4'b1000) begin
			load_data = load_data + 1'b1;
			cntr = 4'b000;	
			sh = 0;
			ld = 1;
		end
		else begin
			sh = 1;
			ld = 0;
		end
	end
end

// for feedback with dout
//assign din = dout;
 	
assign ld_data = load_data;
endmodule
