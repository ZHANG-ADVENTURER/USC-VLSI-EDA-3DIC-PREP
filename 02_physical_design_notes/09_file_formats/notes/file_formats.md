# RTL-to-GDSII File Formats and Handoffs

## 1. Overview

The RTL-to-GDSII flow uses multiple complementary file formats because no single file can fully describe a modern integrated circuit.

Different files describe different aspects of the same chip:

* Logical behavior
* Logical connectivity
* Timing requirements
* Cell timing and power characteristics
* Abstract physical library information
* Design-specific placement and routing
* Extracted interconnect parasitics
* Computed timing delays
* Final manufacturing geometry

The core file map is:

> RTL
> → register-transfer behavior
>
> Gate-level netlist
> → standard-cell instances and logical connectivity
>
> SDC
> → timing requirements and exceptions
>
> .lib
> → cell logic, timing, electrical and power models
>
> Cell LEF
> → abstract physical cell information
>
> Technology LEF
> → process routing and placement technology
>
> DEF
> → design-specific physical implementation
>
> SPEF
> → extracted interconnect resistance and capacitance
>
> SDF
> → computed delay back-annotation
>
> GDSII/OASIS
> → final manufacturing geometry

Key point:

> These files do not duplicate the same information. They describe the same chip from different abstraction levels.

---

## 2. Main File Categories

Important flow files can be grouped into four categories.

### Logical Design Files

These describe circuit behavior or logical connectivity.

Examples:

* RTL
* Gate-level netlist

### Constraint and Analysis Files

These describe timing requirements or calculated implementation results.

Examples:

* SDC
* SPEF
* SDF

### Library and Technology Files

These describe reusable cells and process technology.

Examples:

* `.lib`
* Cell LEF
* Technology LEF
* Library GDSII/OASIS
* Extraction models
* Foundry rule decks

### Physical Implementation Files

These describe how one specific chip or block is physically implemented.

Examples:

* DEF
* GDSII
* OASIS

---

## 3. Behavior, Connectivity and Geometry

### Behavior

Behavior describes what the circuit does.

Primary representation:

* RTL

Example:

> When enable is asserted, the counter increments.

### Connectivity

Connectivity describes which instances and pins are logically connected.

Primary representation:

* Gate-level netlist

Example:

> U1/Q connects to U2/A.

### Geometry

Geometry describes physical shapes, layers and coordinates.

Primary representations:

* DEF
* GDSII/OASIS

Example:

> A metal segment exists on M3 at specified coordinates.

Practical distinction:

* Behavior describes what the circuit does.
* Connectivity describes which cells and pins are connected.
* Geometry describes where cells, wires, and vias physically exist.

---

## 4. Requirement versus Result

### Requirement

SDC defines what timing the design must satisfy.

Example:

> Clock period = 2 ns

### Physical or Analysis Result

SPEF describes the parasitics produced by physical routing.

SDF describes calculated timing delays used for simulation back-annotation.

> SDC
> → timing target
>
> SPEF
> → extracted RC consequence
>
> SDF
> → calculated delay result

---

## 5. RTL

RTL is normally written using Verilog, SystemVerilog or VHDL.

It describes:

* Registers
* Combinational logic
* State transitions
* Datapaths
* Control logic
* Module interfaces
* Clocked behavior

Example:

> always_ff @(posedge clk) begin
>     if (reset)
>         q <= 4'b0000;
>     else if (enable)
>         q <= q + 1'b1;
> end

RTL describes intended hardware behavior but does not specify the exact standard cells or physical coordinates.

Although RTL resembles software, it represents hardware structures.

> assign y = a & b;

may synthesize into combinational gates.

> always_ff @(posedge clk)
>     q <= d;

represents a flip-flop.

---

## 6. Synthesizable and Nonsynthesizable Constructs

Common synthesizable constructs include:

* `always_ff`
* `always_comb`
* `assign`
* `if`
* `case`
* Fixed-bound loops
* Arithmetic operators
* Registers and FSMs

Common simulation-only constructs include:

* `#10`
* `$display`
* `$finish`
* Testbench stimulus
* Certain file operations
* Many testbench `initial` blocks

> #10 a = 1'b1;

describes simulation timing rather than a normal synthesizable hardware element.

Therefore:

> Valid Verilog simulation code is not necessarily synthesizable RTL.

---

## 7. Gate-Level Netlist

Logic synthesis converts RTL into a gate-level netlist.

