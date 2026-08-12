# Synthesis, Gate-Level Netlist, and Standard Cells

## 1. Overview

Logic synthesis converts an RTL design into a gate-level implementation constructed from cells in a target standard-cell library.

The basic relationship is:

```text
RTL
+
Standard-Cell Library
+
Design Constraints
↓
Logic Synthesis
↓
Gate-Level Netlist
+
Timing / Area / Power / Constraint Reports
```

RTL describes the intended logical and sequential behavior.

The standard-cell library defines which cells the synthesis tool may use and provides their logical, timing, power, area, and physical information.

Design constraints specify the performance and electrical requirements that the synthesized implementation should satisfy.

Synthesis is not a line-by-line replacement of Verilog statements with logic gates. The tool analyzes, elaborates, simplifies, restructures, maps, and optimizes the design according to the target library and constraints.

---

## 2. Main Inputs to Logic Synthesis

The three main synthesis inputs are:

```text
RTL
Standard-Cell Library
Design Constraints
```

### RTL

RTL describes what the circuit should do and how data moves between registers.

RTL may contain:

- combinational expressions
- multiplexers
- arithmetic operations
- registers
- counters
- finite-state machines
- module hierarchy
- parameters
- generate blocks

Example:

```verilog
always @(posedge clk)
    q <= d;
```

This describes edge-triggered storage behavior, but it does not specify the exact flip-flop cell used in the manufactured design.

After synthesis, it may be mapped to a standard-cell instance:

```verilog
DFF_X1 U_REG_Q (
    .D(d),
    .CLK(clk),
    .Q(q)
);
```

### Standard-Cell Library

The standard-cell library tells synthesis which cells are available.

Examples include:

```text
INV_X1
INV_X2
INV_X4
NAND2_X1
NOR2_X1
AOI21_X2
MUX2_X1
DFF_X1
BUF_X4
```

The library may provide information such as:

- logical function
- pin definitions
- timing arcs
- cell delay
- input capacitance
- output transition
- setup and hold requirements
- clock-to-Q delay
- drive strength
- power
- abstract area
- physical dimensions
- physical geometry

The same RTL may produce different gate-level netlists when synthesized with different standard-cell libraries.

### Design Constraints

Design constraints tell the synthesis tool what the implementation must achieve.

Examples include:

```tcl
create_clock -period 5 [get_ports clk]

set_input_delay 1.0 \
    -clock clk \
    [get_ports data_in]

set_output_delay 1.5 \
    -clock clk \
    [get_ports data_out]

set_max_transition 0.2 [current_design]

set_max_fanout 8 [current_design]
```

Constraints guide optimization.

A tighter clock period may cause the synthesis tool to:

- choose faster cells
- use stronger drive strengths
- insert buffers
- reduce logic depth
- restructure Boolean logic
- duplicate high-fanout logic
- consume more area
- consume more power

An impossible constraint does not necessarily stop synthesis.

The tool may still produce a gate-level netlist while reporting:

- negative slack
- max transition violations
- max capacitance violations
- max fanout violations
- unconstrained paths

Therefore:

```text
Netlist generated successfully
≠
All constraints passed
```

---

## 3. Standard-Cell Library Views

A standard-cell library is represented through multiple views because different EDA stages require different information.

The three important views are:

```text
.lib
.lef
.gds
```

### Liberty File: `.lib`

The Liberty file contains logical, timing, power, and electrical characterization data.

It may contain:

- Boolean functions
- input and output pins
- timing arcs
- cell delay lookup tables
- output transition lookup tables
- input pin capacitance
- clock-to-Q delay
- setup checks
- hold checks
- recovery and removal checks
- internal power
- switching power information
- leakage power
- abstract cell area
- process corner
- voltage
- temperature
- timing units
- capacitance units

Synthesis and STA primarily use `.lib` data.

```text
.lib
→ Function, timing, power, and electrical behavior
```

### LEF File: `.lef`

The LEF file contains an abstract physical representation of a cell.

It may contain:

- cell width
- cell height
- cell boundary
- pin locations
- pin shapes
- routing access information
- routing blockages
- placement properties
- allowed orientations
- obstruction regions

Placement and routing tools use LEF information without reading the complete transistor-level layout.

```text
.lef
→ Physical abstract used by placement and routing
```

The LEF view normally does not contain the complete internal transistor manufacturing geometry.

### GDS File: `.gds`

The GDS file contains the complete physical layout geometry needed for fabrication.

It may contain:

- active regions
- polysilicon
- wells
- contacts
- local interconnect
- metal layers
- vias
- complete mask geometry

```text
.gds
→ Complete fabrication layout geometry
```

### Comparison

```text
.lib
→ Function + timing + power + electrical characterization

.lef
→ Cell dimensions + pin geometry + physical abstraction

.gds
→ Complete transistor and interconnect layout geometry
```

### Typical Tool Usage

```text
Logic Synthesis
→ Primarily uses RTL, constraints, and .lib

Static Timing Analysis
→ Primarily uses netlist, constraints, .lib, and parasitics

Placement and Routing
→ Uses netlist, LEF, technology files, constraints, and libraries

Fabrication Data
→ Uses final GDS
```

---

## 4. Main Synthesis Stages

The main synthesis stages are:

