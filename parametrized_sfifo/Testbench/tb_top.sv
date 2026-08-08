module sfifo_top;

    parameter int DWIDTH = 8;
    parameter int DEPTH  = 8;

    logic clk;
    logic rst_n;

    sfifo_if #(DWIDTH) vif(clk, rst_n);

    sfifo #(
        .DWIDTH(DWIDTH),
        .DEPTH (DEPTH)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .wen      (vif.wen),
        .ren      (vif.ren),
        .data_in  (vif.data_in),
        .data_out (vif.data_out),
        .flags    (vif.flags)
    );

    sfifo_test #(DWIDTH, DEPTH) test;

    initial
        clk = 0;

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
      repeat(2) @(posedge clk);
        rst_n = 1;
    end

    initial begin
        $dumpfile("sfifo.vcd");
        $dumpvars(0, sfifo_top);
    end

    initial begin
        test = new(vif);
        test.run();
    end

endmodule
