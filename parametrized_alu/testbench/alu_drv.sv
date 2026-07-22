class alu_drv #(parameter int WIDTH = 4);
  
  mailbox #(alu_tr #(WIDTH)) mbx;
  virtual alu_if #(WIDTH) vif;
  
  function new( mailbox #(alu_tr #(WIDTH)) mbx,
               virtual alu_if #(WIDTH) vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction
  
  task initialize();
    vif.a = '0;
    vif.b = '0;
    vif.sel = alu_pkg::alu_opt_t'('0);
    vif.shamt = '0;
  endtask
  
  task drive(alu_tr #(WIDTH) tr);
    vif.a = tr.a;
    vif.b = tr.b;
    vif.sel = tr.sel;
    vif.shamt = tr.shamt;
  endtask
  
  task run();
    alu_tr #(WIDTH) tr;
    initialize();
    forever
      begin
        mbx.get(tr);
        tr.display("DRV");
        drive(tr);
        #5;
      end
  endtask
endclass
