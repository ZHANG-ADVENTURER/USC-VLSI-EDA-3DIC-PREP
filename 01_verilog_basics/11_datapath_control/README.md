# Datapath vs Control

## Overview

This project documents the difference between datapath and control in a digital system.

In previous projects, I practiced individual modules such as ALU, counter, FSM, FIFO, and register file. This project moves from single-module thinking to system-level organization.

A digital system can often be separated into two major parts:

Datapath

The part that stores, transfers, selects, or computes actual data.

Control

The part that decides what the datapath should do and when each operation should happen.

This project also introduces status signals, which report the current condition of a module and help control decisions.

The key idea is:

Datapath carries and processes data.

Control decides how and when the datapath operates.

## Files

| File / Folder | Description |
|---|---|
| `notes/datapath_control_notes.md` | Concept note explaining datapath, control, status signals, classification rules, and a simple datapath/control diagram |
| `README.md` | Project explanation |

## Module Description

No Verilog RTL module was implemented in this project.

This project is a concept and architecture note.

The main system components discussed are:

| Item | Classification | Description |
|---|---|---|
| Register | Datapath | Stores actual data values |
| MUX | Datapath | Selects which data value moves forward |
| ALU | Datapath | Computes data |
| Memory array | Datapath | Stores actual data |
| Bus | Datapath | Transfers data between blocks |
| FSM | Control | Generates decisions over time |
| `mux_sel` | Control | Selects which mux input is used |
| `alu_op` | Control | Decides which ALU operation is performed |
| `write_en` | Control | Decides whether a register or memory should be written |
| `read_en` | Control | Decides whether a read operation is requested |
| `full` | Status / Control | Reports whether a FIFO has no free space |
| `empty` | Status / Control | Reports whether a FIFO has no valid data |
| `valid` | Status / Control | Indicates meaningful data is available |
| `ready` | Status / Control | Indicates the receiver can accept data |

The simple system discussed in the notes contains:

| Component | Classification | Reason |
|---|---|---|
| Register A | Datapath | Stores actual data |
| Register B | Datapath | Stores actual data |
| MUX | Datapath | Selects a data value |
| ALU | Datapath | Computes data |
| Output Register | Datapath | Stores result data |
| Control Unit | Control | Generates decision signals |
| `mux_sel` | Control | Controls MUX selection |
| `alu_op` | Control | Controls ALU operation |
| `out_write_en` | Control | Controls whether the output register stores the result |

## Testbench

No testbench was created for this project.

The goal was to understand digital architecture organization before writing a new RTL implementation.

The notes include classification practice using previous projects:

- ALU result belongs to datapath.
- ALU opcode belongs to control.
- FIFO memory array and data input/output belong to datapath.
- FIFO write enable, read enable, full flag, empty flag, and valid operation signals belong to control/status.
- FSM is mainly control logic.
- Register file data belongs to datapath.
- Register file write enable and address signals are control-related.

The main classification rules are:

- If a signal stores, carries, or computes the actual data, it is usually datapath.
- If a signal decides what operation happens, it is usually control.
- If a signal reports whether a module can act or has completed something, it is usually status/control.
- A module can contain both datapath and control.

## Waveform

No waveform was generated for this project.

This project focused on conceptual understanding and diagram-based explanation.

The notes include a simple datapath/control diagram with:

- Register A
- Register B
- MUX
- ALU
- Output Register
- Control Unit
- `mux_sel`
- `alu_op`
- `out_write_en`

A future RTL version could implement this small datapath and controller, then generate a waveform showing:

- input register values
- mux selection
- ALU operation selection
- output register write enable
- output register update at the clock edge

This would connect datapath/control theory to simulation and waveform verification.