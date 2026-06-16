`timescale 1ns/1ps

module alu_tb_refine;

    reg [3:0] a, b;
    reg [1:0] opcode;

    wire [3:0] result;
    wire zero;

    reg [3:0] expected_result;
    reg expected_zero;

    alu_4bit dut(
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
);

task run_test;
    input [79:0] test_name;
    input [3:0] test_a, test_b;
    input [1:0] test_opcode;
    input [3:0] exp_result;
    input exp_zero;

    begin
       a = test_a;
       b = test_b;
       opcode = test_opcode;
       expected_result = exp_result;
       expected_zero = exp_zero;

       #10;

       if (result == expected_result && zero == expected_zero)
           $display("pass | %s | opcode=%b | a=%b | b=%b | result=%b | expedcted_result=%b | zero=%b | expected_zero=%b", 
           test_name, opcode, a, b, result, expected_result, zero, expected_zero);
        else
           $display("fail | %s | opcode=%b | a=%b | b=%b | result=%b | expedcted_result=%b | zero=%b | expected_zero=%b", 
           test_name, opcode, a, b, result, expected_result, zero, expected_zero);
    end
endtask

initial begin
    $dumpfile("04_testbench_practice/waves/alu_tb_refine.vcd");
    $dumpvars(0, alu_tb_refine);

    $display("Refined ALU Testbench with Expected Results");
    $display("--------------------------------------------------------------------------------");

    // ADD: 3 + 5 = 8
    run_test("ADD", 4'b0011, 4'b0101, 2'b00, 4'b1000, 1'b0);

    // SUB: 9 - 4 = 5
    run_test("SUB", 4'b1001, 4'b0100, 2'b01, 4'b0101, 1'b0);

    // AND: 1100 & 1010 = 1000
     run_test("AND", 4'b1100, 4'b1010, 2'b10, 4'b1000, 1'b0);

    // OR: 0101 | 0011 = 0111
    run_test("OR", 4'b0101, 4'b0011, 2'b11, 4'b0111, 1'b0);

    // SUB_ZERO: 4 - 4 = 0
    run_test("SUB_ZERO", 4'b0100, 4'b0100, 2'b01, 4'b0000, 1'b1);

    // ADD_WRAP: 1111 + 1111 = 11110, lower 4 bits = 1110
    run_test("ADD_WRAP", 4'b1111, 4'b1111, 2'b00, 4'b1110, 1'b0);

    $finish;
end

endmodule