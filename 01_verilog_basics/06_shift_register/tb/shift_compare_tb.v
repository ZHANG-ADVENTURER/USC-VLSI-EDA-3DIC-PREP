`timescale 1ns/1ps

module shift_compare_tb;

reg clk;
reg reset;
reg d;

wire q1_nb;
wire q2_nb;
wire q3_nb;

wire q1_b;
wire q2_b;
wire q3_b;

shift_nonblocking dut_nb(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q1(q1_nb),
    .q2(q2_nb),
    .q3(q3_nb)
);

shift_blocking dut_b(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q1(q1_b),
    .q2(q2_b),
    .q3(q3_b)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("waves/shift_compare.vcd");
    $dumpvars(0, shift_compare_tb);

    clk = 0;
    reset = 1;
    d = 0;

    @(posedge clk);
    #1

    reset = 0;
    d = 1;

    @(posedge clk);
    #1;

    d = 0;

    @(posedge clk);
    #1;

    @(posedge clk);
    #1;

    $finish;
end

endmodule