```text
1. Analyze / Elaborate
2. Technology-Independent Optimization
3. Technology Mapping
4. Post-Mapping Optimization
5. Write Netlist and Reports
```

### Analyze

The tool first reads and analyzes the RTL.

It checks items such as:

- syntax
- module definitions
- signal declarations
- expressions
- always blocks
- assignments
- module instances
- port connections

Syntax or language errors may stop the flow during this stage.

### Elaborate

Elaboration constructs the concrete design structure from parameterized and hierarchical RTL.

It resolves:

- parameter values
- generate blocks
- module hierarchy
- instance connections
- port widths
- constant expressions
- array dimensions
- design top module

Example:

```verilog
module counter #(
    parameter WIDTH = 8
) (
    input  wire             clk,
    input  wire             rst_n,
    output reg [WIDTH-1:0]  count
);
```

If it is instantiated as:

```verilog
counter #(
    .WIDTH(16)
) u_counter (
    .clk(clk),
    .rst_n(rst_n),
    .count(count)
);
```

Elaboration determines:

```text
WIDTH = 16
```

and constructs a concrete 16-bit counter structure.

```text
Elaboration
→ Understand and expand the specific RTL design structure
```

### Technology-Independent Optimization

At this stage, the tool optimizes abstract logic before selecting specific standard cells.

Example:

```verilog
assign y = (a & 1'b1) | 1'b0;
```

This can be simplified to:

```verilog
assign y = a;
```

Possible technology-independent optimizations include:

- constant propagation
- Boolean simplification
- dead logic removal
- unreachable state removal
- common subexpression sharing
- mux simplification
- logic restructuring
- redundant logic elimination

The tool does not yet need to decide whether to use:

```text
NAND2_X1
AOI21_X2
INV_X4
```

```text
Technology-independent optimization
→ Optimize abstract Boolean and sequential logic
```

### Technology Mapping

Technology mapping converts optimized logic into real cells from the target standard-cell library.

For example:

```text
(a & b) | c
```

may be mapped as:

```text
AND2_X1 + OR2_X1
```

or as:

```text
AO21_X1
```

The selected implementation depends on:

- cells available in the library
- cell timing
- clock constraints
- output load
- input slew
- drive strength
- area
- power
- design-rule constraints

The same Verilog operator does not necessarily map to one specific gate.

For example:

```verilog
assign y = a & b;
```

does not guarantee that the final netlist contains exactly one `AND2` cell.

The tool could implement the function using another logically equivalent structure, such as:

```text
NAND + INV
```

depending on the available cells and optimization targets.

```text
Technology mapping
→ Select actual target standard cells
```

### Post-Mapping Optimization

After initial mapping, the tool continues optimizing the mapped gate-level structure.

Possible operations include:

- cell sizing
- buffer insertion
- inverter insertion
- fanout optimization
- transition repair
- capacitance repair
- timing optimization
- logic duplication
- mapped logic restructuring

Example:

```text
INV_X1 → INV_X4
```

This may improve the current cell’s ability to drive a large load.

However, it may also:

- increase area
- increase power
- increase input capacitance
- increase the load seen by the previous stage

Therefore, post-mapping optimization is an iterative PPA optimization process.

### Write Netlist and Reports

The final synthesis stage writes outputs such as:

- gate-level netlist
- timing report
- area report
- power report
- constraint report
- design-rule report
- synthesis log

```text
Analyze / Elaborate
→ Understand and expand the design

Technology-Independent Optimization
→ Simplify abstract logic

Technology Mapping
→ Select actual standard cells

Post-Mapping Optimization
→ Optimize mapped cells and nets

Write
→ Output netlist and reports
```

---

## 5. Gate-Level Netlist

A gate-level netlist contains standard-cell instances and their connectivity.

RTL example:

```verilog
assign y = (a & b) | c;
```

A simplified mapped netlist could be:

```verilog
wire n1;

AND2_X1 U1 (
    .A(a),
    .B(b),
    .Y(n1)
);

OR2_X1 U2 (
    .A(n1),
    .B(c),
    .Y(y)
);
```

### Cell Type

In:

```verilog
AND2_X1 U1
```

`AND2_X1` is the cell type.

It may identify:

```text
AND2
→ Two-input AND function

X1
→ Drive-strength version
```

### Instance Name

`U1` is the instance name.

It uniquely identifies one specific cell instance inside the design.

Multiple instances may share the same cell type:

```verilog
AND2_X1 U1 (...);
AND2_X1 U2 (...);
AND2_X1 U3 (...);
```

### Nets and Pin Connections

A netlist describes which instance pins are connected through which nets.

```verilog
wire n1;
```

In:

```verilog
.Y(n1)
```

the output pin `Y` is connected to net `n1`.

That same net may connect to another cell input:

```verilog
.A(n1)
```

The central question represented by a netlist is:

> Which pin of which instance is connected to which net?

### Sequential Logic in a Netlist

RTL:

```verilog
always @(posedge clk)
    q <= d;
```

Mapped netlist:

```verilog
DFF_X1 U_REG_Q (
    .D(d),
    .CLK(clk),
    .Q(q)
);
```

The behavioral `always @(posedge clk)` description is replaced by a target-library flip-flop instance.

### What a Basic Synthesis Netlist Contains