Example:

> NAND2_X1 U1 (
>     .A(a),
>     .B(b),
>     .ZN(n1)
> );
>
> INV_X1 U2 (
>     .A(n1),
>     .ZN(y)
> );

The netlist contains:

* Library cell types
* Instance names
* Pin connections
* Logical nets
* Design hierarchy or flattened connectivity

It does not contain final:

* Cell coordinates
* Metal routes
* Via positions
* Wire lengths
* Extracted parasitics
* Manufacturing polygons

---

## 8. Cell Type and Instance Name

Example:

> INV_X1 U25 (...);

* `INV_X1` is the cell type.
* `U25` is the instance name.

The cell type comes from a standard-cell library.

The instance name identifies one particular copy of that cell in the current design.

> INV_X1 U25 (...);
> INV_X1 U26 (...);

`U25` and `U26` are separate instances of the same library cell.

Practical distinction:

* Cell type identifies the library-cell model.
* Instance name identifies one specific copy of that cell in the current design.

---

## 9. RTL versus Gate-Level Netlist

| RTL                               | Gate-Level Netlist             |
| --------------------------------- | ------------------------------ |
| Register-transfer behavior        | Standard-cell instances        |
| Written mainly by RTL designers   | Generated mainly by synthesis  |
| Contains behavioral expressions   | Contains mapped library cells  |
| Relatively technology-independent | Technology-dependent           |
| Easier to understand and modify   | Larger and more detailed       |
| No exact library mapping          | Pin-level logical connectivity |

Synthesis preserves logical behavior, not necessarily the exact written RTL structure.

Example:

> (a & b) | (a & c)

may be optimized into:

> a & (b | c)

The Boolean function remains equivalent while the physical implementation may use fewer or faster cells.

---

## 10. RTL and Netlist Hierarchy

A hierarchical design may contain:

> top
> ├── alu
> ├── controller
> ├── register_file
> └── fifo

A hierarchical netlist may retain paths such as:

> top/u_alu/U1
> top/u_fifo/U20

A flattened netlist may reduce hierarchy and place many instances at one level.

Hierarchy helps:

* Debugging
* Block-level analysis
* Design organization
* Physical partitioning

Flattening may provide synthesis tools with greater global optimization freedom.

---

## 11. SDC

SDC stands for Synopsys Design Constraints.

It describes timing intent and external timing assumptions.

Common SDC information includes:

* Clock period
* Clock waveform
* Input delay
* Output delay
* Clock uncertainty
* Clock latency
* Input transition
* Output load
* Maximum transition
* Maximum fanout
* Maximum capacitance
* False paths
* Multicycle paths

SDC does not describe logical functionality or physical geometry.

Practical distinction:

> RTL tells the tool what the circuit does. SDC tells the tool how quickly the circuit must complete its timing requirements.

---

## 12. Clock Definition

Example:

> create_clock -name clk -period 10 [get_ports clk]

This defines:

* Clock name
* Clock source
* Clock period
* Timing reference edges

It does not build the physical clock tree.

The clock tree is physically created later during CTS.

> create_clock
> → defines timing intent
>
> CTS
> → inserts actual clock buffers and routing

---

## 13. Input and Output Delay

### Input Delay

Input delay models time consumed outside the current design before data reaches an input port.

> External register
> → external logic or package
> → design input port
> → internal logic

> set_input_delay 2 -clock clk [get_ports data_in]

The `2 ns` represents external timing usage before the data reaches the current design boundary.

### Output Delay

Output delay reserves timing budget for circuitry outside the current design after data leaves an output port.

> set_output_delay 3 -clock clk [get_ports data_out]

It does not simply describe the physical delay of the output pin.

---

## 14. Input Transition and Output Load

Input transition models the slew of an external signal entering the design.

> set_input_transition 0.2 [get_ports data_in]

Output load models capacitance driven outside the design.

> set_load 0.05 [get_ports data_out]

A slow input transition or large output load can increase cell delay and worsen timing.

---

## 15. Clock Uncertainty and Latency

### Clock Uncertainty

Clock uncertainty reserves timing margin for:

* Jitter
* Skew estimates
* Modeling uncertainty
* Variation margin

> set_clock_uncertainty 0.2 [get_clocks clk]

### Clock Latency

Clock latency models clock travel time from the source to sinks.

Before CTS, it may be estimated.

After CTS, propagated clock paths provide more realistic latency.

Do not confuse:

