class riscv_env extends uvm_env;

  `uvm_component_utils(riscv_env)

  riscv_agent riscv_agnt;
  riscv_ref_model    rm;
  riscv_scb   scb;

  function new(string name="riscv_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    riscv_agnt = riscv_agent::type_id::create("riscv_agnt", this);

    rm = riscv_ref_model #(32,5)::type_id::create("rm", this);

    scb = riscv_scb::type_id::create("scb", this);

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    riscv_agnt.mon.ap.connect(scb.mon_fifo.analysis_export);

    rm.ap.connect(scb.rm_fifo.analysis_export);

  endfunction

endclass
