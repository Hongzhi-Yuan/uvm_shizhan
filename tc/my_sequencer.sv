`ifndef MY_SEQUENCER__SV
`define MY_SEQUENCER__SV


class my_sequencer extends uvm_sequencer#(my_transaction);
	
	`uvm_component_utils(my_sequencer);
	
	function new(string name = "my_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction 
	
	
	virtual task run_phase(uvm_phase phase);
		my_sequence  m_seq;
		phase.raise_objection(this);
		m_seq = my_sequence::type_id::create("m_seq", this);
		m_seq.start(this);
		phase.drop_objection(this);
	endtask 

endclass 




`endif 