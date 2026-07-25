class sfifo_env#(
  parameter int DWIDTH = 8,
  parameter int DEPTH = 8
);
  
  sfifo_gen #(DWIDTH)  gen;
  sfifo_drv #(DWIDTH)  drv;
  sfifo_mon #(DWIDTH)  mon;
  sfifo_rm  #(DWIDTH, DEPTH)  rm;
  sfifo_scb #(DWIDTH)  scb;
  
  mailbox #(sfifo_tr #(DWIDTH)) gen2drv_mbx;
  mailbox #(sfifo_tr #(DWIDTH)) gen2rm_mbx;
  mailbox #(sfifo_tr #(DWIDTH)) mon2scb_mbx;
  mailbox #(sfifo_tr #(DWIDTH)) rm2scb_mbx;
  
  virtual sfifo_if #(DWIDTH) vif;
  
  function new(virtual sfifo_if #(DWIDTH) vif);
    this.vif = vif;
  endfunction
  
  task build();
    gen2drv_mbx = new();
    gen2rm_mbx  = new();
    mon2scb_mbx = new();
    rm2scb_mbx  = new();
    
    gen = new(gen2drv_mbx, gen2rm_mbx,41);
    drv = new(gen2drv_mbx, vif);
    mon = new(mon2scb_mbx, vif);
    rm  = new(gen2rm_mbx, rm2scb_mbx);
    scb = new(mon2scb_mbx, rm2scb_mbx);
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
    #250;
    scb.report();
    $finish;
  endtask
endclass
    
