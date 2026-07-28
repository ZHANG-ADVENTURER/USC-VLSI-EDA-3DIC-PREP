# RTL-to-GDSII Flow Integration

## 1. Overview

The RTL-to-GDSII flow transforms a chip idea and functional specification into a complete physical layout that can be submitted for semiconductor fabrication.

A simplified flow is:

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

The flow gradually moves through different abstraction levels:

* Required system behavior
* Hardware architecture
* Register-transfer description
* Standard-cell connectivity
* Physical cell locations
* Metal and via geometry
* Final manufacturing database

The process is iterative rather than strictly one-directional. A problem discovered during routing or signoff may require returning to placement, floorplanning, synthesis, RTL, or even microarchitecture.

---

## 2. Four Major Flow Phases

The complete flow can be grouped into four major phases.

### Front-End Design and Verification

Front-end work defines and verifies what the circuit should do.

It includes:

* Specification
* Microarchitecture
* RTL design
* Functional verification
* Assertions and coverage
* DFT planning
* Timing-constraint preparation

Main question:

> What logical behavior should the circuit implement?

### Logic Synthesis

Logic synthesis maps RTL into cells from a standard-cell library.

Main question:

> Which standard cells should implement the RTL?

### Physical Design

Physical design creates the actual cell placement, clock network, power network, wires, and vias.

Main question:

> Where should the cells and physical connections be placed?

### Signoff and Tapeout

Signoff verifies that the exact final physical design is manufacturable, timing-clean, electrically safe, reliable, and ready for fabrication.

Main question:

> Can the final layout be manufactured and operated correctly?

---

## 3. Specification

The specification defines the required external behavior and design targets.

Typical specification items include:

* Supported functionality
* Input and output behavior
* Interface protocols
* Data width
* Clock-frequency target
* Latency requirement
* Throughput requirement
* Reset behavior
* Power target
* Error-handling requirements

The specification describes what the design must accomplish. It does not necessarily define the internal hardware organization.

For example, a FIFO specification may require:

* Eight-bit data
* Sixteen entries
* FIFO ordering
* Full and empty indicators
* Correct read and write behavior

It does not necessarily specify exactly how the read and write pointers must be implemented.

Core question:

> What must the design do?

---

## 4. Microarchitecture

Microarchitecture defines the internal hardware organization used to satisfy the specification.

Typical microarchitecture decisions include:

* Pipeline depth
* Datapath structure
* Control-FSM structure
* Register placement
* FIFO or buffer depth
* Arbitration method
* Parallel versus sequential execution
* Ready/valid interface structure

Different microarchitectures can implement the same specification.

For example, multiplication may be implemented using:

### Combinational Multiplier

* Short functional latency
* Long combinational path
* Relatively large area
* Potentially lower maximum frequency

### Iterative Multiplier

* Smaller area
* Multiple-cycle latency
* Additional control logic
* Lower hardware parallelism

### Pipelined Multiplier

* Higher throughput
* More registers
* Higher clock power
* Multiple cycles of latency
* Potentially higher operating frequency

Microarchitecture therefore balances:

* Power
* Performance
* Area
* Latency
* Throughput
* Design complexity

Core question:

> What hardware structure should implement the specification?

---

## 5. RTL Design

RTL translates the selected microarchitecture into a synthesizable hardware description.

RTL describes:

* Registers
* Combinational logic
* Register transfers
* State transitions
* Datapaths
* Control signals
* Pipelines
* Handshake interfaces

A simplified RTL model is:

```text
Current register values
→ combinational calculation
→ next register values
→ capture on a clock edge
```

RTL is not ordinary software. Synthesis eventually converts RTL structures into:

* Flip-flops
* Logic gates
* Multiplexers
* Arithmetic cells
* Buffers
* Other standard cells

Microarchitecture is the hardware organization, while RTL is the formal synthesizable description of that organization.

---

## 6. Functional Verification

Functional verification checks whether the RTL satisfies the specification.

Typical methods include:

* Directed simulation
* Constrained-random simulation
* Assertions
* Functional coverage
* Code coverage
* Formal verification
* Reference-model comparison

