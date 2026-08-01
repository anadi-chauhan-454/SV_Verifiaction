class uart_sanity_test #(int WIDTH = 8) extends uart_base_test #(WIDTH);

  function new(virtual uart_if #(WIDTH) vif);
    super.new(vif);
  endfunction

  virtual task configure();
    env.gen.count = 30;
    env.gen.test_type = uart_gen#(WIDTH)::SANITY;
  endtask

endclass
