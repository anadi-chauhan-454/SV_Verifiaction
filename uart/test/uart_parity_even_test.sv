class uart_parity_even_test #(int WIDTH = 8) extends uart_base_test #(WIDTH);

  function new(virtual uart_if #(WIDTH) vif);
    super.new(vif);
  endfunction

  virtual task configure();
    env.gen.count       = 50;
    env.gen.parity_type = 1'b0; 
    env.gen.test_type   = uart_gen#(WIDTH)::EVEN_PARITY;
  endtask

endclass
