# Day 32 Daily Log

## Topic

RTL-to-GDSII File Formats and Handoffs

## What I Learned

Today I learned how the major RTL-to-GDSII file formats divide information across logical design, timing constraints, library models, physical implementation, parasitic extraction, simulation, and manufacturing.

The central idea is:

> Different files describe different views of the same chip.

The main file relationship is:

> RTL → register-transfer behavior  
> Gate-level netlist → standard-cell instances and logical connectivity  
> SDC → timing requirements and exceptions  
> `.lib` → cell logic, timing, electrical, and power models  
> Cell LEF → abstract physical cell information  
> Technology LEF → process routing and placement technology  
> DEF → design-specific placement and routing  
> SPEF → extracted interconnect resistance and capacitance  
> SDF → calculated delay back-annotation  
> GDSII/OASIS → final manufacturing geometry

I learned to separate three abstraction concepts:

* Behavior describes what the circuit does and is primarily represented by RTL.
* Connectivity describes which instances and pins are connected and is represented by the gate-level netlist.
* Geometry describes physical locations, shapes, layers, wires, and vias and is represented by DEF and GDSII/OASIS.

I also learned the roles of the major handoff files:

* RTL describes synthesizable hardware behavior but not exact standard cells or physical coordinates.
* The gate-level netlist contains mapped cell types, instance names, nets, and pin connections.
* SDC defines timing intent, including clocks, I/O delays, uncertainty, false paths, and multicycle paths.
* `.lib` provides cell timing, power, and electrical behavior.
* Cell LEF provides cell dimensions, pins, and routing obstructions.
* Technology LEF provides process-wide metal, via, placement, and routing information.
* DEF records the physical implementation of one design, including placement and routing objects.
* SPEF stores the RC parasitics extracted from routed interconnect.
* SDF stores calculated delays and timing checks for gate-level simulation.
* GDSII/OASIS stores the final detailed manufacturing geometry.

Several distinctions were especially important:

* `.lib` is the logical and electrical view; LEF is the abstract physical view.
* Cell LEF describes one cell or macro; Technology LEF describes process-wide routing technology.
* DEF describes design-specific implementation; GDSII/OASIS contains complete manufacturing geometry.
* SPEF stores resistance and capacitance; SDF stores calculated delay values.
* A false path is intentionally excluded from normal functional timing analysis.
* A multicycle path is architecturally allowed more than one clock cycle.
* An unconstrained path may not have been checked correctly and must not be treated as timing-clean.

The primary post-route STA inputs are:

> Gate-level netlist + SDC + `.lib` + SPEF → STA

The gate-level netlist provides timing-path connectivity, SDC provides timing requirements, `.lib` provides cell timing models, and SPEF provides interconnect parasitics.

I also learned that SDF simulation cannot replace STA because simulation only observes paths activated by testbench stimulus, while STA analyzes all constrained timing paths without requiring test vectors.

The final stream-out relationship is:

> Physical implementation database + library GDSII/OASIS + macro GDSII/OASIS + layer map → final GDSII/OASIS

DEF supplies instance placement and design-level routing. Library layouts supply complete internal cell geometry. The layer map translates internal EDA layers into foundry layer and datatype identifiers.

## What I Built

I completed the RTL-to-GDSII File Formats and Handoffs module.

Created files:

* `02_physical_design_notes/09_file_formats/notes/file_formats.md`
* `02_physical_design_notes/09_file_formats/README.md`
* `daily-log/Day32.md`

The detailed technical explanations are stored in the notes file. This daily log records the main concepts, corrected misunderstandings, and connection to later STA and physical-design work.

## Key Concepts

### RTL

Describes synthesizable register-transfer behavior.

### Gate-Level Netlist

Contains mapped standard-cell instances and logical pin connectivity.

### SDC

Defines clocks, timing requirements, external assumptions, and timing exceptions.

### `.lib`

Provides logical, timing, electrical, and power models for library cells.

### Cell LEF

Provides abstract dimensions, pins, boundaries, and obstructions for cells and macros.

### Technology LEF

Provides process-wide metal, via, site, grid, and routing information.

### DEF

Records design-specific placement, orientation, blockages, routes, and vias.

### SPEF

Stores extracted interconnect resistance and capacitance.

### SDF

Stores calculated delays and timing checks for simulation back-annotation.

### GDSII/OASIS

Stores final detailed manufacturing geometry.

### False Path

A real path that does not require normal functional setup and hold analysis.

### Multicycle Path

A valid path allowed more than one clock period by the architecture.

### Unconstrained Path

A path for which STA lacks a complete timing requirement.

### Stream-Out

Generates final GDSII/OASIS from the implementation database and library layouts.

### Layer Map

Maps internal EDA layer purposes to foundry layer and datatype identifiers.

## Problems / Fixes

### Problem 1: Reversed DEF and GDSII/OASIS

I initially associated DEF with final manufacturing geometry.

Fix:

DEF describes design-specific placement and routing. GDSII/OASIS contains final detailed manufacturing geometry.

### Problem 2: Misunderstood timing exceptions

I initially treated false, multicycle, and unconstrained paths too loosely.

Fix:

* A false path is intentionally excluded from normal functional timing checks.
* A multicycle path is architecturally allowed multiple cycles.
* An unconstrained path may not have been checked correctly.

### Problem 3: Used the wrong `.lib` lookup variables

I initially used arrival time and delay time as lookup variables.

Fix:

The main combinational cell-delay lookup variables are input slew and output load capacitance. Arrival time is calculated later by STA.

### Problem 4: Confused library physical views

I initially reversed `.lib` and LEF and did not clearly separate Cell LEF from Technology LEF.

Fix:

* `.lib` contains logical, timing, power, and electrical behavior.
* Cell LEF describes one cell or macro.
* Technology LEF describes process-wide routing and placement technology.

### Problem 5: Included SDF as a primary STA input

Fix:

The primary post-route STA inputs are the gate-level netlist, SDC, `.lib`, and SPEF. SDF is mainly used for timing-aware gate-level simulation.

### Problem 6: Connected DEF content with testbench activity

Fix:

DEF records physical implementation independently of testbench activation. Testbench activity may affect simulation or power-analysis activity data, but it does not determine DEF connectivity.

## Connection to VLSI / EDA / 3D IC

Understanding file handoffs is essential because every EDA stage depends on consistent data from earlier stages.

For RTL and synthesis work, RTL, SDC, and `.lib` determine the mapped gate-level implementation.

For Physical Design, the netlist provides instances and connectivity, LEF provides physical library abstractions, and DEF records placement and routing.

For STA, the netlist, SDC, `.lib`, and SPEF must use consistent names, hierarchy, units, and corners.

For EDA development, these formats define interfaces among synthesis, placement, CTS, routing, extraction, STA, simulation, and physical verification.

For 3D IC design, the same handoff principles extend to dies, interposers, TSVs, microbumps, package routing, cross-die timing, and package parasitics.

## One Sentence Summary

RTL-to-GDSII file formats provide complementary logical, timing, electrical, physical, and manufacturing views of the same chip, and correct handoff requires consistency across all views.

## Next Step

Begin Static Timing Analysis by learning timing-path structure, including startpoint, endpoint, launch clock, capture clock, cell delay, net delay, arrival time, required time, and slack.
