class sfifo_scb#(
  parameter int DWIDTH = 8
);
  
  mailbox #(sfifo_tr #(DWIDTH)) act_mbx;
  mailbox #(sfifo_tr #(DWIDTH)) exp_mbx;
  
  int unsigned pass;
  int unsigned fail;
  
  function new(
    mailbox #(sfifo_tr #(DWIDTH)) act_mbx,
    mailbox #(sfifo_tr #(DWIDTH)) exp_mbx
  );
    this.act_mbx = act_mbx;
    this.exp_mbx = exp_mbx;
    this.pass = 0;
    this.fail = 0;
  endfunction
  
  task run();
    sfifo_tr #(DWIDTH) exp_tr;
    sfifo_tr #(DWIDTH) act_tr;
    forever begin
      exp_mbx.get(exp_tr);
      act_mbx.get(act_tr);
      if(exp_tr.compare(act_tr)) begin
        pass++;
        act_tr.display("PASS_SCB");
      end
      else begin
        fail++;
        act_tr.display("FAIL_SCB");
        $display("\n========== SCOREBOARD FAIL ==========");
        $display("Expected:");
        exp_tr.display("EXP");
        $display("Actual:");
        act_tr.display("ACT");
        $display("=====================================\n");
      end
    end
  endtask
  
  task report();
     $display("\n================================");
     $display(" SCOREBOARD REPORT");
     $display("================================");
     $display(" PASS : %0d", pass);
     $display(" FAIL : %0d", fail);
     $display("================================");
  endtask
endclass
