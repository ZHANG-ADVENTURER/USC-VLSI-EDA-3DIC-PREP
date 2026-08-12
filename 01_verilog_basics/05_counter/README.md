# DFF and 4-bit Counter

## Overview

This project introduces sequential logic in Verilog. It implements a basic D flip-flop and a 4-bit counter with enable and synchronous reset.

Unlike combinational logic, sequential logic does not update immediately when an input changes. The counter only updates on the rising edge of the clock.

## Files

```text
05_counter/
├── src/
│   ├── dff.v
│   └── counter_4bit.v
├── tb/
│   └── counter_4bit_tb.v
├── sim/
│   └── counter_4bit_tb.vvp
├── waves/
│   ├── counter_4bit.vcd
│   ├── counter_4bit_sim.png
│   └── counter_4bit_wave.png
└── README.md
```

## Module Description

### `dff.v`

| Signal | Direction | Width | Description |
| `clk` | input | 1 | Clock signal |
| `d` | input | 1 | Data input |
| `q` | output | 1 | Stored output value |

### `counter_4bit.v`

| Signal | Direction | Width | Description |
| `clk` | input | 1 | Clock signal |
| `reset` | input | 1 | Synchronous reset signal |
| `en` | input | 1 | Enable signal |
| `count` | output | 4 | 4-bit counter output |

The counter behavior is:

- When `reset = 1`, `count` is reset to `0000` at the next rising edge of `clk`.
- When `reset = 0` and `en = 1`, `count` increments by 1 at each rising edge of `clk`.
- When `reset = 0` and `en = 0`, `count` holds its current value.

## Testbench

The testbench verifies the 4-bit counter by generating a clock, applying reset and enable signals, and comparing the actual output with the expected output.

The clock is generated using:

```verilog
always #5 clk = ~clk;
```

This creates a clock with a 10 ns period.

Test cases:

- Reset counter to `0000`
- Count from `0000` to `0001`
- Count from `0001` to `0010`
- Count from `0010` to `0011`
- Hold the current count when `en = 0`
- Reset the counter again

The testbench uses `expected_count` to compare with the actual `count` output and prints PASS or FAIL messages in the terminal.

## Waveform

Waveform screenshots: [`waves/counter_4bit_sim.png`](waves/counter_4bit_sim.png) and [`waves/counter_4bit_wave.png`](waves/counter_4bit_wave.png)

The waveform shows that `count` only updates on the rising edge of `clk`.

When `reset = 1`, the counter resets to `0000`. When `en = 1`, the counter increments on each rising clock edge. When `en = 0`, the counter holds its previous value.

The waveform also compares `count` with `expected_count` to confirm that the counter behavior matches the expected result.
