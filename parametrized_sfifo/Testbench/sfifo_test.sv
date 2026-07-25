class sfifo_test #(
    parameter int DWIDTH = 8,
    parameter int DEPTH  = 8
);

    sfifo_env #(DWIDTH, DEPTH) env;

    virtual sfifo_if #(DWIDTH) vif;

    function new(virtual sfifo_if #(DWIDTH) vif);
        this.vif = vif;
    endfunction

    task run();
        env = new(vif);
        env.build();
        env.run();
    endtask

endclass
