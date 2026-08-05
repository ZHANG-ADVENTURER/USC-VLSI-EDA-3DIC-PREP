# Day 25 Daily Log

## Topic

Synthesis, Gate-Level Netlist, and Standard Cells

## What I Learned

Today I studied how logic synthesis converts RTL into a gate-level netlist using a target standard-cell library and design constraints.

I learned that the three main synthesis inputs are:

```text
RTL
Standard-Cell Library
Design Constraints
```

RTL describes the intended logic and sequential behavior.

The standard-cell library defines the available cells and provides their logical, timing, power, area, and physical information.

Design constraints define timing goals and electrical requirements such as clock period, input delay, output delay, maximum transition, maximum capacitance, and maximum fanout.

I learned the main synthesis stages:

```text
Analyze / Elaborate
↓
Technology-Independent Optimization
↓
Technology Mapping
↓
Post-Mapping Optimization
↓
Write Netlist and Reports
```

Analyze and elaborate read the RTL, resolve parameters, expand generate structures, construct module hierarchy, and determine the concrete design structure.

Technology-independent optimization simplifies abstract Boolean and sequential logic before selecting specific standard cells.

Technology mapping converts the optimized logic into real cells from the target library.

Post-mapping optimization performs operations such as cell sizing, buffer insertion, fanout repair, transition repair, and timing optimization.

I also learned that successful synthesis does not necessarily mean that the design satisfies all constraints. A netlist can still be generated while timing violations, design-rule violations, or unconstrained paths remain.

## What I Built / Produced

### Code

No new RTL or testbench code was created because this project focused on synthesis and physical-design concepts.

### Testbench

No testbench was created.

Concept understanding was verified through questions involving:

- synthesis inputs and outputs
- library-file differences
- synthesis-stage ordering
- gate-level netlist interpretation
- cell delay and drive strength
- setup and hold timing
- slack calculations
- timing exceptions
- PVT corners
- synthesis reports

### Waveform

No waveform was generated because the project did not include RTL simulation.

### Notes

Created:

```text
02_physical_design_notes/
└── 02_synthesis_netlist_standard_cell/
    └── notes/
        └── synthesis-netlist-standard-cell.md
```

The notes cover:

- logic synthesis inputs and outputs
- standard-cell library views
- synthesis stages
- technology mapping
- gate-level netlists
- timing arcs
- input slew and output load
- drive strength and cell sizing
- fanout and buffer insertion
- timing and design-rule constraints
- setup and hold analysis
- arrival time, required time, and slack
- WNS, TNS, and critical paths
- input and output delays
- synthesis reports
- PVT corners
- false paths
- multicycle paths
- unconstrained paths

### README

Created:

```text
02_physical_design_notes/
└── 02_synthesis_netlist_standard_cell/
    └── README.md
```

The README summarizes the purpose, files, concepts, verification method, and waveform status of the project.

## Key Concepts

### Logic Synthesis

Logic synthesis converts RTL into a gate-level implementation using cells from a target standard-cell library.

### RTL

RTL describes the intended logical and sequential behavior of the circuit without specifying final physical cells or coordinates.

### Standard-Cell Library

A standard-cell library contains reusable logic cells such as inverters, NAND gates, multiplexers, buffers, and flip-flops.

### Design Constraints

Design constraints define timing goals, interface timing, and electrical limits that guide synthesis optimization.

### Liberty File

A `.lib` file contains logical functions, timing arcs, delay tables, transition tables, power data, input capacitance, setup and hold checks, and PVT information.

### LEF File

A `.lef` file contains the physical abstraction of a cell, including width, height, boundaries, pin positions, pin shapes, and routing blockages.

### GDS File

A `.gds` file contains the complete physical layout geometry required for fabrication.

### Analyze and Elaborate

Analyze reads and checks the RTL.

Elaboration resolves parameters, generate blocks, hierarchy, widths, and instance connections to construct the concrete design.

### Technology-Independent Optimization

This stage simplifies abstract Boolean and sequential logic before selecting specific standard cells.

### Technology Mapping

Technology mapping selects actual cells from the target standard-cell library to implement the optimized logic.

### Post-Mapping Optimization

Post-mapping optimization adjusts the mapped netlist through cell sizing, buffer insertion, restructuring, and design-rule repair.

### Gate-Level Netlist

A gate-level netlist contains standard-cell types, instance names, internal nets, pins, and connectivity.

It normally does not contain final cell coordinates, routing paths, metal layers, via locations, or extracted parasitic RC.

### Cell Type

The cell type identifies the standard-cell function and drive-strength version.

Example:

```text
NAND2_X2
```

### Instance Name

The instance name uniquely identifies one particular cell instance in the design.

