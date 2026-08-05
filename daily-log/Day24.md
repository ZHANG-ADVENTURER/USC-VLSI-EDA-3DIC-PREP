# Day 24

## Topic

RTL-to-GDS Flow Overview

## What I Learned

Today I learned the complete high-level flow used to convert an RTL design into a physical layout that can be submitted for semiconductor manufacturing.

The main flow is:

    RTL
      ↓
    Logic Synthesis
      ↓
    Gate-Level Netlist
      ↓
    Floorplanning
      ↓
    Power Planning
      ↓
    Placement
      ↓
    Clock Tree Synthesis
      ↓
    Routing
      ↓
    Static Timing Analysis
      ↓
    DRC and LVS
      ↓
    GDSII
      ↓
    Tape-out

I learned that RTL describes logical functionality and sequential behavior, but it does not contain physical cell coordinates, metal routing, vias, or chip dimensions.

Logic synthesis maps RTL operations to standard cells and generates a gate-level netlist. The netlist contains cell instances and their logical connectivity, while Physical Design determines their locations and physical interconnections.

I also learned the responsibilities of the main Physical Design stages:

- Floorplanning defines the die, core, macros, and major physical regions.
- Power planning builds the VDD and VSS distribution network.
- Placement assigns coordinates to standard-cell instances.
- CTS constructs the clock-distribution network.
- Routing connects physical pins using metal layers and vias.
- STA checks whether signals satisfy timing requirements.
- DRC checks manufacturing geometry rules.
- LVS checks whether the layout matches the intended netlist.
- GDSII stores the final physical layout geometry.

## What I Built / Produced

- Created `02_physical_design_notes/01_rtl_to_gds_flow/`
- Created `notes/rtl-to-gds-flow.md`
- Created `README.md`
- Documented the major RTL-to-GDS stages
- Added simplified flow diagrams and physical-design explanations
- Completed classification exercises for synthesis, placement, routing, STA, DRC, LVS, and GDSII

## Key Concepts

### RTL

RTL describes logical operations, registers, data transfer, and sequential behavior.

It does not normally describe physical coordinates or detailed routing geometry.

### Logic Synthesis

Logic synthesis converts RTL into a gate-level netlist using cells from a standard-cell library.

### Standard Cell

A standard cell is a pre-designed logic element such as an inverter, NAND gate, multiplexer, buffer, or flip-flop.

### Cell Instance

A cell instance is a specific copy of a standard-cell type used in the design.

For example, in `DFF_X1 reg_q`, `DFF_X1` is the cell type and `reg_q` is the instance name.

### Gate-Level Netlist

A gate-level netlist contains standard-cell instances, pins, and logical connectivity.

It normally does not contain final placement coordinates.

### Floorplanning

Floorplanning defines the overall physical organization of the chip, including die area, core area, macro locations, and placement regions.

### Power Planning

Power planning creates the VDD and VSS distribution network.

Poor power delivery can cause IR drop, increased cell delay, and timing problems.

### Placement

Placement assigns physical coordinates to individual cell instances.

Placement affects wirelength, congestion, timing, power, and routability.

### Clock Tree Synthesis

CTS inserts clock buffers and creates a clock-distribution network.

Its goals include controlling clock skew, clock latency, fanout, and transition time.

### Routing

Routing implements netlist connectivity using physical metal wires and vias.

Global routing plans approximate paths, while detailed routing determines exact tracks and via locations.

### Wire and Via

A wire is a horizontal or vertical metal segment within one routing layer.

A via is a vertical conductor connecting different metal layers.

Both contribute to interconnect parasitics.

### Static Timing Analysis

STA checks whether signals arrive within timing requirements.

It analyzes cell delay, interconnect delay, clock paths, setup timing, and hold timing.

### DRC

DRC checks whether layout geometries satisfy foundry manufacturing rules.

### LVS

LVS checks whether the circuit extracted from the layout matches the reference netlist.

### GDSII

GDSII stores the final physical geometry and hierarchy of the chip layout.

### Tape-out

Tape-out is the formal submission of the signoff-complete layout to the foundry for fabrication.

## Problems and Fixes

### Problem 1: Incomplete understanding of synthesis output

I initially described the synthesis output only as corresponding cells.

Fix:

The synthesis output is more accurately described as a gate-level netlist containing standard-cell instances and their connectivity.

### Problem 2: Confusion between cell type and instance name

I initially treated the standard-cell type as the name of the imported cell.

Fix:

The standard-cell type identifies the library element, while the instance name identifies one specific copy used in the design.

### Problem 3: Incomplete explanation of clock buffers

I initially stated that clock buffers were mainly used to reduce clock skew.

Fix:

Clock buffers also divide fanout, drive capacitive loads, improve transition time, and control clock latency.

### Problem 4: Incorrect description of vias

I initially described a via as connecting different regions.

Fix:

A via specifically connects different metal layers. It is part of the interconnect system but is physically different from a wire segment.

### Problem 5: Imprecise explanation of power-delivery failure

I initially described IR drop as instances not receiving enough energy.

Fix:

A more accurate explanation is that resistance in the power network reduces the local supply voltage, weakens transistor drive strength, and increases cell delay.

## Connection to VLSI / EDA / 3D IC

RTL-to-GDS is the central implementation flow for Physical Design and ASIC engineering.

Understanding this flow prepares me for:

- Logic synthesis
- Floorplanning
- Placement
- Clock Tree Synthesis
- Routing
- Static Timing Analysis
- Timing closure
- Physical verification
- OpenROAD practice

It also connects to my fabrication and TSV background because Physical Design must satisfy manufacturing rules, interconnect constraints, power delivery, and physical integration requirements.

This topic directly supports preparation for USC EE477L and EE577A/B and establishes the framework needed for later STA and OpenROAD projects. :contentReference[oaicite:1]{index=1}

## One Sentence Summary

Today I learned how RTL is transformed into a physically placed, routed, timing-verified, and manufacturable GDSII layout.

## Next Step

Study logic synthesis, gate-level netlists, standard-cell libraries, and timing constraints in greater detail.