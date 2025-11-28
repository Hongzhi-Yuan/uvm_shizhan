`ifndef MY_SEQUENCE__SV
`define MY_SEQUENCE__SV

class my_sequence extends uvm_sequence#(my_transaction);
  `uvm_object_utils(my_sequence)

  function new(string name="my_sequence");
    super.new(name);
  endfunction

//	virtual task pre_body();
//	  `uvm_info("SEQ", "pre_body entered", UVM_LOW)
//	  `uvm_info("SEQ",
//  $sformatf("starting_phase=%s",
//    (starting_phase==null) ? "NULL" : starting_phase.get_name()),
//  UVM_LOW)
//	  if (starting_phase != null)
//	    starting_phase.raise_objection(this);
//	endtask
	
  virtual task body();
	`uvm_info("SEQ", "body entered", UVM_LOW)
    repeat(3) begin
      my_transaction tr;
      `uvm_do(tr)
    end

//	  my_transaction req = my_transaction::type_id::create("req");
//	  start_item(req);
//	  assert(req.randomize());
//	  finish_item(req);


//    #1000;
  endtask

//  virtual task post_body();
//    if (starting_phase != null)
//      starting_phase.drop_objection(this);
//  endtask
//endclass


`endif 