A basic gate-level netlist usually contains:

- module definitions
- standard-cell types
- instance names
- pin connections
- internal nets
- input ports
- output ports
- hierarchy or flattened connectivity

### What a Basic Synthesis Netlist Usually Does Not Contain

A basic synthesis netlist normally does not contain final:

- cell x/y coordinates
- detailed placement
- routed wire paths
- metal-layer assignments
- via locations
- exact wire lengths
- extracted parasitic resistance
- extracted parasitic capacitance
- final DRC-clean geometry

```text
Gate-level netlist
→ Cells and connectivity

Placed-and-routed design
→ Locations, routing, vias, and physical parasitics
```

Timing, power, and area results are normally written in separate reports rather than being the main content of the netlist.

---

## 6. Timing Arcs and Cell Delay

### Timing Arc

A timing arc represents a timing relationship between pins of a standard cell.

For an inverter:

```text
A → Y
```

This means that a transition on input pin `A` affects output pin `Y`.

For a two-input gate, there may be multiple arcs:

```text
A → Y
B → Y
```

For a D flip-flop, important timing arcs and checks include:

```text
CLK → Q
D relative to CLK: setup check
D relative to CLK: hold check
```

### Clock-to-Q Delay

Clock-to-Q delay is the propagation time from an active clock edge to the corresponding change at a flip-flop output.

```text
Active clock edge
↓
Clock-to-Q delay
↓
Q output changes
```

In a register-to-register path, clock-to-Q delay belongs to the launch register.

```text
Launch Register
→ Clock-to-Q delay
→ Combinational Data Path
→ Capture Register
```

### Cell Delay Is Not a Fixed Constant

The delay of one standard cell mainly depends on:

```text
Input slew
Output load
PVT corner
```

### Input Slew

Input slew, also called input transition, describes how quickly an input signal changes between logic levels.

Examples include:

- rise time
- fall time
- low-to-high transition
- high-to-low transition

```text
Slower input slew
→ Cell switches more slowly
→ Cell delay usually increases
```

Input slew must not be confused with clock skew.

```text
Input slew
→ Signal edge transition speed

Clock skew
→ Difference in clock arrival times at different registers
```

### Output Load

The output load driven by a cell may include:

```text
Downstream input pin capacitance
+
Wire capacitance
+
Other parasitic capacitance
```

```text
Larger output load
→ More charge must be moved
→ Slower output transition
→ Larger cell delay
```

### Lookup Tables

A Liberty file commonly stores delay and transition values in lookup tables.

Common table indices include:

```text
Input transition
Output capacitance
```

Simplified example:

| Input Slew | Small Load | Medium Load | Large Load |
|---:|---:|---:|---:|
| Fast | 0.03 ns | 0.05 ns | 0.09 ns |
| Medium | 0.04 ns | 0.07 ns | 0.12 ns |
| Slow | 0.07 ns | 0.11 ns | 0.18 ns |

If the actual input slew and output load fall between characterized values, the EDA tool may interpolate between table entries.

Therefore:

```text
INV_X1 delay
≠ One fixed number
```

---

## 7. Drive Strength and Cell Sizing

Cells with different drive-strength suffixes may implement the same logical function.

```text
INV_X1
INV_X2
INV_X4
```

They all perform inversion, but their driving abilities differ.

```text
X1 < X2 < X4
```

### Benefits of a Stronger Cell

Changing:

```text
INV_X1 → INV_X4
```

may provide:

- stronger output drive
- lower effective output resistance
- faster output transition under large load
- smaller cell delay under heavy load
- improved setup timing

### Costs of a Stronger Cell

A stronger cell usually causes:

- larger cell area
- larger input capacitance
- greater load on the previous cell
- higher dynamic power
- higher leakage power

Example:

```text
U2 changes from X1 to X4
↓
U2 input capacitance increases
↓
U1 output load increases
↓
U1 delay may increase
↓
U1 may also require upsizing
```

Cell sizing is therefore a chain optimization problem rather than an isolated optimization.

### PPA Tradeoff

Synthesis must balance:

```text
P = Power
P = Performance
A = Area
```

Using the strongest cell version everywhere would usually:

- waste area
- waste power
- increase upstream loads
- increase routing congestion
- create unnecessary sizing chains

Therefore:

```text
Stronger cell
≠ Always better
```

---

## 8. Fanout, Capacitance, and Transition

### Fanout

Fanout is the number of input pins driven by one output net.

Example:

```text
One output drives 10 input pins
→ Fanout = 10
```

However, fanout alone does not fully represent the electrical load.

Four small input pins may create less load than two large input pins.

### Total Capacitive Load

Total output load may include:

```text
Downstream input capacitance
+
Wire capacitance
+
Other parasitic capacitance
```

Two nets with the same fanout may have different total capacitance.

### High-Fanout Nets

Common high-fanout signals include:

- reset
- enable
- scan enable
- global control
- test control
- clock

A high-fanout net may produce:

```text
More input loads
↓
Larger total capacitance
↓
Slower transition
↓
Larger driver delay
↓
Possible timing or design-rule violation
```

### Cell Upsizing

One possible repair is:

```text
BUF_X1 → BUF_X4
```

This increases drive strength.

### Buffer Insertion

