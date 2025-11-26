`ifndef MY_INTERFACE__SV
`define MY_INTERFACE__SV


interface my_if(input clock, input reset);
	logic  valid;
	logic  [7:0] data;
	
endinterface 







`endif  