A FIFO verification environment may check:

* Reset behavior
* Read and write behavior
* FIFO ordering
* Full and empty flags
* Simultaneous read and write
* Illegal read or write prevention
* Boundary conditions

Functional verification must derive expected behavior from the specification rather than simply repeat the RTL implementation.

A testbench that duplicates the same RTL error may incorrectly report a passing result.

Core comparison:

> RTL versus specification

---

## 7. Logical Equivalence Checking

Logical Equivalence Checking, or LEC, compares the synthesized gate-level netlist against the RTL.

It checks whether synthesis preserved the RTL behavior.

```text
RTL
↕ LEC
Synthesized gate-level netlist
```

LEC does not directly check whether the RTL satisfies the original specification.

Example:

```text
Specification: y = a + b
Buggy RTL:     y = a - b
Netlist:       implements y = a - b
```

Possible results:

* Functional verification: should fail
* LEC: can pass

The netlist is equivalent to the buggy RTL even though both violate the specification.

---

## 8. Three Major Consistency Checks

Different verification methods compare different abstraction levels.

```text
Specification
    ↕ Functional Verification
RTL
    ↕ LEC
Gate-Level Netlist
    ↕ LVS
Physical Layout
```

| Verification            | Comparison                      |
| ----------------------- | ------------------------------- |
| Functional verification | RTL versus specification        |
| LEC                     | Netlist versus RTL              |
| LVS                     | Extracted layout versus netlist |

Passing LEC and LVS does not prove that the original specification was implemented correctly.

---

## 9. Logic Synthesis

Logic synthesis converts synthesizable RTL into a gate-level netlist constructed from a target standard-cell library.

The three primary inputs are:

* RTL
* Timing constraints
* Standard-cell library

```text
RTL
+ SDC
+ standard-cell .lib
→ Logic Synthesis
→ Gate-level netlist
```

---

## 10. Standard-Cell Library

A `.lib` file describes the logical and electrical behavior of standard cells.

It may contain:

* Boolean function
* Pin direction
* Timing arcs
* Propagation delay
* Input capacitance
* Output transition behavior
* Setup and hold requirements
* Dynamic and leakage power

Typical cells include:

* Inverters
* NAND and NOR gates
* Multiplexers
* Flip-flops
* Buffers
* Complex AOI and OAI cells

Synthesis must select cells that actually exist in the target library.

---

## 11. Drive Strength

Cells with the same logical function may have different drive strengths.

Example:

```text
INV_X1
INV_X2
INV_X4
INV_X8
```

A stronger cell generally provides:

* Lower output resistance
* Faster transition for a heavy load
* Lower delay under high capacitance

However, it also usually causes:

* Larger area
* Larger input capacitance
* Higher leakage power
* Higher dynamic power
* Greater load on the previous stage

Therefore, synthesis uses sufficient drive strength rather than maximum drive strength.

---

## 12. Timing Constraints

Timing constraints define the performance requirements that synthesis and physical-design tools must attempt to meet.

Typical constraints include:

* Clock period
* Input delay
* Output delay
* Clock uncertainty
* Input transition
* Output load
* False paths
* Multicycle paths

The same RTL and standard-cell library may produce different netlists under different timing constraints.

### Relaxed Clock Constraint

The tool may select:

* Smaller cells
* Fewer buffers
* Lower area
* Lower power

### Aggressive Clock Constraint

The tool may select:

* Stronger cells
* More buffers
* Different logic structures
* More area and power

Synthesis is therefore an optimization process, not a direct one-to-one translation from RTL statements to gates.

---

## 13. Synthesis Stages

A simplified synthesis sequence is:

```text
Analyze
→ Elaborate
→ Technology-independent optimization
→ Technology mapping
→ Post-mapping optimization
→ Netlist and report generation
```

### Analyze

Reads and checks the RTL source files.

It processes:

* Syntax
* Module definitions
* Parameters
* Source dependencies

### Elaborate

Builds the complete logical design from the top module.

It resolves:

* Module instances
* Parameters
* Generate blocks
* Signal widths
* Design hierarchy
* Connectivity

