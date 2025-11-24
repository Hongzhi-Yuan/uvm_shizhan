`timescale 1ns/1ps


module  design_top(
	input			clock,
	input			reset,
	input [7:0]  	rxd,
	input 			rx_dv,
	output reg [7:0] txd,
	output reg 		tx_en
);
	

	always  @ (posedge clock, posedge reset) begin 
		if (reset) begin 
			txd <= 'b0;
			tx_en <= 'b0;
		end else begin 
			txd <= rxd;
			tx_en <= rx_dv;
		end 
	end 

endmodule 