# Stage Summary 1

## Topic

Verilog RTL Foundation, Simulation Workflow, FSM, FIFO, Self-Checking Testbench, and SystemVerilog Awareness

## Overview

This stage summary consolidates the first two weeks of my VLSI / EDA / 3D IC summer preparation.

The main purpose of this stage was to build a practical RTL foundation through Verilog source code, testbench writing, simulation, waveform debugging, structured verification, FSM design, FIFO design, and SystemVerilog awareness.

The learning path was:

Week 1: Verilog basics -> combinational logic -> ALU -> testbench practice -> sequential logic -> blocking vs non-blocking assignment

Week 2: FSM concept -> traffic light FSM -> sequence detector FSM -> FIFO concept -> simple FIFO RTL -> self-checking testbench -> SystemVerilog awareness

The most important result of this stage is that I started to understand RTL design as a connection between hardware behavior, code structure, simulation results, verification strategy, and future physical implementation.

---

## Stage 1 Scope

| Stage Component | Main Focus | Main Output |
|---|---|---|
| Week 1 | Verilog basics and simulation workflow | Basic gates, combinational modules, ALU, testbenches, counter, shift register, waveform analysis |
| Week 2 | FSM, FIFO, verification, and SystemVerilog awareness | Traffic light FSM, sequence detector FSM, FIFO notes, simple FIFO RTL, self-checking testbench, SystemVerilog notes |

---

## Part 1: Verilog Toolchain and Project Workflow

I established the basic Verilog project workflow:

```text
Verilog source code -> testbench -> iverilog -> vvp -> VCD -> GTKWave
```

This workflow helped me understand how different project files connect together:

- source code describes the hardware module
- testbench applies inputs and checks outputs
- `iverilog` compiles the design and testbench
- `vvp` runs the simulation
- VCD files record signal activity
- GTKWave displays signal changes over simulation time

I also practiced organizing each project using a GitHub-ready structure:

```text
src/
tb/
sim/
waves/
notes/
README.md
```

This created a repeatable workflow for later RTL, Physical Design, STA, and OpenROAD practice.

---

## Part 2: Basic Combinational Logic

I practiced basic combinational logic modules, including:

- AND gate
- mux
- decoder
- full adder
- ALU

The key rule is:

Combinational logic output depends only on current input values.

Examples:

```text
mux output = function(sel, input signals)
decoder output = function(input code)
full adder output = function(a, b, cin)
ALU result = function(a, b, opcode)
```

These modules do not need a clock because they do not store previous values.

---

## Part 3: ALU Design

I built a 4-bit ALU using `always @(*)` and `case`.

The ALU supported operations such as:

| Opcode | Operation | Meaning |
|---|---|---|
| `2'b00` | ADD | `a + b` |
| `2'b01` | SUB | `a - b` |
| `2'b10` | AND | `a & b` |
| `2'b11` | OR | `a | b` |

The ALU helped me move from simple gates to structured RTL design.

The key lesson was that a large `case` statement does not automatically mean sequential logic. The ALU is still combinational logic because the output is calculated from current inputs only.

---

## Part 4: Testbench Practice

I improved my testbench style from simple stimulus generation to verification-oriented testbench design.

A better testbench should:

- apply stimulus
- drive DUT inputs
- define expected results
- compare actual output with expected output
- print PASS / FAIL messages
- generate waveform files for debugging

This helped me understand that a testbench is not hardware. It is a verification environment used to check whether the DUT behaves correctly.

This was an important step from “running a simulation” to “verifying a design.”

---

## Part 5: Sequential Logic

I practiced sequential logic through:

- D flip-flop
- counter
- shift register

The key rule is:

Sequential logic stores information across clock cycles and updates on a clock edge.

Example:

```verilog
always @(posedge clk) begin
    ...
end
```

Important lessons included:

- `clk = 1` is not the same as `posedge clk`
- `posedge clk` means the instant when the clock changes from `0` to `1`
- enable signals prepare an action, but the stored value updates only at the clock edge
- synchronous reset only takes effect at the clock edge
- `#1` after `@(posedge clk)` in a testbench gives the DUT output time to update before checking

