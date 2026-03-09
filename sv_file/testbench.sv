`timescale 1ns / 1ps

module testbench;

	// there wea re take some input to drivve by testbenh to then sv

	parameter clk_freq = 100000000, boud_rate = 115200;    // Frq = 100MHZ, BR = 115200

	logic clk, rst_n;

	// we are instance of the interface and clasee

	uart_intf intf(.clk(clk));

	test tst(intf);

	// we are instance of desing here

	uart_top #(.clk_freq(clk_freq), .boud_rate(boud_rate))

			          dut_sv(
		    .clk(clk),
		    .rst_n(intf.rst_n),

		    .tran_bit(intf.tran_bit),
		    .tx_data(intf.tx_data),

		    .parity_type(intf.parity_type),
		    .parity_enb(intf.parity_enb),

		    .tx_serial(intf.tx_serial),
		    .tx_rx_busy(intf.tx_rx_busy),

		    .rx_data_out(intf.rx_data_out),
		    .rx_busy(intf.rx_busy),
		    .parity_err(intf.parity_err),
		    .framing_err(intf.framing_err),
		    .data_valid(intf.data_valid)
		);

	     initial begin

	     	clk = 0; rst_n = 0;
	     	#100;

	     	rst_n = 1;
           


           #1000000; $stop;

	     end


	   always #5 clk = ~clk;

	   assign intf.rst_n = rst_n;

endmodule : testbench