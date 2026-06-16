`timescale 1ns/1ps

module decoder2to4_tb_refine;

    reg  [1:0] in;
    wire [3:0] y;

    reg [3:0] expected_y;

    decoder2to4 dut (
        .in(in),
        .y(y)
    );

    task run_test;
        input [1:0] test_in;
        input [3:0] exp_y;

        begin
            in = test_in;
            expected_y = exp_y;

            #10;

            if (y == expected_y) begin
                $display("pass | in=%b | y=%b | expected_y=%b",
                         in, y, expected_y);
            end else begin
                $display("fail | in=%b | y=%b | expected_y=%b",
                         in, y, expected_y);
            end
        end
    endtask

    initial begin
        $dumpfile("04_testbench_practice/waves/decoder2to4_tb_refine.vcd");
        $dumpvars(0, decoder2to4_tb_refine);

        $display("Refined DECODER2TO4 Testbench with Expected Results");
        $display("----------------------------------------------------");

        // 2-to-4 decoder one-hot output
        run_test(2'b00, 4'b0001);
        run_test(2'b01, 4'b0010);
        run_test(2'b10, 4'b0100);
        run_test(2'b11, 4'b1000);

        $finish;
    end

endmodule