---

## Part 6: Blocking vs Non-Blocking Assignment

I compared blocking and non-blocking assignment using shift register examples.

Blocking assignment uses:

```verilog
=
```

It updates immediately and sequentially inside a procedural block.

Non-blocking assignment uses:

```verilog
<=
```

It schedules updates to happen together at the clock edge.

The waveform comparison showed that blocking assignment can allow data to pass through multiple stages in one clock edge, while non-blocking assignment shifts data one stage per clock cycle.

Main rule:

Use non-blocking assignment for clocked sequential logic.

```verilog
always @(posedge clk) begin
    q <= d;
end
```

Use blocking assignment for combinational logic inside `always @(*)`.

```verilog
always @(*) begin
    y = a & b;
end
```

---

## Part 7: FSM Design

I learned that an FSM is a digital control structure that moves between states based on:

- current state
- input conditions
- clock cycles

The standard FSM structure includes:

- state register
- next-state logic
- output logic

The most important distinction is:

`current_state`

This is the real stored state. It is sequential logic.

`next_state`

This is the calculated next state. It is combinational logic.

This helped me understand that a signal staying the same does not automatically mean it stores memory. If it is recalculated from unchanged inputs, it may still be combinational logic.

---

## Part 8: Traffic Light FSM

I practiced writing a traffic light controller using FSM structure.

This project helped me understand how state-based control logic works in a realistic example.

The traffic light FSM strengthened my understanding of:

- state definition
- state transition
- output generation
- clocked state update
- three-block FSM style

It showed how a digital system can control output behavior by moving through defined states over time.

---

## Part 9: Sequence Detector FSM

I designed and verified a sequence detector FSM.

This project helped me practice the full design process:

```text
specification -> state definition -> state transition -> RTL -> testbench -> verification
```

The important concepts included:

- target sequence
- state encoding
- overlapping detection
- Moore FSM output
- cycle-by-cycle checking

The key lesson was that a sequence detector is not just a coding problem. It requires translating a behavior requirement into a state diagram and then into RTL.

---

## Part 10: FIFO Concept

I learned the basic structure of a single-clock FIFO.

FIFO means First In, First Out.

The first data written into the FIFO must be the first data read out.

The main FIFO components are:

- memory array
- write pointer
- read pointer
- count register
- full flag
- empty flag
- valid write condition
- valid read condition

The most important distinction is:

FIFO is order-based access.

A register file or memory is address-based access.

In FIFO, the user does not randomly choose which stored data to read. The read pointer determines the next valid data based on FIFO order.

---

## Part 11: Simple FIFO RTL

I implemented a simple single-clock FIFO with:

- 8-bit data width
- 4-entry depth
- synchronous reset
- write enable
- read enable
- full flag
- empty flag

The internal structure included:

- `mem`
- `write_ptr`
- `read_ptr`
- `count`
- `valid_write`
- `valid_read`

The FIFO write pointer, read pointer, and count register are sequential logic because they must remember previous values.

The full, empty, valid_write, and valid_read signals are combinational logic because they are calculated from current values.

Example:

```verilog
assign full        = (count == 4);
assign empty       = (count == 0);
assign valid_write = write_en && !full;
assign valid_read  = read_en && !empty;
```

The FIFO project helped me connect storage, pointer movement, status flags, and valid operation conditions.

---

## Part 12: Self-Checking Testbench

I improved my verification style by using self-checking testbenches.

The FIFO testbench included:

- task-based checking
- expected values
- actual output comparison
- PASS / FAIL messages
- reset verification
- normal write and read tests
- full condition test
- overflow attempt
- empty condition test
- underflow attempt

This was an important improvement because real verification should not depend only on manually inspecting waveforms.

Waveforms are still useful for debugging timing and signal transitions, but self-checking testbenches are better for repeated verification.

---

## Part 13: SystemVerilog Awareness

I learned the basic purpose of SystemVerilog in modern RTL design.

The main concepts were:

- `logic`
- `always_comb`
- `always_ff`
- `always_latch`

The key point is that SystemVerilog does not change the basic hardware thinking behind RTL design. It makes design intent clearer.

