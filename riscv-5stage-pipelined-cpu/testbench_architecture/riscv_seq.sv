class riscv_seq extends uvm_sequence #(riscv_tr);
  
  `uvm_object_utils(riscv_seq)
  
  int num_tr;
  
  function new(string name="riscv_seq");
    super.new(name);
    num_tr = 100;
  endfunction
  
  virtual task body();
    riscv_tr tr;
    repeat(num_tr) begin
      tr = riscv_tr::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize())
        else
          `uvm_fatal(get_type_name(), "Randomization Failed");
      finish_item(tr);
    end
  endtask
endclass
        
