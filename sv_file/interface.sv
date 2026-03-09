interface uart_intf(input logic  clk);

	  // tx input signals
		logic tran_bit;
		logic [7:0] tx_data;
		logic rst_n;

	  // tx rx control singles
		logic parity_type;
		logic parity_enb;
		
      // tx output singnels
		logic tx_serial;
		logic tx_rx_busy;

	  // rx ouptut singles
		logic [7:0] rx_data_out;
		logic rx_busy;
		logic parity_err;
		logic framing_err;
		logic data_valid;


		// we are doing the clocking block for RX and TX singles


    // ITS IS FOR TX DRIVE AND MONITOR BLOCKS
clocking cb_drv_tx @(posedge clk);

		 default input #1step output #0;

		 input rst_n;

		 output parity_type;
		 output parity_enb;
		 output tran_bit;
		 output tx_data;

		endclocking

		clocking cb_mon_tx @(posedge clk);

		 default input #1step output #1step;         

		 input parity_type;
		 input parity_enb;
		 input tran_bit;
		 input tx_data;

		endclocking



    //  THIS IS FOR RX DRIVER AND MONITOR SIGNLAS

		clocking cb_drv_rx @(posedge clk);

			default input #1step output #1step;

			// this two input are control to generated start and wait
			input rst_n;
			
			output parity_type;
			output parity_enb;
			output tran_bit;

			input data_valid;
			

		endclocking


			clocking cb_mon_rx @(posedge clk);

			 default input #1step output #1step;

			 input rx_data_out;
			 input rx_busy;
			 input parity_err;
			 input framing_err;
			 input data_valid;

			endclocking

 
   // this modport is used in monitor and drive class

		modport mp_drv_tx( clocking  cb_drv_tx);
		modport mp_mon_tx( clocking  cb_mon_tx);


 //  this modport are used in monitor and driver class
		modport mp_drv_rx( clocking cb_drv_rx);
		modport mp_mon_rx( clocking cb_mon_rx);

	
endinterface : uart_intf