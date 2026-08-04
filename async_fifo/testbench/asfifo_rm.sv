class asfifo_rm #(
  int DWIDTH=8,
  int DEPTH=8
);
  
  mailbox #(asfifo_tr #(DWIDTH)) in_mbx;
  mailbox #(asfifo_tr #(DWIDTH)) out_mbx;
  virtual asfifo_if #(DWIDTH) vif;
  
  
  bit [DWIDTH-1:0] queue[$];
  
  function new(mailbox #(asfifo_tr #(DWIDTH)) in_mbx,
               mailbox #(asfifo_tr #(DWIDTH)) out_mbx,
               virtual asfifo_if #(DWIDTH) vif);
    this.in_mbx = in_mbx;
    this.out_mbx = out_mbx;
    this.vif = vif;
  endfunction
  
  task run();
    asfifo_tr #(DWIDTH) tr;
    asfifo_tr #(DWIDTH) exp_tr;
    
    forever begin
      
      in_mbx.get(tr);
      exp_tr = tr.copy();
      
      if(!vif.wrst_n || !vif.rrst_n) queue.delete();
      
      if(tr.wen && !tr.full)
        queue.push_back(tr.data_in);
      if(tr.ren && !tr.empty)
        exp_tr.data_out = queue.pop_front();
      
      exp_tr.full = (queue.size() == DEPTH);
      exp_tr.empty = (queue.size() == 0);
      
      exp_tr.display("RM");
      out_mbx.put(exp_tr);
    end
  endtask
endclass
      
      
    
  
  
