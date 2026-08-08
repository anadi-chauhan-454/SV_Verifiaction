class asfifo_random_test #(int DWIDTH = 8) extends asfifo_base_test #(DWIDTH);
  
  function new(virtual asfifo_if #(DWIDTH) vif);
    super.new(vif);
  endfunction
  
  virtual task configure();
    env.gen.count = 250;
    env.gen.mode = RANDOM;
  endtask
endclass
