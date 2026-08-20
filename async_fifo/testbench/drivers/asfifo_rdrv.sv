class asfifo_rdrv #(int DWIDTH = 16);
  
  mailbox #(asfifo_tr #(DWIDTH)) mbx;
  mailbox #(asfifo_tr #(DWIDTH)) rrm_mbx;
  mailbox #(int unsigned) r_id_mbx;
  
  virtual asfifo_if #(DWIDTH) vif;
  
  function new(mailbox #(asfifo_tr #(DWIDTH)) mbx,
               mailbox #(asfifo_tr #(DWIDTH)) rrm_mbx,
               mailbox #(int unsigned) r_id_mbx,
  			   virtual asfifo_if #(DWIDTH) vif);
    this.mbx = mbx;
    this.rrm_mbx = rrm_mbx;
    this.r_id_mbx = r_id_mbx;
    this.vif = vif;
  endfunction
  
  task reset();
    wait(!vif.rrst_n);
    
    vif.rdrv_cb.ren <= 0;
    
    wait(vif.rrst_n);
    @(vif.rdrv_cb);
  endtask
  
task drive(asfifo_tr #(DWIDTH) tr);

    @(vif.rdrv_cb);
    tr.empty = vif.rdrv_cb.empty;

    if (tr.empty)
        tr.ren = 0;
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
      tr.display("AFTER RDRV");
      if (tr.ren) begin
        rrm_mbx.put(tr.copy());
        r_id_mbx.put(tr.txn_id);
      end
    end
  endtask
endclass
