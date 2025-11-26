`timescale 1ns/1ps

import uvm_pkg::*;

`include "my_interfaces.sv"
`include "my_driver.sv"



 module  sim_top;
	 
	reg clock;
	reg reset;
	 
	my_if input_if(clock, reset);
	my_if output_if(clock, reset);
	


	design_top u_design_top (
		.clock(clock),
		.reset(reset),
		.rx_dv(input_if.valid),
		.rxd  (input_if.data),
		.tx_en(output_if.valid),
		.txd  (output_if.data)
		); 
	
	
	 
	
	
	initial begin
		run_test("my_driver");
	end
	 
	initial begin
		uvm_config_db#(virtual  my_if)::set(null, "uvm_test_top", "vif", input_if);
	end
	 
	initial begin
		clock = 1;
		forever begin 
			#5ns;
			clock = ~clock;
		end 
	end
	
	initial begin 
		reset = 1;
		#200ns;
		reset = 0;
	end 
	
	
	string fsdb_name;
	
	initial begin
  		
	  	if ($test$plusargs("DUMP_FSDB")) begin
	    	if (!$value$plusargs("FSDB_FILE=%s", fsdb_name))
	      		fsdb_name = "wave.fsdb";
	
	    $fsdbDumpfile(fsdb_name);
	    $fsdbDumpvars(0, sim_top);   // sim_top 换成你的 tb 顶层名
	    $fsdbDumpMDA();
	    $display("[FSDB] dumping to %s", fsdb_name);
	  end
end
	
	
	
	
	
	
	
 endmodule 