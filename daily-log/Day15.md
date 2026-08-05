# Day15 Daily Log

## Topic

SystemVerilog Awareness: `logic`, `always_comb`, `always_ff`, and `always_latch`

## What I Learned

Today I learned the basic purpose of SystemVerilog in modern RTL design.

The main point is that SystemVerilog does not completely change the hardware thinking behind Verilog. Instead, it makes the designer's intent clearer.

In Verilog, `reg` can be confusing because it does not always mean a real hardware register. A signal declared as `reg` may still describe combinational logic if it is assigned inside an `always @(*)` block.

SystemVerilog improves this by using `logic` as a more general signal type and using clearer procedural blocks such as `always_comb` and `always_ff`.

I also reviewed how to classify previous Verilog design patterns into SystemVerilog style:

- simple continuous combinational logic uses `assign`
- combinational calculation blocks use `always_comb`
- clocked storage logic uses `always_ff`
- latch behavior uses `always_latch`, but it should usually be avoided unless intentional

## What I Built / Produced

Today I produced a SystemVerilog awareness note.

Produced file:

- `01_verilog_basics/10_systemverilog_awareness/notes/systemverilog-awareness.md`

The note explains:

- why Verilog `reg` can be misleading
- how SystemVerilog `logic` reduces confusion
- how `always_comb` maps to combinational logic
- how `always_ff` maps to clocked sequential logic
- why `always_latch` should be treated carefully
- how previous ALU, FSM, and FIFO examples translate into SystemVerilog coding style

No simulation or waveform was required today because the purpose of Day15 was concept awareness, not a new RTL project.

## Key Concepts

`logic`

A general SystemVerilog signal type that can replace many beginner-level uses of Verilog `wire` and `reg`. However, `logic` itself does not decide whether the hardware is combinational or sequential.

`always_comb`

A SystemVerilog block used for combinational logic. It is similar in purpose to Verilog `always @(*)`. It should be used when the output is calculated immediately from current inputs.

`always_ff`

A SystemVerilog block used for clocked sequential logic. It should be used when the signal needs to remember values across clock cycles.

`always_latch`

A SystemVerilog block used for intentional latch behavior. In beginner RTL design, latch behavior should usually be avoided unless the design specifically requires it.

`assign`

A continuous assignment used for simple combinational connections or simple status flags, such as FIFO `full`, `empty`, `valid_write`, and `valid_read`.

`current_state`

The stored state in an FSM. It is sequential logic and should be implemented with clocked logic.

`next_state`

The calculated next state in an FSM. It is combinational logic because it is computed from the current state and current inputs.

## Problems and Fixes

Problem:

I previously focused too much on whether a signal should be declared as `wire` or `reg`.

Fix:

Today I clarified that the better first question is not whether the signal is `wire` or `reg`, but whether the signal needs to remember previous values.

If the signal needs to remember previous cycles, it belongs in clocked logic.

If the signal only calculates from current values, it belongs in combinational logic.

Problem:

The word `reg` in Verilog can make it seem like every `reg` is a physical register.

Fix:

I learned that Verilog `reg` only means the signal can be assigned inside a procedural block. The actual hardware depends on whether the block is clocked or combinational.

Problem:

I needed a faster way to classify previous RTL examples.

Fix:

I classified common examples:

- FIFO `count` uses `always_ff`
- ALU `result` uses `always_comb`
- FSM `current_state` uses `always_ff`
- FSM `next_state` uses `always_comb`
- FIFO `full` uses `assign`
- FIFO `write_ptr` uses `always_ff`

## Connection to VLSI / EDA / 3D IC

SystemVerilog is important because many modern RTL design and verification flows use SystemVerilog style.

For VLSI and EDA, this helps build cleaner RTL coding habits before moving into synthesis, timing analysis, and RTL-to-GDS flow.

For Physical Design and STA, the distinction between combinational logic and sequential logic is critical. Register boundaries, clocked logic, and combinational paths directly affect timing paths, setup checks, hold checks, and timing closure.

For 3D IC and packaging-aware design, the RTL itself is still the starting point of the implementation flow. Understanding clean RTL structure helps connect high-level digital logic to physical implementation constraints later.

## One Sentence Summary

Today I learned that SystemVerilog keeps the same RTL hardware thinking as Verilog, but uses clearer syntax such as `logic`, `always_comb`, and `always_ff` to separate signal declaration, combinational logic, and clocked storage logic.

## Next Step

Move to Day16 and summarize the digital foundation built so far, including Verilog modules, testbench strategy, waveform usage, FSM, FIFO, and the SystemVerilog awareness bridge.