中文理解：

* Analyze：读懂每个 RTL 文件中定义了什么
* Elaborate：从 top module 出发构建完整设计结构

### Technology-Independent Optimization

Simplifies logic before selecting target cells.

Examples:

```text
a & 1 → a
a | 0 → a
a ^ a → 0
```

It may also remove unused logic and simplify Boolean or arithmetic structures.

### Technology Mapping

Maps generic logic into real cells from the target library.

### Post-Mapping Optimization

May perform:

* Cell resizing
* Buffer insertion
* Logic restructuring
* Timing optimization
* Transition repair
* Capacitance repair
* Area and power optimization

---

## 14. Synthesis Outputs

The main synthesis output is the gate-level netlist.

It contains:

* Standard-cell instances
* Cell types
* Pin connections
* Logical hierarchy or flattened connectivity

Other outputs may include:

* Timing reports
* Area reports
* Power estimates
* Constraint reports
* Design-rule reports
* Unconstrained-path reports

Synthesis does not create:

* Final cell coordinates
* Actual routing
* Final clock tree
* Final SPEF
* Final congestion data
* GDSII/OASIS geometry

---

## 15. Physical-Design Handoff

Physical design commonly receives:

* Gate-level netlist
* SDC timing constraints
* Standard-cell `.lib`
* Technology LEF
* Standard-cell LEF
* Macro physical views
* Operating conditions
* Physical-design constraints

The physical-design tool must understand both:

1. Which cells and connections exist
2. What those cells and routing resources physically look like

---

## 16. `.lib` versus LEF

The `.lib` and LEF files describe different views of the same standard cells.

| `.lib`            | LEF                        |
| ----------------- | -------------------------- |
| Logical function  | Cell boundary              |
| Timing arcs       | Cell width and height      |
| Delay             | Pin locations and shapes   |
| Input capacitance | Routing obstructions       |
| Setup and hold    | Placement sites            |
| Power behavior    | Abstract physical geometry |

中文记忆：

* `.lib`：cell 做什么、跑多快、耗多少电
* LEF：cell 多大、pin 在哪里、routing 如何接入

Technology LEF also provides:

* Routing layers
* Preferred directions
* Routing pitch
* Width and spacing information
* Via definitions
* Manufacturing grid
* Placement-site definitions

---

## 17. Floorplanning

Floorplanning defines the high-level physical organization of the design.

It determines:

* Die boundary
* Core boundary
* Macro locations
* I/O or port locations
* Placement rows
* Halos
* Channels
* Placement blockages
* Routing blockages
* Initial power-grid strategy

Floorplanning does not place every standard cell individually.

中文理解：

> Floorplanning 类似城市总体规划，先决定大型区域、道路空间和不能占用的位置。

---

## 18. Die Area and Core Area

The die area is the complete chip boundary.

It may include:

* Core area
* I/O structures
* Power pads or bumps
* Seal ring
* Boundary structures

The core area is primarily used for:

* Standard cells
* Macros
* Signal routing
* Clock routing
* Power structures

The core is inside the die, but the die includes more than the core.

---

## 19. Core Utilization

A simplified core-utilization expression is:

[
\text{Utilization}
==================

\frac{\text{Standard-cell area}}
{\text{Available placement area}}
]

Extremely high utilization may cause:

* Placement congestion
* Routing congestion
* Insufficient buffer space
* Difficult timing optimization
* Limited ECO flexibility
* Pin-access problems

Very low utilization may cause:

* Larger die area
* Longer wires
* Higher manufacturing cost
* Larger interconnect capacitance

Utilization is therefore a tradeoff rather than a quantity that should always be maximized.

---

## 20. Macro Placement

Macros may include:

* SRAM
* ROM
* Analog IP
* PLL
* Large predesigned blocks

Macros are normally positioned during floorplanning because they have:

* Large fixed dimensions
* Fixed pin locations
* Routing blockages
* Significant power requirements
* Strong influence on wirelength and congestion

Poor macro placement may produce:

* Narrow routing channels
* Long critical paths
* Pin-density hotspots
* Difficult power delivery
* Severe routing congestion

