`ifndef MY_AGENT__SV
`define MY_AGENT__SV


class my_agent extends uvm_agent;
	
	my_driver drv;
	my_monitor mon;
	my_sequencer sqr;
	
	uvm_analysis_port#(my_transaction) ap;
	
	`uvm_component_utils(my_agent)

	function new(string name="my_agent", uvm_component parnet = null );
		super.new(name, parnet);
	endfunction 
	
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon = my_monitor::type_id::create("mon", this);
		if (is_active) begin 
			drv = my_driver::type_id::create("drv", this);
			sqr = my_sequencer::type_id::create("sqr", this);
		end 
		
	endfunction 
	
	
	virtual function  void connect_phase(uvm_phase phase);
		if (is_active == UVM_ACTIVE) begin 
			drv.seq_item_port.connect(sqr.seq_item_export);
		end 
		ap = mon.ap;
	endfunction 
	
	
	
	
endclass 




`endif 