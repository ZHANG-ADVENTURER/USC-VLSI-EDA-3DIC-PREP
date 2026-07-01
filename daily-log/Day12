# Day12 Daily Log

## Topic

FIFO Concept + HDLBits Module Hierarchy Practice

## What I Learned

Today I learned the basic concept of a FIFO and practiced Verilog module instantiation problems on HDLBits.

For the FIFO part, I learned that FIFO means First In, First Out. The first data written into the FIFO should be the first data read out. A FIFO is used as a buffer between hardware modules when data is produced and consumed at different times.

I also learned the main internal parts of a simple FIFO:

- memory array
- write pointer
- read pointer
- count register
- full flag
- empty flag

The write pointer controls where the next data value is stored, and the read pointer controls where the next data value is read from. The count register keeps track of how many valid data values are currently inside the FIFO.

I learned that only comparing `write_ptr` and `read_ptr` is not enough to decide whether a FIFO is empty or full, because both empty and full can happen when the two pointers are equal. To make the first FIFO design easier, I will use a `count` register to generate `full` and `empty`.

For the HDLBits part, I practiced module hierarchy and module instantiation. I learned how to instantiate a module by position and by name, how to connect submodule ports to top-level signals, and how to use internal wires to connect multiple module instances together.

I also practiced using provided D flip-flop modules to build a shift register. Instead of writing the DFF behavior manually with `always @(posedge clk)`, I used the provided `my_dff` and `my_dff8` modules and connected them in series.

## What I Built / Produced

- Notes:
  - Created and expanded `fifo-notes.md`
  - Wrote notes for FIFO concept, circular buffer behavior, write/read rules, full/empty detection, and FIFO data flow

- HDLBits:
  - Completed module instantiation practice
  - Completed connecting ports by position
  - Completed connecting ports by name
  - Completed three-module DFF shift-register practice
  - Worked on module/vector practice using `my_dff8` and a 4-to-1 mux

- README:
  - Not written today
  - FIFO README will be written after Day13, when the FIFO RTL, testbench, waveform, and full verification are completed

## Key Concepts

FIFO

A FIFO is a First In, First Out data buffer. The first data written into the FIFO must be the first data read out.

Memory Array

The memory array stores the actual data values inside the FIFO. For example, `reg [7:0] mem [0:3]` means four storage locations, each storing 8 bits.

Write Pointer

The write pointer points to the next memory location where new data will be written.

Read Pointer

The read pointer points to the next memory location where data will be read.

Circular Buffer

The pointers move through fixed memory locations and wrap around after reaching the last location. For a depth-4 FIFO, the pointer movement is `0 -> 1 -> 2 -> 3 -> 0`.

Valid Write

A valid write happens only when `write_en = 1` and `full = 0`.

The condition is:

`valid_write = write_en && !full`

Valid Read

A valid read happens only when `read_en = 1` and `empty = 0`.

The condition is:

`valid_read = read_en && !empty`

Overflow

Overflow means trying to write into a FIFO when it is already full. In a simple safe FIFO design, the write should be ignored when `full = 1`.

Underflow

Underflow means trying to read from a FIFO when it is empty. In a simple safe FIFO design, the read should be ignored when `empty = 1`.

Count Register

The count register stores how many valid data values are currently inside the FIFO. For a depth-4 FIFO, `count = 0` means empty and `count = 4` means full.

Module Instantiation

Module instantiation means creating an instance of an existing module inside another module. The module type must be the provided submodule name, while the instance name can be chosen by the designer.

Port Connection by Position

Connecting by position means signals are connected according to the order of the ports in the submodule declaration.

Example:

`mod_a ins1 (out1, out2, a, b, c, d);`

Port Connection by Name

Connecting by name means each signal is connected to a specific port using `.port_name(signal_name)`. This is usually safer and clearer than connecting by position.

Internal Wire

An internal wire connects submodule outputs to other submodule inputs inside the top module. The wire name itself has no special meaning; its function comes from what it connects.

Shift Register

A shift register can be built by chaining D flip-flops together. The output of one DFF becomes the input of the next DFF.

Combinational Mux

A mux can be described using `always @(*)` and `case`. If an output is assigned inside an `always` block, it should be declared as `reg` in Verilog, even if the synthesized hardware is combinational logic.

Verilog Number Format

Verilog constants follow the format:

`<width>'<base><value>`

Examples:

`2'b00` means 2-bit binary 0.

`2'd0` means 2-bit decimal 0.

`2'h0` means 2-bit hexadecimal 0.

These can represent the same value, but binary is often clearer when working with selector signals such as `sel[1:0]`.

## Problems and Fixes

- Problem:
  I initially instantiated `top_module` inside `top_module` instead of instantiating the provided submodule.

- Fix:
  I learned that the first word in a module instantiation must be the module type, such as `mod_a`, not the current top module.

- Problem:
  I mixed up port connection by position and by name.

- Fix:
  For by-position problems, I should write signals in the exact order of the submodule port list. For by-name problems, I should use `.port_name(signal_name)`.

- Problem:
  I was unsure how Verilog knows what `q1` and `q2` mean when I declare internal wires.

- Fix:
  I learned that wire names do not automatically have meaning. Verilog understands their role from the port connections. For example, if `q1` connects `dff1.q` to `dff2.d`, then it becomes the wire between the first and second DFF.

- Problem:
  In the module/vector shift-register problem, I connected the third DFF output directly to `q`.

- Fix:
  I learned that the third DFF output should first go to an internal wire such as `q3`, because the final output `q` should come from a 4-to-1 mux that selects between `d`, `q1`, `q2`, and `q3`.

- Problem:
  I reversed assignment direction in the mux case statement.

- Fix:
  The correct assignment direction is `q = selected_signal`, not `selected_signal = q`.

- Problem:
  I was confused by constants like `2'h0`.

- Fix:
  I learned that `2'h0`, `2'd0`, and `2'b00` can all represent a 2-bit zero, but `2'b00` is more visually clear for a 2-bit selector.

## Connection to VLSI / EDA / 3D IC

FIFO is a real RTL building block used in digital systems to buffer data between modules. It is more realistic than simple combinational circuits because it includes memory, control signals, pointers, flags, and clocked behavior.

Understanding FIFO helps prepare for RTL design, digital verification, ASIC implementation, and system-level hardware design. In larger chips, FIFOs are often used between modules that operate at different rates or need temporary data buffering.

The HDLBits module hierarchy exercises are also important for VLSI and EDA because real designs are built hierarchically. Larger chips are not written as one flat block. They are built by instantiating smaller modules, connecting ports, and using internal wires to build structured hardware.

This connects to future Physical Design and STA because hierarchical RTL eventually becomes a hierarchy of synthesized gates, timing paths, registers, and interconnects.

## One Sentence Summary

Today I learned the core structure of a simple FIFO and strengthened my understanding of Verilog module hierarchy by practicing module instantiation, internal wires, DFF chaining, and mux-based output selection.

## Next Step

Continue to Day13 by implementing `simple_fifo.v`, writing `simple_fifo_tb.v`, testing write/read/full/empty behavior, generating the waveform, and then writing the full FIFO README.