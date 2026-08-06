class asfifo_scb #(int DWIDTH = 8);
  
  mailbox #(asfifo_tr #(DWIDTH)) act_wmbx;
  mailbox #(asfifo_tr #(DWIDTH)) act_rmbx;
  mailbox #(asfifo_tr #(DWIDTH)) exp_mbx;
  
  int pass_count;
  int fail_count;

  function new(mailbox #(asfifo_tr #(DWIDTH)) act_wmbx,
               mailbox #(asfifo_tr #(DWIDTH)) act_rmbx,
               mailbox #(asfifo_tr #(DWIDTH)) exp_mbx);
    this.act_wmbx = act_wmbx;
    this.act_rmbx = act_rmbx;
    this.exp_mbx = exp_mbx;
    
    this.pass_count = 0;
    this.fail_count = 0;
  endfunction
  
  task run();
    asfifo_tr #(DWIDTH) act_wtr;
    asfifo_tr #(DWIDTH) act_rtr;
    asfifo_tr #(DWIDTH) exp_tr;
    
    forever begin
      act_wmbx.get(act_wtr);
      act_rmbx.get(act_rtr);
      exp_mbx.get(exp_tr);
      
      if(exp_tr.wcompare(act_wtr)) begin
        pass_count++;
        act_wtr.display("[PASS]_[WSCB]");
      end
      else begin
        fail_count++;
        act_wtr.display("[FAIL]_[WSCB]");
        
        $display("actual");
        act_wtr.display("ACTW");
        
        $display("expected");
        exp_tr.display("EXP");

        if(act_wtr.full != exp_tr.full)
    	  $display("FULL mismatch");
      end
      
      
      if(exp_tr.rcompare(act_rtr)) begin
        pass_count++;
        act_rtr.display("[PASS]_[RSCB]");
      end
      else begin
        fail_count++;
        act_rtr.display("[FAIL]_[RSCB]");
        
        $display("actual");
        act_rtr.display("ACTR");
        
        $display("expected");
        exp_tr.display("EXP");
        
        if(act_rtr.data_out != exp_tr.data_out)
          $display("DATA_OUT mismatch");

        if(act_rtr.empty != exp_tr.empty)
   	      $display("EMPTY mismatch");
      end
    end
  endtask
  
  task report();
    $display("SCB_REPORT");
    $display("PASS=%0d",pass_count);
    $display("FAIL=%0d",fail_count);
  endtask
endclass
      
  
  
