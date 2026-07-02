`timescale 1ns/1ps

module simple_fifo_tb;

    reg clk;
    reg reset;
    reg write_en;
    reg read_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;

    reg [7:0] expected_data;

    simple_fifo dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    task check_flags;
        input expected_full;
        input expected_empty;
        input [319:0] test_name;

        begin
            #1;

            if (full === expected_full && empty === expected_empty) begin
                $display("pass | %-40s | full = %b | empty = %b",
                         test_name, full, empty);
            end else begin
                $display("fail | %-40s | full = %b | expected_full = %b | empty = %b | expected_empty = %b",
                         test_name, full, expected_full, empty, expected_empty);
            end
        end
    endtask

    task write_fifo;
        input [7:0] input_data;
        input expected_full;
        input expected_empty;
        input [319:0] test_name;

        begin
            data_in = input_data;
            write_en = 1;
            read_en = 0;

            @(posedge clk);

            #1;

            if (full === expected_full && empty === expected_empty) begin
                $display("pass | %-40s | write data = %h | full = %b | empty = %b",
                         test_name, input_data, full, empty);
            end else begin
                $display("fail | %-40s | write data = %h | full = %b | expected_full = %b | empty = %b | expected_empty = %b",
                         test_name, input_data, full, expected_full, empty, expected_empty);
            end

            write_en = 0;
        end
    endtask

    task read_fifo;
        input [7:0] expected_value;
        input expected_full;
        input expected_empty;
        input [319:0] test_name;

        begin
            write_en = 0;
            read_en = 1;

            @(posedge clk);

            expected_data = expected_value;

            #1;

            if (data_out === expected_data && full === expected_full && empty === expected_empty) begin
                $display("pass | %-40s | data_out = %h | full = %b | empty = %b",
                         test_name, data_out, full, empty);
            end else begin
                $display("fail | %-40s | data_out = %h | expected_data = %h | full = %b | expected_full = %b | empty = %b | expected_empty = %b",
                         test_name, data_out, expected_data, full, expected_full, empty, expected_empty);
            end

            read_en = 0;
        end
    endtask

    task read_when_empty;
        input expected_full;
        input expected_empty;
        input [319:0] test_name;

        begin
            write_en = 0;
            read_en = 1;

            @(posedge clk);

            #1;

            if (full === expected_full && empty === expected_empty) begin
                $display("pass | %-40s | full = %b | empty = %b",
                         test_name, full, empty);
            end else begin
                $display("fail | %-40s | full = %b | expected_full = %b | empty = %b | expected_empty = %b",
                         test_name, full, expected_full, empty, expected_empty);
            end

            read_en = 0;
        end
    endtask

    initial begin
        $dumpfile("waves/simple_fifo.vcd");
        $dumpvars(0, simple_fifo_tb);

        clk = 0;
        reset = 1;
        write_en = 0;
        read_en = 0;
        data_in = 8'h00;
        expected_data = 8'h00;

        @(posedge clk);
        #1;
        reset = 0;

        check_flags(1'b0, 1'b1, "After reset, FIFO should be empty");

        // Basic write and read test
        write_fifo(8'hA1, 1'b0, 1'b0, "Write A1");
        write_fifo(8'hB2, 1'b0, 1'b0, "Write B2");

        read_fifo(8'hA1, 1'b0, 1'b0, "Read first value, expect A1");
        read_fifo(8'hB2, 1'b0, 1'b1, "Read second value, expect B2");

        // Fill FIFO
        write_fifo(8'h11, 1'b0, 1'b0, "Fill FIFO: write 11");
        write_fifo(8'h22, 1'b0, 1'b0, "Fill FIFO: write 22");
        write_fifo(8'h33, 1'b0, 1'b0, "Fill FIFO: write 33");
        write_fifo(8'h44, 1'b1, 1'b0, "Fill FIFO: write 44, FIFO should be full");

        // Overflow attempt
        write_fifo(8'h55, 1'b1, 1'b0, "Attempt overflow write 55");

        // Read all data after overflow attempt
        read_fifo(8'h11, 1'b0, 1'b0, "Read after overflow, expect 11");
        read_fifo(8'h22, 1'b0, 1'b0, "Read after overflow, expect 22");
        read_fifo(8'h33, 1'b0, 1'b0, "Read after overflow, expect 33");
        read_fifo(8'h44, 1'b0, 1'b1, "Read after overflow, expect 44");

        // Underflow attempt
        read_when_empty(1'b0, 1'b1, "Attempt underflow read");

        $finish;
    end

endmodule