* Clock period: time between clock cycles
* Clock latency: clock travel time
* Clock uncertainty: reserved timing margin

---

## 16. False Paths

A false path physically exists in the design but does not require normal functional setup and hold analysis.

It is not a wrong or slow path.

> set_false_path -from ... -to ...

Incorrectly declaring a real path false can hide a genuine timing violation.

> Critical path marked false
> → STA ignores it
> → reports appear clean
> → silicon may fail

---

## 17. Multicycle Paths

A multicycle path is a valid path that is functionally allowed to take more than one clock cycle.

> set_multicycle_path 2 -setup -from ... -to ...

For a `5 ns` clock:

> Normal single-cycle budget ≈ 5 ns
> Two-cycle setup budget ≈ 10 ns

A multicycle constraint must come from actual architectural behavior, not merely because a path fails timing.

---

## 18. Unconstrained Paths

An unconstrained path is a path for which STA cannot establish a complete timing requirement.

Possible causes include:

* Missing clock
* Missing input delay
* Missing output delay
* Missing generated clock
* Incorrect constraint object
* Incomplete timing coverage

> Unconstrained
> ≠ passed
>
> Unconstrained
> = tool may not know how to check the path

Key point:

> The absence of reported violations does not necessarily mean the design is timing-clean. The path may simply be unconstrained or incorrectly constrained.

---

## 19. Liberty `.lib`

A `.lib` file is a Liberty-format logical, electrical, timing and power model.

It may contain:

* Boolean functions
* Pin directions
* Timing arcs
* Propagation delay
* Output transition
* Input capacitance
* Setup and hold requirements
* Recovery and removal requirements
* Internal power
* Leakage power
* Operating conditions

It is used by:

* Synthesis
* STA
* Physical optimization
* Power analysis
* Signoff

---

## 20. Timing Arcs

A timing arc describes a timing relationship between pins.

For a combinational cell:

> Input A → Output Y

For a flip-flop:

* Clock-to-Q
* Setup
* Hold
* Recovery
* Removal
* Pulse-width checks

A timing arc is a library timing relationship, not a physical metal wire.

---

## 21. Slew and Load Dependence

Cell delay is generally not one fixed value.

Within one PVT corner, cell delay primarily depends on:

1. Input slew
2. Output load capacitance

> Slow input slew
> + large output load
> → larger cell delay

The `.lib` stores delay and output-transition tables.

STA interpolates table values using actual input slew and output load.

Key point:

> PVT determines which library corner is used. Slew and load determine which delay value is selected or interpolated within that library table.

---

## 22. Stage-by-Stage Slew Propagation

The output slew of one cell becomes the input slew of the next cell.

> Input slew
> → Cell 1 delay
> → Cell 1 output slew
> → Cell 2 input slew
> → Cell 2 delay

Therefore, poor transition at one stage can affect later stages.

---

## 23. Input Capacitance and Cell Upsizing

A larger cell usually has larger input transistors and therefore larger input capacitance.

> Upsize current cell
> → current stage may become faster
> → previous stage sees larger load
> → previous stage may become slower

Cell upsizing does not automatically improve the complete path.

Timing optimization must consider the entire path.

---

## 24. PVT Corners

PVT stands for:

* Process
* Voltage
* Temperature

Cell timing changes under different PVT conditions.

Examples include:

* Slow process, low voltage, high temperature
* Typical process, nominal voltage, nominal temperature
* Fast process, high voltage, low temperature

One cell such as `INV_X1` can have different delay values in different `.lib` corners.

---

## 25. LEF

LEF stands for Library Exchange Format.

LEF provides abstract physical information used by placement and routing tools.

It intentionally hides detailed transistor-level internal geometry.

Place-and-route tools mainly need to know:

* Cell size
* Cell boundary
* Pin access
* Routing obstruction
* Placement legality
* Routing technology

---

## 26. Cell LEF

Cell LEF describes the abstract physical view of a standard cell or macro.

It may contain:

* Width and height
* Boundary
* Placement site
* Symmetry
* Pin names
* Pin directions
* Pin metal shapes
* Routing obstructions

Conceptual example:

> Cell: INV_X1
> Width: 0.8 µm
> Height: 2.4 µm
>
> Pin A:
> Layer M1
> Input pin shape
>
> Pin Y:
> Layer M1
> Output pin shape

---

## 27. Technology LEF

Technology LEF describes process-wide placement and routing technology.

It may contain:

