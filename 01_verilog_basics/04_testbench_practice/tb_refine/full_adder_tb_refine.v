`timescale 1ns/1ps

module full_adder_tb_refine;

    reg a, b, cin;

    wire sum, cout;

    reg expected_sum, expected_cout;

    full_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    task run_test;
        input test_a;
        input test_b;
        input test_cin;
        input exp_sum;
        input exp_cout;

        begin
            a = test_a;
            b = test_b;
            cin = test_cin;
            expected_sum = exp_sum;
            expected_cout = exp_cout;

            #10;

            if (sum == expected_sum && cout == expected_cout) begin
                $display("pass | a=%b | b=%b | cin=%b | sum=%b | expected_sum=%b | cout=%b | expected_cout=%b",
                         a, b, cin, sum, expected_sum, cout, expected_cout);
            end else begin
                $display("fail | a=%b | b=%b | cin=%b | sum=%b | expected_sum=%b | cout=%b | expected_cout=%b",
                         a, b, cin, sum, expected_sum, cout, expected_cout);
            end
        end
    endtask

    initial begin
        $dumpfile("04_testbench_practice/waves/full_adder_tb_refine.vcd");
        $dumpvars(0, full_adder_tb_refine);

        $display("Refined FULL_ADDER Testbench with Expected Results");
        $display("---------------------------------------------------");

        // a + b + cin = {cout, sum}
        run_test(1'b0, 1'b0, 1'b0, 1'b0, 1'b0); // 0 + 0 + 0 = 00
        run_test(1'b0, 1'b0, 1'b1, 1'b1, 1'b0); // 0 + 0 + 1 = 01
        run_test(1'b0, 1'b1, 1'b0, 1'b1, 1'b0); // 0 + 1 + 0 = 01
        run_test(1'b0, 1'b1, 1'b1, 1'b0, 1'b1); // 0 + 1 + 1 = 10
        run_test(1'b1, 1'b0, 1'b0, 1'b1, 1'b0); // 1 + 0 + 0 = 01
        run_test(1'b1, 1'b0, 1'b1, 1'b0, 1'b1); // 1 + 0 + 1 = 10
        run_test(1'b1, 1'b1, 1'b0, 1'b0, 1'b1); // 1 + 1 + 0 = 10
        run_test(1'b1, 1'b1, 1'b1, 1'b1, 1'b1); // 1 + 1 + 1 = 11

        $finish;
    end

endmodule