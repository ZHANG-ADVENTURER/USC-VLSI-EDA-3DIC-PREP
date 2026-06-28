# 4-bit ALU and Vector Practice

## Overview

This project implements a 4-bit ALU in Verilog and verifies it using a testbench.

The ALU supports four operations: ADD, SUB, AND, and OR. The operation is selected by a 2-bit `opcode`.

In addition to the ALU project, I also practiced Verilog vectors on HDLBits. The completed HDLBits exercises include Vector0, Vector1, Vector2, Vectorgates, and Gates4. These exercises helped me review vector declaration, bit selection, part selection, bitwise operators, logical operators, and multi-input gates.

## Files

```text
03_alu/
├── HDLBits/
│   └── HDLBits.png
├── sim/
│   └── alu_4bit_tb.vvp
├── src/
│   └── alu_4bit.v
├── tb/
│   └── alu_4bit_tb.v
├── waves/
│   ├── alu_4bit.png
│   └── alu_4bit.vcd
└── README.md
```

## Module Description

| Signal   | Direction | Width | Description                          |
| -------- | --------- | ----: | ------------------------------------ |
| `a`      | input     |     4 | First 4-bit input operand            |
| `b`      | input     |     4 | Second 4-bit input operand           |
| `opcode` | input     |     2 | Selects the ALU operation            |
| `result` | output    |     4 | Result of the selected ALU operation |
| `zero`   | output    |     1 | Becomes 1 when `result` is `0000`    |

## Testbench

The testbench applies different values to `a`, `b`, and `opcode` to verify each ALU operation.

Test cases:

* ADD: `0011 + 0101 = 1000`
* SUB: `1001 - 0100 = 0101`
* AND: `1100 & 1010 = 1000`
* OR: `0101 | 0011 = 0111`
* SUB_ZERO: `0100 - 0100 = 0000`, so `zero = 1`
* ADD_WRAP: `1111 + 1111 = 11110`, but the 4-bit `result` keeps only `1110`

## Waveform

Waveform file: `waves/alu_4bit.png`

The waveform shows how `result` and `zero` change when `a`, `b`, and `opcode` change.

It verifies that `opcode = 00` selects ADD, `opcode = 01` selects SUB, `opcode = 10` selects AND, and `opcode = 11` selects OR.

The waveform also shows that `zero` becomes 1 when `result` is `0000`, and that a 4-bit ALU only keeps the lower 4 bits when an addition result is wider than 4 bits.
