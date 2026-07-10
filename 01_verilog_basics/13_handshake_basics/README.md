# Handshake Basics

## Overview

This project documents the basic valid / ready handshake concept used for communication between digital modules.

The goal is to understand how a producer sends data to a consumer, how the consumer indicates it can accept data, and when a data transfer actually happens.

The key rule is:

transfer happens when valid and ready are both high.

In synchronous RTL design, this usually means data is accepted at the clock edge when both `valid` and `ready` are high.

This topic connects previous FIFO work to larger digital architecture concepts such as producer-consumer communication, backpressure, streaming interfaces, pipeline control, and module-level data movement.

## Files

| File / Folder | Description |
|---|---|
| `notes/handshake-basics.md` | Concept notes explaining valid / ready handshake, producer-consumer communication, FIFO input/output mapping, and timing behavior |
| `README.md` | Project explanation |

## Module Description

No Verilog RTL module was implemented in this project.

This project is a concept and architecture note.

The main interface signals discussed are:

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `data` | Producer to Consumer | design-dependent | The actual payload data being transferred |
| `valid` | Producer to Consumer | 1 | Indicates that the producer has valid data |
| `ready` | Consumer to Producer | 1 | Indicates that the consumer can accept data |
| `transfer` | internal condition | 1 | The actual transfer condition, equal to `valid && ready` |

The signal directions are:

| Signal | Source | Destination |
|---|---|---|
| `data` | Producer | Consumer |
| `valid` | Producer | Consumer |
| `ready` | Consumer | Producer |

The core transfer condition is:

`transfer = valid && ready`

## Testbench

No testbench was created for this topic.

The goal of this project was to understand the handshake concept before writing RTL.

The concept notes include manual reasoning examples for the following cases:

- `valid = 0`, `ready = 0`: no valid data and consumer is not ready
- `valid = 0`, `ready = 1`: consumer is ready, but producer has no valid data
- `valid = 1`, `ready = 0`: producer has valid data, but consumer cannot accept it
- `valid = 1`, `ready = 1`: producer has valid data and consumer accepts it

The most important rule is that data transfer only happens when both `valid` and `ready` are high.

## Waveform

No waveform was generated for this topic.

This project focused on conceptual understanding and diagram-based explanation.

A future RTL version could include a producer-consumer handshake simulation and waveform showing:

- `valid`
- `ready`
- `data`
- successful transfer cycles
- stalled cycles when `valid = 1` and `ready = 0`
- idle cycles when `valid = 0`

The key waveform behavior to check in a future implementation would be:

- data transfers only when `valid && ready`
- producer keeps data stable when `valid = 1` and `ready = 0`
- consumer accepts data only when `ready = 1`
- no data is transferred when either `valid` or `ready` is low