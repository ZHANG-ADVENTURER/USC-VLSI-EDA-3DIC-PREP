# Day17 Daily Log

## Topic

Datapath vs Control

## What I Learned

Today I learned the difference between datapath and control in a digital system.

The main idea is that a larger digital system is not just a collection of separate modules. It is usually organized around two major parts: datapath and control.

Datapath is the part that stores, transfers, selects, or computes actual data.

Control is the part that decides what the datapath should do and when each operation should happen.

This topic connects previous modules such as ALU, FSM, FIFO, counter, and shift register into a more system-level view.

The most important rule I learned is:

If a signal stores, carries, or computes the main data, it is usually part of the datapath.

If a signal decides what operation happens, when data moves, or whether an operation is allowed, it is usually part of the control or status logic.

## What I Built / Produced

Today I produced a datapath and control concept note.

Produced file:

- `01_verilog_basics/11_datapath_control/notes/datapath-control-notes.md`

The note includes:

- definition of datapath
- definition of control
- difference between datapath, control, and status signals
- examples using ALU, FIFO, and FSM
- classification practice
- simple datapath/control diagram
- connection to VLSI / EDA / Physical Design / STA
- connection to USC courses

No Verilog source code, testbench, simulation, or waveform was required today because this topic focused on digital architecture understanding rather than a new RTL implementation.

## Key Concepts

Datapath

Datapath is the part of a digital system where data is stored, transferred, selected, or computed. Examples include registers, muxes, ALUs, memory arrays, buses, data inputs, and data outputs.

Control

Control is the part of a digital system that decides how the datapath behaves. Examples include mux select signals, ALU opcode, write enable, read enable, FSM state, valid signals, and ready signals.

Status Signal

A status signal reports the current condition of a module and is often used by control logic. Examples include full, empty, done, busy, valid, and ready.

ALU

The ALU itself belongs to the datapath because it computes data. The ALU opcode belongs to control because it decides which operation the ALU performs.

FIFO

A FIFO contains both datapath and control/status logic. The memory array, data input, and data output are datapath. The write enable, read enable, full flag, empty flag, valid write, and valid read signals are control or status logic.

FSM

An FSM is mainly control logic. It stores the current state and generates decisions based on the current state and input conditions.

Datapath-Control Separation

Datapath carries and processes data. Control decides how and when the datapath operates.

## Problems and Fixes

Problem:

At first, it was easy to classify any FIFO-related signal as datapath because FIFO stores data.

Fix:

I clarified that not all FIFO signals are datapath. For example, `data_in`, `data_out`, and `mem` are datapath signals because they carry or store real data. However, `full`, `empty`, `valid_read`, and `valid_write` are control/status signals because they decide or describe whether operations are allowed.

Problem:

I initially classified `full` as datapath.

Fix:

I corrected this by understanding that `full` does not carry payload data. It reports the FIFO condition and helps decide whether another write is allowed. Therefore, it is better classified as a control/status signal.

Problem:

It was not always obvious whether a module belongs entirely to datapath or entirely to control.

Fix:

I learned that some modules contain both. FIFO is a good example because it contains data storage and data movement, but also pointers, flags, and valid operation logic.

Problem:

I previously studied ALU, FSM, FIFO, and counter as separate modules.

Fix:

Today I started connecting them into a system-level structure. ALU is mainly datapath, FSM is mainly control, and FIFO combines datapath with control/status logic.

## Connection to VLSI / EDA / 3D IC

Datapath and control separation is important for VLSI and EDA because RTL structure affects later synthesis, Physical Design, and STA.

Datapath often contains wider signals and larger logic blocks, such as ALUs, buses, register files, memory arrays, and data paths between registers. These structures can strongly affect area, wirelength, routing congestion, timing delay, and power.

Control logic often includes FSMs, enable signals, select signals, operation codes, and status signals. These signals decide when data moves and which operation happens.

In STA, both datapath and control create timing paths. A datapath timing path may involve arithmetic logic, muxes, and buses. A control timing path may involve FSM outputs, enable signals, and select signals.

Understanding datapath vs control prepares me for later topics such as register-to-register timing paths, setup timing, hold timing, slack, timing closure, RTL-to-GDS flow, and OpenROAD.

For 3D IC and advanced packaging, this topic also matters because system-level data movement between blocks, memory, chiplets, and interconnect structures requires both datapath design and control coordination.

## One Sentence Summary

Today I learned that datapath stores, transfers, and computes data, while control decides what the datapath should do and when each operation should happen.

## Next Step

Continue Week 3 Digital Architecture Bridge by studying register file basics, including read ports, write ports, address-based access, and the difference between register file and FIFO.