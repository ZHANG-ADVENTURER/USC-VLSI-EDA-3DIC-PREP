# Project Title

RTL-to-GDSII File Formats and Handoffs

# Overview

This module explains the major file formats used throughout the RTL-to-GDSII flow and how information is transferred between front-end design, synthesis, physical design, timing analysis, signoff, and tapeout.

The main purpose is to understand that different files describe different aspects of the same integrated circuit.

These aspects include:

* Register-transfer behavior
* Logical cell connectivity
* Timing requirements
* Cell timing and power characteristics
* Abstract physical library information
* Design-specific placement and routing
* Extracted interconnect parasitics
* Calculated timing delays
* Final manufacturing geometry

The module covers the following core file relationship:

> RTL  
> → register-transfer behavior
>
> Gate-level netlist  
> → standard-cell instances and logical connectivity
>
> SDC  
> → timing requirements and exceptions
>
> `.lib`  
> → cell timing, electrical and power models
>
> Cell LEF  
> → abstract physical cell information
>
> Technology LEF  
> → routing and placement technology
>
> DEF  
> → design-specific physical implementation
>
> SPEF  
> → extracted interconnect resistance and capacitance
>
> SDF  
> → calculated delay back-annotation
>
> GDSII/OASIS  
> → final manufacturing geometry

Each file answers a different engineering question and is used by different EDA tools.

# Files

* `notes/file_formats.md` — Detailed notes covering RTL, gate-level netlist, SDC, `.lib`, LEF, DEF, SPEF, SDF, GDSII/OASIS, and the complete RTL-to-GDSII file handoff flow
* `README.md` — Module overview and file summary

# Module Description

The module begins by dividing RTL-to-GDSII files into four major categories.

## Logical Design Files

These describe circuit behavior or logical connectivity.

Examples include:

* RTL
* Gate-level netlist

RTL describes register-transfer behavior and intended synthesizable hardware.

The gate-level netlist describes:

* Standard-cell types
* Instance names
* Pin connections
* Logical nets

The netlist does not contain final placement coordinates, metal routes, vias, or manufacturing geometry.

## Constraint and Analysis Files

These describe timing requirements or calculated implementation results.

Examples include:

* SDC
* SPEF
* SDF

SDC describes timing intent, including:

* Clock periods
* Input delays
* Output delays
* Clock uncertainty
* Electrical constraints
* False paths
* Multicycle paths

SPEF stores extracted interconnect parasitics:

* Wire resistance
* Via resistance
* Ground capacitance
* Coupling capacitance

SDF stores calculated delay information used primarily for gate-level simulation back-annotation.

## Library and Technology Files

These describe reusable cells and manufacturing technology.

Examples include:

* `.lib`
* Cell LEF
* Technology LEF
* Library GDSII/OASIS

The `.lib` file contains:

* Boolean functions
* Timing arcs
* Propagation delay
* Input capacitance
* Output transition
* Setup and hold requirements
* Recovery and removal requirements
* Power information
* PVT operating conditions

Cell LEF contains:

* Cell width and height
* Cell boundary
* Pin locations
* Pin metal shapes
* Routing obstructions
* Placement-site information

Technology LEF contains:

* Metal layers
* Via and cut layers
* Preferred routing directions
* Routing pitch
* Width and spacing information
* Via definitions
* Manufacturing grid
* Placement sites

## Physical Implementation Files

These describe how one specific design is physically implemented.

Examples include:

* DEF
* GDSII
* OASIS

DEF may contain:

* Die boundary
* Placement rows
* Standard-cell locations
* Macro locations
* Cell orientations
* Top-level pins
* Placement blockages
* Routing blockages
* Special nets
* Signal routes
* Vias

GDSII/OASIS contains the complete final manufacturing geometry, including:

* Standard-cell internal layout
* Macro geometry
* Diffusion
* Contacts
* Metal wires
* Vias
* Power structures
* Metal fill
* Layer and datatype information

The main abstraction relationship is:

> RTL  
> → behavior
>
> Gate-level netlist  
> → logical implementation
>
> DEF  
> → physical implementation
>
> GDSII/OASIS  
> → final manufacturing geometry

The module also distinguishes `.lib` from LEF.

