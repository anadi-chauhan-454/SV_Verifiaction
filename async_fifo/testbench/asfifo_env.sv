class asfifo_env #(
  int DWIDTH=16,
  int DEPTH =16
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
  
  mailbox #(asfifo_tr #(DWIDTH)) wdrv2rm;
  mailbox #(asfifo_tr #(DWIDTH)) rdrv2rm;
  
  mailbox #(asfifo_tr #(DWIDTH)) wmon2scb;
  mailbox #(asfifo_tr #(DWIDTH)) rmon2scb;
  
  mailbox #(asfifo_tr #(DWIDTH)) rmw2scb;
  mailbox #(asfifo_tr #(DWIDTH)) rmr2scb;
  
  mailbox #(int unsigned) w_id_mbx;
  mailbox #(int unsigned) r_id_mbx;
  
  virtual asfifo_if #(DWIDTH) vif;
  
  function new(virtual asfifo_if #(DWIDTH) vif);
    this.vif = vif;
  endfunction
  
  task build();
    gen2wdrv = new();
    gen2rdrv = new();
    
    wdrv2rm  = new();
    rdrv2rm  = new();
    
    wmon2scb = new();
    rmon2scb = new();
    
    rmw2scb  = new();
    rmr2scb  = new();
    
    w_id_mbx = new();
    r_id_mbx = new();
    
    gen = new(gen2wdrv, gen2rdrv);
    
    wdrv = new(gen2wdrv, wdrv2rm, w_id_mbx, vif);
    rdrv = new(gen2rdrv, rdrv2rm, r_id_mbx, vif);
    
    wmon = new(wmon2scb, w_id_mbx, vif);
    rmon = new(rmon2scb, r_id_mbx, vif);
    
    rm = new(wdrv2rm, rdrv2rm, rmr2scb, rmw2scb, vif);
    
    scb = new(wmon2scb, rmon2scb, rmw2scb, rmr2scb);
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
    #5000;
    scb.report();
    $finish;
  endtask
endclass
    
    
    
