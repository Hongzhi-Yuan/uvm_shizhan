`ifndef MY_ENV__SV
`define MY_ENV__SV



class my_env extends uvm_env;
	
	
	my_agent i_agt;
	my_agent o_agt;
	
	
	
	`uvm_component_utils(my_env)
	
	function  new(string name = "my_env", uvm_component parnet = null);
		super.new(name, parnet);
	endfunction 
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		i_agt = my_agent::type_id::create("i_agt", this);
		o_agt = my_agent::type_id::create("o_agt", this);
		i_agt.is_active = UVM_ACTIVE;
		o_agt.is_active = UVM_PASSIVE;
	endfunction
	
	
endclass 



`endif 