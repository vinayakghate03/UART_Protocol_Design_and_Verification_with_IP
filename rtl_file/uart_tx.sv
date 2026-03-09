
module uart_tx(clk, rst_n, tx_data, tran_bit, tx_boud_en, parity_type, parity_enb, tx, busy);

    // we are declare input port 

    input clk, rst_n;
    input [7:0] tx_data;
    input parity_type;
    input parity_enb;
    input tran_bit;
    input tx_boud_en;

    // output port of uart
    output reg tx, busy;


    // we are create the all operation and data sending in seq with FSM order

      typedef enum logic [2:0] { IDEL = 3'b000, 
                                 START = 3'b001, 
                                 DATA = 3'b010, 
                                 PARITY = 3'b011, 
                                 STOP = 3'b100 } states;

      states  prese_state, next_state;


    // we are taken internal regisitor here
      reg [7:0] intrn_data;
      reg start_bit;
      reg stop_bit;
      reg tx_bit;
      reg parity_cal;
      reg parity_bit;

      reg [2:0] bit_count; // count send bits 
   

   // now we are writ ethe preset state logic here
   always_ff @(posedge clk or negedge rst_n) begin
    
        if(!rst_n) begin

             prese_state <= IDEL;
             // intrn_data  <= 0;
             start_bit   <= 0;
             stop_bit    <= 1;
             tx_bit      <= 1;
             // bit_count   <= 0;

        end else begin
             
             prese_state <= next_state;

        end

   end


   // next state logic here
   always_comb begin

     case (prese_state)
         
           IDEL :  begin
                
                tx         = tx_bit;
                busy       = 1'b0;
                bit_count  = 0;
                
                if(tran_bit == 1)begin
                
                    intrn_data = tx_data;
                    next_state = START;

                end
                else begin
                     
                     next_state = IDEL;

                end

            end


            START : begin
                 
                if(tx_boud_en) begin

                    tx         = start_bit;
                    busy       = 1'b1;
                    next_state = DATA;

                end
                else 

                    next_state = START;

            end


            DATA :  begin

                 if(tx_boud_en) begin

                    tx = intrn_data[bit_count];

                         if(bit_count == 7) begin
                        
                                if(parity_enb) begin

                                     next_state =  PARITY;
                                     bit_count  = 0; 

                                end
                                else begin

                                     next_state = STOP;
                                     intrn_data = 0;
                                     bit_count = 0;

                                end

                             // intrn_data = 0;

                        end
                        else begin

                            bit_count = bit_count + 1;
                            next_state = DATA;

                       end
                end
                else begin
                    
                    next_state = DATA;

                end
            end

            
            PARITY : begin

                if(tx_boud_en) begin
                    
                    parity_cal = ^intrn_data;   // checking the number of ones form the data 

                       if(parity_type == 0) begin

                            intrn_data = 0;
                            parity_bit = parity_cal;   // EVEN 
                            tx         = parity_bit;
                            next_state = STOP;
                            


                       end
                       else begin
                            
                            intrn_data = 0;
                            parity_bit = ~parity_cal;  // ODD 
                            tx         = parity_bit;
                            next_state = STOP;
                            

                       end
               end
               else 

                  next_state = PARITY;

            end

            STOP : begin
                      
                   if(tx_boud_en) begin

                         tx         = stop_bit;
                         busy       = 0;
                         next_state = IDEL;

                  end
                  else
                         next_state = STOP;

            end

        default : next_state = IDEL;

     endcase
    
   end

endmodule : uart_tx
