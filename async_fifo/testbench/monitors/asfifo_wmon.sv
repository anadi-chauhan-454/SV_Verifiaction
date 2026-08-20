class asfifo_wmon #(int DWIDTH=16);
  
  mailbox #(asfifo_tr #(DWIDTH)) mbx;
  mailbox #(int unsigned) id_mbx;
  virtual asfifo_if #(DWIDTH) vif;
  
  asfifo_cov #(DWIDTH) cov;
  
  function new(mailbox #(asfifo_tr #(DWIDTH)) mbx,
               mailbox #(int unsigned) id_mbx,
  			   virtual asfifo_if #(DWIDTH) vif);
    this.mbx = mbx;
    this.id_mbx = id_mbx;
    this.vif = vif;
    
    cov = new();
  endfunction
  
  task run();
    asfifo_tr #(DWIDTH) tr;
    int unsigned txn_id;
    
    forever begin
      @(vif.wmon_cb);
      if (vif.wmon_cb.wen && !vif.wmon_cb.full) begin   
        id_mbx.get(txn_id);

        tr = new();
        tr.txn_id  = txn_id;
        tr.wen = vif.wmon_cb.wen;
        tr.data_in = vif.wmon_cb.data_in;
        tr.full = vif.wmon_cb.full;
        
        tr.display("WMON");
        mbx.put(tr.copy());
        cov.write(tr);
      end
    end
  endtask
endclass
      
