# Project Title

Timing Closure and PPA Tradeoffs

# Overview

This module explains how timing violations are diagnosed and repaired during the timing-closure stage of the physical-design flow.

The main timing-closure process is:

> Validate timing constraints and analysis coverage  
> → Identify setup or hold violations  
> → Classify the root cause  
> → Select a targeted repair  
> → Update the physical implementation  
> → Re-extract parasitics  
> → Rerun setup and hold analysis  
> → Review PPA and physical side effects  
> → Repeat until all requirements are satisfied

A positive slack value in one timing report is not sufficient to prove timing closure. Setup, hold, timing constraints, path coverage, operating modes, PVT corners, power, area, utilization, congestion, and physical verification must all be considered.

The module also introduces common setup and hold repair methods, their engineering tradeoffs, and the role of Engineering Change Orders in late-stage implementation.

# Files

- `notes/timing_closure_ppa.md` — Technical notes covering timing-closure objectives, root-cause classification, setup and hold repair methods, PPA tradeoffs, ECOs, and the timing-closure case study.
- `README.md` — Module overview and file navigation.

# Module Description

The module covers:

- Timing-closure objectives and closure loops
- Setup and hold closure
- Constraint correctness and path coverage
- Cell-delay-dominated and net-delay-dominated paths
- Input slew, output load, fanout, and logic depth
- Clock skew and clock uncertainty
- Setup repair methods
- Hold repair methods
- Localized hold-buffer insertion
- Placement and routing optimization
- Logic restructuring and pipelining
- PPA tradeoffs
- Utilization and congestion
- Timing, functional, physical, and metal-only ECOs
- Timing-closure case-study analysis

The central diagnostic rule is:

> Determine whether a violation is caused primarily by cell delay, net delay, clock behavior, physical implementation, or incorrect constraints before selecting a repair.

Setup repair primarily attempts to reduce maximum data-path delay.

Hold repair primarily attempts to increase minimum data-path delay.

Every physical repair must be followed by updated parasitic extraction and renewed setup and hold analysis because a repair that improves one timing check may worsen another.

# Testbench

This module does not contain a dedicated Verilog testbench.

The content focuses on Static Timing Analysis, timing reports, physical implementation, timing repair, and PPA evaluation rather than functional RTL simulation.

# Waveform

This module does not produce one dedicated waveform.

Timing behavior is evaluated through timing paths, arrival time, required time, slack, clock relationships, extracted parasitics, and setup and hold reports rather than simulation waveforms.
