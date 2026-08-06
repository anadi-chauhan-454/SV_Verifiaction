class asfifo_base_test #(int DWIDTH=8, int DEPTH=8);
  asfifo_env #(DWIDTH, DEPTH) env;
  virtual asfifo_if #(DWIDTH) vif;
  
  function new(virtual asfifo_if #(DWIDTH) vif);
    this.vif = vif;
  endfunction
  
  task build();
    env = new(vif);
    env.build();
  endtask
  
  virtual task configure();
    //nothing
  endtask
  
  task run();
    build();
    configure();
    env.run();
  endtask
endclass
