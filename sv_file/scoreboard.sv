import file_pkg::*;

class scoreboard;

	// we are compare with out desired output 

	// we are not taken there virtual interface here interface 

	mailbox uart_mon2scb;

	function  new( mailbox uart_mon2scb );

		  this.uart_mon2scb = uart_mon2scb;
		
	endfunction : new


	task scb_task();

		transaction trans;

      forever begin

         uart_mon2scb.get(trans);

         
        if(trans.data_valid) begin
        	    
        	    $display("Trasaction is Complited");

        	    if(trans.tx_data == trans.rx_data_out)begin
        	    	
        	    $display("Tx = %d, Rx = %d", trans.tx_data, trans.rx_data_out);

        	 end

        end
         
      end
		
	endtask : scb_task

endclass : scoreboard
