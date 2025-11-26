`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV



class my_driver extends uvm_driver;
	
	
	
	`uvm_component_utils(my_driver)
	
	function new(string name = "", uvm_component parent = null );
		super.new(name, parent);
	endfunction 
	
	
	
	virtual task main_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "main_phase called begin", UVM_LOW)
		
		sim_top.rx_dv <= 1'b0;
		sim_top.rxd <= 8'b0;
		
		@(negedge  sim_top.reset);
	
		for (int i = 0;i < 10; i++)  begin 
			@(posedge sim_top.clock);
			sim_top.rx_dv <= 1'b1;
			sim_top.rxd <= $urandom_range(0, 255);
		end 
		
		@(posedge sim_top.clock);
		sim_top.rx_dv <= 1'b0;
		sim_top.rxd <= 'b0;
		
		`uvm_info(get_full_name(), "main_phase called end", UVM_LOW)
	endtask 
	
	
	
	
endclass 



`endif