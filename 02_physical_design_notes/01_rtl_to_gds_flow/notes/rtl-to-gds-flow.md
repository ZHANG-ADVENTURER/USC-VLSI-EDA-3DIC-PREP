# RTL-to-GDS Flow Overview

## Overview

The RTL-to-GDS flow converts a digital design from a logical hardware description into a physical layout that can be submitted for semiconductor manufacturing.

RTL describes the intended logic and timing behavior of a design, but it does not specify the physical coordinates of cells, metal routing, vias, or chip dimensions. Logic synthesis maps the RTL into standard-cell instances and produces a gate-level netlist. Physical design then assigns physical locations and creates the interconnections needed to implement the design as a manufacturable layout.

The simplified flow is:

    RTL
      ↓
    Logic Synthesis
      ↓
    Gate-Level Netlist
      ↓
    Floorplanning
      ↓
    Power Planning
      ↓
    Placement
      ↓
    Clock Tree Synthesis
      ↓
    Routing
      ↓
    Static Timing Analysis
      ↓
    DRC and LVS
      ↓
    GDSII
      ↓
    Tape-out

This is a simplified teaching sequence. In a real design flow, timing analysis, physical verification, and optimization are performed repeatedly rather than only once at the end.

## 1. RTL

RTL stands for Register Transfer Level.

RTL describes:

- How data moves between registers
- What combinational operations are performed
- How registers update on clock edges
- How control logic changes the behavior of the circuit

Examples of RTL structures include:

- ALUs
- Counters
- Registers
- Finite state machines
- FIFOs
- Multiplexers
- Valid/ready interfaces

RTL mainly describes logical functionality and sequential behavior. It normally does not contain:

- Standard-cell physical coordinates
- Metal routing paths
- Via locations
- Die dimensions
- Core dimensions
- Clock-tree geometry
- Detailed power-grid structures

For example, the RTL expression `a + b` specifies an addition operation. It does not specify the exact standard cells, their drive strengths, or their physical locations.

## 2. Logic Synthesis

Logic synthesis converts RTL into a gate-level representation using cells from a standard-cell library.

Its main responsibilities include:

- Reading and elaborating the RTL
- Applying timing and design constraints
- Optimizing Boolean and sequential logic
- Mapping logic operations to available standard cells
- Producing a gate-level netlist

A simplified transformation is:

    RTL description:
    y = a AND b

    After synthesis:
    AND2_X1 U1

In this example:

`AND2_X1`

The standard-cell type selected from the library. `AND2` indicates a two-input AND gate, while `X1` usually indicates a drive-strength option.

`U1`

The instance name of this particular cell in the design.

Synthesis determines which types of cells are used and how they are logically connected. It normally does not assign their final physical coordinates.

## 3. Gate-Level Netlist

A gate-level netlist is a structural representation of the synthesized design.

It primarily contains:

- Module ports
- Standard-cell instances
- Instance pins
- Nets connecting the instances
- Hierarchical module connections

The netlist answers two main questions:

1. Which cell instances exist in the design?
2. How are those instances logically connected?

For example:

    AND2_X1 U1
    INV_X1  U2
    DFF_X1  U3

The netlist may specify that the output of `U1` connects to the input of `U2`, but it does not normally specify where `U1` and `U2` are physically placed.

A useful distinction is:

RTL

Describes the intended logical and sequential behavior.

Gate-Level Netlist

Describes standard-cell instances and their logical connectivity.

Physical Layout

Describes instance locations, metal geometries, vias, and fabrication-layer shapes.

## 4. Floorplanning

Floorplanning defines the overall physical organization of the chip before individual standard-cell instances are placed.

Its main responsibilities include:

- Defining the die boundary
- Defining the core area
- Placing large macros
- Planning I/O pin locations
- Reserving space for standard-cell placement
- Preparing space for the power distribution network
- Estimating routing congestion and connectivity

The die boundary represents the full physical area of the chip.

The core area is the internal region where standard cells, macros, clock structures, and routing resources are mainly implemented.

A simplified view is:

    +-----------------------------------+
    |             Die Area              |
    |                                   |
    |   +---------------------------+   |
    |   |         Core Area         |   |
    |   |                           |   |
    |   |   Macro        Macro      |   |
    |   |                           |   |
    |   |  Standard-Cell Region     |   |
    |   |                           |   |
    |   +---------------------------+   |
    |                                   |
    +-----------------------------------+

Floorplanning does not normally assign the final coordinates of every small standard-cell instance. Instead, it determines the large-scale physical structure and creates the conditions for successful placement and routing.

A poor floorplan can cause:

- Long interconnects
- Routing congestion
- Timing degradation
- Difficult power delivery
- Poor utilization
- Limited space for clock and signal routing

A useful distinction is:

Floorplanning

Defines regions, boundaries, macro locations, and overall physical organization.