Another possible repair is inserting buffers or building a buffer tree.

```text
Original:

Driver
├── Load1
├── Load2
├── Load3
├── Load4
├── Load5
└── Load6
```

```text
Optimized:

             Driver
             /    \
         Buffer  Buffer
         / | \    / | \
        L1 L2 L3 L4 L5 L6
```

Buffer insertion may:

- distribute the load
- reduce load per driver
- improve transition
- improve timing
- repair fanout violations

Its costs include:

- more area
- more power
- more cell count
- buffer propagation delay
- more routing

Clock distribution is normally handled separately during Clock Tree Synthesis.

---

## 9. Timing Constraints and Design-Rule Constraints

Constraints can be divided into different categories.

### Timing Constraints

Timing constraints specify when signals must arrive.

Examples include:

- clock period
- input delay
- output delay
- clock uncertainty
- maximum path delay
- minimum path delay
- generated clock relationships

Example:

```tcl
create_clock -period 5 [get_ports clk]
```

This is a timing constraint.

```text
Timing constraint
→ When must data arrive?
```

### Synthesis Design-Rule Constraints

Synthesis design-rule constraints control electrical loading and signal quality.

Examples include:

- maximum fanout
- maximum capacitance
- maximum transition

```text
Synthesis design-rule constraint
→ Is a driver electrically overloaded?
```

### Maximum Fanout

```tcl
set_max_fanout 8 [current_design]
```

This limits the number of loads driven by one output.

### Maximum Capacitance

```tcl
set_max_capacitance 0.1 [current_design]
```

This limits the total capacitive load seen by an output pin.

A net may have low fanout but still violate max capacitance because of:

- large input pin capacitance
- long wire
- large parasitic capacitance

### Maximum Transition

```tcl
set_max_transition 0.2 [current_design]
```

This limits how slow a signal transition may become.

The exact time unit depends on the library and tool configuration.

### Physical DRC

Physical DRC checks layout geometry rather than synthesis electrical behavior.

Examples include:

- minimum metal width
- minimum metal spacing
- via enclosure
- layer overlap
- cut spacing

### Comparison

```text
Timing Constraint
→ When must data arrive?
→ create_clock, input delay, output delay

Synthesis Design-Rule Constraint
→ Is the net electrically acceptable?
→ max fanout, max capacitance, max transition

Physical DRC
→ Is the layout geometry manufacturable?
→ width, spacing, enclosure, overlap
```

Positive timing slack does not guarantee that design-rule constraints pass.

A path may have:

```text
Slack = +0.2 ns
```

while one net still has:

```text
Actual transition = 0.30 ns
Allowed transition = 0.20 ns
```

Therefore:

```text
Positive slack
≠ All synthesis constraints passed
```

---

## 10. Clock Period and Register-to-Register Timing

A clock constraint may be defined as:

```tcl
create_clock -period 5 [get_ports clk]
```

This defines a 5 ns clock period.

However, the combinational data path cannot normally use the complete 5 ns.

A simplified register-to-register path is:

```text
Launch Register
↓
Clock-to-Q Delay
↓
Combinational Cell Delay
↓
Interconnect Delay
↓
Capture Register Setup Requirement
```

A simplified setup condition is:

```text
Clock-to-Q Delay
+
Data-Path Delay
+
Setup Time
+
Clock Uncertainty
≤ Clock Period
```

Example:

```text
Clock period      = 5.0 ns
Clock-to-Q delay  = 0.2 ns
Setup time        = 0.3 ns
Clock uncertainty = 0.2 ns
```

The approximate time available to the internal data path is:

```text
5.0 - 0.2 - 0.3 - 0.2
= 4.3 ns
```

Therefore:

```text
Clock period = 5 ns
≠
Combinational logic may use the full 5 ns
```

---

## 11. Setup, Hold, and Clock-to-Q

### Setup Time

Setup time requires the input data of a capture register to remain stable for a minimum interval before the active clock edge.

```text
Data becomes stable
↓
Setup interval
↓
Capture clock edge
```

A setup violation means:

```text
Data arrived too late
```

Setup analysis mainly checks maximum-delay paths.

### Hold Time

Hold time requires input data to remain stable for a minimum interval after the active clock edge.

```text
Capture clock edge
↓
Hold interval
↓
Data may change
```

A hold violation means:

```text
New data arrived too early
```

Hold analysis mainly checks minimum-delay paths.

### Clock-to-Q Delay

Clock-to-Q delay is the time from the active clock edge at the launch register to the corresponding change at output `Q`.

```text
Launch clock edge
↓
Clock-to-Q delay
↓
Launch register Q changes
```

### Summary

```text
Setup Time
→ Data stability requirement before the capture edge

Hold Time
→ Data stability requirement after the capture edge

Clock-to-Q Delay
→ Propagation delay from launch clock edge to launch Q
```

---

## 12. Arrival Time, Required Time, and Slack

### Arrival Time

Arrival time represents when data actually reaches the timing endpoint.

For a simplified register-to-register setup path:

```text
Arrival Time
=
Clock-to-Q Delay
+
Combinational Cell Delay
+
Interconnect Delay
```

Example:

```text
Clock-to-Q delay    = 0.2 ns
Combinational delay = 3.1 ns
Interconnect delay  = 0.5 ns
```

