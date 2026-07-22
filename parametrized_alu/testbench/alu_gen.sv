class alu_gen #(parameter int WIDTH = 4);
  
  mailbox #(alu_tr #(WIDTH)) drv_mbx;
  mailbox #(alu_tr #(WIDTH)) rm_mbx;
  alu_tr #(WIDTH) tr;
  
  int count;
  event done;
  
  function new(mailbox #(alu_tr #(WIDTH)) drv_mbx, mailbox #(alu_tr #(WIDTH)) rm_mbx, int count = 100);
    this.drv_mbx = drv_mbx;
    this.rm_mbx = rm_mbx;
    this.count = count;
  endfunction

  task run();
    int i;
    for(i = 0; i < 20; i++) begin
        tr = new();
        
        tr.a     = $urandom_range(0, 15); 
        tr.b     = $urandom_range(0, 15);
        tr.shamt = $urandom_range(0, 3);
        
        tr.sel   = alu_pkg::alu_opt_t'(i % 7); 
        drv_mbx.put(tr.copy());
        rm_mbx.put(tr.copy());
        tr.display("GEN");
      end
    ->done;
  endtask
endclass
