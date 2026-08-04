class asfifo_wdrv #(int DWIDTH=8);
  
  mailbox #(asfifo_tr #(DWIDTH)) mbx;
  
  virtual asfifo_if #(DWIDTH) vif;
  
  function new(mailbox #(asfifo_tr #(DWIDTH)) mbx,
  			   virtual asfifo_if #(DWIDTH) vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction
  
  task reset();
    wait(!vif.wrst_n);
    
    vif.wdrv_cb.wen <= 0;
    vif.wdrv_cb.data_in <= '0;
    
    wait(vif.wrst_n);
    @(vif.wdrv_cb);
  endtask
  
  task drive(asfifo_tr #(DWIDTH) tr);
    @(vif.wdrv_cb);
    
    vif.wdrv_cb.wen <= tr.wen;
    
    if(tr.wen)
      vif.wdrv_cb.data_in <= tr.data_in;
    
    @(vif.wdrv_cb);
    vif.wdrv_cb.wen <= 0;
  endtask
  
  task run();
    asfifo_tr #(DWIDTH) tr;
    
    reset();
    forever begin
      mbx.get(tr);
      tr.display("WDRV");
      drive(tr);
    end
  endtask
endclass
