module riscv_forwading_unit #(int REG_ADDR=5)
  (
    input logic [REG_ADDR-1:0] rda1E,
    input logic [REG_ADDR-1:0] rda2E,
    input logic [REG_ADDR-1:0] wdaM,
    input logic [REG_ADDR-1:0] wdaW,
    input logic reg_writeM,
    input logic reg_writeW,
    
    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
  );
  
  
  always_comb begin
      ForwardA = 2'b00;
      ForwardB = 2'b00;
      
      if(reg_writeM && (wdaM != '0) && (wdaM == rda1E))
        ForwardA = 2'b10;
      else if(reg_writeW && (wdaW != '0) && (wdaW == rda1E))
        ForwardA = 2'b01;
      
      if(reg_writeM && (wdaM != '0) && (wdaM == rda2E))
        ForwardB = 2'b10;
      else if(reg_writeW && (wdaW != '0) && (wdaW == rda2E))
        ForwardB = 2'b01;
  end
endmodule
      
  
