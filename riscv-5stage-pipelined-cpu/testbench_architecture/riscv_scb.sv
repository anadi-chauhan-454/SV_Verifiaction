class riscv_scb extends uvm_scoreboard;

  `uvm_component_utils(riscv_scb)

  uvm_tlm_analysis_fifo #(riscv_mon_tr) mon_fifo;
  uvm_tlm_analysis_fifo #(riscv_exp_tr) rm_fifo;

  riscv_mon_tr actual_tr;
  riscv_exp_tr expected_tr;

  function new(string name="riscv_scb", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_fifo = new("mon_fifo", this);
    rm_fifo  = new("rm_fifo", this);
  endfunction

  virtual task run_phase(uvm_phase phase);

    forever begin

      fork
        mon_fifo.get(actual_tr);
        rm_fifo.get(expected_tr);
      join

      compare_transactions(actual_tr, expected_tr);

    end

  endtask

  virtual function void compare_transactions(
    riscv_mon_tr actual,
    riscv_exp_tr expected
  );

    bit mismatch;

    mismatch = 0;

    if(actual.pcW_cpu !== expected.exp_pcW_cpu) begin
      `uvm_error("SCB",
        $sformatf("PC mismatch: ACT=%h EXP=%h",
                  actual.pcW_cpu,
                  expected.exp_pcW_cpu))
      mismatch = 1;
    end

    if(actual.instrW_cpu !== expected.exp_instrW_cpu) begin
      `uvm_error("SCB",
        $sformatf("INSTR mismatch: ACT=%h EXP=%h",
                  actual.instrW_cpu,
                  expected.exp_instrW_cpu))
      mismatch = 1;
    end

    if(actual.wd_reg_cpu !== expected.exp_wd_reg_cpu) begin
      `uvm_error("SCB",
        $sformatf("WD_REG mismatch: ACT=%b EXP=%b",
                  actual.wd_reg_cpu,
                  expected.exp_wd_reg_cpu))
      mismatch = 1;
    end

    if(actual.wda_reg_cpu !== expected.exp_wda_reg_cpu) begin
      `uvm_error("SCB",
        $sformatf("WDA_REG mismatch: ACT=%h EXP=%h",
                  actual.wda_reg_cpu,
                  expected.exp_wda_reg_cpu))
      mismatch = 1;
    end

    if(actual.wd_cpu !== expected.exp_wd_cpu) begin
      `uvm_error("SCB",
        $sformatf("WD mismatch: ACT=%h EXP=%h",
                  actual.wd_cpu,
                  expected.exp_wd_cpu))
      mismatch = 1;
    end

    if(actual.mr_cpu !== expected.exp_mr_cpu) begin
      `uvm_error("SCB",
        $sformatf("MR mismatch: ACT=%b EXP=%b",
                  actual.mr_cpu,
                  expected.exp_mr_cpu))
      mismatch = 1;
    end

    if(actual.mw_cpu !== expected.exp_mw_cpu) begin
      `uvm_error("SCB",
        $sformatf("MW mismatch: ACT=%b EXP=%b",
                  actual.mw_cpu,
                  expected.exp_mw_cpu))
      mismatch = 1;
    end

    if(actual.maddr_cpu !== expected.exp_maddr_cpu) begin
      `uvm_error("SCB",
        $sformatf("MADDR mismatch: ACT=%h EXP=%h",
                  actual.maddr_cpu,
                  expected.exp_maddr_cpu))
      mismatch = 1;
    end

    if(actual.mwdata_cpu !== expected.exp_mwdata_cpu) begin
      `uvm_error("SCB",
        $sformatf("MWDATA mismatch: ACT=%h EXP=%h",
                  actual.mwdata_cpu,
                  expected.exp_mwdata_cpu))
      mismatch = 1;
    end

    if(actual.mrdata_cpu !== expected.exp_mrdata_cpu) begin
      `uvm_error("SCB",
        $sformatf("MRDATA mismatch: ACT=%h EXP=%h",
                  actual.mrdata_cpu,
                  expected.exp_mrdata_cpu))
      mismatch = 1;
    end

    if(actual.valid_cpu !== expected.exp_valid_cpu) begin
      `uvm_error("SCB",
        $sformatf("VALID mismatch: ACT=%b EXP=%b",
                  actual.valid_cpu,
                  expected.exp_valid_cpu))
      mismatch = 1;
    end

    if(!mismatch) begin
      `uvm_info("SCB",
        "Transaction matched successfully",
        UVM_MEDIUM)
    end

  endfunction

endclass