Example:

```text
U17
```

### Timing Arc

A timing arc describes the timing relationship between two pins of a standard cell.

Examples include:

```text
A → Y
CLK → Q
```

### Input Slew

Input slew describes how quickly an input signal transitions between logic levels.

Slower input slew usually increases cell delay.

### Output Load

Output load includes downstream input capacitance, wire capacitance, and other parasitic capacitance.

A larger output load usually increases delay and slows the output transition.

### Drive Strength

Drive strength describes a cell’s ability to drive an output load.

A stronger cell may reduce delay under a large load, but usually increases area, power, and input capacitance.

### PPA Tradeoff

PPA represents:

```text
Power
Performance
Area
```

Synthesis optimization must balance all three rather than maximizing only performance.

### Fanout

Fanout is the number of input pins driven by one output net.

Fanout alone does not fully represent the electrical load because different pins may have different capacitances.

### Buffer Insertion

Buffer insertion distributes large loads, improves transition, and repairs fanout or capacitance violations.

Its costs include additional area, power, cell count, and propagation delay.

### Timing Constraint

A timing constraint defines when data must arrive.

Examples include:

```text
Clock period
Input delay
Output delay
Clock uncertainty
```

### Synthesis Design-Rule Constraint

A synthesis design-rule constraint limits electrical loading and signal quality.

Examples include:

```text
Maximum fanout
Maximum capacitance
Maximum transition
```

### Physical DRC

Physical DRC checks layout geometry such as metal width, spacing, via enclosure, and layer overlap.

It is different from synthesis design-rule checking.

### Clock-to-Q Delay

Clock-to-Q delay is the propagation delay from the active clock edge at a launch register to the change at its `Q` output.

### Setup Time

Setup time requires data to be stable for a minimum interval before the capture clock edge.

A setup violation means that data arrived too late.

### Hold Time

Hold time requires data to remain stable for a minimum interval after the capture clock edge.

A hold violation means that new data arrived too early.

### Arrival Time

Arrival time represents when data actually reaches the timing endpoint.

### Required Time

Required time represents the latest allowed arrival time under the timing constraint.

### Slack

For setup analysis:

```text
Slack
=
Required Time
-
Arrival Time
```

Positive slack means the path passes.

Negative slack means the path violates timing.

### Critical Path

The critical path is normally the timing path with the worst slack, not necessarily the path with the largest raw delay.

### WNS

WNS means Worst Negative Slack.

It represents the most severe timing violation.

### TNS

TNS means Total Negative Slack.

It represents the sum of all negative slack values.

### Setup Repair

Setup repair aims to reduce maximum data-path delay.

Possible methods include faster cells, stronger cells, reduced logic depth, optimized buffering, shorter routing, and pipelining.

### Hold Repair

Hold repair aims to increase minimum data-path delay.

Possible methods include delay buffers, slower cells, dedicated delay cells, routing delay, and clock-skew adjustment.

### Input Delay

Input delay represents the external delay before data reaches the current design input port.

A larger input delay leaves less time for the internal input-to-register path.

### Output Delay

Output delay reserves time for external interconnect and the external receiving circuit.

### Synthesis Timing

Synthesis timing normally uses estimated interconnect delay because final placement and routing are not yet available.

### Post-Route Timing

Post-route STA uses routed geometry and extracted parasitic resistance and capacitance.

Synthesis timing passing does not guarantee that post-route timing will pass.

### PVT Corner

PVT represents process, voltage, and temperature.

Different PVT conditions change cell delay, transition, leakage, and power.

### Setup Corner

Setup analysis usually becomes more difficult under slower conditions because data may arrive too late.

### Hold Corner

Hold analysis usually becomes more difficult under faster conditions because data may arrive too early.

### False Path

A false path is intentionally excluded from normal setup and hold timing analysis based on a valid architectural or functional reason.

A false-path constraint does not solve metastability.

### Multicycle Path

A multicycle path is allowed to use multiple clock cycles because of a real architectural mechanism such as a clock enable, valid signal, FSM, or protocol.

The constraint does not automatically modify the RTL.

### Unconstrained Path

An unconstrained path lacks enough timing information for STA to calculate a meaningful required time.

An unconstrained path is not equivalent to a timing pass.

## Problems and Fixes

### Problem: Confusing RTL Ports with Synthesis Inputs

I initially identified input, logic, and output as the three synthesis inputs.

### Fix

I corrected the synthesis inputs to:

```text
RTL
Standard-Cell Library
Design Constraints
```

---

### Problem: Confusing Input Slew with Clock Skew

I initially used the term `input skew`.

### Fix

The correct term is `input slew`.

```text
Input slew
→ Signal transition speed

Clock skew
→ Difference in clock arrival times
```

