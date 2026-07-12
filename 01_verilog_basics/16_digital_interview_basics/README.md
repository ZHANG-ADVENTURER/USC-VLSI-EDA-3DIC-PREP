# Project Title

Digital Interview Basics

## Overview

This project reviews common digital design interview topics based on the Verilog, FSM, FIFO, register file, handshake, memory interface, and pipeline projects completed in the previous learning stages.

The notes focus on connecting RTL syntax to hardware behavior rather than memorizing definitions.

The main topics include combinational and sequential logic, blocking and non-blocking assignments, latch inference, FSM structure, FIFO operation, pipeline behavior, valid/ready handshake, memory interfaces, reset design, synthesizable RTL, bit width, carry-out, and signed overflow.

This project prepares for digital design, RTL, ASIC design, DV, Physical Design, and STA internship interviews.

## Files

| File / Folder | Description |
|---|---|
| `notes/` | Contains the digital interview preparation notes |
| `notes/digital-interview-basics.md` | Reviews common interview concepts, mistakes, and model answers |
| `README.md` | Provides a summary of the project |

## Module Description

This project does not implement a new Verilog module.

It reviews the hardware meaning of previously implemented structures, including:

| Structure | Main Hardware Concept |
|---|---|
| Combinational logic | Current-input-based logic without stored state |
| Sequential logic | Clocked logic that stores previous values |
| FSM | State register, next-state logic, and output logic |
| FIFO | Memory array, pointers, count, full, and empty logic |
| Pipeline | Register-separated stages with throughput and latency |
| Valid/ready interface | Transaction transfer and backpressure control |
| Memory interface | Address, data, control, request, and response signals |
| Reset logic | Synchronous and asynchronous state initialization |

Important interview rules include:

    Combinational always block
    → blocking assignment
    → complete output assignments

    Clocked sequential block
    → non-blocking assignment

    FIFO accepted write
    → write_en && !full

    FIFO accepted read
    → read_en && !empty

    Valid/ready transfer
    → valid && ready

    Bubble
    → valid = 0

    Stall
    → valid = 1 and ready = 0

## Testbench

No new Verilog testbench was created for this project.

The concepts were reviewed through fourteen rounds of interview-style questions and one comprehensive mock interview.

The exercises included:

- Explaining combinational and sequential logic
- Distinguishing blocking and non-blocking assignments
- Identifying unintended latch inference
- Describing FSM structure
- Analyzing FIFO read and write behavior
- Handling FIFO overflow and underflow
- Comparing throughput and latency
- Distinguishing pipeline stalls and bubbles
- Explaining valid/ready handshakes
- Classifying datapath, control, and status signals
- Explaining memory request and response timing
- Distinguishing synthesizable RTL from testbench code
- Comparing synchronous and asynchronous resets
- Calculating bit width, carry-out, and signed overflow

## Waveform

No new waveform was generated because this project focuses on interview preparation and conceptual review rather than a new RTL implementation.

Previously generated waveforms from the ALU, counter, shift register, FSM, FIFO, and register file projects were used as supporting examples for the interview concepts.