class alu_env #(parameter int WIDTH = 4);
  
  alu_gen gen;
  alu_drv drv;
  alu_mon mon;
  alu_rm rm;
  alu_scb scb;
  
  mailbox #(alu_tr #(WIDTH)) gen2drv_mbx;
  mailbox #(alu_tr #(WIDTH)) gen2rm_mbx;
  mailbox #(alu_tr #(WIDTH)) mon2scb_mbx;
  mailbox #(alu_tr #(WIDTH)) rm2scb_mbx;
            
  virtual alu_if #(WIDTH)  vif;
  
            function new(virtual alu_if #(WIDTH)  vif);
    this.vif = vif;
  endfunction
            
  task build();
    
    gen2drv_mbx = new();
    gen2rm_mbx = new();
    mon2scb_mbx = new();
    rm2scb_mbx = new();
    
    gen = new(gen2drv_mbx,
	      gen2rm_mbx);
    drv = new(gen2drv_mbx,
              vif);
    mon = new(mon2scb_mbx,
              vif);
    rm = new(gen2rm_mbx,
             rm2scb_mbx);
    scb = new(mon2scb_mbx,
              rm2scb_mbx);
    
  endtask
            
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      rm.run();
      scb.run();
    join_any
    #250;
    scb.report();
    $finish;
  endtask
endclass
    
              
