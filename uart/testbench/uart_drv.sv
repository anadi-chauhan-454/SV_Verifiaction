class uart_drv #(parameter int WIDTH = 8);

  mailbox #(uart_tr #(WIDTH)) mbx;
  virtual uart_if #(WIDTH)    vif;

  function new(mailbox #(uart_tr #(WIDTH)) mbx,
               virtual uart_if #(WIDTH)    vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  task reset();
      wait(!vif.rst_n);

    vif.uart_drv_cb.data_in     <= '0;
    vif.uart_drv_cb.parity_en   <= 1'b0;
    vif.uart_drv_cb.parity_type <= 1'b0;
    vif.uart_drv_cb.stop_bits   <= 1'b0;
    vif.uart_drv_cb.tx_start    <= 1'b0;
    vif.uart_drv_cb.rx          <= 1'b1;
      wait(vif.rst_n);

  endtask

  task drive(uart_tr #(WIDTH) tr);
    bit parity_bit;

    vif.uart_drv_cb.parity_en   <= tr.parity_en;
    vif.uart_drv_cb.parity_type <= tr.parity_type;
    vif.uart_drv_cb.stop_bits   <= tr.stop_bits;

   if (tr.tx_start) begin
 	 while (vif.uart_drv_cb.rx_busy) @(vif.uart_drv_cb);
  		vif.uart_drv_cb.data_in  <= tr.data_in;
  		vif.uart_drv_cb.tx_start <= 1'b1;
  		@(vif.uart_drv_cb);
  		vif.uart_drv_cb.tx_start <= 1'b0; 
     @(vif.uart_drv_cb);
 	 while (vif.uart_drv_cb.tx_busy) @(vif.uart_drv_cb);
     @(vif.uart_drv_cb);
	end
    else begin
      wait (!vif.uart_drv_cb.tx_busy);

      vif.uart_drv_cb.rx <= 1'b0;
      repeat (16) @(vif.uart_drv_cb);

      for (int i = 0; i < WIDTH; i++) begin
        vif.uart_drv_cb.rx <= tr.data_in[i];
        repeat (16) @(vif.uart_drv_cb);
      end

      if (tr.parity_en) begin
        parity_bit = ^tr.data_in;
        if (tr.parity_type)
          parity_bit = ~parity_bit;

        if (tr.inject_parity_err)
          vif.uart_drv_cb.rx <= ~parity_bit;
        else
          vif.uart_drv_cb.rx <= parity_bit;

        repeat (16) @(vif.uart_drv_cb);
      end

      if (tr.inject_frame_err) begin
        vif.uart_drv_cb.rx <= 1'b0;
      end else begin
        vif.uart_drv_cb.rx <= 1'b1;
      end
      repeat (16) @(vif.uart_drv_cb);

      if (tr.stop_bits && !tr.inject_frame_err) begin
        vif.uart_drv_cb.rx <= 1'b1;
        repeat (16) @(vif.uart_drv_cb);
      end

      vif.uart_drv_cb.rx <= 1'b1;
    end
  endtask

  task run();
    uart_tr #(WIDTH) tr;

    reset();
    forever begin
      mbx.get(tr);
      @(vif.uart_drv_cb);
      tr.display("DRV");
      drive(tr);
    end
  endtask

endclass
