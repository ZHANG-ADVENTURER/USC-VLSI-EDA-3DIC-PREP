# Day 22 Daily Log

## Topic

Digital Interview Basics

## What I Learned

Today I reviewed the main digital design concepts that commonly appear in RTL, ASIC design, DV, Physical Design, and STA interviews.

The focus was not only on remembering definitions, but also on explaining how Verilog code maps to real hardware.

I reviewed the difference between combinational and sequential logic.

Combinational logic depends only on current inputs, while sequential logic stores state and depends on previously saved values.

I also reviewed blocking and non-blocking assignments.

Blocking assignments update variables immediately and are normally used in combinational procedural logic.

Non-blocking assignments evaluate old values first and update registers afterward, which correctly models parallel flip-flop behavior.

I learned that `<=` does not independently create memory. The clocked event control, such as `always @(posedge clk)`, determines sequential storage behavior.

I reviewed latch inference and learned that an unintended latch is created when a combinational block does not assign an output on every possible path.

I also reviewed FSM structure, FIFO operation, pipeline behavior, valid/ready handshakes, memory interfaces, reset types, synthesizable RTL, bit widths, carry-out, and signed overflow.

## What I Built / Produced

Notes

Created:

`01_verilog_basics/16_digital_interview_basics/notes/digital-interview-basics.md`

The notes include:

- Combinational vs sequential logic
- State vs derived logic
- Blocking vs non-blocking assignments
- Latch vs flip-flop
- FSM structure
- Moore vs Mealy FSM
- FIFO structure and corner cases
- Pipeline throughput and latency
- Stall and bubble behavior
- Valid/ready handshake
- Datapath, control, and status classification
- Memory interface timing
- Synchronous and asynchronous reset
- Synthesizable RTL vs testbench code
- Bit width and truncation
- Signed and unsigned arithmetic
- Carry-out and signed overflow
- Common interview mistakes
- Fourteen comprehensive mock interview answers

README

Created:

`01_verilog_basics/16_digital_interview_basics/README.md`

The README summarizes the interview topics, hardware structures, important RTL rules, and review method.

Interview Practice

Completed fourteen rounds of interview-style questions.

The practice included identifying incorrect or incomplete answers and replacing them with more precise hardware-level explanations.

Code

No new RTL module was implemented.

Previously completed ALU, counter, shift register, FSM, FIFO, register file, handshake, memory interface, and pipeline projects were used as examples.

Testbench

No new testbench was created.

The review focused on conceptual reasoning and interview communication.

Waveform

No new waveform was generated.

Previously created waveforms were used to connect interview answers with actual RTL behavior.

## Key Concepts

Combinational Logic

Logic whose outputs depend only on current inputs.

It is commonly described using `assign` or `always @(*)`.

Sequential Logic

Logic that stores state using flip-flops or registers.

It is normally updated on a clock edge.

Blocking Assignment

Uses `=` and updates the left-hand side immediately.

It is normally used in combinational procedural logic.

Non-Blocking Assignment

Uses `<=` and schedules register updates after right-hand-side values are evaluated.

It is normally used in clocked sequential logic.

Unintended Latch

A storage element inferred when combinational outputs are not assigned on every possible path.

Flip-Flop

An edge-triggered storage element that samples input on a clock edge.

FSM

A control structure containing a state register, next-state logic, and output logic.

FIFO

An order-based storage structure in which the first written item is the first item read.

Valid Write

A write request that is accepted because the FIFO is not full.

`valid_write = write_en && !full`

Valid Read

A read request that is accepted because the FIFO is not empty.

`valid_read = read_en && !empty`

Throughput

The rate at which a system completes transactions.

A filled single-lane pipeline may produce one result per cycle.

Latency

The time or number of cycles required for one transaction to move from input to output.

Stall

A condition in which valid data cannot move because the downstream stage is not ready.

Bubble

An invalid pipeline entry represented by `valid = 0`.

Handshake Transfer

