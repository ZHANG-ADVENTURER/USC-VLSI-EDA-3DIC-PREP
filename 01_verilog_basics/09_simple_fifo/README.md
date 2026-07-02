# Simple FIFO

## Overview

This project implements a simple single-clock FIFO in Verilog.

The FIFO stores 8-bit data values and has a depth of 4. It supports write and read operations using `write_en` and `read_en`.

The FIFO uses a memory array, a write pointer, a read pointer, and a count register. The `full` and `empty` flags are generated from the count value.

This project also includes a self-checking testbench that verifies basic write/read behavior, FIFO full behavior, overflow protection, empty behavior, and underflow protection.

## Files

| File / Folder | Description |
|---|---|
| `src/simple_fifo.v` | Verilog RTL source code for the simple FIFO |
| `tb/simple_fifo_tb.v` | Self-checking testbench for the FIFO |
| `sim/simple_fifo_tb.vvp` | Compiled simulation output |
| `waves/simple_fifo.vcd` | Generated waveform file |
| `notes/fifo-notes.md` | FIFO concept notes |
| `README.md` | Project explanation |

## Module Description

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `clk` | input | 1 | Clock signal |
| `reset` | input | 1 | Synchronous reset signal |
| `write_en` | input | 1 | Write request signal |
| `read_en` | input | 1 | Read request signal |
| `data_in` | input | 8 | Data written into the FIFO |
| `data_out` | output | 8 | Data read from the FIFO |
| `full` | output | 1 | Indicates that the FIFO is full |
| `empty` | output | 1 | Indicates that the FIFO is empty |

## Testbench

The testbench verifies the FIFO using a self-checking method.

The testbench applies write and read operations, compares the actual output with the expected output, and prints `pass` messages in the terminal.

Test cases:

- Reset the FIFO and check that `empty = 1`
- Write `8'hA1` and `8'hB2`
- Read back `8'hA1` and `8'hB2` in the correct order
- Fill the FIFO with `8'h11`, `8'h22`, `8'h33`, and `8'h44`
- Check that `full = 1` after four writes
- Attempt to write `8'h55` when the FIFO is full
- Read back the original four values and confirm that `8'h55` was not stored
- Attempt to read when the FIFO is empty
- Check that the FIFO remains empty after the underflow attempt

The terminal output shows that all test cases passed.

