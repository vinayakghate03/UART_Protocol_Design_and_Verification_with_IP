module uart_boud_rate #(parameter clk_freq = 100000000, boud_rate = 9600)
 (clk, rst_n, tx_boud_en, rx_boud_en);

	input clk, rst_n;
	output reg tx_boud_en, rx_boud_en; 

//	  we are taken teo parameter 
//      parameter clk_freq = 100000000;  // 100MHZ
//      parameter boud_rate = 9600;



    // we are crete the counter resisotr for the clount nub of clock for tx and rx
    reg [15:0] tx_count;
    reg [15:0] rx_count;

    // we are make clock based boaut rate to send data clk_per_bit;
    localparam tx_clk_per_bit = clk_freq/boud_rate;               // HOW MANY CYCLE REQ TO 1 UART TRANSMITS
    localparam rx_clk_per_bit = clk_freq/(16 * boud_rate);



  // LOGIC TO GENERATE BOUD RATE FOR TX SENDER 
  always_ff @(posedge clk or negedge rst_n) begin
  	
  	if(!rst_n) begin

  		  tx_boud_en  <= 0;
  		  tx_count    <= 0;

  	end
  	else begin
  		
    		if(tx_count == tx_clk_per_bit -1) begin
     
    			tx_boud_en   <= 1;
    			tx_count     <= 0;

    		end
    		else begin
            
    			tx_count     <= tx_count + 1;
    			tx_boud_en   <= 0;

    		end
  	end

  end


  // LOGIC TO GENERATE BOUDRATE FOR RX SENDER
  always @(posedge clk or negedge rst_n) begin
  	
    	if(!rst_n) begin
    	   
    	     rx_boud_en   <= 0;
    	     rx_count     <= 0;

    	end
    	else begin
    		
      		if(rx_count == rx_clk_per_bit -1) begin
      			
      			 rx_boud_en <= 1;
      			 rx_count   <= 0;

      		end
      		else begin
      			
      			 rx_boud_en  <= 0;
      			 rx_count    <= rx_count + 1;

      		end
    	end
      
    end

endmodule : uart_boud_rate