---

### Problem: Assuming Cell Delay Mainly Depends on Routing

I initially focused only on later routing effects.

### Fix

I learned that standard-cell delay primarily depends on:

```text
Input slew
Output load
PVT corner
```

Routing contributes interconnect delay and also affects the capacitive load seen by the driver.

---

### Problem: Misunderstanding Stronger Cell Resistance

I initially thought that a stronger cell could have greater output resistance.

### Fix

A stronger cell normally has lower effective output resistance but larger input capacitance, area, and power.

---

### Problem: Confusing Timing Constraints and Design-Rule Constraints

I initially classified maximum transition as a timing constraint.

### Fix

I learned that:

```text
create_clock
→ Timing constraint

set_max_transition
→ Synthesis design-rule constraint
```

---

### Problem: Confusing Launch and Capture Register Timing

I initially associated clock-to-Q delay with the capture register.

### Fix

Clock-to-Q delay belongs to the launch register.

Setup time belongs to the capture register.

---

### Problem: Reversing the Hold Repair Direction

I initially stated that hold repair should reduce minimum path delay.

### Fix

A hold violation means data arrives too early, so minimum data-path delay must normally be increased.

---

### Problem: Incorrect TNS Calculation

I initially calculated TNS incorrectly.

### Fix

TNS includes only negative slack values.

Example:

```text
-0.4 ns + -0.1 ns = -0.5 ns
```

Positive slack is not included.

---

### Problem: Assuming Positive WNS Proves Complete Timing Coverage

I initially thought positive WNS meant that all important paths had been checked.

### Fix

Positive WNS only describes analyzed and constrained paths.

Constraint coverage must also be checked for unconstrained endpoints, missing clocks, missing I/O delays, and incomplete clock relationships.

---

### Problem: Misunderstanding Unconstrained Paths

I initially described an unconstrained path as a path with excessive delay.

### Fix

An unconstrained path is a path for which the tool lacks sufficient timing requirements.

Its delay may be short or long, but the tool cannot calculate a meaningful timing result without the missing constraints.

---

### Problem: Confusing Netlist Contents with Report Contents

I initially included timing, area, and power information as core netlist contents.

### Fix

The gate-level netlist mainly contains:

```text
Cell types
Instance names
Pin connections
Internal nets
Connectivity
```

Timing, area, and power information belongs mainly to separate reports.

---

### Problem: Reversing Synthesis Optimization Stages

I initially placed technology mapping before technology-independent optimization.

### Fix

The correct order is:

```text
Analyze / Elaborate
↓
Technology-Independent Optimization
↓
Technology Mapping
↓
Post-Mapping Optimization
↓
Write Netlist and Reports
```

Abstract logic must be optimized before it is mapped to actual standard cells.

## Connection to VLSI / EDA / 3D IC

### VLSI Design

Synthesis connects RTL design with transistor-based standard-cell implementation.

It converts behavioral and register-transfer descriptions into a technology-dependent gate-level structure that can enter physical design.

### EDA

Synthesis is a major EDA stage.

EDA tools perform:

- RTL analysis
- elaboration
- Boolean optimization
- technology mapping
- cell sizing
- buffering
- timing analysis
- area estimation
- power estimation
- constraint checking

Understanding synthesis reports is necessary for evaluating whether an implementation is suitable for later physical-design stages.

### Physical Design

The gate-level netlist produced by synthesis becomes a major input to:

- floorplanning
- placement
- Clock Tree Synthesis
- routing
- parasitic extraction
- post-route STA

The `.lef` physical abstraction and gate-level connectivity allow physical-design tools to place cells and route nets.

### Static Timing Analysis

The timing concepts studied today directly support STA:

- timing arcs
- setup
- hold
- clock-to-Q
- arrival time
- required time
- slack
- WNS
- TNS
- timing exceptions
- PVT corners

These concepts will be expanded during the dedicated STA stage.

### 3D IC

In 3D IC and chiplet systems, synthesis still creates gate-level netlists for individual dies or design blocks.

Later stages must also consider:

- die-to-die interfaces
- partitioning
- inter-die latency
- clock distribution
- power delivery
- TSV or hybrid-bond parasitics
- thermal effects
- timing across multiple dies

The timing and PVT principles learned here remain important because 3D integration introduces additional interconnect, power, and thermal constraints.

## One Sentence Summary

Logic synthesis transforms RTL into an optimized standard-cell gate-level netlist while balancing timing, power, area, electrical design rules, and constraint coverage.

## Next Step

Study floorplanning and learn how the synthesized gate-level netlist, macros, I/O locations, utilization targets, aspect ratio, and physical constraints are organized into an initial chip layout.