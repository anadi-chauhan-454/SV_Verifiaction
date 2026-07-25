class sfifo_gen#(
  parameter int DWIDTH = 8
);
  
  sfifo_tr #(DWIDTH) tr;
  mailbox #(sfifo_tr #(DWIDTH)) drv_mbx;
  mailbox #(sfifo_tr #(DWIDTH)) rm_mbx;
  
  int count;
  event done;
  
  function new(mailbox #(sfifo_tr #(DWIDTH)) drv_mbx,
               mailbox #(sfifo_tr #(DWIDTH)) rm_mbx,
               int count = 100);
    this.drv_mbx = drv_mbx;
    this.rm_mbx = rm_mbx;
    this.count = count;
  endfunction
  
  task run();
        int i;
    	for(i = 0; i < count; i++) begin
        tr = new();
	tr.wen     = $urandom_range(0, 1);
        tr.ren     = $urandom_range(0, 1);
        tr.data_in = $urandom_range(0, (2**DWIDTH)-1);
   /*repeat(count)
      begin
        tr = new();
        assert(tr.randomize())
          else
            $fatal("[GEN] Randomization failed for Transaction %0d", tr.txn_id);*/
        drv_mbx.put(tr.copy());
        rm_mbx.put(tr.copy());
        tr.display("GEN");
      end
    ->done;
  endtask
endclass