```text
Arrival time
= 0.2 + 3.1 + 0.5
= 3.8 ns
```

### Required Time

Required time represents the latest time at which the data may arrive while still satisfying the timing requirement.

Simplified setup calculation:

```text
Required Time
=
Clock Period
-
Setup Time
-
Clock Uncertainty
```

Example:

```text
Clock period      = 5.0 ns
Setup time        = 0.3 ns
Clock uncertainty = 0.2 ns
```

```text
Required time
= 5.0 - 0.3 - 0.2
= 4.5 ns
```

### Slack

For setup analysis:

```text
Slack
=
Required Time
-
Arrival Time
```

Using the previous values:

```text
Slack
= 4.5 - 3.8
= +0.7 ns
```

### Positive Slack

```text
Slack > 0
→ Timing requirement passes
```

### Zero Slack

```text
Slack = 0
→ Data arrives exactly at the allowed limit
```

### Negative Slack

```text
Slack < 0
→ Timing violation
```

Example:

```text
Arrival time  = 4.3 ns
Required time = 4.0 ns
```

```text
Slack
= 4.0 - 4.3
= -0.3 ns
```

The path fails setup timing by 0.3 ns.

---

## 13. Critical Path, WNS, and TNS

### Critical Path

The critical path is usually the path with the worst slack under the current timing analysis conditions.

It is not necessarily the path with the numerically largest raw delay.

Example:

```text
Path A delay    = 4.0 ns
Required time   = 5.0 ns
Slack           = +1.0 ns
```

```text
Path B delay    = 3.5 ns
Required time   = 3.2 ns
Slack           = -0.3 ns
```

Although Path A has greater delay, Path B has worse slack.

Therefore, Path B is the critical path.

```text
Critical path
→ Path with the smallest or worst slack
```

### WNS

WNS means:

```text
Worst Negative Slack
```

Example:

```text
Path 1: +0.5 ns
Path 2: -0.2 ns
Path 3: -0.6 ns
Path 4: +0.1 ns
```

```text
WNS = -0.6 ns
```

WNS describes the severity of the worst timing violation.

### TNS

TNS means:

```text
Total Negative Slack
```

It is the sum of all negative slack values.

Using the previous example:

```text
TNS
= -0.2 + -0.6
= -0.8 ns
```

Positive slack values are not added to TNS.

### WNS and TNS Comparison

```text
WNS
→ How severe is the single worst violation?

TNS
→ How severe are all violations combined?
```

Two designs may have different timing situations:

```text
Design A:
WNS = -1.0 ns
TNS = -1.0 ns
```

This may indicate one severe violating path.

```text
Design B:
WNS = -0.2 ns
TNS = -20 ns
```

This may indicate many smaller violations.

If the worst slack is positive:

```text
Worst slack = +0.1 ns
```

then no analyzed setup path has negative setup slack.

However, this does not prove:

- hold timing passes
- all paths are constrained
- design-rule constraints pass
- all analysis corners pass

---

## 14. Setup and Hold Repair

### Setup Violation

A setup violation means data arrives too late.

```text
Setup violation
→ Maximum data-path delay is too large
```

The repair objective is:

```text
Reduce maximum data-path delay
```

Possible setup fixes include:

- use faster cells
- use stronger cells
- reduce logic depth
- restructure Boolean logic
- reduce fanout
- insert appropriate buffers
- duplicate high-fanout logic
- shorten routing
- improve placement
- add a pipeline register

Example:

```text
Before pipelining:

Register
→ Logic 1
→ Logic 2
→ Logic 3
→ Register
```

```text
After pipelining:

Register
→ Logic 1
→ Logic 2
→ Pipeline Register
→ Logic 3
→ Register
```

Pipeline insertion changes the microarchitecture and latency, so it is not merely a physical optimization.

### Hold Violation

A hold violation means new data arrives too early.

```text
Hold violation
→ Minimum data-path delay is too small
```

The repair objective is:

```text
Increase minimum data-path delay
```

Possible hold fixes include:

- insert delay buffers
- insert dedicated delay cells
- use slower or smaller cells
- add appropriate routing delay
- adjust clock skew

The inserted delay elements must not change the logical function.

It is not appropriate to add arbitrary Boolean logic merely to create delay.

### Interaction Between Setup and Hold

Setup and hold fixes may affect one another.

```text
Use faster cells
→ Setup may improve
→ Hold may worsen
```

```text
Insert delay buffers
→ Hold may improve
→ Setup may worsen
```

Timing closure therefore requires iterative balancing.

### Clock Period and Hold

Increasing clock period can improve setup timing because the next capture edge occurs later.

```text
Longer clock period
→ More setup time available
```

However, hold analysis normally occurs near the same clock edge.

Therefore:

```text
Increasing clock period
→ Usually does not directly repair hold violations
```

---

## 15. Input Delay and Output Delay

A chip or design block communicates with external logic.

```text
External Logic
→ Current Design
→ External Logic
```

Therefore, the synthesis and STA tools must understand the timing outside the current design boundary.

### Input Delay

Input delay describes the delay before data reaches the current design input port.

Example:

```text
External Register
→ External Logic / Interconnect
→ Current Design Input
→ Internal Logic
→ Internal Register
```

