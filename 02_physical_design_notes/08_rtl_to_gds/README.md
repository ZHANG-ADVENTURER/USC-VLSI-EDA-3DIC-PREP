# Project Title

RTL-to-GDSII Flow Integration

# Overview

This module integrates the complete digital ASIC implementation flow from specification and RTL design through synthesis, physical design, signoff, and tapeout.

It connects the major abstraction levels of chip design:

* Specification
* Microarchitecture
* RTL
* Gate-level netlist
* Physical layout
* GDSII or OASIS

The purpose of this module is to understand:

* What each stage receives as input
* What each stage produces as output
* Which engineering question each stage answers
* How front-end and back-end work are connected
* Why later-stage violations may originate from earlier design decisions
* Why the RTL-to-GDSII flow is iterative rather than strictly linear

# Files

* `notes/rtl_to_gds.md` — Detailed notes covering the complete RTL-to-GDSII flow, stage handoffs, inputs, outputs, verification boundaries, and feedback loops
* `README.md` — Module overview and file description

# Module Description

The module covers the following major stages:

* Specification
* Microarchitecture
* RTL design
* Functional verification
* Logical Equivalence Checking
* Logic synthesis
* Standard-cell libraries
* Timing constraints
* Technology mapping
* Physical-design handoff
* Floorplanning
* Macro placement
* Core utilization
* Placement
* Global placement
* Legalization
* Detailed placement
* Clock Tree Synthesis
* Clock latency
* Clock skew
* Useful skew
* Routing
* Global routing
* Detailed routing
* Parasitic extraction
* SPEF
* Physical-design signoff
* GDSII and OASIS generation
* Tapeout

The complete simplified flow is:

```text
Specification
→ Microarchitecture
→ RTL Design
→ Functional Verification
→ Logic Synthesis
→ Floorplanning
→ Power Planning
→ Placement
→ Clock Tree Synthesis
→ Routing
→ Parasitic Extraction
→ Signoff
→ GDSII / OASIS
→ Tapeout
```

Important abstraction distinctions include:

* Specification defines what the design must do.
* Microarchitecture defines what hardware organization will implement the specification.
* RTL describes the microarchitecture using registers and combinational logic.
* Functional verification compares RTL behavior against the specification.
* Synthesis maps RTL into standard cells.
* Floorplanning determines the global physical organization.
* Placement determines standard-cell locations.
* CTS builds the physical clock network.
* Routing creates exact metal and via connections.
* Parasitic extraction calculates interconnect resistance and capacitance.
* Signoff verifies timing, manufacturability, electrical safety, power integrity, and reliability.
* GDSII or OASIS stores the final manufacturing geometry.

The three primary design representations are:

| Representation     | Main Content                                     |
| ------------------ | ------------------------------------------------ |
| RTL                | Register-transfer behavior                       |
| Gate-level netlist | Standard-cell instances and logical connectivity |
| GDSII/OASIS        | Final manufacturing geometry                     |

The three important consistency checks are:

| Check                   | Comparison               |
| ----------------------- | ------------------------ |
| Functional verification | RTL versus specification |
| LEC                     | Netlist versus RTL       |
| LVS                     | Layout versus netlist    |

Passing LEC and LVS does not prove that the original RTL correctly implements the specification. A functional error can be preserved consistently through synthesis and physical implementation.

The module also emphasizes feedback loops.

Examples include:

* Synthesis timing failure may require RTL or microarchitecture changes.
* Placement congestion may require floorplan modification.
* CTS problems may require placement or clock-constraint changes.
* Routing detours may require placement or macro movement.
* Signoff violations may require ECO implementation and repeated analysis.

A later-stage problem may originate from an earlier stage. For example:

```text
Poor macro placement
→ narrow routing channel
→ congestion
→ routing detour
→ larger parasitics
→ setup violation
```

Therefore, successful RTL-to-GDSII closure depends on root-cause analysis rather than repeatedly optimizing only the stage where the problem was first observed.

# Testbench

This module does not contain one dedicated Verilog testbench.

Functional verification appears as one stage of the complete flow and may use:

* Directed simulation
* Constrained-random simulation
* Assertions
* Functional coverage
* Code coverage
* Formal verification
* Reference models

The testbench verifies:

> RTL behavior versus specification

Other verification methods in the flow include:

* LEC for netlist-versus-RTL equivalence
* LVS for layout-versus-netlist consistency
* STA for timing verification
* DRC for manufacturing geometry
* ERC for electrical-rule compliance
* EM and IR-drop analysis for reliability and power integrity

# Waveform

This module does not produce one final waveform.

Different stages produce different engineering outputs, including:

* RTL simulation waveforms
* Functional coverage reports
* Synthesis timing reports
* Area and power reports
* Placement-density maps
* Congestion maps
* Clock-tree latency and skew reports
* Routed-layout views
* Parasitic extraction files
* Setup and hold reports
* Signal-integrity reports
* EM and IR-drop maps
* DRC, LVS, and ERC reports
* Final GDSII or OASIS database

The final result of the flow is not a waveform. It is a verified physical manufacturing database and an approved tapeout package.
