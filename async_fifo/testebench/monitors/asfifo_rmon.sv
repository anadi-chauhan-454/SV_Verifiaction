class asfifo_rmon #(int DWIDTH=8);
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
      @(vif.rmon_cb);
      tr= new();
      
      tr.ren =  vif.rmon_cb.ren;
      tr.data_out = vif.rmon_cb.data_out;
      tr.empty = vif.rmon_cb.empty;
      
      tr.display("RMON");
      mbx.put(tr.copy());
      cov.write(tr);
    end
  endtask
endclass
      
      
