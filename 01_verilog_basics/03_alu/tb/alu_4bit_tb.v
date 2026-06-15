`timescale 1ns/1ps

module alu_4bit_tb;

reg [3:0] a, b;
reg [1:0] opcode;

wire [3:0]result;
wire zero;

reg [79:0] operation;

alu_4bit dut(
    .a(a),
    .b(b),
    .opcode(opcode),
    .result(result),
    .zero(zero)
);

initial begin
    $dumpfile("waves/alu_4bit.vcd");
    $dumpvars(0, alu_4bit_tb);

    $display("Time | Operation | opcode | a | b | result | zero");
    $display("--------------------------------------------------");

    // Test 1: ADD
    a = 4'd3;
    b = 4'd5;
    opcode = 2'b00;
    operation = "ADD";
    #10;
    $display("%0t | %s | %b | %b | %b | %b | %b", $time, operation, opcode, a, b, result, zero);

    // Test 2: SUB
    a = 4'd9;
    b = 4'd4;
    opcode = 2'b01;
    operation = "SUB";
    #10;
    $display("%0t | %s | %b | %b | %b | %b | %b", $time, operation, opcode, a, b, result, zero);

    // Test 3: AND
    a = 4'b1100;
    b = 4'b1010;
    opcode = 2'b10;
    operation = "AND";
    #10;
    $display("%0t | %s | %b | %b | %b | %b | %b", $time, operation, opcode, a, b, result, zero);

    // Test 4: OR
    a = 4'b0101;
    b = 4'b0011;
    opcode = 2'b11;
    operation = "OR";
    #10;
    $display("%0t | %s | %b | %b | %b | %b | %b", $time, operation, opcode, a, b, result, zero);

    // Test 5: result becomes zero
    a = 4'd4;
    b = 4'd4;
    opcode = 2'b01;
    operation = "SUB_ZERO";
    #10;
    $display("%0t | %s | %b | %b | %b | %b | %b", $time, operation, opcode, a, b, result, zero);

    // Test 6: 4-bit wrap around
    a = 4'b1111;
    b = 4'b1111;
    opcode = 2'b00;
    operation = "ADD_WRAP";
    #10;
    $display("%0t | %s | %b | %b | %b | %b | %b", $time, operation, opcode, a, b, result, zero);

    $finish;

end


endmodule