# SystemVerilog Awareness

## Overview

This project documents the basic SystemVerilog awareness concepts needed before moving into more modern RTL coding style.

The goal is not to fully switch from Verilog to SystemVerilog yet. The goal is to understand why modern RTL code often uses SystemVerilog syntax and how it maps to the Verilog concepts already learned.

The main concepts covered are:

- `logic`
- `always_comb`
- `always_ff`
- `always_latch`
- Verilog `wire` / `reg` vs SystemVerilog `logic`
- Verilog `always @(*)` vs SystemVerilog `always_comb`
- Verilog `always @(posedge clk)` vs SystemVerilog `always_ff`
- how to classify previous ALU, FSM, FIFO, and counter examples in SystemVerilog style

The most important idea is that SystemVerilog does not change the basic RTL hardware thinking. It makes the designer's intent clearer.

## Files

| File / Folder | Description |
|---|---|
| `notes/systemverilog_awareness.md` | Concept note explaining `logic`, `always_comb`, `always_ff`, `always_latch`, and RTL classification rules |
| `README.md` | Project explanation |

## Module Description

No new RTL module was implemented in this project.

This project is a concept-awareness note.

The main SystemVerilog constructs discussed are:

| Construct | Purpose | Hardware Meaning |
|---|---|---|
| `logic` | General signal declaration | A signal type, not a guarantee of register hardware |
| `always_comb` | Combinational logic block | Used when output is calculated from current inputs |
| `always_ff` | Clocked sequential logic block | Used when a signal must remember previous values across clock cycles |
| `always_latch` | Latch-intent block | Used only when latch behavior is intentional |
| `assign` | Continuous assignment | Used for simple combinational connections or status flags |

The main classification rule is:

| Design Intent | Verilog Style | SystemVerilog Style |
|---|---|---|
| Simple combinational connection | `assign` | `assign` |
| Combinational calculation block | `always @(*)` | `always_comb` |
| Clocked storage logic | `always @(posedge clk)` | `always_ff @(posedge clk)` |
| General signal declaration | `wire` / `reg` | `logic` |

## Testbench

No testbench was created for this project.

The purpose of this project was to understand SystemVerilog coding style and hardware intent before writing `.sv` files.

The notes include classification examples based on previous Verilog projects:

- ALU `result` is combinational logic and maps to `always_comb`.
- Counter `count` is stored register logic and maps to `always_ff`.
- FSM `current_state` is stored state and maps to `always_ff`.
- FSM `next_state` is combinational calculation and maps to `always_comb`.
- FIFO `full` and `empty` are combinational status flags and map to `assign`.
- FIFO `write_ptr`, `read_ptr`, and `count` are stored values and map to `always_ff`.

The key verification idea is conceptual rather than simulation-based:

If a signal needs to remember previous cycles, it should be clocked storage logic.

If a signal only calculates from current values, it should be combinational logic.

## Waveform

No waveform was generated for this project.

This project focused on concept notes instead of RTL simulation.

A future SystemVerilog practice project could include rewriting a previous Verilog module, such as an ALU, FSM, or FIFO, using SystemVerilog-style constructs.

The expected future waveform behavior would remain the same as the Verilog version because SystemVerilog does not change the intended hardware behavior. It only makes the RTL coding style clearer.