Placement

Assigns specific coordinates to individual standard-cell instances.

## 5. Power Planning

Power planning creates the physical network that distributes power and ground throughout the chip.

The power network is commonly called the Power Distribution Network, or PDN.

Its main signals are:

`VDD`

The power-supply network.

`VSS` or `GND`

The ground and current-return network.

A simplified power-delivery structure is:

    Power Pads
        ↓
    Power Ring
        ↓
    Power Stripes
        ↓
    Standard-Cell Power Rails
        ↓
    Individual Cell Instances

Common physical structures include:

- Power rings around the core
- Vertical and horizontal power stripes
- Standard-cell power rails
- Vias connecting power across metal layers
- Connections from pads or bumps to the internal power grid

The main goal is to provide all instances with stable, low-resistance VDD and VSS connections.

Power networks have electrical resistance. When current flows through them, voltage drop occurs:

    Vdrop = I × R

This effect is called IR drop.

Excessive IR drop can reduce the voltage available to standard cells. Lower supply voltage can weaken transistor drive strength and increase cell delay, which may lead to timing violations or functional instability.

Power planning must therefore consider:

- Current demand
- Metal width
- Number of power stripes
- Via count
- Power-network resistance
- IR drop
- Electromigration risk

Power planning does not determine the logical function of the circuit. It ensures that the physical implementation can receive reliable power during operation.

## 6. Placement

Placement assigns physical coordinates to the standard-cell instances created during logic synthesis.

The gate-level netlist already defines:

- Which instances exist
- Which pins belong to each instance
- How the instances are logically connected

Placement determines where each instance is physically located inside the core area.

For example:

    AND2_X1 U1 → (120, 80)
    INV_X1  U2 → (145, 80)
    DFF_X1  U3 → (190, 100)

Here, `U1`, `U2`, and `U3` are specific cell instances. Placement assigns coordinates to these instances rather than to the abstract cell types.

The main objectives of placement include:

- Reducing wirelength
- Improving timing
- Reducing routing congestion
- Maintaining legal cell locations
- Meeting utilization targets
- Leaving sufficient routing resources
- Supporting later clock-tree and routing stages

### Global Placement

Global placement determines approximate locations for standard-cell instances.

At this stage, cells may overlap or may not yet satisfy all placement rules. The objective is to find a placement that provides reasonable wirelength, timing, and congestion.

### Legalization

Legalization moves cells to valid placement sites and removes overlaps.

After legalization:

- Cells are aligned to legal standard-cell rows
- Cells do not overlap
- Placement rules are satisfied
- The design preserves the intended logical connectivity

### Detailed Placement

Detailed placement performs smaller local adjustments to improve:

- Timing
- Wirelength
- Congestion
- Cell spacing
- Local placement quality

Placement strongly affects timing because physical distance affects interconnect parasitics.

A simplified relationship is:

    Longer distance
        ↓
    Longer routing wire
        ↓
    Larger parasitic resistance and capacitance
        ↓
    Larger interconnect delay
        ↓
    Possible timing violation

The same gate-level netlist can therefore produce different timing results under different placement solutions.

Placement does not change the intended logical function of the design. It changes the physical implementation and can significantly affect power, performance, and area.

## 7. Clock Tree Synthesis

Clock Tree Synthesis, or CTS, builds the physical clock-distribution network after standard-cell placement.

The clock signal must reach a large number of sequential elements, such as:

- Flip-flops
- Registers
- Memory clock pins
- Clock-gating cells

Directly connecting one clock source to all sequential elements would create:

- Very high fanout
- Large capacitive load
- Slow clock transitions
- Large differences in clock arrival time

CTS inserts clock buffers and constructs a hierarchical clock tree.

A simplified clock tree is:

              Clock Source
                    |
              Clock Buffer
               /          \
          Buffer          Buffer
          /   \            /   \
        FF1   FF2         FF3   FF4

The main goals of CTS include:

- Controlling clock skew
- Controlling clock latency
- Reducing clock fanout per driver
- Improving clock transition time
- Building a reliable clock-distribution network

### Clock Skew

Clock skew is the difference in clock arrival time between two sequential elements.

For example:

    Clock arrival at FF1 = 1.0 ns
    Clock arrival at FF2 = 1.3 ns

    Clock skew = 0.3 ns

CTS attempts to control and reduce clock skew, but it normally cannot make every clock arrival time exactly identical.

### Clock Latency

Clock latency is the propagation time from the clock source to the clock pin of a sequential element.

For example:

    Clock source
        ↓
    Clock buffers
        ↓
    Clock routing
        ↓
    Register clock pin

The total delay along this path contributes to clock latency.

### Clock Buffers

Clock buffers are inserted to:

- Drive large clock loads
- Divide high fanout across multiple branches
- Improve rise and fall times
- Balance clock-path delays
- Control skew and latency

