module uart_bind;

  bind uart_top uart_assertions #(
      .WIDTH(8)
  ) u_uart_assertions (
      .clk          (clk),
      .rst_n        (rst_n),

      .parity_en    (parity_en),
      .parity_type  (parity_type),
      .stop_bits    (stop_bits),
      .tx_start     (tx_start),
      .baud_tick    (baud_tick),

      .current_state(current_state),
      .bit_count    (bit_count),

      .tx           (tx),
      .tx_busy      (tx_busy),
      .tx_done      (tx_done),

      .rx           (rx),
      .rx_busy      (rx_busy),
      .rx_done      (rx_done),
      .frame_error  (frame_error),
      .parity_error (parity_error)
  );

endmodule
