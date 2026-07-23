class alu_test #(parameter int WIDTH = 4);
  
  alu_env #(WIDTH) env;
  virtual alu_if #(WIDTH) vif;
  
  function new(virtual alu_if #(WIDTH) vif);
    this.vif = vif;
  endfunction
  
  task run();
    env = new(vif);
    env.build();
    env.run();
  endtask
endclass