CTS creates new physical clock paths that did not exist as detailed geometry in the original RTL.

After CTS, timing analysis must include both:

- Data-path delay
- Clock-path delay

CTS is therefore closely connected to setup timing, hold timing, clock skew, and timing closure.

## 8. Routing

Routing creates the physical interconnections between placed cell pins according to the connectivity defined in the gate-level netlist.

The netlist may specify a logical connection such as:

    U1/Y → U2/A

Routing determines how that connection is physically implemented using:

- Metal layers
- Routing tracks
- Vias
- Wire segments
- Layer transitions

A simplified routed connection is:

    U1/Y
      |
    Metal 1
      |
     Via
      |
    Metal 2
      |
    U2/A

Metal wires mainly provide horizontal or vertical interconnection within a routing layer.

Vias provide vertical connections between different metal layers.

Both wires and vias contribute parasitic resistance and capacitance, so they affect interconnect delay.

### Global Routing

Global routing determines the approximate regions through which each net should travel.

Its main goals include:

- Estimating routing demand
- Identifying congested regions
- Estimating wirelength
- Assigning general routing resources
- Planning connections across the chip

Global routing does not normally determine the exact track and via location for every wire.

### Detailed Routing

Detailed routing creates the exact physical geometry of the interconnects.

It determines:

- Exact routing tracks
- Exact metal-layer assignments
- Exact via locations
- Wire width and spacing
- Pin-access connections
- Rule-compliant turns and layer transitions

Detailed routing must satisfy manufacturing design rules while preserving the connectivity required by the netlist.

### Routing Congestion

Routing congestion occurs when too many nets compete for limited routing resources in the same region.

High congestion can cause:

- Longer detoured wires
- More vias
- Larger interconnect delay
- Additional DRC violations
- Difficulty completing all connections
- Timing degradation

Placement and floorplanning strongly affect routing congestion because they determine where cells, macros, and pins are located.

### Routing and Timing

Physical wires and vias introduce parasitic effects.

A simplified relationship is:

    Longer wire
        ↓
    Larger wire resistance and capacitance
        ↓
    Larger interconnect delay

More layer transitions may also require more vias:

    More vias
        ↓
    Additional via resistance
        ↓
    Larger interconnect delay

Wire and via effects are both generally included in interconnect parasitics.

Therefore:

    Path Delay
    = Cell Delay + Interconnect Delay

Routing does not change the intended logical connectivity, but it determines the physical paths that implement that connectivity.

## 9. Static Timing Analysis

Static Timing Analysis, or STA, checks whether signals arrive within the required timing limits.

STA does not primarily verify whether the logical result is correct. It verifies whether the result arrives at the correct time.

A typical register-to-register timing path is:

    Launch Register
          ↓
    Clock-to-Q Delay
          ↓
    Combinational Logic
          ↓
    Interconnect Delay
          ↓
    Capture Register

STA analyzes timing information from:

- The gate-level netlist
- Standard-cell timing libraries
- Clock definitions
- Timing constraints
- Input and output constraints
- Extracted interconnect parasitics
- Clock-tree information

### Cell Delay

Cell delay is the delay through standard cells such as:

- AND gates
- Multiplexers
- Buffers
- Inverters
- Adders
- Flip-flops

Cell delay depends on factors such as:

- Cell type
- Drive strength
- Input transition
- Output load
- Supply voltage
- Process and temperature conditions

### Interconnect Delay

Interconnect delay is caused by the physical wires and vias between cell pins.

It depends on:

- Wire length
- Wire width
- Metal layer
- Parasitic resistance
- Parasitic capacitance
- Via count
- Coupling with nearby wires

Placement and routing therefore directly affect STA results.

### Setup Timing

Setup timing checks whether data arrives early enough before the capture clock edge.

A setup violation means that the data arrives too late for the capture register to reliably store it.

Possible causes include:

- Excessive combinational delay
- Long routing paths
- Weak cell drive strength
- Large fanout
- Large clock uncertainty
- Unfavorable clock skew

### Hold Timing

Hold timing checks whether data remains stable long enough after the capture clock edge.

A hold violation usually means that the new data arrives too early at the capture register.

Possible causes include:

- Very short data paths
- Strong cells
- Small interconnect delay
- Unfavorable clock skew

### Static Analysis

STA is called static because it does not require simulation of every possible input pattern.

Instead, it analyzes valid timing paths using timing models and constraints.

A useful distinction is:

RTL Simulation

Checks functional behavior for applied test cases.

Static Timing Analysis

Checks whether relevant timing paths satisfy setup, hold, and other timing requirements.

A design may pass functional simulation but still fail STA.

Similarly, a design may be logically correct but unable to operate at the target clock frequency.

## 10. DRC and LVS

After physical implementation, the layout must be checked for manufacturability and logical correctness.

