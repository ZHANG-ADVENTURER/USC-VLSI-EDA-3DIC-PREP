module simple_fifo (
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

    reg [7:0] mem [0:3];

    reg [1:0] write_ptr;
    reg [1:0] read_ptr;

    reg [2:0] count;

    wire valid_write;
    wire valid_read;

    assign full  = (count == 4);
    assign empty = (count == 0);

    assign valid_write = write_en && !full;
    assign valid_read  = read_en && !empty;

    always @(posedge clk) begin
        if (reset) begin
            write_ptr <= 2'b00;
            read_ptr  <= 2'b00;
            count     <= 3'b000;
            data_out  <= 8'b00000000;
        end
        
        else begin
            if (valid_write) begin
                mem[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
            end

            if (valid_read) begin
                data_out <= mem[read_ptr];
                read_ptr <= read_ptr + 1;
            end

            case ({valid_write, valid_read})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                2'b11: count <= count;
                2'b00: count <= count;
            endcase
        end
    end

endmodule