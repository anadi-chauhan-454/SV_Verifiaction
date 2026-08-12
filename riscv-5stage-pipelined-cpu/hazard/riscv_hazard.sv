module riscv_hazard #(int REG_ADDR=5)
  (
    input logic [REG_ADDR-1:0] rda1D,
    input logic [REG_ADDR-1:0] rda2D,
    input logic [REG_ADDR-1:0] wdaE,
    input logic mem_readE,
    
    output logic pc_write,
    output logic IF_ID_write,
    output logic flushE
  );
  
  logic hazard;
  
  assign hazard =  mem_readE && (wdaE != '0) && (
        (rda1D == wdaE) ||
        (rda2D == wdaE)
    );
  
  always_comb begin
    pc_write = 1'b1;
    IF_ID_write = 1'b1;
    flushE = 1'b0;
    if(hazard) begin
      pc_write = 1'b0;
      IF_ID_write = 1'b0;
      flushE = 1'b1;
    end
  end
endmodule
