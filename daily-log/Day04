# Day 04 Daily Log

## Topic

4-bit ALU, opcode-controlled combinational logic, and Verilog vector practice

## What I Learned

* I learned how to build a 4-bit ALU using `always @(*)` and `case`.
* I learned how a 2-bit `opcode` can select different ALU operations.
* I learned the difference between bitwise AND / OR and normal arithmetic operations.
* I learned that a 4-bit result only keeps the lower 4 bits when the full result is wider than 4 bits.
* I learned how `zero` can be used as a flag to indicate whether the ALU result is `0000`.
* I practiced Verilog vectors on HDLBits, including vector declaration, bit selection, part selection, bitwise operators, logical operators, and multi-input gates.
* I reviewed why `reg` and `wire` depend on how a signal is driven, not simply whether the signal is an input or output.

## What I Built / Produced

* Code: `src/alu_4bit.v`
* Testbench: `tb/alu_4bit_tb.v`
* Simulation output: `sim/alu_4bit_tb.vvp`
* Waveform file: `waves/alu_4bit.vcd`
* Waveform screenshot: `waves/alu_4bit.png`
* HDLBits screenshot: `HDLBits/HDLBits.png`
* README: `README.md`

## Key Concepts

### ALU

An ALU is an Arithmetic Logic Unit.

It performs arithmetic operations such as addition and subtraction, and logic operations such as AND and OR.

### Opcode

Opcode means operation code.

In this project, the 2-bit `opcode` decides which ALU operation is selected.

### `always @(*)`

`always @(*)` describes combinational logic.

In this ALU, it recalculates `result` whenever `a`, `b`, or `opcode` changes.

### `case`

`case` selects one branch from multiple possible operations.

In this project, `case (opcode)` selects ADD, SUB, AND, or OR.

### `assign`

`assign` describes continuous combinational logic.

In this project, it is used to generate the `zero` flag from the current value of `result`.

### Zero Flag

The zero flag becomes 1 when the ALU result is `0000`.

This kind of flag is commonly used in processors and control logic.

### Vector

A vector is a multi-bit signal.

For example, `input [3:0] a` means `a` is a 4-bit input.

### Bitwise Operation

A bitwise operation calculates each bit separately.

For example, `1100 & 1010 = 1000`.

### Logical Operation

A logical operation treats the whole vector as one boolean value.

This is different from a bitwise operation, which works bit by bit.

### `reg` and `wire`

`reg` is used for signals assigned inside `initial` or `always` blocks.

`wire` is used for signals driven by `assign` statements or module outputs.

## Problems and Fixes

### Problem

The `.vcd` waveform file was not generated correctly at first.

### Fix

The problem was caused by a path mismatch between the testbench `$dumpfile` path and the terminal working directory. I fixed it by running the simulation from the `03_alu/` folder and using `waves/alu_4bit.vcd`.

### Problem

The terminal output showed only a 1-bit `result`.

### Fix

The testbench had declared `result` as a 1-bit wire. I fixed it by changing `wire result;` to `wire [3:0] result;`.

### Problem

The waveform was hard to read in GTKWave.

### Fix

I focused on the essential signals: `a`, `b`, `opcode`, `result`, and `zero`. I also learned that wide helper signals can make the waveform harder to read if they are expanded bit by bit.

## Connection to VLSI / EDA / 3D IC

The ALU is a basic datapath module in digital design.

In real VLSI design, RTL modules like this are synthesized into gates and standard cells. These standard cells are later placed, routed, and checked through timing analysis.

This project helps me connect Verilog RTL behavior to actual hardware implementation.

The HDLBits vector practice is also important because real digital systems use buses, multi-bit signals, bit selections, and bitwise operations extensively.

## One Sentence Summary

Today I built and verified a 4-bit ALU and practiced Verilog vectors, which helped me understand opcode-controlled combinational logic and multi-bit signal operations.

## Next Step

* Continue practicing combinational and sequential modules.
* Review testbench writing and waveform reading.
* Prepare for the next module: counter or sequential logic.