---

## 21. Halo and Channel

### Halo

A halo is a keepout region surrounding a macro.

It prevents standard cells from being placed too close to macro edges.

### Channel

A channel is the open space between two macros.

It may be required for:

* Signal routing
* Clock routing
* Power routing
* Buffer placement

中文区分：

* Halo：围绕单个 macro 的保护区域
* Channel：两个 macros 之间的通道

---

## 22. Placement and Routing Blockages

### Placement Blockage

Controls where standard cells may be placed.

Types may include:

* Hard blockage
* Soft blockage
* Partial blockage

### Routing Blockage

Restricts routing on selected metal layers or regions.

Do not confuse:

* Placement blockage → controls cells
* Routing blockage → controls wires and vias

---

## 23. Placement

Placement assigns physical locations to standard cells inside the core.

Its objectives include:

* Timing
* Wirelength
* Congestion
* Density
* Power
* Legality
* ECO flexibility

Placement follows floorplanning:

```text
Floorplanning
→ Global Placement
→ Legalization
→ Detailed Placement
```

---

## 24. Global Placement

Global placement assigns approximate standard-cell locations.

At this stage, cells may temporarily:

* Overlap
* Be located off legal rows
* Use approximate coordinates

The objective is to create a good global distribution while optimizing:

* Estimated wirelength
* Timing
* Congestion
* Density

Global placement does not determine macro positions. Macro placement belongs mainly to floorplanning.

---

## 25. Legalization

Legalization converts approximate placement into a legal arrangement.

It ensures:

* Cells align to valid placement rows.
* Cells use valid placement sites.
* Cells do not overlap.
* Cells remain in legal regions.
* Blockages are respected.
* Orientation rules are satisfied.

Legalization is not merely a test. It actively moves cells into legal positions.

---

## 26. Detailed Placement

Detailed placement performs smaller local changes after legalization.

Possible operations include:

* Cell swapping
* Local movement
* Row reordering
* Small displacement
* Local timing optimization
* Local congestion improvement

---

## 27. Timing-Driven Placement

Timing-driven placement gives greater priority to critical paths.

Moving connected critical cells closer can produce:

```text
Shorter wirelength
→ lower interconnect resistance and capacitance
→ lower net delay
→ earlier data arrival
→ improved setup slack
```

However, placing too many critical cells in one region may create congestion.

Placement must therefore balance timing and routing capacity.

---

## 28. Congestion-Driven Placement

Congestion occurs when routing demand exceeds routing capacity.

Routing demand depends on:

* Net count
* Pin count
* Estimated wire crossings
* Local cell density
* Macro pin concentration

Routing capacity depends on:

* Available tracks
* Metal layers
* Power-grid usage
* Blockages
* Macro obstructions

Congestion-driven placement may:

* Spread cells
* Reduce local density
* Move cells away from macro edges
* Use partial blockages
* Reduce high pin-density clusters

---

## 29. Wirelength Estimation

Before routing, exact wire geometry does not exist.

Placement tools may estimate wirelength using Half-Perimeter Wirelength, or HPWL.

For the smallest rectangle containing all pins:

[
\text{HPWL}
===========

\text{Rectangle Width}
+
\text{Rectangle Height}
]

HPWL does not include:

* Routing detours
* Via count
* Detailed obstacles
* Layer changes
* Final RC parasitics

---

## 30. Placement Whitespace

Placement must leave whitespace for later operations.

Whitespace may be required for:

* CTS buffers
* Timing buffers
* Hold-fix cells
* Cell upsizing
* Decap cells
* ECO cells
* Congestion relief
* Physical-only cells

Routing mainly uses metal layers above the cells. Therefore, placement whitespace is not simply empty space reserved for wires; it provides physical room for later cell insertion, movement, and optimization.

---

## 31. Pre-CTS Timing

Before CTS, the actual clock network does not exist.

The clock may be modeled using:

* Ideal clock assumptions
* Estimated latency
* Clock uncertainty

The design does not yet contain final:

* Clock buffers
* Clock routes
* Clock latency
* Clock skew

