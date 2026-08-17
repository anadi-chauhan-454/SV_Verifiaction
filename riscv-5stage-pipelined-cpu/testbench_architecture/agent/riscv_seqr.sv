class riscv_seqr extends uvm_sequencer #(riscv_tr);

    `uvm_component_utils(riscv_seqr)

    function new(string name="riscv_seqr",
                 uvm_component parent);

        super.new(name, parent);

    endfunction

endclass
