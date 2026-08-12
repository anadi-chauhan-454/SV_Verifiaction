class riscv_agent extends uvm_agent;

  `uvm_component_utils(riscv_agent)

  riscv_seqr seqr;
  riscv_drv   drv;
  riscv_mon   mon;

  function new(string name="riscv_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon = riscv_mon::type_id::create("mon", this);

    if(get_is_active() == UVM_ACTIVE) begin
      seqr = riscv_seqr::type_id::create("seqr", this);
      drv  = riscv_drv::type_id::create("drv", this);
    end

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end

  endfunction

endclass