Pre-CTS hold analysis is therefore less accurate than post-CTS hold analysis.

---

## 32. Clock Tree Synthesis

Clock Tree Synthesis, or CTS, builds the physical network that distributes the clock from its source to sequential sinks.

Clock sinks include:

* Flip-flop clock pins
* Register clock pins
* Macro clock pins
* Clock-gating cell pins

CTS inserts clock buffers and inverters to control:

* Clock latency
* Clock skew
* Clock transition
* Fanout
* Clock power
* Routing impact

One clock source cannot directly drive thousands of flip-flops because the total load would cause:

* High capacitance
* Slow transition
* Large delay
* High power
* Routing difficulty

A hierarchical clock tree divides the total load among multiple buffers.

---

## 33. Clock Latency

Clock latency is the time required for a clock edge to travel from the clock source to one sink.

[
\text{Clock Latency}
====================

## \text{Clock Arrival at Sink}

\text{Clock Launch at Source}
]

It is often called insertion delay.

中文记忆：

> Latency 是 clock 到达一个 sink 花费的时间。

---

## 34. Clock Skew

Clock skew is the clock-arrival-time difference between two sinks.

For a launch-to-capture path:

[
\text{Skew}
===========

## T_{\text{capture clock}}

T_{\text{launch clock}}
]

中文记忆：

> Skew 是 clock 到达两个 sinks 的时间差。

### Positive Skew

Capture clock arrives later.

Typical simplified effect:

* Setup may improve.
* Hold may worsen.

### Negative Skew

Capture clock arrives earlier.

Typical simplified effect:

* Setup may worsen.
* Hold may improve.

---

## 35. Useful Skew

CTS does not always attempt to achieve mathematically exact zero skew.

Reasons include:

* Exact zero skew is physically impractical.
* Excessive balancing may increase power and area.
* Additional buffers may worsen congestion.
* Different timing paths have different requirements.
* Controlled skew may improve critical timing.

Useful skew intentionally adjusts clock-arrival relationships to improve setup or hold timing.

The goal is acceptable global timing closure, not necessarily zero skew at every sink pair.

---

## 36. Clock Gating

Clock gating disables downstream clock switching in inactive blocks.

```text
Clock
→ Integrated Clock-Gating Cell
→ Gated Clock
→ Registers
```

Benefits include lower dynamic power.

Clock-gating setup and hold checks ensure that the enable signal does not create:

* Short pulses
* Missing pulses
* Extra pulses
* Clock glitches

A dedicated clock-gating cell is safer than directly combining a clock and enable with ordinary combinational logic.

---

## 37. Post-CTS Optimization

After CTS, the tool can analyze more realistic:

* Clock latency
* Clock skew
* Setup timing
* Hold timing

Possible post-CTS operations include:

* Clock-buffer resizing
* Data-path resizing
* Buffer insertion
* Delay-cell insertion
* Cell movement
* Congestion repair
* Setup repair
* Hold repair

CTS introduces a tradeoff among:

* Skew
* Latency
* Transition
* Power
* Area
* Congestion
* Timing closure

---

## 38. Routing

Routing converts logical nets into physical metal and via geometry.

The gate-level netlist may specify:

```text
U1/Z → U2/A
```

Routing determines:

* Metal layers
* Wire path
* Wire width
* Wire spacing
* Via locations
* Actual wirelength
* Physical pin access

Netlist connectivity specifies what must be connected. Routing specifies how the connection is physically implemented.

---

## 39. Metal Layers and Preferred Directions

Different metal layers may have different:

* Width
* Thickness
* Pitch
* Resistance
* Capacitance
* Preferred routing direction

A simplified direction pattern may be:

```text
M1: horizontal
M2: vertical
M3: horizontal
M4: vertical
```

A via connects adjacent metal layers vertically.

Upper layers are often wider, thicker, and lower resistance, making them useful for:

* Long-distance signals
* Clock routes
* Power distribution
* High-current connections

Lower layers are often used for local cell connections and pin access.

---

## 40. Global Routing

Global routing plans approximate routing paths.

It determines:

