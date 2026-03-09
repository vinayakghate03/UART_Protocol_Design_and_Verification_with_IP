import file_pkg::*;


class monitor;

	// this is the monitor class that observe the dut out singles here

	// we are create the interface of the rx and tx

	virtual uart_intf.mp_mon_tx intf_tx;
	virtual uart_intf.mp_mon_rx intf_rx;

	// we are take one more mailbox that can put simple singles form dut and send to scoreboard for desired output 

	mailbox uart_mon2scb;


	function new( virtual uart_intf.mp_mon_tx intf_tx, virtual uart_intf.mp_mon_rx intf_rx, mailbox uart_mon2scb);

				this.intf_tx = intf_tx;
				this.intf_rx = intf_rx;
				this.uart_mon2scb = uart_mon2scb;

	endfunction : new


	// we are create one task for that

	task mon_task();
   

         // we are sample all single form the dut

         transaction trans;
         // scoreboard scb;

         forever begin
         	
         	trans = new();

     //     tx singles sample 
            @(intf_tx.cb_mon_tx);

              trans.parity_type  = intf_tx.cb_mon_tx.parity_type;
              trans.parity_enb   = intf_tx.cb_mon_tx.parity_enb;
              trans.tran_bit     = intf_tx.cb_mon_tx.tran_bit;
              trans.tx_data      = intf_tx.cb_mon_tx.tx_data;


     
     // //     rx signale sample
     	     @(intf_rx.cb_mon_rx);

     	       trans.rx_data_out  = intf_rx.cb_mon_rx.rx_data_out;
     	       trans.parity_err   = intf_rx.cb_mon_rx.parity_err;
     	       trans.framing_err  = intf_rx.cb_mon_rx.framing_err;
     	       trans.data_valid   = intf_rx.cb_mon_rx.data_valid;
     	       trans.rx_busy      = intf_rx.cb_mon_rx.rx_busy;


             // trans.display("monitor are executes");

             uart_mon2scb.put(trans);

         // end

   end

	endtask : mon_task
	
endclass : monitor