* Metal layers
* Cut and via layers
* Preferred routing directions
* Routing pitch
* Width and spacing information
* Via definitions
* Placement sites
* Manufacturing grid

Practical distinction:

* Cell LEF describes the dimensions, pins, and routing obstructions of one cell or macro.
* Technology LEF describes process-wide metal layers, vias, placement sites, and routing resources.

---

## 28. `.lib` versus LEF

| `.lib`                      | LEF                     |
| --------------------------- | ----------------------- |
| Logical and electrical view | Abstract physical view  |
| Boolean function            | Cell size               |
| Timing arcs                 | Pin geometry            |
| Delay tables                | Cell boundary           |
| Input capacitance           | Routing obstruction     |
| Setup and hold              | Placement site          |
| Power information           | Physical routing access |

Memory rule:

> .lib
> → What does the cell do electrically?
>
> LEF
> → What does the cell look like physically?

---

## 29. Multiple Views of One Cell

One standard cell may have:

* `.lib` timing and power model
* LEF abstract physical view
* GDSII/OASIS detailed layout
* Verilog functional model
* SPICE transistor-level model

These are different views of the same cell.

Cell names and pin names must remain consistent across views.

A netlist instance of `NAND2_X4` requires a matching LEF view for placement and routing.

Without the LEF, the physical-design tool does not know:

* Cell dimensions
* Pin locations
* Routing access
* Obstructions
* Legal placement rules

---

## 30. DEF

DEF stands for Design Exchange Format.

DEF describes the physical implementation of one specific chip or block.

It may contain:

* Die boundary
* Design units
* Placement rows
* Standard-cell locations
* Macro locations
* Orientations
* Pins
* Blockages
* Regions
* Special nets
* Signal routes
* Vias

Practical distinction:

> LEF describes reusable library templates. DEF describes how the current design instantiates and physically implements those templates.

---

## 31. Netlist, LEF and DEF Relationship

Suppose the design contains:

> INV_X1 U25 (...);

The files provide:

> Netlist
> → U25 exists and uses INV_X1
>
> LEF
> → INV_X1 has this size and pin geometry
>
> DEF
> → U25 is placed at this coordinate and orientation

The shared instance name links logical and physical databases.

---

## 32. DEF Database Units

DEF commonly stores physical coordinates as integer database units.

Example:

> UNITS DISTANCE MICRONS 1000

means:

> 1000 database units = 1 µm

Integer coordinates reduce floating-point precision issues in physical databases.

---

## 33. DEF Placement Status

### Unplaced

The instance has no assigned physical coordinate.

### Placed

The instance has a location but may still be moved by optimization tools.

### Fixed

The instance has a location and should normally remain unchanged.

Macros are often fixed after floorplanning, although other instances can also be fixed.

---

## 34. Cell Orientation

Common DEF orientations include:

* `N`
* `S`
* `E`
* `W`
* `FN`
* `FS`
* `FE`
* `FW`

Standard-cell rows often alternate between orientations such as `N` and `FS`.

Orientation affects:

* Power-rail alignment
* Pin locations
* Routing access
* Geometric legality

---

## 35. DEF Through the Physical Flow

### Floorplan DEF

May include:

* Die boundary
* Rows
* Macro placement
* Blockages
* Initial power structures

### Placement DEF

Adds:

* Standard-cell locations
* Orientations
* Inserted physical cells

### Post-CTS DEF

Adds:

* Clock cells
* Clock-cell placement
* Clock implementation data

### Routed DEF

Adds:

* Signal routes
* Vias
* Detailed routing information

An early DEF does not necessarily contain final routing.

---

## 36. DEF versus GDSII/OASIS

| DEF                               | GDSII/OASIS                                    |
| --------------------------------- | ---------------------------------------------- |
| Design implementation description | Detailed manufacturing geometry                |
| Instance coordinates              | Complete cell polygons                         |
| Placement and routing objects     | Diffusion, contacts, metal and vias            |
| References cell masters           | Contains or references detailed layouts        |
| Used during physical design       | Used for physical verification and fabrication |

DEF does not depend on which nets were activated by a testbench.

Testbench activity affects simulation and may affect power-analysis activity data, but it does not define the content of DEF.

---

## 37. SPEF

SPEF stands for Standard Parasitic Exchange Format.

It stores extracted interconnect parasitics:

* Wire resistance
* Via resistance
* Ground capacitance
* Coupling capacitance
* Distributed RC connectivity

