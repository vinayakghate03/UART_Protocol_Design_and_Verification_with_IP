import file_pkg::*;

class generator;


	// we are make virtual inteface here

	virtual uart_intf.mp_drv_tx  intf_tx;
	virtual uart_intf.mp_drv_rx  intf_rx;


	// we are  take one mail box for carry singles
	mailbox uart_gen2drv;


	// we are make contructor for this that allocate memory as we assing vlaue of the class members

	function new(virtual uart_intf.mp_drv_rx  intf_rx, virtual uart_intf.mp_drv_tx intf_tx, mailbox uart_gen2drv);

		 this.intf_tx = intf_tx;
		 this.intf_rx = intf_rx;

		 this.uart_gen2drv = uart_gen2drv;

	 endfunction : new 


	 // we are creaet the generator task to put value of the transaction

	 task gen_task();

	 	transaction trans;

            // wait until reset is released
            wait(intf_rx.cb_drv_rx.rst_n == 1 && intf_tx.cb_drv_tx.rst_n == 1);

			 	repeat(5) begin

			         trans = new();
		           

			 		trans.parity_type = $urandom_range(0,1);
			 		trans.parity_enb  = 1;
			 		trans.tran_bit    = 1;
			 		trans.tx_data = $urandom_range(20,100);
		        
			 		uart_gen2drv.put(trans);          

			 	      // trans.display("generator Executed");

			        // wait for RX data completion
		             @(posedge intf_rx.cb_drv_rx.data_valid);
		            
		            


			 	end
      
	 endtask : gen_task
	
endclass : generator