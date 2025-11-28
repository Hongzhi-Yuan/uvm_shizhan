`ifndef MY_MODE__SV
`define MY_MODE__SV


class my_model extends uvm_component ;
	uvm_blocking_get_port#(my_transaction) port;
	uvm_analysis_port#(my_transaction) ap;
	
	
	`uvm_component_utils(my_model)
	function new(string name = "my_model", uvm_component parent = null );
		super.new(name, parent);
	endfunction 
	
	virtual function void  build_phase(uvm_phase phase);
		super.build_phase(phase);
		port = new("port", this);
		ap = new("ap", this);
	endfunction
	
	virtual task  run_phase(uvm_phase phase);
		my_transaction tr;
		my_transaction new_tr;
		while(1) begin 
			port.get(tr);
			new_tr = new("new_tr");
			new_tr.copy(tr);
			new_tr.print();
			ap.write(new_tr);
		end 
	endtask
	
	
endclass




`endif 