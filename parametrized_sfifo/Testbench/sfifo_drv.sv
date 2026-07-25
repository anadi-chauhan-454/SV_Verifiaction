class sfifo_drv#(
  parameter int DWIDTH = 8
);
  
  mailbox #(sfifo_tr #(DWIDTH)) mbx;
  virtual sfifo_if #(DWIDTH) vif;
  
  function new(
    mailbox #(sfifo_tr #(DWIDTH)) mbx,
  	virtual sfifo_if #(DWIDTH) vif
  );
    this.mbx = mbx;
    this.vif = vif;
  endfunction
  
  task reset();
    wait(!vif.rst_n);
     vif.sfifo_cb.wen <= 0;
     vif.sfifo_cb.ren <= 0;
     vif.sfifo_cb.data_in <= '0;
    wait(vif.rst_n);
  endtask
  
  task drive(sfifo_tr #(DWIDTH) tr);
    vif.sfifo_cb.wen <= tr.wen;
    vif.sfifo_cb.ren <= tr.ren;
    vif.sfifo_cb.data_in <= tr.data_in;

    @(vif.sfifo_cb);
    vif.sfifo_cb.wen <= 0;
    vif.sfifo_cb.ren <= 0;
  endtask
  
  task run();
    sfifo_tr #(DWIDTH) tr;
    reset();
    forever
      begin
        mbx.get(tr);
	@(vif.sfifo_cb);
        tr.display("DRV");
        drive(tr);
      end
  endtask
endclass
    
    
