# Day20 Daily Log

## Topic

Memory Interface Awareness

## What I Learned

Today I learned the basic concept of a memory interface in a digital system.

A memory interface is the group of address, data, and control signals used by a module to read from or write to memory.

The main idea is:

address + data + control = memory interface

I also learned what a bus means in digital design.

A bus is not one single wire. It is a group of parallel signal lines used together.

For example, `write_data[7:0]` is an 8-bit data bus. It contains 8 parallel wires and can carry an 8-bit value.

The most important distinction is:

A data bus carries data.

A memory array stores data.

I also reviewed the difference between memory, register file, and FIFO.

A register file and memory both use address-based access. This means an address selects which location to read or write.

A FIFO uses order-based access. This means the first data written must be the first data read.

Another important concept is memory latency.

A register file can use combinational read, where the output changes after the read address changes.

A larger memory often uses synchronous read, where the read data may become valid one or more clock cycles after the read request.

## What I Built / Produced

Today I produced a memory interface concept note and README file.

Produced files:

- `01_verilog_basics/14_memory_interface_basics/notes/memory-interface-basics.md`
- `01_verilog_basics/14_memory_interface_basics/README.md`

The notes include:

- definition of memory interface
- explanation of bus
- data bus
- address bus
- control signals
- basic memory model
- memory write operation
- memory read operation
- combinational read
- synchronous read
- read latency
- register file vs memory
- FIFO vs memory
- memory interface signal classification
- memory interface diagram
- memory interface and valid/ready handshake connection

No RTL source code, testbench, simulation, or waveform was required today because the goal was memory interface awareness rather than a new Verilog implementation.

## Key Concepts

Memory Interface

A memory interface is the group of signals used by a module to access memory. It usually includes address, data, and control signals.

Bus

A bus is a group of parallel signal lines used together. An 8-bit bus has 8 wires, and a 32-bit bus has 32 wires.

Data Bus

A data bus carries actual data values. Examples include `write_data[7:0]` and `read_data[7:0]`. A data bus belongs to the datapath.

Address Bus

An address bus selects which memory location should be accessed. For example, a 4-bit address bus can select 16 locations because 2^4 = 16.

Control Signal

A control signal decides what operation happens. Examples include `write_en`, `read_en`, `valid`, and `ready`.

Memory Array

A memory array stores data. For example, `mem[0]` to `mem[15]` can represent 16 memory locations.

Write Operation

A write operation stores data into memory. It is usually clocked because the memory contents are being updated.

Read Operation

A read operation returns data from memory. It can be combinational or synchronous depending on the memory design.

Combinational Read

In combinational read, the output can change after the address changes. This is similar to the register file project.

Synchronous Read

In synchronous read, the memory returns data after a clock edge, often with one-cycle latency.

Read Latency

Read latency means the read data is not available immediately after the address is provided. It may become valid in a later clock cycle.

Address-Based Access

Address-based access means the user selects a storage location using an address. Register files and memories use address-based access.

Order-Based Access

Order-based access means data must be read in the same order it was written. FIFO uses order-based access.

## Problems and Fixes

Problem:

I initially described a data bus as something that stores data.

Fix:

I corrected this distinction. A data bus carries data, while a register or memory array stores data.

Problem:

I initially thought a 4-bit address could access only 4 locations.

Fix:

I learned that an n-bit address can select 2^n locations. Therefore, a 4-bit address can select 16 locations.

Problem:

I thought register file and memory are both instant because both use address-based access.

Fix:

I learned that both are address-based, but their read timing can be different. A register file can use combinational read, while larger memory often uses synchronous read and may have read latency.

Problem:

It was easy to confuse memory and FIFO because both store data.

Fix:

I clarified that memory uses address-based access, while FIFO uses order-based access.

Problem:

The README originally mentioned a separate `diagrams/` folder.

Fix:

I corrected the README because the diagram is included directly inside `notes/memory-interface-basics.md`, so no separate diagram folder is needed.

## Connection to VLSI / EDA / 3D IC

Memory interface basics are important for VLSI and EDA because most digital systems need to move data between logic blocks and storage structures.

In RTL design, memory interfaces define how modules read and write stored data.

In Physical Design, address buses, data buses, control signals, and memory blocks affect placement, routing, wirelength, congestion, timing delay, and power.

Data buses can be wide and create routing pressure.

Address decoding can create timing delay.

Control signals such as `read_en`, `write_en`, `valid`, and `ready` create control timing paths.

In STA, memory-related paths may include register-to-memory address paths, register-to-memory write data paths, memory read data to register paths, and control signal paths.

For 3D IC and advanced packaging, memory interface awareness is also important because chiplets, memory blocks, interposers, and high-bandwidth interfaces all require organized data movement and control coordination.

## One Sentence Summary

Today I learned that a memory interface combines address, data, and control signals to allow a digital module to read from or write to memory.

## Next Step

Continue Week 3 Digital Architecture Bridge by studying pipeline concepts, including pipeline stages, register boundaries, throughput, latency, and their connection to STA.