Constraint:

```tcl
set_input_delay 2.0 \
    -clock clk \
    [get_ports data_in]
```

This tells the tool that the input data reaches the design boundary approximately 2 ns after the reference clock edge.

If:

```text
Clock period = 10 ns
Input delay  = 2 ns
```

then the internal input-to-register path does not have the full 10 ns.

Its approximate available time becomes:

```text
10 ns
-
2 ns external input delay
-
setup time
-
uncertainty
```

A larger input delay generally leaves less time for the internal input-to-register path.

### Output Delay

Output delay reserves time for external transmission and the external receiving circuit.

Example:

```text
Internal Register
→ Internal Logic
→ Current Design Output
→ External Interconnect
→ External Register
```

Constraint:

```tcl
set_output_delay 3.0 \
    -clock clk \
    [get_ports data_out]
```

This means part of the clock period must be reserved for the external path and external setup requirement.

If:

```text
Clock period  = 10 ns
Output delay  = 3 ns
```

then the internal register-to-output path has approximately:

```text
10 - 3 = 7 ns
```

before considering other timing effects.

### Path Types

```text
Register-to-Register
→ Internal register to internal register
```

```text
Input-to-Register
→ Input port to internal register
→ Requires input timing constraints
```

```text
Register-to-Output
→ Internal register to output port
→ Requires output timing constraints
```

```text
Input-to-Output
→ Input port through combinational logic to output port
→ Requires interface timing constraints
```

Using only `create_clock` and omitting I/O delays may create an unrealistically optimistic timing model.

---

## 16. Synthesis Reports

Synthesis output includes more than a netlist.

Typical outputs include:

```text
Gate-Level Netlist
Timing Report
Area Report
Power Estimate
Design-Rule Report
Constraint Report
Synthesis Log
```

### Timing Report

A timing report may contain:

- startpoint
- endpoint
- path type
- timing arcs
- cell delay
- estimated net delay
- arrival time
- required time
- slack
- WNS
- TNS

Example:

```text
Startpoint: reg_a
Endpoint:   reg_b
Arrival:    4.2 ns
Required:   4.0 ns
Slack:     -0.2 ns
```

This indicates that synthesis produced a netlist, but the path has a setup violation.

### Area Report

An area report may contain:

- combinational cell count
- sequential cell count
- buffer and inverter count
- total cell count
- total mapped cell area
- hierarchy-based area

Example:

```text
Combinational cells: 850
Sequential cells:    120
Buffers/Inverters:   210
Total cell area:     5432.6
```

The synthesis area is mainly the summed abstract area of mapped standard cells.

It is not the same as the final chip or core area.

Final physical area must also consider:

- utilization
- placement whitespace
- routing resources
- power grid
- clock tree
- macros
- blockages
- filler cells
- tap cells
- physical spacing

```text
Synthesis cell area
≠
Final placed-and-routed core area
```

### Power Report

A synthesis power estimate may include:

- internal power
- switching power
- leakage power
- clock power estimate
- hierarchy-based power

Power accuracy depends on:

- clock frequency
- voltage
- PVT corner
- toggle activity
- input activity
- capacitance estimates
- selected cells

If realistic switching activity is not available, the tool may use default assumptions.

Therefore, synthesis power is usually an early estimate rather than final signoff power.

### Design-Rule Report

This report may include:

- max fanout violations
- max capacitance violations
- max transition violations

A design may have positive timing slack but still contain design-rule violations.

### Constraint Report

A constraint report may show:

- clock definitions
- I/O delays
- clock uncertainty
- timing exceptions
- unconstrained paths
- generated clocks
- path groups

### Synthesis Log

The synthesis log records:

- commands
- warnings
- errors
- optimization stages
- removed logic
- inferred cells
- mapping results
- unresolved references
- constraint problems

Warnings should not be ignored automatically.

---

## 17. Synthesis Timing Versus Post-Route Timing

During synthesis, placement and routing are not yet finalized.

The synthesis tool normally does not know the final:

- cell coordinates
- wire lengths
- routing layers
- via counts
- resistance
- capacitance
- coupling capacitance

Therefore, synthesis net delay is typically based on:

- wire-load estimates
- fanout-based estimates
- physically aware estimates
- preliminary placement estimates

```text
Synthesis timing
→ Early timing estimate
```

After placement and routing, parasitic resistance and capacitance can be extracted from the physical design.

```text
Post-route STA
→ Timing analysis using routed geometry and extracted parasitics
```

Therefore:

```text
Synthesis timing pass
≠
Post-route timing guaranteed to pass
```

Real wires may be:

- longer than estimated
- more resistive
- more capacitive
- affected by coupling
- affected by congestion-driven detours

---

## 18. PVT Corners

PVT means:

```text
P = Process
V = Voltage
T = Temperature
```

The same standard cell can have different timing and power characteristics under different PVT conditions.

### Process Corners

Common process corners include:

```text
TT
→ Typical NMOS, Typical PMOS
```

```text
SS
→ Slow NMOS, Slow PMOS
```

```text
FF
→ Fast NMOS, Fast PMOS
```

Additional mixed corners may include:

```text
SF
→ Slow NMOS, Fast PMOS

FS
→ Fast NMOS, Slow PMOS
```

