interface alu_if #(parameter int WIDTH = 4);

    import alu_pkg::*;

    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [$clog2(WIDTH)-1:0] shamt;

    alu_opt_t sel;

    logic [WIDTH-1:0] result;
    status_flags_t flags;

    modport dut (
        input  a,
        input  b,
        input  sel,
        input  shamt,

        output result,
        output flags
    );

    modport tb (
        output a,
        output b,
        output sel,
        output shamt,
      
        input result,
        input flags
    );

endinterface
