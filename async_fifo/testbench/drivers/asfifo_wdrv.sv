class asfifo_wdrv #(int DWIDTH=16);
  
  mailbox #(asfifo_tr #(DWIDTH)) mbx;
  mailbox #(asfifo_tr #(DWIDTH)) wrm_mbx;
   mailbox #(int unsigned) w_id_mbx;
  
  virtual asfifo_if #(DWIDTH) vif;
  
  function new(mailbox #(asfifo_tr #(DWIDTH)) mbx,
               mailbox #(asfifo_tr #(DWIDTH)) wrm_mbx,
               mailbox #(int unsigned) w_id_mbx,
  			   virtual asfifo_if #(DWIDTH) vif);
    this.mbx = mbx;
    this.wrm_mbx = wrm_mbx;
    this.w_id_mbx = w_id_mbx;
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
    
    tr.full = vif.wdrv_cb.full;

    if (tr.full)
        tr.wen = 0;
    
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
      @(vif.wdrv_cb);
      if (tr.wen) begin
        wrm_mbx.put(tr.copy());
        w_id_mbx.put(tr.txn_id);
      end
    end
  endtask
endclass
