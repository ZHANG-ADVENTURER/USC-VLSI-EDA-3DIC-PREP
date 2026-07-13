# Project Title

RTL-to-GDS Flow Overview

## Overview

This project introduces the complete digital ASIC implementation flow from Register Transfer Level design to the final GDSII layout.

The notes explain how RTL is converted into a gate-level netlist through logic synthesis and how physical design transforms the netlist into a manufacturable layout.

The covered stages include:

- RTL
- Logic Synthesis
- Gate-Level Netlist
- Floorplanning
- Power Planning
- Placement
- Clock Tree Synthesis
- Routing
- Static Timing Analysis
- DRC
- LVS
- GDSII
- Tape-out

This project provides a conceptual foundation for Physical Design, STA, ASIC implementation, and later OpenROAD practice.

## Files

| File / Folder | Description |
|---|---|
| `notes/` | Technical notes for the RTL-to-GDS flow |
| `notes/rtl-to-gds-flow.md` | Detailed explanation of each major RTL-to-GDS stage |
| `README.md` | Project overview and file description |

## Module Description

This is a concept-based Physical Design project rather than a Verilog RTL module.

It explains how a digital design progresses through the following transformation:

    RTL description
        ↓
    Synthesized gate-level netlist
        ↓
    Physically placed and routed layout
        ↓
    Verified GDSII database

The project also distinguishes:

- Logical functionality
- Timing correctness
- Physical manufacturability
- Layout-to-netlist consistency

## Testbench

No Verilog testbench is used in this project.

The content is verified through concept-classification exercises covering:

- RTL versus physical layout
- Cell type versus cell instance
- Floorplanning versus placement
- Wire versus via
- Cell delay versus interconnect delay
- DRC versus LVS
- Netlist versus GDSII

## Waveform

No simulation waveform is required because this project does not implement or simulate an RTL module.

The main output is the technical note:

`notes/rtl-to-gds-flow.md`