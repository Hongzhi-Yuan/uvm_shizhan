`ifndef MY_MONITOR__SV
`define MY_MONITOR__SV


class my_monitor extends uvm_monitor;
	
	virtual my_if vif;
	
	`uvm_component_utils(my_monitor)
	
	function new (string name = "my_monitor", uvm_component parent = null );
		super.new(name, parent);
	endfunction 
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
			
		if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
			`uvm_fatal(get_full_name(), "virtual interface must be set!!!!!!!!!!!!!")
		
	endfunction 
	
	
	virtual task main_phase(uvm_phase phase);
		my_transaction tr;
		tr = new("tr");
		collect_one_pkt(tr);
		
		
	endtask 
	
	
	virtual task collect_one_pkt(my_transaction tr);
		bit [7:0] data_q[$];
		int size;
		
		
		while(1)
			if (vif.valid) break;
			
		`uvm_info(get_full_name(), "Begin collect one pkt", UVM_LOW)
		
		while(vif.valid) begin 
			data_q.push_back(vif.data);
			@(posedge vif.clock);
		end 
		
		// pop dmac 
		repeat (6) begin 
			tr.dmac[7:0] = data_q.pop_front();
			tr.dmac <<= 8;
		end 
		
		
		// pop smac 
		repeat (6) begin 
			tr.smac[7:0] = data_q.pop_front();
			tr.smac <<= 8;
		end 
		
		
		// pop ether_type
		repeat (2) begin 
			tr.ether_type[7:0] = data_q.pop_front();
			tr.ether_type <<=  8;
		end 
		
		// pop pload 
		for (int i = tr.pload.size() - 1; i >= 0; i--) begin 
			tr.pload[i] = data_q.pop_front();
		end 
		
		// pop crc
		repeat (4) begin 
			tr.crc [7:0] = data_q.pop_front();
			tr.crc <<= 8;
		end 
		
		`uvm_info(get_full_name(), "Finish collect one pkt", UVM_LOW)
		
		tr.print();
	endtask 
	
	
	
	
	
	
	
	
	
endclass 








`endif 