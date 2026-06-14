`timescale 1ns/1ps

module decoder2to4_tb;

reg [1:0] in;
wire [3:0] y;

decoder2to4 uut(
    .in(in),
    .y(y)
);

initial begin
    $dumpfile("waveforms/decoder2to4.vcd");
    $dumpvars(0, decoder2to4_tb);

    in = 2'b00; #10;
    in = 2'b01; #10;
    in = 2'b10; #10;
    in = 2'b11; #10;

    $finish;

end

endmodule