SPEF is used by:

* STA
* Signal-integrity analysis
* Power analysis
* Post-route optimization
* Signoff tools

---

## 38. Why Netlist Connectivity Is Insufficient

A netlist may specify:

> U1/Z → U2/A

but it does not indicate whether the connection is:

* Short or long
* Routed on lower or upper metal
* Routed through multiple vias
* Forced around blockages
* Coupled to neighboring nets

The same logical net may have different physical RC and delay depending on routing.

---

## 39. Ground and Coupling Capacitance

### Ground Capacitance

Capacitance between a signal interconnect and surrounding reference conductors.

Larger ground capacitance increases the load driven by the source cell.

### Coupling Capacitance

Capacitance between neighboring signal nets.

The timing effect depends on:

* Switching direction
* Switching alignment
* Aggressor strength
* Parallel routing length
* Spacing

Opposite-direction switching may increase effective victim delay and worsen setup.

Same-direction switching may reduce effective delay and create hold risk.

---

## 40. Distributed RC

A short net may be modeled approximately as a lumped capacitance.

A long net is more accurately represented as a distributed network:

> Driver
> → R1 → node1
> → R2 → node2
> → R3 → load

Capacitances attach at multiple points.

SPEF commonly represents distributed RC networks.

---

## 41. SPEF Naming

Large SPEF files may use name mapping to shorten hierarchical names.

The SPEF names must correctly match the gate-level netlist.

Otherwise, parasitics may not annotate onto the correct nets.

---

## 42. SDF

SDF stands for Standard Delay Format.

It contains calculated timing quantities for gate-level simulation back-annotation.

It may include:

* Cell delays
* Interconnect delays
* Setup checks
* Hold checks
* Recovery/removal checks
* Pulse-width checks

SDF stores computed delay values rather than raw RC networks.

---

## 43. SPEF versus SDF

| SPEF                              | SDF                                   |
| --------------------------------- | ------------------------------------- |
| Stores resistance and capacitance | Stores calculated delay               |
| Electrical parasitic model        | Timing annotation model               |
| Used heavily by STA and SI        | Used heavily by gate-level simulation |
| Allows delay recalculation        | Contains precomputed timing values    |
| Represents distributed RC         | Represents delay and timing checks    |

Memory rule:

> SPEF = RC
> SDF  = delay

---

## 44. Post-Route STA Inputs

The four primary post-route STA inputs are:

> Gate-level netlist
> + SDC
> + .lib
> + SPEF
> → STA

Their roles are:

| File    | Role                          |
| ------- | ----------------------------- |
| Netlist | Timing-path connectivity      |
| SDC     | Timing requirements           |
| `.lib`  | Cell delays and timing checks |
| SPEF    | Interconnect parasitics       |

SDF is normally not a primary STA input. It is commonly generated for timing-aware simulation.

---

## 45. Why SDF Simulation Does Not Replace STA

Gate-level simulation with SDF depends on testbench stimulus.

> Path not activated by testbench
> → simulation does not observe the path

STA:

* Requires no functional stimulus
* Systematically analyzes all constrained paths
* Efficiently checks setup and hold
* Provides timing coverage unsuitable for exhaustive simulation

Therefore, SDF simulation supplements but does not replace STA.

---

## 46. GDSII and OASIS

GDSII and OASIS represent final physical layout geometry.

They may contain:

* Standard-cell layouts
* Macro layouts
* Diffusion
* Contacts
* Metal wires
* Vias
* Power structures
* Metal fill
* Seal-ring structures
* Layer and datatype identifiers

Their main question is:

> What exact shapes should be manufactured?

---

## 47. GDSII versus OASIS

Both formats serve a similar layout purpose.

### GDSII

* Older
* Widely supported
* Can produce very large files

### OASIS

* Newer
* More compact
* More efficient for repeated and advanced geometry

OASIS does not represent a different physical design. It encodes the layout more efficiently.

---

## 48. Stream-Out

Stream-out generates final GDSII/OASIS from the physical-design database.

> Physical implementation database
> + library GDS/OASIS
> + macro GDS/OASIS
> + layer map
> → stream-out
> → final chip GDSII/OASIS

DEF may state:

> U25 is an INV_X1 at coordinate (x, y).

Library GDS provides the complete internal layout of `INV_X1`.

Stream-out places that complete geometry at the specified coordinate and adds design-level routes and vias.

---

## 49. Layer Map

