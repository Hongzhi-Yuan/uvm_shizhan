`ifndef MY_MONITOR__SV
`define MY_MONITOR__SV


class my_monitor extends uvm_monitor;
	
	virtual my_if vif;
	uvm_analysis_port#(my_transaction) ap;
	
	`uvm_component_utils(my_monitor)
	
	function new (string name = "my_monitor", uvm_component parent = null );
		super.new(name, parent);
	endfunction 
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
			
		ap = new("ap", this);
		if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
			`uvm_fatal(get_full_name(), "virtual interface must be set!!!!!!!!!!!!!")
		
	endfunction 
	
	
	virtual task main_phase(uvm_phase phase);
		my_transaction tr;
		forever begin 
			tr = new("tr");
			assert(tr.randomize with {tr.pload.size() == 50;});
			collect_one_pkt(tr);
//			tr.print();
			ap.write(tr);
		end 
	endtask 
	
	
	virtual task collect_one_pkt(my_transaction tr);
		bit [7:0] data_q[$];
		int psize;
		
		
		while (1) begin 
			@(posedge vif.clock);
			if (vif.valid) break; 
		end 
			
		`uvm_info(get_full_name(), "Begin collect one pkt", UVM_LOW)
		
		while(vif.valid) begin 
			data_q.push_back(vif.data);
			@(posedge vif.clock);
		end 
		
		// pop dmac 
		for (int i = 0; i < 6; i++) begin 
			tr.dmac = {tr.dmac[39:0], data_q.pop_front()};
		end 
		
		// pop smac
		for (int i = 0; i < 6; i++) begin 
			tr.smac = {tr.smac[39:0], data_q.pop_front()};
		end
		
		// pop eth_type
		for (int i = 0; i < 2; i++) begin 
			tr.ether_type = {tr.ether_type[7:0], data_q.pop_front()};
		end
		
		// pop pload 
		for (int i = 0; i < tr.pload.size(); i++) begin 
			tr.pload[i] = data_q.pop_front();
		end 
		
		// pop crc 
		for (int i = 0; i < 4; i++) begin 
			tr.crc = {tr.crc[23:0], data_q.pop_front()};
		end 
		
		

		`uvm_info(get_full_name(), "END collect one pkt", UVM_LOW)

	endtask 
	
	
	
	
	
	
	
	
	
endclass 








`endif 