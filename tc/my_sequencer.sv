`ifndef MY_SEQUENCER__SV
`define MY_SEQUENCER__SV


class my_sequencer extends uvm_sequencer#(my_transaction);
	
	`uvm_component_utils(my_sequencer);
	
	function new(string name = "my_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction 
	
	virtual task main_phase(uvm_phase phase);
		my_sequence seq;
		phase.raise_objection(this);
		seq = my_sequence::type_id::create("seq");
		seq.start(this);
		phase.drop_objection(this);
	endtask 
	
	
	
endclass 




`endif 