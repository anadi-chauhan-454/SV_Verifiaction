module riscv_dm #(int WIDTH =32)
(
    input  logic             clk,
    input  logic [WIDTH-1:0] address,
    input  logic [WIDTH-1:0] w_data,
    input  logic             mem_read,
    input  logic             mem_write,
    input  logic [2:0]       funct3,

    output logic [WIDTH-1:0] r_data
);

logic [31:0] data_mem [0:1023];
logic [9:0] index;
logic [1:0] byte_offset;

assign index       = address[11:2];
assign byte_offset = address[1:0];

always_comb begin
    r_data = '0;

    if(mem_read) begin
        case(funct3)

            3'b010:
                r_data = data_mem[index];

            3'b000: begin
                case(byte_offset)
                    2'b00: r_data = {{24{data_mem[index][7]}},  data_mem[index][7:0]};
                    2'b01: r_data = {{24{data_mem[index][15]}}, data_mem[index][15:8]};
                    2'b10: r_data = {{24{data_mem[index][23]}}, data_mem[index][23:16]};
                    2'b11: r_data = {{24{data_mem[index][31]}}, data_mem[index][31:24]};
                endcase
            end

            3'b001: begin
                if(byte_offset[0] == 1'b0) begin
                    if(byte_offset[1] == 1'b0)
                        r_data = {{16{data_mem[index][15]}}, data_mem[index][15:0]};
                    else
                        r_data = {{16{data_mem[index][31]}}, data_mem[index][31:16]};
                end
            end

            3'b100: begin
                case(byte_offset)
                    2'b00: r_data = {24'b0, data_mem[index][7:0]};
                    2'b01: r_data = {24'b0, data_mem[index][15:8]};
                    2'b10: r_data = {24'b0, data_mem[index][23:16]};
                    2'b11: r_data = {24'b0, data_mem[index][31:24]};
                endcase
            end

            3'b101: begin
                if(byte_offset[0] == 1'b0) begin
                    if(byte_offset[1] == 1'b0)
                        r_data = {16'b0, data_mem[index][15:0]};
                    else
                        r_data = {16'b0, data_mem[index][31:16]};
                end
            end

            default: r_data = '0;
        endcase
    end
end

always_ff @(posedge clk) begin
    if(mem_write) begin
        case(funct3)

            3'b010:
                data_mem[index] <= w_data;

            3'b000: begin
                case(byte_offset)
                    2'b00: data_mem[index][7:0]   <= w_data[7:0];
                    2'b01: data_mem[index][15:8]  <= w_data[7:0];
                    2'b10: data_mem[index][23:16] <= w_data[7:0];
                    2'b11: data_mem[index][31:24] <= w_data[7:0];
                endcase
            end

            3'b001: begin
                if(byte_offset[0] == 1'b0) begin
                    if(byte_offset[1] == 1'b0)
                        data_mem[index][15:0] <= w_data[15:0];
                    else
                        data_mem[index][31:16] <= w_data[15:0];
                end
            end

            default: ;
        endcase
    end
end

endmodule
