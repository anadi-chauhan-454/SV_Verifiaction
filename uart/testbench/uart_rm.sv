class uart_rm #(parameter int WIDTH = 8);

  mailbox #(uart_tr #(WIDTH)) in_mbx;
  mailbox #(uart_tr #(WIDTH)) out_mbx;

  function new(
      mailbox #(uart_tr #(WIDTH)) in_mbx,
      mailbox #(uart_tr #(WIDTH)) out_mbx
  );
    this.in_mbx  = in_mbx;
    this.out_mbx = out_mbx;
  endfunction


  task run();

    uart_tr #(WIDTH) tr;
    uart_tr #(WIDTH) exp_tr;

    bit parity_calc;

    forever begin

      in_mbx.get(tr);

      exp_tr = tr.copy();

      if (tr.tx_start) begin

        exp_tr.serial_stream.delete();

        exp_tr.serial_stream.push_back(1'b0);

        for (int i = 0; i < WIDTH; i++)
          exp_tr.serial_stream.push_back(tr.data_in[i]);

        if (tr.parity_en) begin
          parity_calc = ^tr.data_in;

          if (tr.parity_type)
            parity_calc = ~parity_calc;

          exp_tr.serial_stream.push_back(parity_calc);
        end

        exp_tr.serial_stream.push_back(1'b1);

        if (tr.stop_bits)
          exp_tr.serial_stream.push_back(1'b1);

        exp_tr.tx_done = 1'b1;

        exp_tr.tx_busy  = 0;
        exp_tr.tx_start = 0;
        exp_tr.tx       = 1;

      end

      else begin

        exp_tr.data_out = tr.data_in;

        exp_tr.parity_error =
            tr.parity_en && tr.inject_parity_err;

        exp_tr.frame_error =
            tr.inject_frame_err;

        exp_tr.rx_done =
            !(exp_tr.parity_error ||
              exp_tr.frame_error);

        exp_tr.rx_busy = 0;

      end

      out_mbx.put(exp_tr.copy());

      exp_tr.display("RM");

    end

  endtask

endclass
