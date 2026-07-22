class alu_mon #(parameter int WIDTH = 4);
  
  mailbox #(alu_tr #(WIDTH)) mbx;
  virtual alu_if #(WIDTH) vif;
  
  function new( mailbox #(alu_tr #(WIDTH)) mbx,
               virtual alu_if #(WIDTH) vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction
  
  task run();
    alu_tr #(WIDTH) tr;
    
    forever
      begin
       #2;
       tr = new();
        
       tr.a = vif.a;
       tr.b = vif.b;
       tr.sel = vif.sel;
       tr.shamt = vif.shamt;
        
        tr.result = vif.result;
		tr.flags = vif.flags;
        
        tr.display("MON");
        mbx.put(tr.copy());
	#3;
      end
  endtask
endclass
   	 
    
    
