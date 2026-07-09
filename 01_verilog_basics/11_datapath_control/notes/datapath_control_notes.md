# Datapath vs Control Notes

## Topic

Datapath vs Control

## Overview

This note explains the difference between datapath and control in a digital system.

In previous projects, I practiced individual modules such as ALU, counter, FSM, and FIFO. Starting from this topic, the focus moves from single modules to system-level organization.

The key question is:

How do different digital blocks work together inside a larger system?

A digital system can often be separated into two major parts:

Datapath

The part that stores, transfers, and processes data.

Control

The part that decides what the datapath should do.

---

## 1. What Is Datapath?

Datapath is the part of a digital system where data actually moves and gets processed.

It answers questions such as:

Where does the data come from?

Which hardware block does the data pass through?

Where is the data stored?

Where does the result go?

Common datapath components include:

- registers
- muxes
- ALUs
- adders
- shifters
- memory arrays
- buses
- data input signals
- data output signals

For example:

register A -> ALU -> register B

In this path, data is read from register A, processed by the ALU, and written into register B.

This is datapath because real data values are being stored, transferred, and computed.

---

## 2. What Is Control?

Control is the part of a digital system that decides how the datapath behaves.

Control does not usually carry the main data payload. Instead, it sends command-like signals to datapath components.

It answers questions such as:

Which input should the mux select?

Which operation should the ALU perform?

Should this register be written this cycle?

Should memory read or write happen?

Should FIFO accept a write?

Should FIFO allow a read?

Common control signals include:

- mux select
- ALU opcode
- register write enable
- memory read enable
- memory write enable
- FIFO write enable
- FIFO read enable
- FSM state
- valid signal
- ready signal
- full flag
- empty flag

For example:

alu_op = 2'b00 means ALU should perform addition.

mux_sel = 1 means the mux should choose input 1.

write_en = 1 means the register is allowed to update at the clock edge.

These signals control the movement and operation of data.

---

## 3. Datapath vs Control in a Small System

A simple system may contain:

- register A
- register B
- mux
- ALU
- output register
- controller

The datapath looks like this:

register A

register B

mux

ALU

output register

The control logic sends signals such as:

mux_sel

alu_op

output_register_write_en

The datapath carries and processes the actual data.

The control logic decides which operation happens and when it happens.

---

## 4. Example: ALU

In an ALU system:

ALU inputs

Datapath.

They are real data values.

ALU result

Datapath.

It is the computed data result.

alu_op or opcode

Control.

It decides which operation the ALU performs.

Important distinction:

The ALU itself belongs to the datapath because it computes data.

The opcode belongs to control because it selects the operation.

---

## 5. Example: FIFO

FIFO contains both datapath and control/status logic.

FIFO datapath elements:

data_in

The data entering the FIFO.

data_out

The data leaving the FIFO.

mem

The memory array that stores FIFO data.

FIFO control/status elements:

write_en

Controls whether a write is requested.

read_en

Controls whether a read is requested.

valid_write

Shows whether the requested write is allowed.

valid_read

Shows whether the requested read is allowed.

full

Shows whether the FIFO has no free space.

empty

Shows whether the FIFO has no valid data.

write_ptr

Tracks where the next write should occur.

read_ptr

Tracks where the next read should occur.

count

Tracks how many valid elements are stored.

Important note:

Some FIFO signals are internal state or status signals. They are not main payload data, but they control or describe the behavior of the datapath.

For example, full is not datapath data. It is a status/control signal because it tells the system whether another write is allowed.

---

## 6. Example: FSM

An FSM is mainly control logic.

An FSM stores the current state and generates control decisions based on the current state and inputs.

For example, a traffic light FSM does not perform large data computation.

Instead, it controls which light should be active.

A sequence detector FSM does not process wide arithmetic data.

Instead, it controls when detected should become 1.

FSM current_state

Control state.

It stores where the controller currently is.

FSM next_state

Combinational control calculation.

It calculates where the controller should go next.

FSM output signals

Usually control or status signals.

They tell other parts of the system what should happen.

---

## 7. Datapath, Control, and Status

Not every signal is purely datapath or pure control.

Some signals are better described as status signals.

Status signals report the current condition of a module and are often used by control logic.

Examples:

full

A FIFO status signal showing no free space.

empty

A FIFO status signal showing no valid data.

done

A status signal showing an operation has completed.

busy

A status signal showing a module is still working.

valid

A status/control signal showing data is meaningful.

ready

A status/control signal showing the receiver can accept data.

These signals are not the main data payload, but they influence when data can move.

A useful classification is:

datapath

Stores, transfers, or computes the main data.

control

Decides which operation happens.

status

Reports module condition and helps control decisions.

---

## 8. Classification Practice

ALU result

Datapath.

It is the actual computed data.

alu_op

Control.

It decides which ALU operation is performed.

mux_sel

Control.

It decides which mux input is selected.

register file data

Datapath.

It is the actual stored operand or result data.

write_en

Control.

It decides whether a write operation is allowed.

current_state

Control/status.

It stores the current state of the controller.

data_out

Datapath.

It is the actual output data.

full

Control/status.

It reports whether the FIFO is full and controls whether another write is allowed.

memory array

Datapath.

