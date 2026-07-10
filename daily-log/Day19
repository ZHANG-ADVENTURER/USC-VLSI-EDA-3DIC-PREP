# Day19 Daily Log

## Topic

Valid / Ready Handshake Basics

## What I Learned

Today I learned the basic valid / ready handshake protocol used for communication between digital modules.

The main idea is that a digital system often has one module producing data and another module consuming data. These two modules may not always be ready at the same time, so they need a communication rule to decide when data is actually transferred.

The producer generates `valid`.

The consumer generates `ready`.

Data transfer happens only when both `valid` and `ready` are high.

In synchronous RTL design, this usually means that data is accepted at the clock edge when `valid = 1` and `ready = 1`.

I also learned that `valid` and `ready` are not the main data payload. They are control/status signals that coordinate data movement.

This topic connects directly to the FIFO design I built earlier. On the FIFO input side, `write_en` behaves like a valid signal, and `!full` behaves like a ready signal. On the FIFO output side, `!empty` behaves like a valid signal, and `read_en` behaves like a ready or request signal.

## What I Built / Produced

Today I produced a handshake basics note and README file.

Produced files:

- `01_verilog_basics/13_handshake_basics/notes/handshake-basics.md`
- `01_verilog_basics/13_handshake_basics/README.md`

The notes include:

- why handshake is needed
- producer and consumer roles
- valid signal meaning
- ready signal meaning
- signal directions
- transfer condition
- four valid / ready cases
- FIFO input-side handshake mapping
- FIFO output-side handshake mapping
- producer-consumer handshake diagram
- FIFO handshake diagrams
- connection to datapath and control
- connection to VLSI / EDA / Physical Design / STA

No RTL source code, testbench, simulation, or waveform was required today because the goal was to understand the handshake concept before implementing it in Verilog.

## Key Concepts

Producer

A producer is the module that generates or sends data. It controls the `valid` signal.

Consumer

A consumer is the module that receives data. It controls the `ready` signal.

Valid

`valid` means the producer currently has meaningful data available. It moves from producer to consumer.

Ready

`ready` means the consumer can accept data now. It moves from consumer to producer.

Transfer

A transfer happens only when `valid` and `ready` are both high. In a synchronous RTL design, the transfer is usually accepted at the clock edge.

Data

`data` is the actual payload being transferred. It belongs to the datapath.

Control / Status Signals

`valid` and `ready` are control/status signals. They coordinate when data movement is allowed.

FIFO Input-Side Handshake

On the FIFO input side, `write_en` behaves like valid, and `!full` behaves like ready. A write is accepted only when `write_en && !full`.

FIFO Output-Side Handshake

On the FIFO output side, `!empty` behaves like valid, and `read_en` behaves like ready or request. A read is accepted only when `read_en && !empty`.

Backpressure

Backpressure happens when the consumer is not ready. In valid / ready terms, this appears as `valid = 1` and `ready = 0`. The producer has data, but the consumer cannot accept it yet.

## Problems and Fixes

Problem:

It was easy to think that `valid = 1` alone means data has already transferred.

Fix:

I learned that `valid = 1` only means the producer has valid data. Transfer happens only when both `valid` and `ready` are high.

Problem:

It was easy to confuse which side generates `valid` and which side generates `ready`.

Fix:

I clarified that the producer generates `valid`, and the consumer generates `ready`.

Problem:

I needed to connect the abstract handshake concept to a module I already understood.

Fix:

I connected valid / ready handshake to the previous FIFO project. FIFO input uses `write_en && !full`, which is similar to `valid && ready`. FIFO output uses `read_en && !empty`, which is also a transfer condition.

Problem:

It was not immediately obvious why `valid` and `ready` are control/status signals instead of datapath signals.

Fix:

I clarified that `data` is the actual payload and belongs to the datapath. `valid` and `ready` only control whether the data is meaningful and whether it can be accepted.

Problem:

I needed to understand what happens when `valid = 1` and `ready = 0`.

Fix:

I learned that this means the producer has valid data, but the consumer cannot accept it yet. In many valid / ready protocols, the producer should keep the data stable until the transfer happens.

## Connection to VLSI / EDA / 3D IC

Valid / ready handshake is important for VLSI and EDA because real digital systems are built from communicating modules.

In RTL design, handshake signals control when data moves between modules.

In Physical Design and STA, both datapath and control/status signals create real timing paths. The datapath may include buses, registers, FIFOs, muxes, and processing logic. The control path may include valid, ready, enable signals, FSM outputs, and status flags.

Handshake logic also helps prevent data loss when one module is faster than another module. This is important in producer-consumer systems, streaming datapaths, FIFO-based buffering, pipeline backpressure, bus protocols, and larger SoC-style designs.

For 3D IC and advanced packaging, handshake concepts are also relevant because chiplets, memory blocks, and interconnect structures need reliable data movement and flow control. Valid / ready is one basic way to understand how data transfer can be coordinated between different blocks.

## One Sentence Summary

Today I learned that valid / ready handshake is a module communication rule where the producer asserts `valid`, the consumer asserts `ready`, and data transfers only when both signals are high.

## Next Step

Continue Week 3 Digital Architecture Bridge by studying memory interface basics, including address, data, read/write control signals, and memory access latency.