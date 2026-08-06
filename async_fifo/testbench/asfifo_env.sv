class asfifo_env #(
  int DWIDTH=8,
  int DEPTH =8
);
  
  asfifo_gen #(DWIDTH) gen; 
  
  asfifo_wdrv #(DWIDTH) wdrv;
  asfifo_rdrv #(DWIDTH) rdrv;
  
  asfifo_wmon #(DWIDTH) wmon;
  asfifo_rmon #(DWIDTH) rmon;
  
  asfifo_rm #(DWIDTH, DEPTH) rm;
  asfifo_scb #(DWIDTH) scb;
  
  mailbox #(asfifo_tr #(DWIDTH)) gen2wdrv;
  mailbox #(asfifo_tr #(DWIDTH)) gen2rdrv;
  mailbox #(asfifo_tr #(DWIDTH)) gen2rm;
  mailbox #(asfifo_tr #(DWIDTH)) wmon2scb;
  mailbox #(asfifo_tr #(DWIDTH)) rmon2scb;
  mailbox #(asfifo_tr #(DWIDTH)) rm2scb;
  
  virtual asfifo_if #(DWIDTH) vif;
  
  function new(virtual asfifo_if #(DWIDTH) vif);
    this.vif = vif;
  endfunction
  
  task build();
    gen2wdrv = new();
    gen2rdrv = new();;
    gen2rm = new();;
    wmon2scb = new();
    rmon2scb = new();
    rm2scb = new();
    
    gen = new(gen2wdrv, gen2rdrv, gen2rm);
    wdrv = new(gen2wdrv, vif);
    rdrv = new(gen2rdrv, vif);
    wmon = new(wmon2scb, vif);
    rmon = new(rmon2scb, vif);
    rm = new(gen2rm, rm2scb, vif);
    scb = new(wmon2scb, rmon2scb, rm2scb);
  endtask
  
  task run();
    fork
      gen.run();
      wdrv.run();
      rdrv.run();
      wmon.run();
      rmon.run();
      rm.run();
      scb.run();
    join_none
    @(gen.done);
    #500;
    scb.report();
    $finish;
  endtask
endclass
    
    
    
