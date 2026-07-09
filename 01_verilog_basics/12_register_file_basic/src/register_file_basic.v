module register_file_basic(
    input clk,
    input reset,
    input write_en,
    input [1:0] write_addr,
    input [7:0] write_data,
    input [1:0] read_addr1,
    input [1:0] read_addr2,
    output [7:0] read_data1,
    output [7:0] read_data2
);

    reg [7:0] regs [0:3];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                regs[i] <= 8'b00000000;
            end
        end else begin
            if (write_en) begin
                regs[write_addr] <= write_data;
            end
        end
    end

    assign read_data1 = regs[read_addr1];
    assign read_data2 = regs[read_addr2];

endmodule