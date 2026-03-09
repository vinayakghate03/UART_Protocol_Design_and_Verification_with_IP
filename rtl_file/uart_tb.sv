`timescale 1ns / 1ps

module uart_tb;

     parameter clk_freq = 100000000, boud_rate = 115200;  //100000000

	  logic clk, rst_n;

   // tx rx input control singls
	  logic parity_type;         
	  logic parity_enb;

	  // tx control input 
	  logic tran_bit;
	  logic [7:0] tx_data;

      logic tx_serial;
      logic tx_rx_busy;

	  // output port logic rx
	  logic [7:0] rx_data_out;          
	  logic parity_err;
	  logic framing_err;
	  logic data_valid;
	  logic rx_busy;

     
     uart_top #(.clk_freq(clk_freq),.boud_rate(boud_rate))
                    dut (     .clk(clk),
                              .data_valid(data_valid),
                              .framing_err(framing_err),
                              .parity_enb(parity_enb),
                              .parity_err(parity_err),
                              .parity_type(parity_type),
                              .rst_n(rst_n),
                              .rx_busy(rx_busy),
                              .rx_data_out(rx_data_out),
                              .tran_bit(tran_bit),
                              .tx_data(tx_data),
                              .tx_rx_busy(tx_rx_busy),
                              .tx_serial(tx_serial)
                         );

 


	  // we are create the tb single here

	   task transaction;
    	input [7:0] din;
    	input       ptype;
         input       penb;
        
        begin
        	  

        	 @(posedge clk);
        	 tx_data = din;
        	 parity_type = ptype;
        	 parity_enb = penb;
        	 tran_bit = 1;

        	 @(posedge clk)
        	 tran_bit = 0; 


        	 wait( tx_rx_busy == 1);
        	 wait (tx_rx_busy == 0);

        	 wait(data_valid == 1);

        end
    endtask : transaction


    initial begin
    	
      clk = 0; rst_n = 0;
    	#20;
    	rst_n = 1;
    	#10;

    end

   always #5 clk = ~clk;

    initial begin
    	 

      #30;

    // $monitor("TX_DATA = %d, TX_BUSY = %b, RX_DATA = %d, RX_BUSY = %b", tx_data, tx_rx_busy, rx_data_out, rx_busy);
    
  wait(rst_n == 1);        // wait until reset released
  

  repeat(5) @(posedge clk);

  transaction(8'b1100_1011, 1'b0, 1'b0);
  transaction(8'b1010_1000, 1'b0, 1'b1);
  transaction(8'b1111_1000, 1'b0, 1'b0);
  transaction(8'b1010_1111, 1'b0, 1'b1);
  transaction(8'b0000_1111, 1'b0, 1'b0);


  #3000000;
  $stop;
    end


    // initial 
    //   $monitor(" Tx Monitor -> Tx_state = %p, tx_data = %d, tx_inter = %b tx_bit_count = %d, tx_serial = %b", 
    //                     dut.dut_tx.prese_state, dut.dut_tx.tx_data, dut.dut_tx.intrn_data, dut.dut_tx.bit_count, dut.dut_tx.tx);

      // initial
         // $monitor(" Rx Monitor -> RX_state = %p,  rx_serial = %b,  rx_inter = %b, rx_bit_count = %d, rx_data_out = %d",
                         // dut.dut_rx.present_state, dut.dut_rx.rx, dut.dut_rx.inter_data, dut.dut_rx.bit_count, dut.dut_rx.rx_data);

endmodule : uart_tb