| `.lib`                       | LEF                     |
| ---------------------------- | ----------------------- |
| Logical and electrical model | Abstract physical model |
| Boolean function             | Cell dimensions         |
| Timing arcs                  | Pin locations           |
| Delay tables                 | Cell boundary           |
| Input capacitance            | Routing obstruction     |
| Setup and hold               | Placement site          |
| Power information            | Physical routing access |

A simple memory rule is:

> `.lib`  
> → What does the cell do electrically?
>
> LEF  
> → What does the cell look like physically?

The relationship among netlist, LEF, and DEF is:

> Gate-level netlist  
> → which instance exists and how it is logically connected
>
> LEF  
> → what the referenced cell type looks like
>
> DEF  
> → where that particular instance is physically placed

For example:

> Gate-level netlist:  
> INV_X1 U25
>
> Cell LEF:  
> INV_X1 has a defined width, height and pin geometry
>
> DEF:  
> U25 is placed at a specific coordinate and orientation

The same instance names must remain consistent across logical and physical databases.

The module also explains the primary files used by post-route STA:

> Gate-level netlist  
> + SDC  
> + `.lib`  
> + SPEF  
> → Static Timing Analysis

Their roles are:

| File               | STA Role                                |
| ------------------ | --------------------------------------- |
| Gate-level netlist | Timing-path connectivity                |
| SDC                | Timing requirements and exceptions      |
| `.lib`             | Cell timing models and timing checks    |
| SPEF               | Interconnect resistance and capacitance |

SDF is mainly used for gate-level timing simulation rather than as a primary STA input.

The distinction is:

> SPEF  
> → extracted RC network
>
> SDF  
> → calculated delay annotation

The module concludes with the stream-out flow:

> Physical implementation database  
> + standard-cell GDSII/OASIS  
> + macro GDSII/OASIS  
> + layer map  
> → Stream-out  
> → Final chip GDSII/OASIS

DEF provides design-specific placement and routing information.

Library GDSII/OASIS provides the complete internal geometry of each standard cell and macro.

The layer map converts internal EDA layer names and purposes into foundry-defined GDS layer numbers and datatypes.

After metal-fill insertion, parasitic extraction and timing analysis may need to be repeated because fill can change:

* Ground capacitance
* Coupling capacitance
* Interconnect delay
* Crosstalk behavior

The complete file handoff flow is:

> RTL + SDC + `.lib`  
> → Logic Synthesis  
> → Gate-level netlist
>
> Gate-level netlist + SDC + `.lib` + LEF  
> → Physical Design  
> → DEF and implementation database
>
> Routed design + extraction models  
> → Parasitic Extraction  
> → SPEF
>
> Netlist + SDC + `.lib` + SPEF  
> → STA  
> → Timing reports and possible SDF
>
> Physical database + library layouts + layer map  
> → Stream-out  
> → GDSII/OASIS

# Testbench

This module does not contain one dedicated Verilog testbench.

Testbench-related files are relevant mainly to RTL simulation and gate-level simulation.

RTL simulation commonly uses:

* RTL
* Testbench
* Assertions
* Reference models

Timing-aware gate-level simulation may use:

* Gate-level netlist
* Functional standard-cell models
* SDF
* Testbench

SDF back-annotation adds calculated delays and timing checks to the simulated gate-level design.

However, SDF simulation does not replace Static Timing Analysis.

Gate-level simulation only observes paths activated by the testbench, while STA systematically analyzes all constrained timing paths without requiring test vectors.

# Waveform

This module does not produce one final waveform.

Different stages generate different outputs.

Examples include:

* RTL simulation waveforms
* Gate-level simulation waveforms
* Synthesis timing reports
* Constraint reports
* DEF placement snapshots
* Routing databases
* Congestion maps
* SPEF parasitic files
* STA setup and hold reports
* SDF timing annotation
* DRC and LVS reports
* Final GDSII/OASIS layout database

A waveform represents signal behavior over time.

DEF, SPEF, and GDSII/OASIS instead represent physical implementation information, electrical parasitics, and manufacturing geometry.

The final result of this module is a complete understanding of how logical, timing, library, physical, extraction, simulation, and manufacturing files are connected throughout the RTL-to-GDSII flow.