* Which regions a net should cross
* Approximate layer usage
* Routing demand
* Routing capacity
* Congestion hotspots

中文理解：

> Global routing 先决定线路大致经过哪些区域，还没有精确到具体 track。

---

## 41. Detailed Routing

Detailed routing creates exact legal wire and via geometry.

It determines:

* Specific routing tracks
* Exact metal segments
* Exact via positions
* Pin connections
* Width and spacing legality

| Global Routing             | Detailed Routing      |
| -------------------------- | --------------------- |
| Approximate route planning | Exact geometry        |
| Resource allocation        | Track assignment      |
| Congestion estimation      | Legal wires and vias  |
| Regional paths             | Final physical routes |

---

## 42. Routing Congestion

Routing congestion occurs when demand exceeds capacity.

Demand may increase because of:

* High net density
* High pin density
* Dense placement
* Macro pin concentration
* Complex connectivity

Capacity may decrease because of:

* Macros
* Routing blockages
* Wide power stripes
* Reserved clock resources
* Limited metal layers
* Narrow macro channels

Possible consequences include:

* Long detours
* More vias
* Larger parasitics
* Timing degradation
* DRC violations
* Unrouted nets

---

## 43. Routing and Parasitics

Once physical routing exists, more accurate interconnect parasitics can be calculated.

A routing detour may cause:

```text
Longer wire
→ larger resistance and capacitance
→ larger net delay
→ later data arrival
→ worse setup slack
```

Post-route timing is more accurate than placement-stage timing because the tool knows:

* Actual wirelength
* Routing layers
* Via count
* Detours
* Neighboring nets
* Extracted resistance and capacitance

---

## 44. Critical-Net and Clock Routing

Critical nets may receive:

* Shorter routing
* Upper metal layers
* Wider wires
* Increased spacing
* Fewer detours
* Shielding

Clock routes may use nondefault rules such as:

* Wider wire
* Larger spacing
* Upper metal
* Shielding

These methods may improve:

* Resistance
* Transition
* Crosstalk immunity
* Reliability

However, they consume additional routing capacity.

---

## 45. Parasitic Extraction

Parasitic extraction converts final routing geometry into electrical interconnect models.

It extracts:

* Wire resistance
* Via resistance
* Ground capacitance
* Coupling capacitance

The primary output is often SPEF.

| File               | Main content                            |
| ------------------ | --------------------------------------- |
| Gate-level netlist | Cell instances and logical connectivity |
| SDC                | Timing constraints                      |
| `.lib`             | Cell timing and power behavior          |
| SPEF               | Extracted interconnect parasitics       |
| GDSII/OASIS        | Final manufacturing geometry            |

---

## 46. Physical-Design Signoff

Signoff evaluates the exact final or near-final implementation.

Typical signoff categories include:

* DRC
* LVS
* ERC
* Final parasitic extraction
* Setup and hold STA
* MMMC analysis
* Signal integrity
* Antenna
* Electromigration
* Static IR drop
* Dynamic IR drop
* Metal density
* Final GDSII/OASIS verification

The signoff question is:

> Is the exact final layout safe to manufacture and operate?

---

## 47. GDSII and OASIS

GDSII and OASIS contain final manufacturing geometry.

They include:

* Standard-cell geometry
* Macro geometry
* Metal wires
* Vias
* Contacts
* Power grid
* Metal fill
* Physical-only cells
* Layer and datatype information

They do not replace:

* RTL
* Gate-level netlist
* SDC
* SPEF
* `.lib`

---

## 48. Three Main Design Representations

| Representation     | Main content                                     |
| ------------------ | ------------------------------------------------ |
| RTL                | Register-transfer behavior                       |
| Gate-level netlist | Standard-cell instances and logical connectivity |
| GDSII/OASIS        | Final manufacturing geometry                     |

These are different abstraction levels of the same chip.

---

## 49. Feedback Loops

The RTL-to-GDSII flow is iterative.

### Synthesis Feedback

```text
Timing failure
→ modify constraints, RTL, or microarchitecture
→ rerun synthesis
```

### Placement Feedback

