class uart_mon #(parameter int WIDTH = 8);

  mailbox #(uart_tr #(WIDTH)) mbx;
  virtual uart_if #(WIDTH) vif;
  uart_cov #(WIDTH) cov;

  function new(mailbox #(uart_tr #(WIDTH)) mbx,
               virtual uart_if #(WIDTH) vif);
    this.mbx = mbx;
    this.vif = vif;
    cov = new();
  endfunction

  task monitor_tx();

    uart_tr #(WIDTH) tr;

    forever begin

      @(posedge vif.tx_start);

      tr = new();

      tr.tx_start    = 1'b1;
      tr.data_in     = vif.data_in;
      tr.parity_en   = vif.parity_en;
      tr.parity_type = vif.parity_type;
      tr.stop_bits   = vif.stop_bits;

      tr.serial_stream.delete();

      @(posedge vif.baud_tick);
      tr.serial_stream.push_back(vif.tx);

      repeat(WIDTH) begin
        @(posedge vif.baud_tick);
        tr.serial_stream.push_back(vif.tx);
      end

      if(tr.parity_en) begin
        @(posedge vif.baud_tick);
        tr.serial_stream.push_back(vif.tx);
      end

      @(posedge vif.baud_tick);
      tr.serial_stream.push_back(vif.tx);

      if(tr.stop_bits) begin
        @(posedge vif.baud_tick);
        tr.serial_stream.push_back(vif.tx);
      end

      wait(vif.tx_done);

      tr.tx_done   = 1'b1;
      tr.timestamp = $time;

      tr.display("MON_TX");

      mbx.put(tr.copy());

      cov.write(tr);

    end

  endtask


  task monitor_rx();

    uart_tr #(WIDTH) tr;

    forever begin

      wait(vif.rx_done || vif.frame_error || vif.parity_error);

      tr = new();

      tr.data_out      = vif.data_out;
      tr.rx_done       = vif.rx_done;
      tr.frame_error   = vif.frame_error;
      tr.parity_error  = vif.parity_error;

      tr.timestamp = $time;

      tr.display("MON_RX");

      mbx.put(tr.copy());

      cov.write(tr);

      @(posedge vif.clk);

    end

  endtask

  task run();
    fork
      monitor_tx();
      monitor_rx();
    join
  endtask

endclass
