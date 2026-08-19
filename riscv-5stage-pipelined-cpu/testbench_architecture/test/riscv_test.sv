class riscv_test extends uvm_test;

    `uvm_component_utils(riscv_test)

    riscv_env env;
    riscv_seq seq;


    function new(string name="riscv_test",
                 uvm_component parent=null);

        super.new(name,parent);

    endfunction


    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        env = riscv_env::type_id::create("env", this);

    endfunction


    virtual task run_phase(uvm_phase phase);

        phase.raise_objection(this);


        seq = riscv_seq::type_id::create("seq");


        seq.start(env.riscv_agnt.seqr);


        #1000ns;


        phase.drop_objection(this);

    endtask


endclass