At an SS corner, cells are generally slower.

At an FF corner, cells are generally faster.

### Voltage

In general:

```text
Lower voltage
→ Lower transistor drive current
→ Slower switching
→ Larger delay
```

```text
Higher voltage
→ Faster switching
→ Higher dynamic power
```

### Temperature

A common simplified relationship is:

```text
Higher temperature
→ Lower carrier mobility
→ Slower switching
→ Larger cell delay
```

However, advanced processes may exhibit temperature inversion under some voltage and process conditions.

Therefore, timing behavior should be determined from characterized library data rather than relying only on a simple high-temperature-is-slowest rule.

### PVT and Liberty Files

Different PVT corners may use different `.lib` files or library sets.

Example:

```text
slow.lib
typical.lib
fast.lib
```

The same cell may have different delay tables in each library.

Example values:

```text
INV_X1 at FF corner → 0.04 ns
INV_X1 at TT corner → 0.06 ns
INV_X1 at SS corner → 0.10 ns
```

These values are only illustrative.

### Setup Corner

Setup analysis worries about data arriving too late.

Therefore, setup is often more difficult under slower conditions:

```text
Slow process
Low voltage
Often high temperature
→ Larger data-path delay
→ Greater setup risk
```

Simplified memory rule:

```text
Setup worst case
≈ Slow corner
```

### Hold Corner

Hold analysis worries about data arriving too early.

Therefore, hold is often more difficult under faster conditions:

```text
Fast process
High voltage
Often low temperature
→ Smaller data-path delay
→ Greater hold risk
```

Simplified memory rule:

```text
Hold worst case
≈ Fast corner
```

Real signoff analysis uses multiple corners and accounts for:

- data-path variation
- clock-path variation
- interconnect variation
- on-chip variation
- different voltage modes
- different operating modes

---

## 19. Unconstrained Paths

STA can only correctly analyze paths that have sufficient timing constraints.

An unconstrained path is a path for which the tool does not have enough timing information to calculate a meaningful required time.

```text
Unconstrained path
→ Missing timing requirement
```

It does not mean:

```text
Timing passed
```

It also does not necessarily mean:

```text
Delay is too long
```

### Common Causes

Possible causes include:

- missing clock definition
- missing input delay
- missing output delay
- missing generated clock
- undefined clock-domain relationship
- incomplete path constraints
- missing virtual clock
- incorrect clock propagation definition

Example:

```text
Input Port
→ Combinational Logic
→ Register
```

If only `create_clock` is defined and `set_input_delay` is missing, the input-to-register path may be incompletely constrained.

### Positive WNS Does Not Prove Full Coverage

A positive WNS only means:

> Among the paths that were analyzed under the current setup analysis, the worst slack is positive.

It does not prove:

- every clock is defined
- every I/O path is constrained
- every endpoint is analyzed
- every generated clock is defined
- every clock-domain relationship is correct

Therefore:

```text
Positive WNS
≠
Complete constraint coverage
```

### Timing Checks

Tools may provide commands such as:

```tcl
check_timing
```

These checks may identify:

- unconstrained endpoints
- missing clocks
- missing input delays
- missing output delays
- generated-clock problems
- constant clock pins
- incomplete constraints

Correct timing analysis requires both:

```text
Good slack
+
Complete timing coverage
```

---

## 20. False Paths

A false path is a physically connected path that the designer intentionally excludes from normal setup and hold timing analysis.

Example:

```tcl
set_false_path \
    -from [get_clocks clk_a] \
    -to [get_clocks clk_b]
```

### Asynchronous Clock Domains

Example:

```text
Clock Domain A
→ Synchronizer
→ Clock Domain B
```

If `clk_a` and `clk_b` are asynchronous, they have no fixed edge relationship suitable for ordinary synchronous STA.

The clocks may be declared asynchronous or the relevant paths may be excluded from normal timing analysis.

However:

```text
False-path constraint
≠
Metastability eliminated
```

Metastability must be addressed through architecture and CDC techniques such as:

- synchronizer chains
- asynchronous FIFOs
- handshaking protocols
- CDC verification

### Mutually Exclusive Modes

A path may also be false in a particular operating mode if functional controls guarantee that the path cannot be activated.

Examples may include:

- functional mode versus test mode
- mutually exclusive mux paths
- configuration-dependent paths

### False Path Versus Unconstrained Path

```text
False Path
→ Designer intentionally excludes the path
→ Must have a functional or architectural reason
```

```text
Unconstrained Path
→ Tool lacks enough timing information
→ Usually indicates missing or incomplete constraints
```

### Danger of False Paths

`set_false_path` removes normal timing checks.

If a real functional path is incorrectly declared false:

```text
Real timing violation
↓
Path excluded
↓
STA no longer reports the violation
```

Therefore:

```text
False path
≠
A method for hiding bad slack
```

A critical path must not be declared false merely to improve WNS.

---

## 21. Multicycle Paths

By default, STA normally assumes that a register-to-register path completes in one clock cycle.

```text
Launch edge
→ Data propagation
→ Next capture edge
```

A multicycle path is a path that has a valid architectural reason to use more than one clock cycle.

Example:

```tcl
set_multicycle_path 2 -setup \
    -from [get_registers launch_reg] \
    -to [get_registers capture_reg]
```

