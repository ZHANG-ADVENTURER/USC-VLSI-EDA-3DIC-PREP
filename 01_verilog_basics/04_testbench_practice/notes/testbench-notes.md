# Testbench Notes

## Topic

Testbench practice and verification-oriented simulation

## What is a Testbench?

A testbench is a simulation environment used to verify a Verilog module.

It is not the hardware design itself.

The hardware module is called the DUT, which means Device Under Test. The testbench provides input stimulus to the DUT and checks whether the output behavior is correct.

## DUT

DUT means Device Under Test.

In this practice, the DUT is the 4-bit ALU module:

```verilog
alu_4bit dut (
    .a(a),
    .b(b),
    .opcode(opcode),
    .result(result),
    .zero(zero)
);
```

The ALU is the hardware being tested.
The testbench is only the environment around it.

## Stimulus

Stimulus means the input values given to the DUT during simulation.

For example:

```verilog
a = 4'b0011;
b = 4'b0101;
opcode = 2'b00;
```

This stimulus asks the ALU to perform ADD with inputs 3 and 5.

## Expected Result

The expected result is the correct answer that the testbench uses for comparison.

For example:

```verilog
expected_result = 4'b1000;
expected_zero = 1'b0;
```

This means the testbench expects the ALU result to be `1000` and the zero flag to be `0`.

## Actual Result

The actual result is the output produced by the DUT.

In this practice:

```verilog
result
zero
```

are the actual outputs from the ALU.

## PASS / FAIL Check

A better testbench should not only print the output. It should compare the actual output with the expected output.

Example:

```verilog
if (result == expected_result && zero == expected_zero) begin
    $display("pass");
end else begin
    $display("fail");
end
```

This means the test passes only when both `result` and `zero` match the expected values.

## Task

A task is used to organize repeated testbench code.

Instead of writing the same stimulus and checking logic many times, I can define one task:

```verilog
task run_test;
```

Then each test case can be written as one line:

```verilog
run_test("ADD", 4'b0011, 4'b0101, 2'b00, 4'b1000, 1'b0);
```

This makes the testbench cleaner and easier to extend.

## `$display`

`$display` prints information to the terminal during simulation.

It is useful for showing:

* test name
* input values
* actual output
* expected output
* PASS / FAIL result

`$display` is only for simulation. It does not describe hardware.

## `$dumpfile`

`$dumpfile` specifies the VCD waveform file name.

Example:

```verilog
$dumpfile("04_testbench_practice/waves/alu_tb_refine.vcd");
```

This tells the simulator where to save the waveform data.

## `$dumpvars`

`$dumpvars` selects which signals should be recorded in the VCD file.

Example:

```verilog
$dumpvars(0, alu_tb_refine);
```

This records the signals inside the `alu_tb_refine` testbench module.

## `$finish`

`$finish` ends the simulation.

Without `$finish`, some simulations may continue running, especially when there is an `always` block such as a clock generator.

## Why Testbench Matters

Writing RTL code is not enough.

A designer must also prove that the module behaves correctly under different input conditions.

A testbench helps verify the module by applying stimulus, checking expected behavior, and generating waveforms for debugging.

## One Sentence Summary

A testbench is not hardware; it is a verification environment used to drive inputs, check outputs, and prove that the DUT behaves correctly.
