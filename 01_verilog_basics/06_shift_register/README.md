# Blocking vs Non-blocking Shift Register

## Overview

This project compares blocking assignment (`=`) and non-blocking assignment (`<=`) in Verilog sequential logic.

Two shift register modules are implemented and simulated with the same input stimulus. The waveform shows how blocking assignment and non-blocking assignment produce different behaviors in clocked logic.

## Files

```text
06_shift_register/
├── notes/
│   └── blocking-vs-nonblocking.md
├── sim/
│   └── shift_compare_tb.vvp
├── src/
│   ├── shift_blocking.v
│   └── shift_nonblocking.v
├── tb/
│   └── shift_compare_tb.v
├── waves/
│   ├── shift_compare.vcd
│   └── shift_compare.png
└── README.md
```

## Module Description

### `shift_blocking.v`

| Signal | Direction | Width | Description |
| `clk` | input | 1 | Clock signal |
| `reset` | input | 1 | Synchronous reset signal |
| `d` | input | 1 | Serial data input |
| `q1` | output | 1 | First shift register stage |
| `q2` | output | 1 | Second shift register stage |
| `q3` | output | 1 | Third shift register stage |

This module uses blocking assignment (`=`) inside a clocked `always @(posedge clk)` block.

### `shift_nonblocking.v`

| Signal | Direction | Width | Description |
| `clk` | input | 1 | Clock signal |
| `reset` | input | 1 | Synchronous reset signal |
| `d` | input | 1 | Serial data input |
| `q1` | output | 1 | First shift register stage |
| `q2` | output | 1 | Second shift register stage |
| `q3` | output | 1 | Third shift register stage |

This module uses non-blocking assignment (`<=`) inside a clocked `always @(posedge clk)` block.

## Testbench

The testbench instantiates both shift register modules and applies the same clock, reset, and input signal `d`.

The input `d` is set to `1` for one clock cycle and then returns to `0`. This allows the waveform to show how the value moves through the shift register stages.

Test behavior:

- Reset both shift registers.
- Set `d = 1` for one clock cycle.
- Set `d = 0`.
- Observe how `q1`, `q2`, and `q3` change in both versions.

In the non-blocking version, the `1` shifts one stage per clock cycle.

In the blocking version, the `1` can pass through multiple stages in the same clock edge during simulation.

## Waveform

Waveform file: `waves/shift_compare.png`

The waveform compares:

```text
q1_b, q2_b, q3_b
q1_nb, q2_nb, q3_nb
```

The `_b` signals come from the blocking version.

The `_nb` signals come from the non-blocking version.

The waveform shows that the non-blocking version behaves like a real three-stage shift register, while the blocking version allows the input value to propagate through the stages immediately within the same clocked block.