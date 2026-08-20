class asfifo_rmon #(int DWIDTH=16);
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
     @(vif.rmon_cb);
       id_mbx.get(txn_id);
       
        tr = new();
        tr.txn_id  = txn_id;
        tr.data_out = vif.rmon_cb.data_out;
        
        tr.display("RMON");
        mbx.put(tr.copy());
        cov.write(tr);
    end
  endtask
endclass
      
      