In Verilog, `reg` can be confusing because it does not always mean a physical register.

SystemVerilog improves clarity by using:

- `logic` for general signal declaration
- `always_comb` for combinational logic
- `always_ff` for clocked sequential logic
- `always_latch` for intentional latch behavior

Example classification:

| Signal / Logic | Hardware Meaning | SystemVerilog Style |
|---|---|---|
| ALU `result` | Current-input calculation | `always_comb` |
| FSM `current_state` | Stored state | `always_ff` |
| FSM `next_state` | Current-state calculation | `always_comb` |
| FIFO `count` | Stored occupancy value | `always_ff` |
| FIFO `write_ptr` | Stored pointer | `always_ff` |
| FIFO `read_ptr` | Stored pointer | `always_ff` |
| FIFO `full` | Current count flag | `assign` |
| FIFO `empty` | Current count flag | `assign` |

---

## Key Concepts

### Module

A Verilog module describes a hardware block.

### Port

A port is the external interface of a module.

Inputs are signals provided by the outside world.

Outputs are signals the outside world needs to observe or use.

### Internal Signal

An internal signal is used only inside the module implementation.

Examples include temporary wires, state registers, pointers, counters, and internal valid signals.

### DUT

DUT means Device Under Test. It is the hardware module being tested by the testbench.

### Testbench

A testbench applies inputs, checks outputs, and verifies whether the DUT works correctly.

### Waveform

A waveform shows how signals change over simulation time.

It is useful for debugging clock behavior, reset behavior, state transitions, and timing relationships.

### Combinational Logic

Combinational logic depends only on current input values.

Examples:

- mux
- decoder
- full adder
- ALU
- FSM next-state logic
- FIFO full / empty flags

### Sequential Logic

Sequential logic stores information across clock cycles.

Examples:

- D flip-flop
- counter
- shift register
- FSM current state
- FIFO write pointer
- FIFO read pointer
- FIFO count

### Clock Edge

A clock edge is the instant when the clock changes value.

Most sequential logic in this stage updated on:

```verilog
posedge clk
```

### Synchronous Reset

A synchronous reset only takes effect at the active clock edge.

### Blocking Assignment

Blocking assignment uses `=` and executes immediately in order.

It is commonly used in combinational `always @(*)` blocks.

### Non-Blocking Assignment

Non-blocking assignment uses `<=` and schedules updates to occur together at the clock edge.

It is commonly used in sequential `always @(posedge clk)` blocks.

### FSM

An FSM is a state-based control structure.

It uses stored state and transition logic to control behavior over time.

### FIFO

A FIFO is an ordered buffer.

It stores data and guarantees first-in, first-out behavior.

### SystemVerilog Awareness

SystemVerilog introduces clearer RTL coding constructs such as `logic`, `always_comb`, and `always_ff`.

---

## Main Classification Rules

### Rule 1: If a signal needs to remember previous cycles, it is sequential logic.

Examples:

- counter value
- shift register contents
- FSM `current_state`
- FIFO `write_ptr`
- FIFO `read_ptr`
- FIFO `count`

Use:

```verilog
always @(posedge clk)
```

or SystemVerilog style:

```systemverilog
always_ff @(posedge clk)
```

---

### Rule 2: If a signal is calculated only from current values, it is combinational logic.

Examples:

- ALU result
- mux output
- decoder output
- FSM `next_state`
- FIFO `full`
- FIFO `empty`
- FIFO `valid_write`
- FIFO `valid_read`

Use:

```verilog
assign
```

or:

```verilog
always @(*)
```

or SystemVerilog style:

```systemverilog
always_comb
```

---

### Rule 3: Complexity does not determine whether logic is sequential.

A large `case` statement can still be combinational logic.

A simple counter can still be sequential logic.

The real question is:

```text
Does this signal need to remember previous cycles?
```

---

### Rule 4: Ports and internal signals should be separated clearly.

Ports are the module interface.

Internal signals are implementation details.

Example:

FIFO ports:

- `clk`
- `reset`
- `write_en`
- `read_en`
- `data_in`
- `data_out`
- `full`
- `empty`

FIFO internal signals:

