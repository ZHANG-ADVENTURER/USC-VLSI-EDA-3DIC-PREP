`timescale 1ns/1ps

module counter_4bit_tb;

reg clk;
reg reset;
reg en;

wire [3:0] count;

reg [3:0] expected_count;

counter_4bit dut(
    .clk(clk),
    .reset(reset),
    .en(en),
    .count(count)
);

always #5 clk = ~clk;

task check_count;
    input [79:0] test_name;
    input [3:0] exp_count;

    begin
        expected_count = exp_count;

        #1

        if (count == expected_count) begin
            $display("pass | %s | time=%0t | reset=%b | en=%b | count=%b | expected_count=%b",
                         test_name, $time, reset, en, count, expected_count);
        end else begin
            $display("fail | %s | time=%0t | reset=%b | en=%b | count=%b | expected_count=%b",
                         test_name, $time, reset, en, count, expected_count);
        end
    end
endtask    

initial begin
    $dumpfile("05_counter/waves/counter_4bit.vcd");
    $dumpvars(0 , counter_4bit_tb);

    clk = 0;
    en = 0;
    reset = 1;
    expected_count = 4'b0000;

    @(posedge clk);
    check_count("reset", 4'b0000);

    en = 1;
    reset = 0;

    @(posedge clk);
    check_count("count_1", 4'b0001);

    @(posedge clk);
    check_count("count_2", 4'b0010);

    @(posedge clk);
    check_count("count_3", 4'b0011);

    en = 0;

    @(posedge clk);
    check_count("hold", 4'b0011);

    en = 1;
    reset = 1;

    @(posedge clk);
    check_count("reset", 4'b0000);

    $finish;
end

endmodule