A layer map translates internal EDA layer names and purposes into foundry-defined numeric GDS/OASIS layer and datatype identifiers.

Example:

> Internal M1 drawing
> → layer 31, datatype 0
>
> Internal M1 pin
> → layer 31, datatype 10

An incorrect layer map can cause:

* Missing geometry
* Geometry on the wrong manufacturing layer
* DRC failures
* Incorrect mask data
* Fabrication failure

Key point:

> A layer map is not a simple name translation. It is an exact mapping between internal design-layer purposes and foundry manufacturing layer and datatype identifiers.

---

## 50. Physical-Only Cells

Final physical layouts may include cells not directly described in RTL:

* Filler cells
* Tap cells
* End-cap cells
* Tie cells
* Decap cells
* Spare cells
* Antenna diodes

These support:

* Well continuity
* Substrate bias
* Row boundaries
* Constant logic values
* Power integrity
* ECO flexibility
* Antenna protection

They appear in physical databases and GDSII/OASIS despite not representing original functional RTL logic.

---

## 51. Metal Fill

Metal fill is inserted to satisfy manufacturing density requirements and improve CMP uniformity.

Fill changes physical geometry and can alter:

* Ground capacitance
* Coupling capacitance
* Signal delay
* Crosstalk behavior

Therefore, after fill insertion the flow may rerun:

* Parasitic extraction
* STA
* Signal-integrity analysis
* DRC

---

## 52. Checksums and Waivers

### Checksum

A checksum verifies that the submitted layout file is exactly the same file that was approved.

It does not prove the design is correct.

### Waiver

A waiver is a formally reviewed and approved exception.

A waiver normally requires:

* Exact violation identification
* Technical justification
* Risk review
* Approval
* Documentation
* Traceability

A mandatory unwaived violation normally blocks tapeout.

---

## 53. Complete File Handoff Flow

### Logic Synthesis

Inputs:

* RTL
* SDC
* `.lib`

Outputs:

* Gate-level netlist
* Timing reports
* Area reports
* Power estimates

### Physical Design

Inputs:

* Gate-level netlist
* SDC
* `.lib`
* Cell LEF
* Technology LEF
* Macro views

Outputs:

* Implementation database
* DEF
* Placement, CTS and routing reports

### Extraction and STA

Inputs:

* Gate-level netlist
* SDC
* `.lib`
* Routed physical design
* Extraction models

Outputs:

* SPEF
* Timing reports
* Possible SDF

### Stream-Out and Tapeout

Inputs:

* Final physical database
* Standard-cell GDS/OASIS
* Macro GDS/OASIS
* Layer map
* Signoff data

Outputs:

* Final GDSII/OASIS
* Physical verification reports
* Tapeout package

---

## 54. Final File Table

| File               | Main content                            | Primary use                        |
| ------------------ | --------------------------------------- | ---------------------------------- |
| RTL                | Register-transfer behavior              | Simulation and synthesis           |
| Gate-level netlist | Cell instances and logical connectivity | Physical design, STA and LVS       |
| SDC                | Timing requirements and exceptions      | Synthesis, physical design and STA |
| `.lib`             | Cell logic, timing and power models     | Synthesis, STA and optimization    |
| Cell LEF           | Cell dimensions, pins and obstructions  | Placement and routing              |
| Technology LEF     | Metal, via and placement technology     | Physical design                    |
| DEF                | Design-specific placement and routing   | Physical implementation            |
| SPEF               | Extracted interconnect R and C          | STA and SI                         |
| SDF                | Calculated delay annotation             | Gate-level simulation              |
| GDSII/OASIS        | Final detailed manufacturing geometry   | Verification and fabrication       |

---

## 55. Core Principle

The complete file relationship can be summarized as:

> RTL
> → what the design does
>
> Gate-level netlist
> → which standard cells implement it
>
> SDC
> → what timing the design must meet
>
> .lib
> → how cells behave electrically
>
> LEF
> → what cells and routing resources look like abstractly
>
> DEF
> → where this design’s instances and routes are implemented
>
> SPEF
> → what interconnect RC the implementation creates
>
> SDF
> → what calculated delays should be annotated into simulation
>
> GDSII/OASIS
> → what exact geometry will be manufactured

The central rule is:

> Every file answers a different engineering question. Correct RTL-to-GDSII handoff requires consistent cell names, pin names, hierarchy, units, corners, constraints and physical-layer definitions across all views.
