# Day07 Daily Log

## Topic

Sequential Logic: D Flip-Flop and 4-bit Counter

## What I Learned

- I learned the difference between combinational logic and sequential logic.
- I learned that sequential logic updates only on a clock edge.
- I learned how to use `always @(posedge clk)` to describe clocked behavior.
- I learned that `en` and `reset` are control signals, but they do not update the counter immediately.
- I learned that a synchronous reset only takes effect on the rising edge of the clock.
- I learned why a testbench may wait `#1` after a clock edge before checking the output.

## What I Built / Produced

- Code:
  - `05_counter/src/dff.v`
  - `05_counter/src/counter_4bit.v`

- Testbench:
  - `05_counter/tb/counter_4bit_tb.v`

- Waveform:
  - `05_counter/waves/counter_4bit.vcd`
  - `05_counter/waves/counter_4bit.png`

- Notes:
  - Sequential logic updates state only on clock edges.
  - `en = 1` prepares the counter to increment, but the increment happens only at the next `posedge clk`.
  - `reset = 1` clears the counter only at the next clock edge because this design uses synchronous reset.

- README:
  - `05_counter/README.md`

## Key Concepts

Clock edge  
A clock edge is the moment when the clock changes value. In this project, the counter updates only on the rising edge of the clock.

Sequential logic  
Sequential logic depends on both current inputs and previous state. A counter remembers its previous count value.

D Flip-Flop  
A D flip-flop stores one bit of data and updates its output only on the rising edge of the clock.

Synchronous reset  
A synchronous reset is checked only at the clock edge. It does not reset the output immediately when the reset signal changes.

Enable signal  
The enable signal controls whether the counter is allowed to update. When `en = 0`, the counter holds its current value.

Non-blocking assignment  
The `<=` operator is used in clocked sequential logic so that register updates happen in a controlled way at the clock edge.

Testbench delay  
The `#1` delay after `@(posedge clk)` allows the DUT output to update before the testbench checks the result.

## Problems and Fixes

- Problem:
  I initially thought that when `en = 1` and `clk = 1`, the counter should immediately increment.

- Fix:
  I learned that `clk = 1` is not the same as `posedge clk`. The counter only updates at the instant when the clock changes from `0` to `1`.

- Problem:
  I was confused about why the testbench waits `#1` after the clock edge.

- Fix:
  I learned that non-blocking assignments update after the clock edge event, so the testbench waits briefly before checking the output.

## Connection to VLSI / EDA / 3D IC

Sequential logic is the foundation of real digital systems. In VLSI and Physical Design, most timing paths are register-to-register paths, such as DFF to combinational logic to DFF. Understanding how counters and flip-flops update on clock edges prepares me for STA concepts such as setup time, hold time, clock period, slack, and timing closure.

## One Sentence Summary

Today I learned how sequential logic uses clock edges to store and update state, and I built a 4-bit counter with enable and synchronous reset.

## Next Step

- Learn blocking vs non-blocking assignments.
- Compare two shift register designs.
- Use waveform results to understand why `=` and `<=` behave differently in Verilog.