class asfifo_rdrv #(DWIDTH = 8);
  
  mailbox #(asfifo_tr #(DWIDTH)) mbx;
  
  virtual asfifo_if #(DWIDTH) vif;
  
  function new(mailbox #(asfifo_tr #(DWIDTH)) mbx,
  			   virtual asfifo_if #(DWIDTH) vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction
  
  task reset();
    wait(!vif.rrst_n)
    
    vif.rdrv_cb.ren <= 0;
    
    wait(vif.rrst_n);
  endtask
  
  task drive(asfifo_tr #(DWIDTH) tr);
    @(vif.rdrv_cb);
    
    vif.rdrv_cb.ren <= tr.ren;
    
    @(vif.rdrv_cb);
    vif.rdrv_cb.ren <= 0;
  endtask
  
  task run();
    asfifo_tr #(DWIDTH) tr;
    
    reset();
    forever begin
      mbx.get(tr);
      tr.display("RDRV");
      drive(tr);
    end
  endtask
endclass
