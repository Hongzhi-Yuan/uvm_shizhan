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
		my_transaction  tr;
		phase.phase_done.set_drain_time(this, 200ns);
		phase.raise_objection(this);
	
		`uvm_info(get_full_name(), "main_phase called begin", UVM_LOW)
		
		
		vif.valid <= 'b0;
		vif.data <= 'b0;
		
		@(negedge  vif.reset);
		
		repeat(2) begin 
			tr = new("tr");
			assert(tr.randomize() with {pload.size() == 200;}) ;
			drive_one_pkt(tr);
		end 
	
		
		`uvm_info(get_full_name(), "main_phase called end", UVM_LOW)
		phase.drop_objection(this);
	endtask 
	
	
	virtual task drive_one_pkt(my_transaction tr);
		bit [47:0] data_temp;
		bit [7:0] data_q[$];
		
		// push dmac
		data_temp = tr.dmac;
		for(int i = 0; i < 6; i++)begin 
			data_q.push_back(data_temp[47:40]);
			data_temp = data_temp << 8;
		end 
		
		
		//push smac
		data_temp = tr.smac;
		for(int i = 0; i < 6; i++)begin 
			data_q.push_back(data_temp[47:40]);
			data_temp = data_temp << 8;
		end 
		
		
		//push type
		data_temp = tr.ether_type;
		for(int i = 0; i < 2; i++)begin 
			data_q.push_back(data_temp[15:8]);
			data_temp = data_temp << 8;
		end 
		
		
		//push pload
		for (int i = tr.pload.size() - 1; i > 0; i--)  begin 
			data_q.push_back(tr.pload[i]);
		end 
		
		
		//push crc
		data_temp = tr.crc;
		for (int i = 0; i < 4; i++) begin 
			data_q.push_back(data_temp[31:24]);
			data_temp = data_temp << 8;
		end 
		
		
		// pop data to BUS
		for (int i = 0; i < data_q.size(); i++) begin 
			@(posedge  vif.clock);
			vif.valid <= 'b1;
			vif.data <= data_q.pop_front();
		end 
		
		@(posedge  vif.clock);
		vif.valid <= 'b0;
		vif.data <= 'b0;
		
	endtask
	
	
	
	
endclass 



`endif