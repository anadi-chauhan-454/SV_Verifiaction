class asfifo_rm #(
  int DWIDTH = 16,
  int DEPTH  = 16
);

  mailbox #(asfifo_tr #(DWIDTH)) win_mbx;
  mailbox #(asfifo_tr #(DWIDTH)) rin_mbx;

  mailbox #(asfifo_tr #(DWIDTH)) outr_mbx;
  mailbox #(asfifo_tr #(DWIDTH)) outw_mbx;

  virtual asfifo_if #(DWIDTH) vif;

  bit [DWIDTH-1:0] queue[$];

  function new(
    mailbox #(asfifo_tr #(DWIDTH)) win_mbx,
    mailbox #(asfifo_tr #(DWIDTH)) rin_mbx,
    mailbox #(asfifo_tr #(DWIDTH)) outr_mbx,
    mailbox #(asfifo_tr #(DWIDTH)) outw_mbx,
    virtual asfifo_if #(DWIDTH) vif
  );

    this.win_mbx  = win_mbx;
    this.rin_mbx  = rin_mbx;
    this.outr_mbx = outr_mbx;
    this.outw_mbx = outw_mbx;
    this.vif      = vif;

  endfunction

  task run();
    fork
      write_domain();
      read_domain();
    join_none
  endtask
  
  task write_domain();
    asfifo_tr #(DWIDTH) tr;
    asfifo_tr #(DWIDTH) exp_tr;
    forever begin
      @(vif.wdrv_cb);
      win_mbx.get(tr);
      if (!vif.wrst_n) begin
        queue.delete();
        continue;
      end
      exp_tr = tr.copy();
      if (tr.wen && !vif.wmon_cb.full) begin
        if (queue.size() < DEPTH) begin
          queue.push_back(tr.data_in);
          outw_mbx.put(exp_tr);
          exp_tr.display("WRM");
        end
        else begin
          $error("[RM] Reference FIFO overflow");
        end
      end
    end
  endtask

  task read_domain();
    asfifo_tr #(DWIDTH) tr;
    asfifo_tr #(DWIDTH) exp_tr;
    forever begin
      @(vif.rdrv_cb);
      rin_mbx.get(tr);
      if (!vif.rrst_n) begin
        queue.delete();
        continue;
      end
      exp_tr = tr.copy();
      if (tr.ren && !tr.empty) begin
        if (queue.size() != 0) begin
          @(vif.rdrv_cb);
          exp_tr.data_out = queue.pop_front();
          outr_mbx.put(exp_tr);
          exp_tr.display("RRM");
        end
        else begin
          $error("[RM] Reference FIFO underflow");
        end
      end
    end
  endtask
endclass
