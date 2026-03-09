`include "enviroment.sv"

module test(uart_intf intf);

	// we are creaete the object of the env class

	enviroment env;

	initial begin
		
			   env = new(intf.mp_drv_tx,
	                     intf.mp_mon_tx,
	                     intf.mp_drv_rx,
	                     intf.mp_mon_rx );

		      env.env_task();

	end

endmodule : test