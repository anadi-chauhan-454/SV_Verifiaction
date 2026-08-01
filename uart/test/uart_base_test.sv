class uart_base_test #(int WIDTH=8);
  
  uart_env #(WIDTH) env;
  virtual uart_if #(WIDTH) vif;
  
  function new(virtual uart_if #(WIDTH) vif);
    this.vif = vif;
  endfunction
  
  task build();
    env = new(vif);
    env.build();
  endtask
  
      virtual task configure();
        // Default: do nothing
    endtask
    
  
  task run();
    build();
    configure();
    env.run();
  endtask
endclass
