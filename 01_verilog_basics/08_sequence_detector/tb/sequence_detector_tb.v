`timescale 1ns/1ps

module sequence_detector_tb;

    reg clk;
    reg reset;
    reg bit_in;

    wire detected;

    reg expected_detected;

    sequence_detector dut(
        .clk(clk),
        .reset(reset),
        .bit_in(bit_in),
        .detected(detected)
    );

    always #5 clk = ~clk;

    task check_detected;
        input input_bit;
        input expected_value;
        input [319:0] test_name;

        begin
            bit_in = input_bit;

            @(posedge clk);

            expected_detected = expected_value;

            #1;

            if (detected === expected_detected) begin
                $display("pass | %-30s | bit_in = %b | detected = %b",
                         test_name, bit_in, detected);
            end else begin
                $display("fail | %-30s | bit_in = %b | detected = %b | expected = %b",
                         test_name, bit_in, detected, expected_detected);
            end
        end
    endtask

    initial begin
        $dumpfile("waves/sequence_detector.vcd");
        $dumpvars(0, sequence_detector_tb);

        clk = 0;
        reset = 1;
        bit_in = 0;
        expected_detected = 0;

        @(posedge clk);
        reset = 0;

        // Test sequence: 1011011
        // Expected detections: after 1011 and after 1011011

        check_detected(1'b1, 1'b0, "Input 1");
        check_detected(1'b0, 1'b0, "Input 10");
        check_detected(1'b1, 1'b0, "Input 101");
        check_detected(1'b1, 1'b1, "Input 1011 detected");

        check_detected(1'b0, 1'b0, "Input 10110");
        check_detected(1'b1, 1'b0, "Input 101101");
        check_detected(1'b1, 1'b1, "Input 1011011 detected");

        $finish;
    end

endmodule