`ifndef MY_SEQUENCE__SV
`define MY_SEQUENCE__SV

class my_sequence extends uvm_sequence#(my_transaction);
  `uvm_object_utils(my_sequence)

  function new(string name="my_sequence");
    super.new(name);
  endfunction

  virtual task pre_body();
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  endtask

  virtual task body();
    repeat(3) begin
      my_transaction tr;
      `uvm_do(tr)
    end

    #1000;
  endtask

  virtual task post_body();
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass


`endif 