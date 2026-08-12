# Project Title

Static Timing Analysis Summary

# Overview

This module integrates the complete Static Timing Analysis flow from timing inputs to timing closure.

The central STA relationship is:

> Gate-Level Netlist + SDC + Liberty Library + SPEF  
> → Build Timing Graph  
> → Calculate Arrival and Required Times  
> → Calculate Setup and Hold Slack  
> → Generate Timing Reports  
> → Diagnose Root Causes  
> → Apply Targeted Repairs  
> → Re-extract Parasitics  
> → Rerun STA Until Timing Closure

The module also includes setup and hold report-reading practice, timing-repair reasoning, WNS and TNS interpretation, and English explanations suitable for technical interviews.

# Files

- [`notes/sta-summary.md`](notes/sta-summary.md) — Complete STA reference covering inputs, timing graphs, setup and hold equations, report reading, timing closure, root-cause classification, and interview explanations.
- `README.md` — Module overview and file navigation.

# Module Description

The module covers:

- Why STA is vectorless
- Differences between STA and functional simulation
- Gate-level netlist, SDC, Liberty, and SPEF
- Timing graph construction
- Startpoints and endpoints
- Input-to-register, register-to-register, register-to-output, and input-to-output paths
- Arrival time and required time
- Setup and hold slack
- Maximum-delay and minimum-delay analysis
- Clock skew
- Clock period versus capture latency
- Setup timing-report reading
- Hold timing-report reading
- Cell-delay-dominated and net-delay-dominated paths
- Timing-repair selection
- Setup and hold repair interaction
- WNS and TNS
- STA across synthesis, placement, CTS, routing, and signoff
- Timing-closure integration
- Engineering explanation templates
- Ninety-second and short interview explanations

The core interpretation rules are:

> Negative setup slack means data arrives too late.  
> Negative hold slack means new data arrives too early.  
> Setup analysis focuses on maximum delay.  
> Hold analysis focuses on minimum delay.

A timing repair must match the root cause and must be followed by updated parasitic extraction and renewed setup and hold analysis.

# Testbench

This module does not contain a dedicated Verilog testbench.

STA is a vectorless timing-analysis method. It builds and analyzes a timing graph from the netlist, timing constraints, cell timing libraries, and interconnect parasitics instead of applying functional input vectors.

Functional simulation remains necessary for verifying logical behavior, state transitions, protocols, and output values.

# Waveform

This module does not produce a dedicated simulation waveform.

Timing behavior is evaluated through timing paths, clock relationships, arrival time, required time, setup slack, hold slack, incremental delay, cumulative path time, and timing reports.
