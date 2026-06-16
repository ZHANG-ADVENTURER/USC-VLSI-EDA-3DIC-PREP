`timescale 1ns/1ps

module mux2to1_tb_refine;

    reg a;
    reg b;
    reg sel;

    wire y;

    reg expected_y;

    mux2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    task run_test;
        input test_a;
        input test_b;
        input test_sel;
        input exp_y;

        begin
            a = test_a;
            b = test_b;
            sel = test_sel;
            expected_y = exp_y;

            #10;

            if (y == expected_y) 
                $display("pass | a=%b | b=%b | sel=%b | y=%b | expected_y=%b",
                         a, b, sel, y, expected_y);
            else
                $display("fail | a=%b | b=%b | sel=%b | y=%b | expected_y=%b",
                         a, b, sel, y, expected_y);
        end
    endtask

    initial begin
        $dumpfile("04_testbench_practice/waves/mux2to1_tb_refine.vcd");
        $dumpvars(0, mux2to1_tb_refine);

        $display("Refined MUX2TO1 Testbench with Expected Results");
        $display("------------------------------------------------");

        // sel = 1, output should follow a
        run_test(1'b0, 1'b0, 1'b1, 1'b0);
        run_test(1'b1, 1'b0, 1'b1, 1'b1);

        // sel = 0, output should follow b
        run_test(1'b0, 1'b1, 1'b0, 1'b1);
        run_test(1'b1, 1'b0, 1'b0, 1'b0);

        $finish;
    end

endmodule