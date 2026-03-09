`timescale 1ns / 1ps

module uart_tb;

	  logic clk, rst_n;

   // tx rx input control singls
	  logic parity_type;         
	  logic parity_enb;

	  // tx control input 
	  logic tran_bit;
	  logic [7:0] data;

    logic tx_serial;
    logic tx_rx_busy;

	  // output port logic rx
	  logic [7:0] rx_data_out;          
	  logic parity_err;
	  logic framing_err;
	  logic data_valid;

     
     uart_top dut_top(.clk(clk), 
     									.rst_n(rst_n), 
     									.tran_bit(tran_bit), 
     									.parity_type(parity_type), 
     									.parity_enb(parity_enb), 
     									.tx_data(data), 
     									.rx_data_out(rx_data_out), 
     									.tx_serial(tx_serial), 
     									.tx_rx_busy(tx_rx_busy), 
     									.parity_err(parity_err), 
     									.framing_err(framing_err), 
     									.data_valid(data_valid)

     									);

 


	  // we are create the tb single here

	   task transaction;
    	input [7:0] din;
    	input       ptype;
      input       penb;
        
        begin
        	  

        	 @(posedge clk);
        	 data = din;
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
    	
      clk = 0; rst_n = 1;
    	#20;
    	rst_n = 0;
    	#10;

    end

   always #5 clk = ~clk;

    initial begin
    	 
    	  $monitor("state = %p, data = %d, tx = %b, rx_data = %d ", dut_top.dut_tx.prese_state, data, tx_serial, rx_data_out);


    	  // $monitor("clk = %b, rst = %b tx_count = %b rx_count = %b", clk, rst_n, dut_br.tx_count, dut_br.rx_count);
    	 // #20;
    	 transaction(8'b1100_1011, 1'b0, 1'b0);
    	 // tran_bit = 0;
    	 transaction(8'b1010_1000, 1'b0, 1'b1);
    	 transaction(8'b1111_1000, 1'b0, 1'b0);
    	 transaction(8'b1010_1111, 1'b0, 1'b1);
    	 transaction(8'b0000_1111, 1'b0, 1'b0);

    	 #2000000; $finish; 
    end

endmodule : uart_tb