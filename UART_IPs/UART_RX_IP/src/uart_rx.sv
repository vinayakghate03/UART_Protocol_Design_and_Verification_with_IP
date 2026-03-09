
module uart_rx (clk, rst_n, rx_boud_en, rx, busy, parity_en, parity_type, rx_data, rx_busy, parity_err, framing_err, data_valid);

	// input port here
	input clk, rst_n;
	input rx, busy;
	input rx_boud_en;
	input parity_en;
	input parity_type;


	// output port 
	output reg [7:0] rx_data;
	output reg rx_busy;
	output reg parity_err;
	output reg framing_err;
	output reg data_valid;


	// we are delared the internal state here

	typedef enum logic [2:0] {   S_IDEL   = 3'b000, 
	                             S_START  = 3'b001,
	                             S_DATA   = 3'b010, 
	                             S_PARITY = 3'b011, 
	                             S_STOP   = 3'b100 
	            } states_t;

    states_t present_state, next_state;


	// we are taken internal control sing 
	reg [7:0]  inter_data;
	reg [0:15] sample_count;  // it count the start bit at 16 time to check for valid
	reg        start_bit;
	reg        stop_bit;
	reg        parity_bit;
	reg        parity_cal;
	reg [2:0]  bit_count;   // format of tha data is 11 bits so we take it
	reg        serial_bit;



	// we are wirte state logic 

	always @(posedge clk) begin
		
		if(rst_n)begin
			 
           present_state <= S_IDEL;
           sample_count <= 0;

		end
		else begin
			
			present_state <= next_state;


			// this logic is check the very bit for 16 time to corrction

			if(rx_boud_en) begin

				sample_count <= sample_count + 1;


				if(sample_count == 7) begin
					
					serial_bit <= rx;

				end

				if(sample_count == 15) begin

					 sample_count <= 0;

				end
			end

			if(present_state == S_STOP && parity_err == 0 && framing_err == 0) begin
				
				data_valid <= 1;

			end
			else begin
				
				data_valid <= 0;

			end


		end

	end


	always_comb begin 

		case(present_state)

			S_IDEL : begin

				  inter_data = 'bx;
				  // rx_busy = 0;
				  parity_err = 0;
				  data_valid = 0;
				  framing_err = 0;

                 if(sample_count == 7) begin

				   if(rx == 0 && busy) begin  //  its detect start bit

				   	  next_state   = S_START;
				   	  bit_count    = 0;

				   end
				   else 

				   	next_state = S_IDEL;

				end

			end

			S_START : begin

				  // we checking the start bit for 16 time for correction
                   rx_busy = 1;

				  if(rx_boud_en == 1) begin
				  	  
				  	  if(sample_count == 7) begin
				  	  	   
				  	  	   if(serial_bit == 0) begin  // we are cheking again if start bit are constat no any error there

				  	  	   	   next_state = S_START;

				  	  	   end
				  	  	   // else begin
				  	  	 
				  	  	   // 	   next_state = S_IDEL;  // it start bit change then it gose ot reset state
				  	  	   // 	   // sample_count  = 0;
				  	  	   	   
				  	  	   // end

				  	  end
				  	  else if(sample_count == 15)begin
				  	  	      
				  	  	      start_bit = serial_bit;
				  	  	      next_state = S_DATA;   // we are checked 16 time to statet bits

				  	  end

				  end
				  else begin
				  	  
				  	  next_state = S_START;

				  end
		   end

		   S_DATA : begin

                rx_busy = busy;

		   	    if(rx_boud_en == 1) begin

			   	       if(sample_count == 7) begin

			   	              inter_data[bit_count] = rx;

			   	        end
				   	    else if( sample_count == 15) begin

				   	    	 if(bit_count == 7) begin    // sample count  == 7 then bit is valid here we check middle valeus here
				   	    	 
	                                rx_data = inter_data;

					   	    	 	// we are chekcing the parity is enable to go on the parity state else gose ot stop state
					   	    	 	if(parity_en)begin
					   	    	 		
					   	    	 		next_state = S_PARITY;

					   	    	 	end
					   	    	 	else begin
					   	    	 		
					   	    	 		next_state = S_STOP;

					   	    	 	end

					   	    	 	bit_count = 0;
					   	    	 	inter_data = 'b0;
					   	    	 	next_state = S_STOP;

				   	    	 end
				   	    	 else begin 

				   	    	 	bit_count = bit_count + 1;
				   	    	 	// next_state = S_DATA;

				   	         end
				end
				else begin
			   	    	
			   	    next_state = S_DATA;

			   	end
              
              end

             end
        
		   	S_PARITY : begin


		   	   if(rx_boud_en == 1) begin

		   	   	   parity_cal = ^rx_data;
		   	   	   // inter_data = 'bx;
		   	   	
		   	   	   if(sample_count == 7)begin   // we are cheking that bit simple count

			   	   	   	// sample the parity bit here 

			   	   	   	  parity_bit = serial_bit;

			   	   	end
			   	   	else if( sample_count == 15 )begin
			   	   		

			   	   		 if(parity_type  == 0) begin // EVEN parity parity error check here
			   	   	   	  	
				   	   	   	     if(parity_bit == parity_cal)  begin

				   	   	   	     	 parity_err = 0;
				   	   	   	     	 next_state = S_STOP;

	                             end
				   	   	   	     else begin

				   	   	   	     	parity_err = 1;
				   	   	   	     	next_state = S_IDEL;

				   	   	        end

				   	   	   end
			   	   	       else begin               // ODD parity error check here
			   	   	       	 
				   	   	       	 if(parity_bit == ~parity_cal)begin

				   	   	       	 	parity_err = 0;
				   	   	       	 	next_state = S_STOP;

				   	   	       	 end
				   	   	         else begin

				   	   	         	parity_err = 1;
				   	   	         	next_state = S_IDEL;
				   	   	         end

			   	   	      end

			   	    	end
			   	   	   	  
		   	      end

		    end


         S_STOP : begin

            
                rx_busy = 0;

	         	 if(rx_boud_en == 1) begin
	         	 	
		         	 	if(sample_count == 7) begin
		         	 		
		         	 		 stop_bit = serial_bit;

		         	 	end
		         	 	else if( sample_count == 15 ) begin
		         	 		
		         	 	     framing_err = (stop_bit == 1) ? 0 : 1;
		         	 		 next_state = S_IDEL;

		         	 	end
	         	    end
	           end
     
         default : next_state = S_IDEL;
        
		endcase // present_state
		
	end
   

endmodule : uart_rx