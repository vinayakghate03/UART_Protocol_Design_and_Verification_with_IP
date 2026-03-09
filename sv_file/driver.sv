import file_pkg::*;


class driver;

	// there we are drive all siglen with interface

	virtual uart_intf.mp_drv_tx  intf_tx;
	virtual uart_intf.mp_drv_rx  intf_rx;

    

	// we take one mailbox that can exprot generate singles
	mailbox uart_gen2drv;

	// we are create contructor it call at creaet if the objec of the class

	function new( virtual uart_intf.mp_drv_tx intf_tx, virtual uart_intf.mp_drv_rx intf_rx, mailbox uart_gen2drv);

			this.intf_rx = intf_rx;
			this.intf_tx = intf_tx;
			this.uart_gen2drv = uart_gen2drv;

	endfunction : new


	task drv_task();

      // we are creaet the asse all single which is puted in mailbox
       
       transaction trans;

	      repeat(5) begin
	      	
	      	uart_gen2drv.get(trans); // all mailbox signals here

	       // drvie single based on clock

	       @(intf_tx.cb_drv_tx);

	       // control singles of the tx
	        intf_tx.cb_drv_tx.tran_bit     <= trans.tran_bit;
	        intf_tx.cb_drv_tx.parity_type  <= trans.parity_type;
	        intf_tx.cb_drv_tx.parity_enb   <=  trans.parity_enb;
	        intf_tx.cb_drv_tx.tx_data      <= trans.tx_data;

	        
	        @(intf_rx.cb_drv_rx);

	        // drive the coontrol single of the rx
	        intf_rx.cb_drv_rx.parity_enb  <= trans.parity_enb;
	        intf_rx.cb_drv_rx.parity_type <= trans.parity_type;
	        intf_rx.cb_drv_rx.tran_bit    <= trans.tran_bit;

	        // trans.display("Drivers class executed"); 

	      end

	endtask : drv_task
	
endclass : driver