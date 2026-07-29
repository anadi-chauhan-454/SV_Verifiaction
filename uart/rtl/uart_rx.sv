module uart_rx#(parameter int WIDTH=8)
  (
    input logic clk,
    input logic rst_n,
    input logic rx,
    input logic parity_type,
    input logic parity_en,
    input logic stop_bits,
    output logic baud_tick,
    
    output logic [WIDTH-1:0] data_out,
    output logic rx_busy,
    output logic rx_done,
    
    output logic frame_error,
    output logic parity_error
  );
  
  typedef enum logic[3:0]{
    IDLE,
    START,
    DATA,
    PARITY,
    STOP
  }states;
  
  states next_state, current_state;
 
  logic [WIDTH-1:0] shift_data_reg;
  logic [$clog2(WIDTH)-1:0] bit_count;
  
  logic stop_count_reg;
  logic cal_parity;
  
  logic en_shift;
  logic save_data;
  logic clr_bit_count, inc_bit_count;
  
  assign cal_parity = parity_type ? ~(^shift_data_reg) : (^shift_data_reg);
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      current_state <= IDLE;
      shift_data_reg <= '0;
      data_out <= '0;
      bit_count <= '0;
      stop_count_reg <= 1'b0;
    end
    else begin
      current_state <= next_state;
      if(en_shift)
        shift_data_reg <= {rx, shift_data_reg[WIDTH-1:1]};
      if (save_data)
        data_out <= shift_data_reg;
      
      if(clr_bit_count)
        bit_count <= '0;
      else if(inc_bit_count)
        bit_count <= bit_count + 1'b1;
      
     if (current_state == STOP && baud_tick && stop_bits)
        stop_count_reg <= ~stop_count_reg;
     else if (current_state == IDLE)
        stop_count_reg <= 1'b0;
    end
  end
  
  always_comb begin
    next_state = current_state;
    
    rx_busy = 0;
    rx_done = 0;
    frame_error = 0;
    parity_error = 0;
    
    en_shift = 0;
    save_data = 0;
    inc_bit_count = 0;
    clr_bit_count = 0;
    
    unique case(current_state)
      IDLE: begin
        if(rx == 0) begin
          clr_bit_count = 1;
          next_state = START;
        end
      end
      
      START: begin
        rx_busy = 1;
       if (baud_tick) begin
          if (rx == 1'b0) begin
            next_state = DATA;
          end else begin
            next_state = IDLE;
          end
        end
      end
      
      DATA: begin
        rx_busy = 1;
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
        rx_busy = 1;
       if (baud_tick) begin
          if (rx != cal_parity) begin
            parity_error = 1'b1;
          end
          next_state = STOP;
        end
      end
      
      STOP: begin
        rx_busy      = 1'b1;
		if (baud_tick) begin
          if (rx == 1'b0) begin
            frame_error = 1'b1;
            next_state  = IDLE;
          end else begin
            if (stop_bits && !stop_count_reg) begin
              next_state = STOP; 
            end else begin
              rx_done    = 1'b1;
              save_data  = 1'b1;
              next_state = IDLE;
            end
          end
        end
      end

      default: begin
        next_state = IDLE;
      end

    endcase
  end

endmodule
        
  
