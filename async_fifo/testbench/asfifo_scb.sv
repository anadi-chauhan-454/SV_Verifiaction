class asfifo_scb #(int DWIDTH = 16);

  mailbox #(asfifo_tr #(DWIDTH)) act_wmbx;
  mailbox #(asfifo_tr #(DWIDTH)) act_rmbx;

  mailbox #(asfifo_tr #(DWIDTH)) exp_wmbx;
  mailbox #(asfifo_tr #(DWIDTH)) exp_rmbx;

  int pass_count;
  int fail_count;

  asfifo_tr #(DWIDTH) act_w[int unsigned];
  asfifo_tr #(DWIDTH) act_r[int unsigned];

  asfifo_tr #(DWIDTH) exp_w[int unsigned];
  asfifo_tr #(DWIDTH) exp_r[int unsigned];


  function new(
    mailbox #(asfifo_tr #(DWIDTH)) act_wmbx,
    mailbox #(asfifo_tr #(DWIDTH)) act_rmbx,
    mailbox #(asfifo_tr #(DWIDTH)) exp_wmbx,
    mailbox #(asfifo_tr #(DWIDTH)) exp_rmbx
  );

    this.act_wmbx = act_wmbx;
    this.act_rmbx = act_rmbx;

    this.exp_wmbx = exp_wmbx;
    this.exp_rmbx = exp_rmbx;

    pass_count = 0;
    fail_count = 0;
  endfunction

  task write_actual();
    asfifo_tr #(DWIDTH) tr;
    forever begin
      act_wmbx.get(tr);
      act_w[tr.txn_id] = tr;
      write_match();
    end
  endtask
  
  task write_expected();
    asfifo_tr #(DWIDTH) tr;
    forever begin
      exp_wmbx.get(tr);
      exp_w[tr.txn_id] = tr;
      write_match();
    end
  endtask

  task write_match();
    int unsigned id;
    asfifo_tr #(DWIDTH) act_tr;
    asfifo_tr #(DWIDTH) exp_tr;
    if (act_w.size() == 0 || exp_w.size() == 0)
      return;
    foreach (act_w[id]) begin
      if (exp_w.exists(id)) begin
        act_tr = act_w[id];
        exp_tr = exp_w[id];
        $display("[SCB] ACT W: txn_id=%0d", act_tr.txn_id);
        $display("[SCB] EXP W: txn_id=%0d", exp_tr.txn_id);
        if (exp_tr.wcompare(act_tr)) begin
          pass_count++;
          act_tr.display("[PASS]_[WSCB]");
        end
        else begin
          fail_count++;
          act_tr.display("[FAIL]_[WSCB]");
          $display("actual");
          act_tr.display("[ACTW]");
          $display("expected");
          exp_tr.display("[EXPW]");
          if (act_tr.data_in != exp_tr.data_in)
            $display("DATA_IN mismatch");
        end
        act_w.delete(id);
        exp_w.delete(id);
      end
    end
  endtask

  task read_actual();
    asfifo_tr #(DWIDTH) tr;
    forever begin
      act_rmbx.get(tr);
      act_r[tr.txn_id] = tr;
      read_match();
    end
  endtask

  task read_expected();
    asfifo_tr #(DWIDTH) tr;
    forever begin
      exp_rmbx.get(tr);
      exp_r[tr.txn_id] = tr;
      read_match();
    end
  endtask

  task read_match();
    int unsigned id;
    asfifo_tr #(DWIDTH) act_tr;
    asfifo_tr #(DWIDTH) exp_tr;
    if (act_r.size() == 0 || exp_r.size() == 0)
      return;
    foreach (act_r[id]) begin
      if (exp_r.exists(id)) begin
        act_tr = act_r[id];
        exp_tr = exp_r[id];
        $display("[SCB] ACT R: txn_id=%0d", act_tr.txn_id);
        $display("[SCB] EXP R: txn_id=%0d", exp_tr.txn_id);
        if (exp_tr.rcompare(act_tr)) begin
          pass_count++;
          act_tr.display("[PASS]_[RSCB]");
        end
        else begin
          fail_count++;
          act_tr.display("[FAIL]_[RSCB]");
          $display("actual");
          act_tr.display("[ACTR]");
          $display("expected");
          exp_tr.display("[EXPR]");
          if (act_tr.data_out !== exp_tr.data_out)
            $display("DATA_OUT mismatch");
        end
        act_r.delete(id);
        exp_r.delete(id);
      end
    end
  endtask

  task run();
    fork
      write_actual();
      write_expected();

      read_actual();
      read_expected();
    join
  endtask

  task report();

    $display("");
    $display("======================================");
    $display("             SCB_REPORT");
    $display("======================================");
    $display("PASS = %0d", pass_count);
    $display("FAIL = %0d", fail_count);
    $display("======================================");
    $display("");

    $display("Unmatched actual writes   = %0d", act_w.size());
    $display("Unmatched expected writes = %0d", exp_w.size());

    $display("Unmatched actual reads    = %0d", act_r.size());
    $display("Unmatched expected reads  = %0d", exp_r.size());

  endtask
endclass
