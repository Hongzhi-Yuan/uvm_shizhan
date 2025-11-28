`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV



class my_driver extends uvm_driver#(my_transaction);
	
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
//		my_transaction  tr;
//		phase.phase_done.set_drain_time(this, 200ns);
//		phase.raise_objection(this);
	
		`uvm_info(get_full_name(), "main_phase called begin", UVM_LOW)
		
		
		vif.valid <= 'b0;
		vif.data <= 'b0;
		
		@(negedge  vif.reset);
		
//		repeat(2) begin 
////			tr = new("tr");
//			
//			req = new("req");
//			assert(req.randomize() with {req.pload.size() == 50;}) ;
//			drive_one_pkt(req);
//			repeat (10) @(posedge vif.clock);
//				
//		end 

		while (1) begin 
			seq_item_port.get_next_item(req);
			drive_one_pkt(req);
			seq_item_port.item_done();
		end 


		
		`uvm_info(get_full_name(), "main_phase called end", UVM_LOW)
//		phase.drop_objection(this);
	endtask 
	
	
	virtual task drive_one_pkt(my_transaction tr);

		bit [7:0]  data_q []	;
		int psize;
		
		psize = tr.pack_bytes(data_q)/8;
		
		
		// push BUS 
//		for (int i = 0; i < data_q.size(); i++) begin 
//			@(posedge vif.clock);
//			vif.valid <=  'b1;
//			vif.data <= data_q.pop_front();
//		end 
		
		for (int i = 0; i < psize; i++) begin 
			@(posedge vif.clock);
			vif.valid <= 'b1;
			vif.data <= data_q[i];
		end 
		
		
		@(posedge vif.clock);
		vif.valid <= 'b0;
		vif.data  <= 'b0;
	
	endtask
	
	
	
	
endclass 



`endif