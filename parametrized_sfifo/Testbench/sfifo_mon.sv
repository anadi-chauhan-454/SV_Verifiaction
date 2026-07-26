class sfifo_mon#(
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
  
  task run();
    sfifo_tr #(DWIDTH) tr;
    forever 
      begin
        @(vif.sfifo_mon_cb);


	if (vif.sfifo_mon_cb.wen === 1'b1 || vif.sfifo_mon_cb.ren === 1'b1) begin
	         tr = new();
        
         tr.wen = vif.sfifo_mon_cb.wen;
         tr.ren = vif.sfifo_mon_cb.ren;
         tr.data_in = vif.sfifo_mon_cb.data_in;
         tr.data_out = vif.sfifo_mon_cb.data_out;
         tr.flags = vif.sfifo_mon_cb.flags;
        
         tr.display("MON");
         mbx.put(tr.copy());
      end
end
  endtask
endclass
        
