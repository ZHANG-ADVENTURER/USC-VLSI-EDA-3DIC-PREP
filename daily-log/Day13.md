# Day13 Daily Log

## Topic

Simple FIFO RTL

## What I Learned

Today I implemented a simple single-clock FIFO in Verilog.

The FIFO stores 8-bit data and has a depth of 4. It uses a memory array to store data, a write pointer to decide where the next data should be written, a read pointer to decide where the next data should be read, and a count register to track how many valid data values are currently inside the FIFO.

I learned that `full` and `empty` can be generated from the count value:

`full = (count == 4)`

`empty = (count == 0)`

I also learned that `write_en` and `read_en` are only requests. A real write should only happen when the FIFO is not full, and a real read should only happen when the FIFO is not empty.

The valid operation rules are:

`valid_write = write_en && !full`

`valid_read = read_en && !empty`

I also built a self-checking testbench that automatically verifies FIFO behavior through terminal `pass` messages instead of relying only on waveform inspection.

## What I Built / Produced

- Code:
  - `src/simple_fifo.v`

- Testbench:
  - `tb/simple_fifo_tb.v`

- Simulation:
  - `sim/simple_fifo_tb.vvp`

- Waveform:
  - `waves/simple_fifo.vcd`

- Notes:
  - Continued using `notes/fifo-notes.md` from Day12

- README:
  - `README.md`

The terminal output showed that all FIFO test cases passed.

## Key Concepts

FIFO

A FIFO is a First In, First Out buffer. The first data written into the FIFO should be the first data read out.

Memory Array

The memory array stores the actual data values inside the FIFO.

In this project, the FIFO memory is:

`reg [7:0] mem [0:3];`

This means the FIFO has 4 storage locations, and each location stores 8 bits.

Write Pointer

The write pointer points to the memory location where the next valid write will store data.

Read Pointer

The read pointer points to the memory location where the next valid read will get data.

Count Register

The count register tracks how many valid data values are currently inside the FIFO.

For this depth-4 FIFO:

`count = 0` means the FIFO is empty.

`count = 4` means the FIFO is full.

Full Flag

The `full` flag becomes 1 when the FIFO has no free space.

In this design:

`full = (count == 4)`

Empty Flag

The `empty` flag becomes 1 when the FIFO has no valid data to read.

In this design:

`empty = (count == 0)`

Valid Write

A valid write happens only when `write_en = 1` and `full = 0`.

If the FIFO is full, the write request should be ignored.

Valid Read

A valid read happens only when `read_en = 1` and `empty = 0`.

If the FIFO is empty, the read request should be ignored.

Overflow Protection

Overflow protection means preventing new data from being written when the FIFO is already full.

In the testbench, I attempted to write `8'h55` after the FIFO was full, and the FIFO correctly kept the original stored values.

Underflow Protection

Underflow protection means preventing invalid reads when the FIFO is empty.

In the testbench, I attempted to read after the FIFO was empty, and the FIFO correctly remained empty.

Self-Checking Testbench

A self-checking testbench compares actual DUT outputs with expected results and prints `pass` or `fail` automatically.

This is stronger than only looking at a waveform because the testbench directly verifies correctness.

## Problems and Fixes

- Problem:
  I was not fully sure how to decide which signals should be module ports and which signals should stay inside the RTL source file as internal signals.

- Fix:
  I learned that ports are the interface between the module and the outside world. If a signal is given by the outside, it should be an input port. If a signal needs to be observed by the outside, it should be an output port. Signals that are only used to implement the module internally should remain internal signals.

  In the FIFO design, `clk`, `reset`, `write_en`, `read_en`, and `data_in` are input ports because they are controlled by the testbench or an external module. `data_out`, `full`, and `empty` are output ports because the outside needs to observe them. In contrast, `mem`, `write_ptr`, `read_ptr`, `count`, `valid_write`, and `valid_read` are internal signals because they are only used to implement the FIFO behavior.

- Problem:
  I was unsure whether I should write the internal RTL logic first and then go back to declare missing signals.

- Fix:
  I learned that a better RTL design flow is to decide the module interface first, then decide the internal storage and internal combinational signals, and finally write the logic. Small missing declarations can still be fixed during debugging, but the main design should start from the interface and hardware structure rather than from random logic code.

  A useful design order is:

  1. Define what the module should do.
  2. Decide the input and output ports.
  3. Decide what the module needs to remember internally.
  4. Decide what the module needs to calculate immediately.
  5. Write sequential logic and combinational logic separately.

- Problem:
  I knew the rule that clocked logic usually uses `<=` and combinational logic usually uses `=`, but I still had difficulty quickly deciding whether a piece of logic is sequential or combinational.

- Fix:
  I learned to classify signals by hardware meaning instead of only looking at syntax. If a signal needs to remember previous information, it is storage/state and should be updated in `always @(posedge clk)` using non-blocking assignment `<=`. If a signal is only calculated from current values, it is combinational logic and should use `assign` or `always @(*)` with blocking assignment `=`.

  In the FIFO design, `mem`, `write_ptr`, `read_ptr`, `count`, and `data_out` are sequential because they store data or state across clock cycles. `full`, `empty`, `valid_write`, and `valid_read` are combinational because they are immediately calculated from current values.

- Problem:
  I confused “a signal staying the same” with “a signal having memory.”

- Fix:
  I learned that a combinational signal can stay the same if its inputs stay the same, but that does not mean it is storing memory. For example, in an FSM, `next_state` may remain `S_1` if `current_state` and `bit_in` do not change, but `next_state` is still only a combinational calculation. The signal that actually stores the FSM state is `current_state`, because it only updates on the clock edge.

  A useful way to remember this is:

  `next_state` is the calculated destination.

  `current_state` is the stored state.

- Problem:
  The FIFO testbench needed to verify not only basic write and read behavior, but also full and empty behavior.

- Fix:
  I added test cases for reset, normal write/read, filling the FIFO, overflow attempt, reading all stored data, and underflow attempt.

- Problem:
  Waveform inspection was not necessary for final verification today.

- Fix:
  I still generated the `.vcd` waveform file, but used terminal-based self-checking output as the main verification evidence.

## Connection to VLSI / EDA / 3D IC

FIFO is a practical RTL building block used in real digital systems. It is commonly used to buffer data between producer and consumer modules, especially when different parts of a design do not operate at the exact same rate.

This project connects to VLSI and ASIC design because it combines memory, pointers, flags, control logic, and sequential behavior in one module. These are all important concepts for larger RTL designs.

It also connects to verification because the testbench checks expected behavior automatically. In real chip projects, engineers need to prove that modules work correctly before synthesis and physical implementation.

For Physical Design and STA, this FIFO also matters because the design contains registers, memory-like storage, control paths, and data paths. These structures eventually become timing paths that need to be synthesized, placed, routed, and checked.

## One Sentence Summary

Today I implemented and verified a simple single-clock FIFO, learning how memory, pointers, count logic, full/empty flags, and self-checking testbenches work together in a realistic RTL module.

## Next Step

Continue to Day14: SystemVerilog awareness, focusing on `logic`, `always_comb`, `always_ff`, and the difference between Verilog and SystemVerilog coding style.