- `mem`
- `write_ptr`
- `read_ptr`
- `count`
- `valid_write`
- `valid_read`

---

## Problems and Fixes

### Problem 1: Confusing `clk = 1` with `posedge clk`

Fix:

I learned that `clk = 1` is a clock level, while `posedge clk` is the transition from `0` to `1`.

Sequential logic updates at the edge, not simply because the clock is high.

---

### Problem 2: Expecting enable signals to update hardware immediately

Fix:

I learned that enable signals such as `en`, `write_en`, and `read_en` only prepare an operation.

The actual register update happens at the active clock edge.

---

### Problem 3: Checking testbench outputs too early

Fix:

I used a small delay such as `#1` after `@(posedge clk)` so the DUT output has time to update before checking.

---

### Problem 4: Confusing blocking and non-blocking assignment

Fix:

I compared blocking and non-blocking shift registers.

The non-blocking version better matched real flip-flop behavior because all registers updated together at the clock edge.

---

### Problem 5: Confusing `current_state` and `next_state`

Fix:

I clarified that `current_state` is the stored FSM state, while `next_state` is the combinational calculation of the next state.

---

### Problem 6: Confusing port signals and internal signals

Fix:

I used the interface rule:

If the outside world needs to drive it or observe it, it should be a port.

If it is only used to implement the module internally, it should stay as an internal signal.

---

### Problem 7: Relying too much on waveform inspection

Fix:

I started using self-checking testbenches with expected values and PASS / FAIL output.

Waveforms are still useful for debugging, but self-checking testbenches are better for repeated verification.

---

### Problem 8: Misunderstanding Verilog `reg`

Fix:

I learned that Verilog `reg` does not always mean a physical register.

The actual hardware depends on whether the signal is assigned in clocked logic or combinational logic.

SystemVerilog improves this by using `logic`, `always_comb`, and `always_ff`.

---

## Connection to USC Courses

### EE457

This stage supports digital design foundations, including combinational logic, sequential logic, FSMs, counters, datapath/control preparation, and state-based system behavior.

### EE560L

This stage supports RTL coding, testbench writing, waveform debugging, and structured verification practice.

### EE577B

This stage provides preparation for more advanced RTL design, synthesis-aware coding style, and later digital implementation projects.

---

## Connection to VLSI / EDA / Physical Design / STA

This stage is important for VLSI and EDA because all later implementation work starts from RTL.

Combinational modules represent logic between registers.

Sequential modules represent registers and state elements.

A basic timing path can be understood as:

```text
launch register -> combinational logic -> capture register
```

This connects directly to later topics such as:

- synthesis
- standard cells
- RTL-to-GDS flow
- placement
- routing
- setup timing
- hold timing
- slack
- STA
- timing closure

FSM state registers, FIFO pointers, FIFO count registers, counters, and shift registers create sequential boundaries.

Combinational logic between these boundaries becomes timing paths.

Therefore, the distinction between combinational and sequential logic is not only a coding issue. It is also a Physical Design and STA issue.

---

## Connection to 3D IC / Advanced Packaging

This stage is still mostly digital design foundation, but it supports the later 3D IC direction.

In 2.5D / 3D IC systems, data movement between blocks, chiplets, memory, and interconnect structures is critical.

FIFO concepts, valid read/write control, and clean RTL structure are useful for understanding data buffering and communication between system components.

This foundation will later connect to chiplet communication, packaging-aware system integration, timing-aware physical implementation, and system-level data movement.

---

## Stage 1 Deliverables

By the end of this stage, I produced:

- Verilog source files
- testbench files
- simulation outputs
- VCD waveform files
- waveform screenshots
- README files
- daily logs
- Week 1 summary
- Week 2 summary
- SystemVerilog awareness notes
- FIFO notes
- blocking vs non-blocking notes
- self-checking testbench examples

These outputs make the learning process visible, organized, and GitHub-ready.

---

## One Sentence Summary

In Stage 1, I built a practical RTL foundation by learning Verilog syntax, combinational and sequential logic, testbench verification, waveform debugging, FSM design, FIFO buffering, and SystemVerilog-aware coding style.