A successful transaction that occurs when both `valid` and `ready` are asserted.

Backpressure

A downstream inability to accept data that propagates toward upstream modules.

Read Valid

A response signal indicating that the memory read-data bus currently contains a valid result.

Synchronous Reset

A reset that is checked only at the active clock edge.

Asynchronous Reset

A reset that can affect registers without waiting for a clock edge.

Truncation

The loss of upper bits when a result is stored in a destination with insufficient width.

Carry-Out

An extra bit generated beyond the most significant bit, mainly associated with unsigned arithmetic.

Signed Overflow

A condition in which a signed result exceeds the representable range.

For signed addition, overflow occurs when operands have the same sign but the result has the opposite sign.

## Problems and Fixes

Problem

I initially described combinational logic only with `always @(*)`.

Fix

Combinational logic may be described using either continuous assignment with `assign` or procedural logic with `always @(*)`.

Problem

I initially treated `<=` as the reason sequential logic can remember values.

Fix

The clocked event control creates sequential storage behavior.

Non-blocking assignment provides the correct simulation behavior for parallel register updates.

Problem

I initially said every latch is incorrect.

Fix

A latch is a valid level-sensitive storage element.

The problem is an unintended latch inferred when combinational logic is incomplete.

Problem

I initially described FIFO empty reads as producing a bubble and latch.

Fix

An empty FIFO read is an underflow condition.

Latch inference is caused by incomplete combinational assignments, not by an illegal FIFO operation.

Problem

I initially described `write_en` as indicating a successful write.

Fix

`write_en` is only a request.

The write succeeds only when:

`write_en && !full`

Problem

I initially answered that a four-stage pipeline could produce four results per cycle.

Fix

A four-stage single-lane pipeline may contain four transactions in flight, but normally produces only one completed result per cycle after filling.

Problem

I initially described `_n` as a falling edge.

Fix

The suffix `_n` indicates an active-low signal.

`negedge` specifically refers to a falling-edge event.

Problem

I initially treated reset assertion and deassertion as fixed edge directions.

Fix

Assertion means entering the active reset state, while deassertion means leaving it.

The edge direction depends on whether the reset is active-high or active-low.

Problem

I initially classified FIFO `data_in` as control.

Fix

`data_in` is datapath because it carries payload data.

Port direction does not determine datapath or control classification.

Problem

I initially explained that `#10` is not synthesizable because it does not contain a loop.

Fix

`#10` is a simulator time delay and does not describe a fixed hardware structure.

Real hardware waiting behavior must use clock cycles, counters, FSM states, or handshakes.

Problem

I initially used carry-out and signed overflow as if they were similar indicators.

Fix

Carry-out mainly indicates unsigned range extension.

Signed overflow depends on the relationship between operand signs and the result sign.

## Connection to VLSI / EDA / 3D IC

VLSI

Digital interview concepts describe how RTL is translated into combinational gates, flip-flops, registers, memories, and control logic.

EDA

Synthesis tools infer hardware from RTL coding styles and report problems such as latch inference, width mismatch, unreachable states, and multiple drivers.

Physical Design

Pipeline depth, register count, reset structure, and datapath width affect placement, routing, congestion, area, and clock-tree load.

STA

Clocked logic, pipeline stages, latch behavior, reset recovery/removal, and register-to-register paths are directly related to timing analysis.

DV

FIFO boundary behavior, handshake rules, valid-data checking, overflow, underflow, reset behavior, and signed arithmetic are common verification targets.

3D IC

Chiplet and die-to-die interfaces also depend on valid/ready handshakes, buffering, pipeline latency, data width, reset synchronization, and interface correctness.

## One Sentence Summary

Digital design interviews test whether I can connect Verilog syntax, state behavior, interface protocols, arithmetic rules, and timing concepts to the hardware that will actually be synthesized.

## Next Step

Create an EE457 and EE560L preparation summary that connects the completed digital projects to USC coursework and future RTL, Physical Design, STA, and EDA study.