It stores actual data values.

valid_read

Control/status.

It reports whether the current read operation is valid.

---

## 9. Main Rules

Rule 1

If a signal stores, carries, or computes the actual data, it is usually datapath.

Examples:

data_in

data_out

ALU result

register data

memory array

bus

Rule 2

If a signal decides what operation happens, it is usually control.

Examples:

alu_op

mux_sel

write_en

read_en

reg_write_en

mem_write

Rule 3

If a signal reports whether a module can act or has completed something, it is usually status/control.

Examples:

full

empty

valid

ready

done

busy

Rule 4

FSMs are usually control logic because they generate decisions over time.

Rule 5

A module can contain both datapath and control.

FIFO is a good example because it has data storage and data movement, but also pointers, flags, and valid operation logic.

---

## 10. Connection to Previous Projects

ALU

The ALU result belongs to the datapath.

The opcode belongs to control.

Counter

The count value is stored state.

If the count is used as the main value being processed, it can be considered datapath.

The enable and reset signals are control.

FSM

The FSM is mainly control logic.

It stores current_state and generates control outputs.

FIFO

The FIFO memory array and data input/output are datapath.

The write enable, read enable, full flag, empty flag, and valid operation signals are control/status.

SystemVerilog Awareness

SystemVerilog makes the separation clearer by encouraging explicit coding style:

always_ff for stored state

always_comb for combinational decision logic

assign for simple status or connection logic

---

## 11. Connection to VLSI / EDA / Physical Design / STA

Datapath and control separation is important for VLSI and EDA because physical implementation depends on the structure of RTL.

Datapath often contains wider signals and larger logic blocks, such as ALUs, buses, register files, and memory interfaces.

Control logic often contains FSMs, enable signals, mux select signals, and operation codes.

In Physical Design, datapath structures can affect:

- area
- wirelength
- placement
- routing congestion
- timing delay
- power

In STA, datapath and control both create timing paths.

A basic timing path can be understood as:

launch register -> combinational logic -> capture register

Datapath timing paths may involve arithmetic logic, muxes, and buses.

Control timing paths may involve FSM outputs, enables, and select signals.

Understanding datapath vs control helps me later understand register-to-register paths, setup timing, hold timing, slack, and timing closure.

---

## 12. Connection to USC Courses

EE457

Datapath and control are central to digital system design. CPU organization, FSMs, registers, ALUs, and memory interfaces all depend on this distinction.

EE560L

Structured RTL design requires clean separation between data movement and control decisions.

EE577B

More advanced VLSI design and implementation projects require understanding how RTL structure affects synthesis and physical implementation.

---

---

## 13. Simple Datapath and Control Diagram

The following diagram shows a small digital system separated into datapath and control.

    Control Unit
    +----------------+
    |                |
    |  FSM / Control |
    |                |
    +----------------+
        |      |      |
        |      |      |
     mux_sel alu_op out_write_en
        |      |      |
        v      v      v

    Datapath

    +----------------+        +-----+        +-----+        +----------------+
    | Register A     |------->|     |        |     |        | Output Register |
    | data source    |        | MUX |------->| ALU |------->| result storage  |
    +----------------+        |     |        |     |        +----------------+
                              +-----+        +-----+
    +----------------+           ^
    | Register B     |-----------|
    | data source    |
    +----------------+

In this system, the datapath contains:

- Register A
- Register B
- MUX
- ALU
- Output Register

These blocks store, transfer, select, or compute actual data.

The control unit generates:

- mux_sel
- alu_op
- out_write_en

These control signals decide how the datapath behaves.

---

## 14. How to Read the Diagram

Register A and Register B store data values.

The MUX selects which register value should enter the ALU.

The ALU performs an operation on the selected data.

The Output Register stores the ALU result at the clock edge.

The Control Unit does not directly process the main data.

Instead, it controls the datapath by sending command-like signals.

mux_sel

Decides whether the MUX selects Register A or Register B.

alu_op

Decides whether the ALU performs add, subtract, AND, OR, or another operation.

out_write_en

Decides whether the Output Register should store the ALU result at the next clock edge.

---

## 15. Datapath / Control Separation in This Diagram

| Item | Classification | Reason |
|---|---|---|
| Register A | Datapath | Stores actual data |
| Register B | Datapath | Stores actual data |
| MUX | Datapath | Selects which data value moves forward |
| ALU | Datapath | Computes data |
| Output Register | Datapath | Stores result data |
| Control Unit | Control | Generates decisions |
| mux_sel | Control | Decides MUX input selection |
| alu_op | Control | Decides ALU operation |
| out_write_en | Control | Decides whether result is stored |

---

## 16. Why This Matters

A larger digital system is usually not just a collection of random modules.

It is organized around two major ideas:

Datapath

Where the data moves and gets processed.

Control

What tells the datapath what to do.

This separation is the bridge from small Verilog modules to larger digital architecture.

In later topics, register files, memory interfaces, handshakes, and pipelines will all use the same idea:

data movement plus control decisions.

The key idea is:

Datapath carries and processes the data.

Control decides how and when the datapath operates.

## One Sentence Summary

Datapath stores, transfers, and computes data, while control decides what the datapath should do and when operations should happen.
