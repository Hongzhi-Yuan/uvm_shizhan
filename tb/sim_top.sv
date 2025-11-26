`timescale 1ns/1ps

import uvm_pkg::*;

`include "my_driver.sv"



 module  sim_top;
	 
	reg clock;
	reg reset;
	reg [7:0] rxd;
	reg rx_dv;
	wire [7:0] txd;
	wire tx_en;

	design_top u_design_top (
		.clock(clock),
		.reset(reset),
		.rx_dv(rx_dv),
		.rxd  (rxd),
		.tx_en(tx_en),
		.txd  (txd)
		); 
	
	
	 
	my_driver drv;
	
	initial begin
		drv = new("drv", null);
		drv.main_phase(null);
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
		
		#4000ns;
		$finish();
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