Two important physical-verification checks are:

- Design Rule Check, or DRC
- Layout Versus Schematic, or LVS

These checks answer different questions.

DRC asks:

    Can this layout be manufactured using the target process?

LVS asks:

    Does this layout implement the intended circuit?

### Design Rule Check

Design Rule Check verifies whether the physical geometries in the layout satisfy the manufacturing rules provided by the foundry.

Typical DRC rules include:

- Minimum metal width
- Minimum metal spacing
- Minimum via size
- Minimum via enclosure
- Required layer overlap
- Minimum area
- Density requirements
- Well and implant spacing
- Antenna-related rules

For example:

    Required Metal 1 spacing = 0.10 µm
    Actual Metal 1 spacing   = 0.06 µm

This condition produces a DRC violation.

Design rules exist because semiconductor manufacturing has physical limitations and process variation.

If two wires are placed too close together, fabrication variation may cause:

- Metal bridging
- Short circuits
- Reduced yield
- Reliability problems

If a wire is too narrow, it may experience:

- High resistance
- Electromigration risk
- Manufacturing failure

DRC mainly checks geometric compliance. It does not prove that the circuit connectivity is logically correct.

### Layout Versus Schematic

Layout Versus Schematic checks whether the circuit extracted from the physical layout matches the intended schematic or reference netlist.

A simplified comparison is:

    Reference Netlist
            ↕
    Extracted Layout Netlist

LVS checks items such as:

- Device or cell count
- Device types
- Pin names
- Net connectivity
- Missing connections
- Extra connections
- Opens
- Shorts

An open means that a required electrical connection is missing.

A short means that two nets that should be separate are electrically connected.

For example, the reference netlist may require:

    U1/Y → U2/A

If the layout instead connects:

    U1/Y → U3/A

the design may still satisfy all width and spacing rules, so DRC may pass. However, LVS will fail because the extracted connectivity does not match the intended design.

### DRC and LVS Are Independent

A design can pass DRC but fail LVS.

Example:

- All metal widths and spacing rules are satisfied
- One signal is connected to the wrong pin

Result:

    DRC: Pass
    LVS: Fail

A design can also pass LVS but fail DRC.

Example:

- All logical connections are correct
- One metal wire is narrower than the allowed minimum

Result:

    LVS: Pass
    DRC: Fail

Therefore:

DRC

Checks manufacturability and geometric rule compliance.

LVS

Checks whether the physical layout matches the intended circuit connectivity.

Passing both checks is necessary before tape-out, but additional signoff checks are also required.

## 11. GDSII and Tape-out

GDSII stands for Graphic Data System II.

It is a standard file format used to represent the physical geometry and hierarchy of an integrated-circuit layout.

GDSII contains layout information such as:

- Geometric shapes
- Polygons
- Layer numbers
- Cell boundaries
- Instance locations
- Metal shapes
- Via shapes
- Pin shapes
- Layout hierarchy

A simplified view is:

    GDSII
    ├── Layer geometries
    ├── Standard-cell layouts
    ├── Instance coordinates
    ├── Metal routing
    ├── Vias
    └── Chip hierarchy

Unlike a gate-level netlist, GDSII represents physical geometry rather than only logical connectivity.

A useful distinction is:

Gate-Level Netlist

Describes cell instances and logical connections.

GDSII

Describes the physical geometry used to implement those instances and connections.

### Physical Layers

The final layout contains shapes associated with fabrication layers, such as:

- Active regions
- Gate-related layers
- Contacts
- Metal layers
- Via layers
- Well and implant layers
- Pin and boundary layers

The foundry does not receive instructions such as:

    Place an AND gate here.

Instead, the final design contains the geometric shapes required to fabricate the structures that implement the logic.

Standard-cell layout views provide the physical geometries for library cells. The physical-design flow places these cells and adds routing shapes between them.

### Tape-out

Tape-out is the process of submitting the final, signoff-complete design to the foundry for manufacturing.

The term comes from older design flows in which layout data was transferred using magnetic tape. Modern flows use digital file transfer, but the term remains standard in the semiconductor industry.

Before tape-out, the design must complete signoff checks such as:

- Static timing analysis
- DRC
- LVS
- Power-integrity analysis
- IR-drop analysis
- Electromigration analysis
- Signal-integrity checks
- Reliability checks

A design should not be taped out if it still contains:

- Setup violations
- Hold violations
- DRC violations
- LVS mismatches
- Severe IR-drop problems
- Electromigration violations

The simplified final stage is:

    Routed Layout
          ↓
    Timing and Physical Signoff
          ↓
    Final GDSII
          ↓
    Tape-out
          ↓
    Foundry Manufacturing

Tape-out does not mean that manufacturing is already complete.

It means that the design team has finalized the design data and formally submitted it for fabrication.