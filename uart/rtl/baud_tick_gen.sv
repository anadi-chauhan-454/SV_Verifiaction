module baud_tick_gen #(
 parameter int CLK_FREQ = 50_000_000,
 parameter int BAUD_RATE = 9600
)
  (
    input logic clk,
    input logic rst_n,
    input logic en,
    output logic baud_tick  
  );
  
  localparam int REQ_COUNT = CLK_FREQ / BAUD_RATE;
  
  logic [$clog2(REQ_COUNT)-1:0] count;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      count <= '0;
      baud_tick <= 0;
    end
    else begin
      baud_tick <= 0;
      if(en) begin
        if(count == REQ_COUNT-1) begin
          count <= '0;
          baud_tick <= 1;
        end
        else
          count <= count + 1'b1;
      end
      else
        count <= '0;
    end
  end
endmodule
    
 
