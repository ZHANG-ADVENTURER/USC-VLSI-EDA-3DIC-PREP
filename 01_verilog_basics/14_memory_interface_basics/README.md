# Memory Interface Basics

## Overview

This project documents the basic concept of a memory interface in a digital system.

A memory interface is the group of address, data, and control signals used by a module to read from or write to memory.

The goal of this project is to understand how a digital module accesses memory, how address and data buses work, and why memory access may have latency.

This topic connects previous work on register file, FIFO, datapath/control separation, and valid/ready handshake.

The main idea is:

address + data + control = memory interface

## Files

| File / Folder | Description |
|---|---|
| `notes/memory-interface-basics.md` | Concept note explaining memory interface signals, bus types, read/write behavior, latency, signal classification rules, and the memory interface diagram |
| `README.md` | Project explanation |

## Module Description

No Verilog RTL module was implemented in this project.

This project is a concept and architecture note.

The main memory interface signals discussed are:

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `clk` | input | 1 | Clock signal used for synchronous memory operations |
| `reset` | input | 1 | Reset signal for initializing control state if needed |
| `addr` | module to memory | design-dependent | Address bus used to select the memory location |
| `write_en` | module to memory | 1 | Control signal that enables a write operation |
| `write_data` | module to memory | design-dependent | Data bus carrying the value to be written into memory |
| `read_en` | module to memory | 1 | Control signal that enables a read operation |
| `read_data` | memory to module | design-dependent | Data bus carrying the value returned from memory |
| `valid` | request side to receiver | 1 | Optional control/status signal indicating that a memory request is valid |
| `ready` | receiver to request side | 1 | Optional control/status signal indicating that the memory side can accept or complete the request |

The key signal groups are:

| Signal Group | Example | Main Role |
|---|---|---|
| Address bus | `addr[3:0]` | Selects memory location |
| Data bus | `write_data[7:0]`, `read_data[7:0]` | Carries actual data |
| Control signals | `write_en`, `read_en`, `valid`, `ready` | Decide operation timing and behavior |

## Testbench

No testbench was created for this topic.

The purpose of this project was to understand memory interface concepts before writing a memory RTL implementation.

The concept notes include manual reasoning examples for:

- address bus behavior
- data bus behavior
- write enable control
- read enable control
- memory write operation
- memory read operation
- combinational read
- synchronous read
- read latency
- register file vs memory
- FIFO vs memory
- memory interface and valid/ready handshake

Important conceptual checks:

- A bus is a group of parallel signal lines.
- A data bus carries data but does not store data.
- A memory array stores data.
- An address bus selects a memory location.
- A 4-bit address can select 16 locations.
- Memory is address-based.
- FIFO is order-based.
- Combinational read can update output after address changes.
- Synchronous read may return data after one or more clock cycles.

## Waveform

No waveform was generated for this project.

This project focused on conceptual understanding and diagram-based explanation.

The memory interface diagram is included directly in:

`notes/memory-interface-basics.md`

The diagram shows the signal directions between a requesting module and memory, including:

- `addr`
- `write_data`
- `write_en`
- `read_en`
- `read_data`

A future RTL version could implement a simple memory module and generate a waveform showing:

- `addr`
- `write_en`
- `write_data`
- `read_en`
- `read_data`
- clocked write behavior
- combinational or synchronous read behavior
- read latency if synchronous read is used

The key waveform behavior to check in a future implementation would be:

- write data is stored into `mem[addr]` when `write_en` is high at the clock edge
- read data corresponds to the selected address
- combinational read updates after address changes
- synchronous read returns data after a clock edge or after a defined latency