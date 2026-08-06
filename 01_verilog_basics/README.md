# Project Title

Verilog and Digital Design Foundations

# Overview

This module develops the RTL and digital-design foundation required for later work in Design Verification, synthesis, Static Timing Analysis, and Physical Design.

The learning sequence progresses from simple combinational logic to sequential logic, finite-state machines, storage structures, control/datapath organization, interfaces, and pipelines.

The main progression is:

> Basic gates  
> → Combinational logic  
> → Arithmetic logic  
> → Testbench practice  
> → Sequential circuits  
> → FSMs and sequence detection  
> → FIFO and register-file structures  
> → Handshake and memory interfaces  
> → Pipeline concepts  
> → Digital-design interview review

The exercises use Verilog or introductory SystemVerilog concepts together with simulation-oriented testbenches and waveform inspection.

# Files

| Path | Main focus |
|---|---|
| `01_basic_gates/` | Basic logic gates and introductory RTL structure |
| `02_combinational/` | Combinational logic and selection logic |
| `03_alu/` | Arithmetic and logic operations |
| `04_testbench_practice/` | Testbench structure, stimulus, checks, and simulation workflow |
| `05_counter/` | Counter-based sequential logic |
| `06_shift_register/` | Shift-register structures and serial/parallel data movement |
| `07_fsm_traffic_light/` | Finite-state-machine design using a traffic-light controller |
| `08_sequence_detector/` | Sequence detection and state-transition behavior |
| `09_simple_fifo/` | FIFO storage, pointers, status signals, and verification |
| `10_systemverilog_awareness/` | Introductory SystemVerilog awareness and syntax comparison |
| `11_datapath_control/` | Separation of datapath and control logic |
| `12_register_file_basic/` | Register-file organization and read/write behavior |
| `13_handshake_basics/` | Ready/valid communication and transfer conditions |
| `14_memory_interface_basics/` | Basic memory-interface concepts |
| `15_pipeline_concept/` | Pipeline latency, throughput, stalls, and bubbles |
| `16_digital_interview_basics/` | Consolidated digital-design interview fundamentals |
| `17_course_bridge_summary/` | Bridge from introductory RTL work to later VLSI and EDA study |

# Module Description

## Combinational Logic

The first part of the module introduces gates, multiplexers, decoders, arithmetic logic, and other combinational structures.

The central rule is:

> Output depends only on current input values.

These exercises establish the use of continuous assignments, combinational procedural logic, bit widths, signed and unsigned interpretation, and complete assignment coverage.

## Sequential Logic

Counters, shift registers, FIFOs, and register files introduce clocked state.

The central rule is:

> Next state is sampled at a clock edge and preserved between clock edges.

This section reinforces clock usage, reset behavior, non-blocking assignments, and the distinction between state registers and combinational next-state logic.

## Finite-State Machines

The traffic-light controller and sequence detector connect state storage with combinational transition and output logic.

The work covers:

- State definition
- Present state and next state
- Transition conditions
- Output generation
- Overlapping sequence detection
- Simulation of state-dependent behavior

## Storage and Interfaces

FIFO, register-file, handshake, and memory-interface exercises introduce reusable digital-system structures.

These modules connect local RTL coding rules with system-level concerns such as:

- Data validity
- Flow control
- Backpressure
- Read and write timing
- Full and empty conditions
- Interface ownership

## Pipeline Concepts

The pipeline section distinguishes throughput from latency and introduces stalls and bubbles.

This material provides the conceptual bridge to timing-driven digital design, where register placement affects both architecture and achievable clock frequency.

## Connection to Later Modules

This module provides the logical foundation for:

> RTL  
> → synthesis  
> → gate-level netlist  
> → STA  
> → Physical Design

The later Physical Design and OpenROAD modules analyze how these logical structures become standard-cell instances, timing paths, placed cells, clock trees, routed nets, and final physical outputs.

# Testbench

Individual exercise directories contain testbench-oriented practice appropriate to their modules.

The testbench work includes:

- DUT instantiation
- Clock and reset generation
- Input stimulus
- Expected-value checks
- Task-based checking
- Timing control with clock-edge waits
- Short settle delays where required
- Pass/fail messages

The testbenches form an introductory basis for later Design Verification study. They are directed simulation environments rather than complete constrained-random or coverage-driven verification systems.

# Waveform

Waveforms are used to inspect combinational responses, clocked state transitions, reset behavior, FIFO activity, FSM transitions, handshakes, and pipeline timing.

Waveform review complements automated checks by making temporal behavior visible.

The waveform work is educational simulation evidence and is separate from the timing reports generated later by synthesis, STA, and Physical Design tools.
