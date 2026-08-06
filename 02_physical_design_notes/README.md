# Project Title

Physical Design and RTL-to-GDSII Notes

# Overview

This module provides the conceptual foundation for the digital Physical Design flow.

It explains how an RTL design is transformed into a manufacturable layout through synthesis, floorplanning, placement, Clock Tree Synthesis, routing, physical verification, extraction, timing analysis, and final handoff.

The main flow is:

> RTL and constraints  
> → synthesis  
> → gate-level netlist  
> → floorplanning  
> → power planning  
> → placement  
> → Clock Tree Synthesis  
> → routing  
> → extraction  
> → signoff checks  
> → GDSII or OASIS

This module focuses on concepts, stage relationships, files, checks, and engineering interpretation. Practical OpenROAD execution is documented separately in `../04_openroad_practice/`.

# Files

| Path | Main focus |
|---|---|
| `01_rtl_to_gds_flow/` | Complete RTL-to-GDSII flow overview |
| `02_synthesis_netlist_standard_cells/` | Synthesis, gate-level netlists, standard cells, and timing constraints |
| `03_floorplanning/` | Die/core definition, macros, rows, blockages, halos, channels, and power planning |
| `04_placement/` | Standard-cell placement, density, congestion, legalization, and optimization |
| `05_cts/` | Clock Tree Synthesis, latency, skew, clock buffers, and clock routing |
| `06_routing_drc_lvs/` | Global routing, detailed routing, DRC, LVS, antenna, and physical verification |
| `07_signoff/` | Timing, power integrity, extraction, verification, and tapeout-oriented checks |
| `08_rtl_to_gds/` | Consolidated RTL-to-GDSII review |
| `09_file_formats/` | RTL, netlist, SDC, Liberty, LEF, DEF, SPEF, SDF, GDSII, and OASIS |

# Module Description

## Synthesis and Logical Handoff

Synthesis converts RTL behavior into a gate-level netlist mapped to a standard-cell library.

Its major inputs include:

- RTL
- Timing constraints
- Liberty timing and power data

Its main outputs include:

- Gate-level netlist
- Synthesis reports
- Timing and area estimates

The synthesized netlist describes logical connectivity, not final cell placement or routing.

## Floorplanning

Floorplanning defines the physical framework of the design.

Major topics include:

- Die and core boundaries
- Standard-cell rows
- Macro placement
- Halos and channels
- Placement and routing blockages
- I/O placement
- Power-distribution planning
- Early congestion risk

A poor floorplan can make later timing, congestion, power, and routability closure difficult or impossible.

## Placement

Placement assigns physical locations to standard cells and legalizes them onto rows.

Placement quality affects:

- Wirelength
- Congestion
- Cell density
- Timing
- Power
- Clock-tree feasibility
- Detailed-routing difficulty

Placement optimization may resize cells, insert buffers, or restructure selected paths.

## Clock Tree Synthesis

CTS builds the physical clock-distribution network.

Its main objectives are to control:

- Clock latency
- Clock skew
- Transition
- Capacitance
- Fanout
- Power
- Routing impact

After CTS, setup and hold analysis must use propagated clock paths rather than only ideal clock assumptions.

## Routing and Physical Verification

Global routing estimates routing demand and creates guides. Detailed routing assigns exact tracks, wire segments, and vias.

Major checks include:

- Congestion and overflow
- Shorts and spacing violations
- Antenna effects
- DRC
- LVS
- ERC
- Density and metal fill

Tool-level routing completion is not automatically equivalent to foundry signoff.

## Signoff

Signoff combines several analysis domains:

- Setup and hold timing
- Multi-mode multi-corner analysis
- Extracted parasitics
- Signal integrity
- Electromigration
- Static and dynamic IR drop
- DRC, LVS, and ERC
- Final layout review

A positive WNS from one timing report is not sufficient to prove complete signoff.

## File Handoffs

Different files describe different aspects of the same design:

| File type | Information |
|---|---|
| RTL | Register-transfer behavior |
| Gate-level netlist | Cell instances and logical connectivity |
| SDC | Timing constraints |
| Liberty | Cell timing, power, and electrical models |
| LEF | Abstract technology and cell geometry |
| DEF | Design-specific placement and routing |
| SPEF | Extracted interconnect parasitics |
| SDF | Annotated path and interconnect delays |
| GDSII/OASIS | Final manufacturing geometry |

# Testbench

No standalone testbench is defined at the module level.

Functional testbenches belong to the RTL modules under `../01_verilog_basics/`. This Physical Design module focuses on implementation stages, timing and physical reports, file handoffs, and signoff concepts.

Functional verification remains necessary before and after implementation, but it is not replaced by Physical Design checks.

# Waveform

No simulation waveform is generated at the module level.

The primary evidence in this module consists of technical notes, flow diagrams, timing-path interpretations, file relationships, and physical-design concepts.

Implementation screenshots and measured OpenROAD results are stored in `../04_openroad_practice/`.