```text
Placement congestion
→ spread cells or adjust blockages
→ modify floorplan if required
→ rerun placement
```

### CTS Feedback

```text
Poor skew or clock congestion
→ change clock constraints or placement
→ rebuild clock tree
```

### Routing Feedback

```text
Routing detour or DRC issue
→ reroute, change layer, or move cells
```

### Signoff Feedback

```text
Signoff violation
→ implement ECO
→ rerun affected stages
→ regenerate final database
```

A problem found in a later stage may originate from an earlier stage.

---

## 50. Root-Cause Analysis

### Setup-Violation Causes

A setup violation may originate from:

* Too much combinational logic in one RTL pipeline stage
* Weak cell selection
* Poor placement
* Long routing detour
* Excessive parasitics
* Unfavorable clock skew

Different root causes require different fixes.

A routing problem should not automatically be fixed by adding a buffer if the real cause is:

* Poor macro placement
* Narrow routing channel
* Excessive utilization
* Incorrect pipeline structure

### Congestion Causes

Congestion may originate from:

* High utilization
* Poor macro placement
* Narrow channels
* Pin-density hotspots
* Too many buffers
* Wide power stripes
* Routing blockages

A severe structural congestion problem may require returning to floorplanning.

Detailed routing cannot create routing capacity when macros or blockages physically remove the required space.

---

## 51. PPA Through the Flow

PPA means:

* Power
* Performance
* Area

PPA estimates become more accurate as the design moves toward final layout.

### Synthesis

Uses cell timing and estimated interconnect.

### Placement

Uses physical locations and estimated wirelength.

### CTS

Adds clock latency, skew, buffers, and clock power.

### Routing

Adds real route length, vias, and more accurate parasitics.

### Signoff

Uses final extraction and qualified analysis models.

Early estimates are useful, but they are not final.

---

## 52. Cost of Late Changes

Changes become more expensive later in the flow.

```text
Early RTL bug
→ relatively easy to modify and verify

Post-route bug
→ requires physical ECO and repeated analysis

Post-tapeout bug
→ may require new masks and fabrication
```

Therefore:

> Earlier detection generally produces lower engineering and manufacturing cost.

---

## 53. Final Integrated Flow Table

| Stage                   | Main input                                | Main output                   |
| ----------------------- | ----------------------------------------- | ----------------------------- |
| Specification           | Product requirements                      | Functional requirements       |
| Microarchitecture       | Specification and PPA targets             | Hardware organization         |
| RTL                     | Microarchitecture                         | Synthesizable HDL             |
| Functional verification | RTL and specification                     | Verified RTL                  |
| Synthesis               | RTL, SDC and `.lib`                       | Gate-level netlist            |
| Floorplanning           | Netlist, LEF and constraints              | Die/core and macro plan       |
| Placement               | Floorplan and netlist                     | Legal standard-cell locations |
| CTS                     | Placed design and clock constraints       | Physical clock tree           |
| Routing                 | Placed design and clock tree              | Metal wires and vias          |
| Extraction              | Routed geometry                           | SPEF                          |
| Signoff                 | Layout, netlist, SDC, SPEF and rule decks | Tapeout approval              |
| Stream-out              | Verified physical database                | GDSII/OASIS                   |
| Tapeout                 | Final database and reports                | Foundry release               |

---

## 54. Core Principle

The complete RTL-to-GDSII process can be summarized as:

```text
Specification defines required behavior.
Microarchitecture defines hardware organization.
RTL describes that organization.
Verification checks RTL functionality.
Synthesis maps RTL into standard cells.
Floorplanning defines global physical structure.
Placement positions standard cells.
CTS builds the clock network.
Routing creates metal and via connections.
Extraction calculates interconnect parasitics.
Signoff verifies manufacturability, timing and reliability.
GDSII/OASIS represents the final manufacturing geometry.
Tapeout releases the verified database for fabrication.
```

The most important engineering lesson is:

> RTL-to-GDSII is an iterative abstraction-refinement process. Every later physical result depends on earlier logical and architectural decisions, and successful closure requires identifying the real root cause rather than optimizing only the stage where a violation was first observed.
