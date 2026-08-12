# Verilog and Digital Design Foundations

This module develops the RTL and digital-design foundation used later in synthesis, Static Timing Analysis, and Physical Design. It contains both implemented Verilog projects and concept-only study notes; those categories are separated below.

## Implemented and Simulated Projects

| Project | Evidence |
|---|---|
| [Basic gates](01_basic_gates/README.md) | RTL, testbench, VCD, and waveform image |
| [Combinational modules](02_combinational/README.md) | Mux, decoder, and full-adder RTL with testbenches and waveforms |
| [4-bit ALU](03_alu/README.md) | RTL, testbench, VCD, and waveform image |
| [Testbench practice](04_testbench_practice/README.md) | Refined directed and self-checking testbenches |
| [DFF and counter](05_counter/README.md) | Sequential RTL, testbench, and waveform evidence |
| [Shift-register comparison](06_shift_register/README.md) | Blocking/non-blocking implementations and simulation |
| [Traffic-light FSM](07_fsm_traffic_light/README.md) | Moore FSM, self-checking testbench, and waveforms |
| [Sequence-detector FSM](08_sequence_detector/README.md) | Overlapping `1011` detector, self-checking testbench, and waveforms |
| [Simple FIFO](09_simple_fifo/README.md) | Depth-4 FIFO, full/empty handling, overflow/underflow checks, and VCD |
| [Register file](12_register_file_basic/README.md) | Clocked write, dual combinational read ports, self-checking testbench, and waveforms |

The portfolio-facing selection emphasizes the [FIFO, sequence detector, and register file](../featured-projects/03_rtl_digital_foundation/README.md), with the traffic-light FSM as additional implemented work.

## Conceptual and Note-Only Topics

The following topics were studied but do not currently contain Verilog implementation evidence in their directories:

| Topic | Current evidence |
|---|---|
| [SystemVerilog awareness](10_systemverilog_awareness/README.md) | Syntax and RTL-modeling notes |
| [Datapath and control](11_datapath_control/README.md) | Architecture notes only |
| [Ready/valid handshake](13_handshake_basics/README.md) | Protocol and timing notes only |
| [Memory-interface basics](14_memory_interface_basics/README.md) | Interface-concept notes only |
| [Pipeline concepts](15_pipeline_concept/README.md) | Latency, throughput, stall, bubble, and backpressure notes only |
| [Digital interview review](16_digital_interview_basics/README.md) | Consolidated review notes |
| [Course bridge summary](17_course_bridge_summary/README.md) | Preparation and capability mapping |

These topics are not presented as implemented RTL projects.

## Implemented Design Progression

> Combinational logic → arithmetic logic → sequential state → finite-state machines → FIFO and register-file storage structures

The implemented projects reinforce synthesizable combinational and clocked logic, reset behavior, non-blocking assignments, state transitions, pointer and occupancy tracking, address-based storage, and directed/self-checking verification.

## Verification Scope

Implemented project directories include combinations of:

- DUT instantiation
- Clock and reset generation
- Directed input stimulus
- Expected-value checks
- Task-based checking
- PASS/FAIL messages
- VCD generation and waveform inspection

These are introductory directed simulation environments, not constrained-random or coverage-driven verification systems.

## Connection to Later Work

> RTL → synthesis → gate-level netlist → STA → Physical Design

The later [Physical Design](../02_physical_design_notes/README.md), [STA](../03_sta_notes/README.md), and [OpenROAD](../04_openroad_practice/README.md) modules examine how logical structures become standard-cell instances, timing paths, placed cells, clock trees, routed nets, and physical implementation outputs.
