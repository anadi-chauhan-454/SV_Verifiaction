class uart_scb #(parameter int WIDTH = 8);

  mailbox #(uart_tr #(WIDTH)) act_mbx;
  mailbox #(uart_tr #(WIDTH)) exp_mbx;

  int unsigned pass;
  int unsigned fail;

  function new(mailbox #(uart_tr #(WIDTH)) act_mbx,
               mailbox #(uart_tr #(WIDTH)) exp_mbx);

    this.act_mbx = act_mbx;
    this.exp_mbx = exp_mbx;

    pass = 0;
    fail = 0;

  endfunction

  function bit compare_trans(
      uart_tr #(WIDTH) exp,
      uart_tr #(WIDTH) act
  );

    if(exp.tx_done) begin

      if(exp.data_in     != act.data_in)
        return 0;

      if(exp.parity_en   != act.parity_en)
        return 0;

      if(exp.parity_type != act.parity_type)
        return 0;

      if(exp.stop_bits   != act.stop_bits)
        return 0;

      if(exp.serial_stream.size() != act.serial_stream.size())
        return 0;

      foreach(exp.serial_stream[i]) begin

        if(exp.serial_stream[i] != act.serial_stream[i])
          return 0;

      end

      return 1;

    end

    else begin

      if(exp.data_out != act.data_out)
        return 0;

      if(exp.parity_error != act.parity_error)
        return 0;

      if(exp.frame_error != act.frame_error)
        return 0;

      if(exp.rx_done != act.rx_done)
        return 0;

      return 1;

    end

  endfunction

  task run();

    uart_tr #(WIDTH) exp;
    uart_tr #(WIDTH) act;

    forever begin

      exp_mbx.get(exp);
      act_mbx.get(act);

      if(compare_trans(exp,act)) begin

        pass++;

        act.display("PASS_SCB");

      end
      else begin

        fail++;

        act.display("FAIL_SCB");

        $display("\n=================================");
        $display("        SCOREBOARD FAIL");
        $display("=================================");

        $display("\nExpected:");
        exp.display("EXP");

        $display("\nActual:");
        act.display("ACT");

        $display("=================================\n");

      end

    end

  endtask

  task report();

    $display("\n================================");
    $display(" SCOREBOARD REPORT");
    $display("================================");
    $display(" PASS : %0d",pass);
    $display(" FAIL : %0d",fail);
    $display("================================");

  endtask

endclass
