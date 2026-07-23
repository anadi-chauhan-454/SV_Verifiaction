class alu_scb #(parameter int WIDTH = 4);
  
  mailbox #(alu_tr #(WIDTH)) exp_mbx;
  mailbox #(alu_tr #(WIDTH)) act_mbx;
  
  int unsigned pass;
  int unsigned fail;
  
  function new(
    mailbox #(alu_tr #(WIDTH)) exp_mbx,
    mailbox #(alu_tr #(WIDTH)) act_mbx);
    
    this.exp_mbx = exp_mbx;
    this.act_mbx = act_mbx;
    
    this.pass = 0;
    this.fail = 0;
  endfunction
  
  task run();
    alu_tr #(WIDTH) exp_tr;
    alu_tr #(WIDTH) act_tr;
    forever
      begin
        exp_mbx.get(exp_tr);
        act_mbx.get(act_tr);
        if(exp_tr.compare(act_tr))
           begin
             pass++;
             act_tr.display("PASS_SCB");
           end
           else
             begin
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
