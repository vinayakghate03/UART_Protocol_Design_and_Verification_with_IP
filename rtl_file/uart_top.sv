module uart_top #(parameter clk_freq = 100000000, boud_rate = 9600)(
   
   input  logic clk,
   input  logic rst_n,

   input  logic tran_bit,
   input  logic parity_type,
   input  logic parity_enb,
   input  logic [7:0] tx_data,

   output logic tx_serial,
   output logic tx_rx_busy,

   output logic [7:0] rx_data_out,
   output logic rx_busy,
   output logic parity_err,
   output logic framing_err,
   output logic data_valid
);

   // Internal wires
   logic tx_boud_en1, rx_boud_en1;
   logic tx_rx_line;
   logic tx_busy;


   // Baud generator
   uart_boud_rate #(.clk_freq(clk_freq), .boud_rate(boud_rate))
   dut_br(
       .clk(clk),
       .rst_n(rst_n),
       .tx_boud_en(tx_boud_en1),
       .rx_boud_en(rx_boud_en1)
   );



   // UART TX
   uart_tx dut_tx(
       .clk(clk),
       .rst_n(rst_n),
       .tx_data(tx_data),
       .tran_bit(tran_bit),
       .parity_enb(parity_enb),
       .parity_type(parity_type),
       .tx(tx_rx_line),
       .busy(tx_busy),
       .tx_boud_en(tx_boud_en1)
   );



   // UART RX
   uart_rx dut_rx(
       .clk(clk),
       .rst_n(rst_n),
       .rx_boud_en(rx_boud_en1),
       .rx(tx_rx_line),        
       .busy(tx_busy),
       .parity_enb(parity_enb),
       .parity_type(parity_type),
       .rx_data(rx_data_out),
       .rx_busy(rx_busy),
       .parity_err(parity_err),
       .framing_err(framing_err),
       .data_valid(data_valid)
   );


//   // Output serial line
   assign tx_serial = tx_rx_line;
   assign tx_rx_busy = tx_busy;

endmodule