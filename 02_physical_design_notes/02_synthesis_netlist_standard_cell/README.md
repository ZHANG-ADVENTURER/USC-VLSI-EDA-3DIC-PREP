# Synthesis, Gate-Level Netlist, and Standard Cells

## Overview

This study project explains how logic synthesis converts RTL into a gate-level netlist using a target standard-cell library and design constraints.

The notes cover the synthesis flow, standard-cell library views, technology mapping, cell sizing, timing constraints, gate-level netlists, synthesis reports, PVT corners, and timing exceptions.

## Files

| File / Folder | Description |
|---|---|
| `notes/` | Detailed synthesis and standard-cell study notes |
| [`notes/synthesis-netlist-standard-cell.md`](notes/synthesis-netlist-standard-cell.md) | Main notes covering synthesis, netlists, timing, libraries, and constraints |
| `README.md` | Project overview and file description |

## Module Description

This project is a conceptual physical-design study project rather than an RTL implementation.

The main concepts include:

- RTL, standard-cell libraries, and design constraints
- `.lib`, `.lef`, and `.gds` library views
- Analyze, elaborate, optimization, and technology mapping
- Gate-level cell instances, nets, pins, and connectivity
- Input slew, output load, drive strength, and fanout
- Setup, hold, clock-to-Q, slack, WNS, and TNS
- Timing constraints and synthesis design-rule constraints
- PVT corners
- False paths, multicycle paths, and unconstrained paths
- Timing, area, power, and constraint reports

No Verilog module ports are defined in this project.

## Testbench

No RTL module or testbench was created for this project.

Understanding was verified through concept questions covering:

- synthesis inputs and outputs
- standard-cell library views
- synthesis stage ordering
- gate-level netlist structure
- cell delay and drive strength
- setup and hold timing
- slack calculations
- synthesis constraints
- timing exceptions
- synthesis report interpretation

## Waveform

No waveform was generated because this project focuses on synthesis concepts and gate-level implementation theory rather than RTL simulation.
