`timescale 1ns/1ps

module mux2to1_tb;

reg a, b, sel;
wire y;

mux2to1 uut (
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);

initial begin
    $dumpfile("waveforms/mux2to1.vcd");
    $dumpvars(0, mux2to1_tb);

    a = 0; b = 0; sel = 0; #10;
    a = 0; b = 0; sel = 1; #10;
    a = 1; b = 0; sel = 0; #10;
    a = 1; b = 0; sel = 1; #10;
    a = 0; b = 1; sel = 0; #10;
    a = 0; b = 1; sel = 1; #10;
    a = 1; b = 1; sel = 0; #10;
    a = 1; b = 1; sel = 1; #10;

    $finish;
end

endmodule