This allows the setup check to use two clock cycles.

If:

```text
Clock period = 5 ns
```

then a two-cycle setup path may receive approximately:

```text
2 × 5 ns = 10 ns
```

before other timing adjustments.

### Multicycle Constraint Does Not Modify RTL

A multicycle constraint only changes the STA timing requirement.

It does not automatically:

- insert a pipeline register
- generate a clock enable
- pause data
- generate a valid signal
- change the FSM
- prevent the destination register from sampling early

Therefore, a valid multicycle path must have an architectural basis.

Possible mechanisms include:

- clock enable
- valid signal
- FSM state control
- protocol-defined sampling
- destination register updates every N cycles

Example:

```verilog
if (result_valid)
    result_reg <= result;
```

If `result_valid` only becomes active every two cycles, a two-cycle path may be architecturally justified.

### Multicycle Setup and Hold

A setup multicycle constraint often requires a corresponding hold adjustment.

A common form is:

```tcl
set_multicycle_path 2 -setup ...
set_multicycle_path 1 -hold  ...
```

The detailed clock-edge relationship is analyzed more deeply during STA study.

### Danger of Multicycle Paths

If a normal single-cycle path is incorrectly declared multicycle:

```text
Real requirement = 5 ns
Incorrect constraint = 10 ns
```

a real timing violation may be hidden.

Therefore:

```text
Path is slow
≠
Path is automatically multicycle
```

### Path-Type Comparison

```text
Normal Path
→ Must satisfy the default timing relationship
```

```text
Multicycle Path
→ Allowed multiple cycles due to a real architectural mechanism
```

```text
False Path
→ Intentionally excluded from normal setup/hold analysis
```

```text
Unconstrained Path
→ Missing sufficient timing requirements
```

---

## 22. Key Differences

### RTL Versus Gate-Level Netlist

```text
RTL
→ Describes intended logic and sequential behavior
→ Technology-independent
→ No final physical coordinates
```

```text
Gate-Level Netlist
→ Describes mapped standard-cell instances and connectivity
→ Technology-dependent
→ Still normally lacks final placement and routing
```

### Cell Type Versus Instance Name

```text
NAND2_X2 U17
```

```text
NAND2_X2
→ Cell type
```

```text
U17
→ Instance name
```

### Input Slew Versus Clock Skew

```text
Input slew
→ Speed of a signal transition
```

```text
Clock skew
→ Difference between clock arrival times
```

### Setup Versus Hold

```text
Setup
→ Data must not arrive too late
→ Maximum-delay analysis
```

```text
Hold
→ Data must not arrive too early
→ Minimum-delay analysis
```

### Netlist Versus Reports

```text
Netlist
→ Cell instances, pins, nets, connectivity
```

```text
Reports
→ Timing, area, power, constraints, violations
```

### Synthesis Timing Versus Post-Route Timing

```text
Synthesis timing
→ Estimated interconnect behavior
```

```text
Post-route timing
→ Extracted routed parasitic behavior
```

---

## 23. Complete Synthesis Flow Summary

```text
RTL
+
Standard-Cell Library
+
Design Constraints
↓
Analyze
↓
Elaborate
↓
Technology-Independent Optimization
↓
Technology Mapping
↓
Post-Mapping Optimization
↓
Gate-Level Netlist
+
Timing Report
+
Area Report
+
Power Report
+
Constraint Report
+
Design-Rule Report
↓
Physical Design
↓
Placement
↓
Clock Tree Synthesis
↓
Routing
↓
Parasitic Extraction
↓
Post-Route STA
```

---

## 24. Final Checklist

Before accepting a synthesis result, verify:

### RTL and Elaboration

- Correct top module selected
- No unresolved module references
- Parameter values are correct
- Generate blocks are expanded correctly
- Port widths are correct
- No unintended latches
- Sequential logic is inferred correctly

### Libraries

- Correct `.lib` files are loaded
- Correct PVT corner is selected
- Required cells are available
- Correct operating voltage and temperature are used

### Constraints

- Clock is defined
- Clock period is correct
- Input delays are defined
- Output delays are defined
- Clock uncertainty is defined where required
- Generated clocks are defined
- Clock-domain relationships are defined
- False paths have valid justification
- Multicycle paths have valid architectural justification
- Unconstrained paths are reviewed

### Timing

- Setup WNS reviewed
- Setup TNS reviewed
- Hold timing reviewed
- Critical paths reviewed
- Timing is checked at relevant corners
- Timing coverage is complete

### Design Rules

- Max fanout violations reviewed
- Max capacitance violations reviewed
- Max transition violations reviewed

### Area and Power

- Total mapped cell area reviewed
- Cell count reviewed
- Buffer count reviewed
- Sequential and combinational area reviewed
- Power assumptions reviewed
- Switching activity assumptions reviewed

### Outputs

- Gate-level netlist generated
- Reports generated
- Warnings reviewed
- Synthesis log reviewed
- Netlist functionality verified where required

---

## 25. One-Sentence Summary

Logic synthesis converts RTL into a target-library gate-level netlist by elaborating the design, optimizing abstract logic, mapping it to characterized standard cells, and repeatedly balancing timing, power, area, electrical design rules, and constraint coverage.