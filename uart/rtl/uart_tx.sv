module uart_tx#(parameter int WIDTH=8)
  (
    input logic clk,
    input logic rst_n,
    input logic [WIDTH-1:0] data_in,
    input logic baud_tick,
    input logic tx_start,
    input logic parity_en,
    input logic parity_type,
    input logic stop_bits,
    
    output logic tx,
    output logic tx_busy,
    output logic tx_done
  );
  
  typedef enum logic [2:0]{
    IDLE,
    START,
    DATA,
    PARITY,
    STOP
  }states;
  
  states current_state, next_state;
  
  logic [WIDTH-1:0] shift_data_reg;
  logic [$clog2(WIDTH)-1:0] bit_count;
  
  logic parity_bit;
  logic stop_count_reg;
  
  logic clr_bit_count, inc_bit_count;
  logic load_shift, en_shift;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      current_state <= IDLE;
      shift_data_reg <= '0;
      bit_count <= '0;
      stop_count_reg <= 1'b0;
    end
    else begin
      current_state <= next_state;
      
      if(load_shift) begin
        shift_data_reg <= data_in;
        parity_bit <= parity_type ? ~(^data_in) : ^data_in;
        stop_count_reg <= 1'b0;
      end
      else if(en_shift)
        shift_data_reg <= {1'b0, shift_data_reg[WIDTH-1:1]};
      
      if(clr_bit_count)
        bit_count <= '0;
      else if(inc_bit_count)
        bit_count <= bit_count + 1'b1;
      
      if (current_state == STOP && baud_tick && stop_bits) begin
        stop_count_reg <= ~stop_count_reg;
      end
    end
  end
    
    
    
    
  always_comb begin
    next_state = current_state;
    
    clr_bit_count = 0;
    inc_bit_count = 0;
    
    load_shift = 0;
    en_shift = 0;
    
    tx_busy = 0;
    tx_done = 0;
    tx = 1;
    
    unique case(current_state)
      IDLE: begin
        if(tx_start) begin
          load_shift = 1;
          clr_bit_count = 1;
          next_state = START;
        end
      end
      
      START: begin
        tx = 0;
        tx_busy = 1;
        if(baud_tick)
          next_state = DATA;
      end
      
      DATA: begin
        tx = shift_data_reg[0];
        tx_busy = 1;
        if(baud_tick) begin
          en_shift = 1;
          inc_bit_count = 1;
          if(bit_count == WIDTH-1) begin
            if(parity_en)
              next_state = PARITY;
            else
              next_state = STOP;
          end
        end
      end
      
      PARITY: begin
        tx_busy = 1'b1;
        tx = parity_bit;
        if (baud_tick) begin
          next_state = STOP;
        end
      end

      STOP: begin
        tx           = 1'b1;
        tx_busy      = 1'b1;

        if (baud_tick) begin
          if (stop_bits && !stop_count_reg) begin
            next_state = STOP; 
          end else begin
            tx_done    = 1'b1;
            next_state = IDLE;
          end
        end
      end

      default: begin
        next_state = IDLE;
      end

    endcase
  end

endmodule
        
        
        
          
  	
    
    
