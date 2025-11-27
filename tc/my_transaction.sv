`ifndef MY_TRANSACTION__SV
`define MY_TRANSACTION__SV


class my_transaction extends  uvm_sequence_item;
	rand bit [47:0] dmac;
	rand bit [47:0] smac;
	rand bit [15:0] ether_type;
	rand byte pload[];
	rand bit [31:0] crc;
	 
	constraint  c {
		pload.size inside {[46:1500]};
	} 
	
	function  bit [31:0] clc_crc(); 
		return  'b0;
	endfunction  
	
	function void post_randomsize();
		this.crc = clc_crc();
	endfunction 
	
	`uvm_object_utils(my_transaction)
	
	function  new (string name  = "my_transaction") ;
		super.new(name);
	endfunction 
	
endclass 

`endif

