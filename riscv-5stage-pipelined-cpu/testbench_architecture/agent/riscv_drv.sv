class riscv_drv extends uvm_driver #(riscv_tr);
  `uvm_component_utils(riscv_drv)
  
  virtual riscv_if #(32,5) vif;
  uvm_analysis_port #(riscv_seq_item #(32,5)) ap;
  
  function new(string name="riscv_drv", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if(!uvm_config_db#(virtual riscv_if)::get(
      this,
      "",
      "vif",
      vif)) begin
      `uvm_fatal(get_type_name(), "Interface Fetch Failed");
    end
  endfunction
  
  task reset();
    wait(!vif.rst_n);
     vif.imem_wen <= 0;
     vif.imem_wda <= '0;
     vif.imem_wd <= '0;
    wait(vif.rst_n);
    @(vif.drv_cb);
  endtask
  
  task drive();
    @(vif.drv_cb);
    
    vif.drv_cb.imem_wen <= req.imem_wen;
    
    if(req.imem_wen) begin
      vif.drv_cb.imem_wda <= req.imem_wda;
      vif.drv_cb.imem_wd  <= req.imem_wd;
    end
    
    @(vif.drv_cb);
    vif.drv_cb.imem_wen <= 0;
  endtask
  
  virtual task run_phase(uvm_phase phase);
    reset();
    forever begin
      seq_item_port.get_next_item(req);
      ap.write(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
endclass
    
    
