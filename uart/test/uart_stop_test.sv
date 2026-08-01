class uart_stop_test #(int WIDTH = 8) extends uart_base_test #(WIDTH);

  function new(virtual uart_if #(WIDTH) vif);
    super.new(vif);
  endfunction
  
  virtual task configure();
    env.gen.count     = 50;
    env.gen.stop_bits = 1'b1;
    env.gen.test_type = uart_gen#(WIDTH)::STOP;
  endtask

endclass
