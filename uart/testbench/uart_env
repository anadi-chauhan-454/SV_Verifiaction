class uart_env #(int WIDTH=8);
  
  uart_gen #(WIDTH) gen;
  uart_drv #(WIDTH) drv;
  uart_mon #(WIDTH) mon;
  uart_rm  #(WIDTH) rm;
  uart_scb #(WIDTH) scb;
  
  mailbox #(uart_tr #(WIDTH)) gen_drv;
  mailbox #(uart_tr #(WIDTH)) gen_rm;
  mailbox #(uart_tr #(WIDTH)) mon_scb;
  mailbox #(uart_tr #(WIDTH)) rm_scb;
  
  virtual uart_if #(WIDTH) vif;
  
  function new(virtual uart_if #(WIDTH) vif);
    this.vif = vif;
  endfunction
  
   
  task build();
    gen_drv = new();
    gen_rm  = new();
    mon_scb = new();
    rm_scb  = new();
    
    gen = new(gen_drv, gen_rm);
    drv = new(gen_drv, vif);
    mon = new(mon_scb, vif);
    rm  = new(gen_rm, rm_scb);
    scb = new(mon_scb, rm_scb);
  endtask
  
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      rm.run();
      scb.run();
    join_none
    @(gen.done);
    #20ms;
    scb.report();
    $finish;
  endtask
endclass
  
