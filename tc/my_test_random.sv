`ifndef MY_TEST_RANDOM__SV
`define MY_TEST_RANDOM__SV


class random_class;
	rand bit  [7:0] rand_a;
	rand bit [7:0] rand_b;
	rand bit [7:0] rand_c;
	rand bit [7:0] rand_d;

//	constraint  c{
//		rand_a  < 10;
//		rand_b inside {[10:20]};
//		(rand_c == 0) -> (rand_d  == 1000);
//	}

endclass 


function automatic void  test_random();
	random_class demo0 = new;
	random_class demo1 = new;
	demo0.randomize();
	demo1.randomize() with {rand_a inside {[10:20]};};
	
	$display(demo1.rand_a);
	
endfunction 




`endif 