class asfifo_sanity_test #(int DWIDTH = 8) extends asfifo_base_test #(DWIDTH);
  
  function new(virtual asfifo_if #(DWIDTH) vif);
    super.new(vif);
  endfunction
  
  virtual task configure();
    env.gen.count = 10;
    env.gen.mode = SANITY;
  endtask
endclass
