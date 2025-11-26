`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV



class my_driver extends uvm_driver;
	
	virtual  my_if vif;
	
	`uvm_component_utils(my_driver)
	
	function new(string name = "", uvm_component parent = null );
		super.new(name, parent);
	endfunction 
	
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual  my_if)::get(this, "", "vif", vif)) 
			`uvm_fatal(get_full_name(), "virtual  interface must be set!!!!!!!")
	endfunction 
	
	virtual task main_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 200ns);
		phase.raise_objection(this);
	
		`uvm_info(get_full_name(), "main_phase called begin", UVM_LOW)
		
		
		vif.valid <= 'b0;
		vif.data <= 'b0;
		
		@(negedge  vif.reset);
	
		for (int i = 0;i < 10; i++)  begin 
			@(posedge vif.clock);
			vif.valid <= 1'b1;
			vif.data <= $urandom_range(0, 255);
		end 
		
		@(posedge vif.clock);
		vif.valid <= 1'b0;
		vif.data <= 'b0;
		
		`uvm_info(get_full_name(), "main_phase called end", UVM_LOW)
		phase.drop_objection(this);
	endtask 
	
	
	
	
endclass 



`endif