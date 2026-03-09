class transaction ;

 
    // tx singles genrator here
    randc logic [7:0] tx_data;
	  rand logic parity_type;         
	  rand logic parity_enb;
	  rand logic tran_bit;
	

	  // output port logic rx
	  logic [7:0] rx_data_out;          
	  logic parity_err;
	  logic framing_err;
	  logic data_valid;
	  logic rx_busy;


	  // we are writting here defualt display contructor 

				function void display(string name);

				   $display("---------------- %s ----------------", name);

				   $display("tx_data      = %0h", tx_data);
				   $display("parity_type  = %0b", parity_type);
				   $display("parity_enb   = %0b", parity_enb);
				   $display("tran_bit     = %0b", tran_bit);

				   $display("rx_data_out  = %0h", rx_data_out);
				   $display("parity_err   = %0b", parity_err);
				   $display("framing_err  = %0b", framing_err);
				   $display("data_valid   = %0b", data_valid);
				   $display("rx_busy      = %0b", rx_busy);

				endfunction

	
endclass : transaction