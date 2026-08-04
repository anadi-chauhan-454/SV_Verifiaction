class asfifo_wmon #(int DWIDTH=8);
  
  mailbox #(asfifo_tr #(DWIDTH)) mbx;
  virtual asfifo_if #(DWIDTH) vif;
  
  asfifo_cov #(DWIDTH) cov;
  
  function new(mailbox #(asfifo_tr #(DWIDTH)) mbx,
  			   virtual asfifo_if #(DWIDTH) vif);
    this.mbx = mbx;
    this.vif = vif;
    
    cov = new();
  endfunction
  
  task run();
    asfifo_tr #(DWIDTH) tr;
    
    forever begin
      @(vif.wmon_cb);
      tr = new();
      tr.wen = vif.wmon_cb.wen;
      tr.data_in = vif.wmon_cb.data_in;
      tr.full = vif.wmon_cb.full;
        
      tr.display("WMON");
      mbx.put(tr.copy());
      cov.write(tr);
    end
  endtask
endclass
      
