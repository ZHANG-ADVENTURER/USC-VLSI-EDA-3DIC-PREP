# Day 4: Testbench Practice

## Overview

This project refines previous Verilog testbenches by adding expected results and automatic PASS / FAIL checks.

The goal is to understand that a testbench is not hardware. A testbench is a verification environment that drives inputs, checks outputs, prints simulation results, and generates waveform files.

This practice refines the testbenches for:

* `mux2to1`
* `decoder2to4`
* `full_adder`
* `alu_4bit`

## Files

```text
04_testbench_practice/
├── notes/
│   └── testbench-notes.md
├── screenshots/
├── sim/
│   ├── alu_tb_refine.vvp
│   ├── mux2to1_tb_refine.vvp
│   ├── decoder2to4_tb_refine.vvp
│   └── full_adder_tb_refine.vvp
├── tb_refine/
│   ├── alu_tb_refine.v
│   ├── mux2to1_tb_refine.v
│   ├── decoder2to4_tb_refine.v
│   └── full_adder_tb_refine.v
├── waves/
│   ├── alu_tb_refine.vcd
│   ├── mux2to1_tb_refine.vcd
│   ├── decoder2to4_tb_refine.vcd
│   └── full_adder_tb_refine.vcd
└── README.md
```

## Module Description

| Signal            | Direction | Width | Description                            |
| ----------------- | --------- | ----: | -------------------------------------- |
| `mux2to1.a`       | input     |     1 | First input of the 2-to-1 multiplexer  |
| `mux2to1.b`       | input     |     1 | Second input of the 2-to-1 multiplexer |
| `mux2to1.sel`     | input     |     1 | Select signal                          |
| `mux2to1.y`       | output    |     1 | MUX output                             |
| `decoder2to4.in`  | input     |     2 | 2-bit decoder input                    |
| `decoder2to4.y`   | output    |     4 | 4-bit one-hot decoder output           |
| `full_adder.a`    | input     |     1 | First input bit                        |
| `full_adder.b`    | input     |     1 | Second input bit                       |
| `full_adder.cin`  | input     |     1 | Carry-in bit                           |
| `full_adder.sum`  | output    |     1 | Sum output bit                         |
| `full_adder.cout` | output    |     1 | Carry-out bit                          |
| `alu_4bit.a`      | input     |     4 | First 4-bit ALU operand                |
| `alu_4bit.b`      | input     |     4 | Second 4-bit ALU operand               |
| `alu_4bit.opcode` | input     |     2 | Selects the ALU operation              |
| `alu_4bit.result` | output    |     4 | ALU result                             |
| `alu_4bit.zero`   | output    |     1 | Becomes 1 when `result` is `0000`      |

## Testbench

The refined testbenches apply input stimulus, store expected output values, compare actual outputs with expected outputs, and print PASS or FAIL in the terminal.

Test cases:

* `mux2to1_tb_refine.v`: verifies that `y` follows `a` when `sel = 0` and follows `b` when `sel = 1`
* `decoder2to4_tb_refine.v`: verifies all four one-hot outputs for inputs `00`, `01`, `10`, and `11`
* `full_adder_tb_refine.v`: verifies all eight combinations of `a`, `b`, and `cin`
* `alu_tb_refine.v`: verifies ADD, SUB, AND, OR, zero flag behavior, and 4-bit wraparound behavior

## Waveform

Waveform files:

```text
waves/alu_tb_refine.vcd
waves/mux2to1_tb_refine.vcd
waves/decoder2to4_tb_refine.vcd
waves/full_adder_tb_refine.vcd
```

The waveforms show the relationship between input stimulus, actual DUT outputs, and expected values.

The refined ALU waveform shows `a`, `b`, `opcode`, `result`, `expected_result`, `zero`, and `expected_zero`.

The refined combinational waveforms show that the tested modules produce the correct outputs for each input case.
