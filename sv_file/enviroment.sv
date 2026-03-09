import file_pkg::*;


class enviroment;

  // we are include subclases of the enviroment 

  // this is object of the all class
  transaction trans;
  generator   gen;
  driver      drv;
  monitor     mon;
  scoreboard  scb;


 
 // we are creaet teh interface for all class where we need

 virtual uart_intf.mp_drv_tx intf_drv_tx;
 virtual uart_intf.mp_mon_tx intf_mon_tx;

 virtual uart_intf.mp_drv_rx intf_drv_rx;
 virtual uart_intf.mp_mon_rx intf_mon_rx;


 // this is mailbox of the both monitor and driver there apss witn class contructor

  mailbox uart_gen2drv;
  mailbox uart_mon2scb;


 // we are creaet the contrructr of the envc

 function  new( virtual uart_intf.mp_drv_tx intf_drv_tx, virtual uart_intf.mp_mon_tx intf_mon_tx,
 	              virtual uart_intf.mp_drv_rx intf_drv_rx, virtual uart_intf.mp_mon_rx intf_mon_rx    );


 			this.intf_drv_tx = intf_drv_tx;
 			this.intf_mon_tx = intf_mon_tx;
 			this.intf_drv_rx = intf_drv_rx;
 			this.intf_mon_rx = intf_mon_rx;


 		//  we are call to mailbox contrictor 
 		uart_gen2drv = new();
 		uart_mon2scb = new();


 		//  we are call to all classe of the contructor and pass there arguments
 		gen = new(intf_drv_rx, intf_drv_tx, uart_gen2drv);
 		drv = new(intf_drv_tx, intf_drv_rx, uart_gen2drv);
 		mon = new(intf_mon_tx, intf_mon_rx, uart_mon2scb);
 		scb = new(uart_mon2scb);
 	
 endfunction : new


   task env_task();

      // we are call to all task of the envirome sub classes
        fork

           gen.gen_task();
           drv.drv_task();
           mon.mon_task();
           scb.scb_task();

        join_none
      
   endtask : env_task

	
endclass : enviroment