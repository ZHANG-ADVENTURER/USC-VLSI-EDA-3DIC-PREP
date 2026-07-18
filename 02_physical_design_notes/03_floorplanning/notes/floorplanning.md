# Floorplanning

## Overview

Floorplanning is the first major physical-design stage after logic synthesis.

After synthesis, the design is represented by a gate-level netlist containing standard-cell instances and connectivity. However, the netlist does not normally define the final physical coordinates of those cells.

Floorplanning converts this logical connectivity into an initial physical organization.

A simplified flow is:

```text
RTL
↓
Logic Synthesis
↓
Gate-Level Netlist
↓
Floorplanning
↓
Placement
↓
Clock Tree Synthesis
↓
Routing
↓
STA / Signoff
```

The goal of floorplanning is not simply to make the chip as small as possible.

A good floorplan must provide a physically feasible starting point for:

* standard-cell placement
* routing
* clock-tree synthesis
* timing closure
* power distribution

---

# 1. Gate-Level Netlist vs Physical Layout

A gate-level netlist describes:

* standard-cell types
* instance names
* internal nets
* module ports
* pin connections
* logical connectivity

For example:

```text
NAND2_X1 U1
INV_X2   U2
DFF_X1   U3
```

The netlist may describe:

```text
U1.Y → U2.A
U2.Y → U3.D
```

However, it normally does not contain the final:

* x/y coordinates
* routing paths
* metal-layer assignments
* via locations
* exact wire lengths
* extracted parasitic R/C

Therefore:

```text
Netlist
= What cells exist
+ How they are connected

Physical Layout
= Where cells are located
+ How they are physically connected
```

Floorplanning begins the transition from logical connectivity to physical implementation.

---

# 2. Floorplanning vs Placement

Floorplanning determines the large-scale physical organization of the design.

It typically considers:

* die boundary
* core area
* aspect ratio
* utilization
* macro placement
* macro orientation
* I/O and pin planning
* channels
* halos
* blockages
* space and structure needed for power planning

Placement comes later and mainly determines the physical locations of individual standard-cell instances.

Therefore:

```text
Floorplanning
= Large-scale physical organization

Placement
= Detailed positioning of standard cells
```

An important distinction is:

```text
Macro placement
→ Often part of floorplanning

Standard-cell placement
→ Main task of the placement stage
```

---

# 3. Die Area and Core Area

## Die Area

The die area represents the overall physical boundary of the silicon die.

It may contain:

* core area
* I/O-related structures
* power structures
* edge spacing
* other physical structures

---

## Core Area

The core area is the main internal region used for:

* standard cells
* macros
* internal signal routing
* power-distribution structures

The relationship can be visualized as:

```text
+--------------------------------------+
|              Die Area                |
|                                      |
|    +----------------------------+    |
|    |         Core Area          |    |
|    |                            |    |
|    +----------------------------+    |
|                                      |
+--------------------------------------+
```

Therefore:

```text
Core Area ⊂ Die Area
```

The core area is normally smaller than the overall die area.

---

# 4. Core Margin

Core margin is the reserved space between the core boundary and the die boundary.

It should not be understood as space that exists only to prevent the two boundaries from overlapping.

Core margin can provide space or geometric conditions for:

* power rings
* I/O-related structures
* routing resources
* required physical spacing
* other chip-edge structures

Simplified view:

```text
Die Boundary
     ↓
[ Core Margin ]
     ↓
Core Boundary
```

Therefore:

```text
Core Margin
= Reserved physical region between die and core
```

---

# 5. Standard Cells and Macros

## Standard Cells

Standard cells are relatively small logic elements provided by a technology library.

Examples include:

* INV
* NAND
* NOR
* MUX
* DFF
* Buffer

Examples of actual library cells may include:

```text
INV_X1
NAND2_X2
DFF_X1
BUF_X4
```

Standard cells usually:

* follow a standard row structure
* exist in large quantities
* are relatively small
* are placed automatically during placement

---

## Macros

Macros are much larger functional blocks.

Examples include:

* SRAM
* ROM
* PLL
* analog IP
* pre-designed accelerator blocks

A hard macro usually has a predefined:

* width
* height
* internal layout
* pin locations
* routing restrictions

Because macros are large and relatively inflexible, their positions are usually considered early during floorplanning.

---

# 6. Aspect Ratio

Aspect ratio describes the shape of the core.

A simplified definition can be expressed as:

```text
Aspect Ratio ≈ Height / Width
```

The exact convention can depend on the EDA tool.

A core may be:

* approximately square
* horizontally elongated
* vertically elongated

Core shape matters because an extreme aspect ratio may increase:

* wirelength
* routing difficulty
* clock-distribution complexity
* timing difficulty
* power-distribution difficulty

Therefore:

```text
Enough area
≠
Automatically good floorplan
```

The shape of that area also matters.

---

# 7. Utilization

Utilization describes how much of the available placement area is occupied by standard cells.

For example:

```text
Available placement area = 100 units
Standard-cell area        = 70 units

Utilization ≈ 70%
```

High utilization may reduce core area, but it can also reduce available physical flexibility.

Potential consequences of excessive utilization include:

* routing congestion
* difficult legalization
* difficult buffer insertion
* reduced timing-optimization space
* difficult hold fixing
* increased routing detours

Therefore:

```text
High Utilization
→ Density ↑
→ Congestion Risk ↑
```

However, extremely low utilization is also not always desirable because it may increase:

* core area
* die area
* cost
* average wirelength
* power
* delay

Therefore:

```text
Utilization is a tradeoff
between

Area
Routability
Timing
Power
```

Utilization is not simply:

```text
Higher = Better
```

or:

```text
Lower = Better
```

---

# 8. Macro Placement

Macro placement is one of the most important tasks in floorplanning.

The physical positions of macros should consider:

* logical connectivity
* timing-critical relationships
* routing demand
* pin locations
* power delivery
* macro shapes

---

## Connectivity-Aware Placement

If two macros communicate through many nets, placing them very far apart may cause:

```text
Distance ↑
↓
Wirelength ↑
↓
Parasitic R/C ↑
↓
Interconnect Delay ↑
```

Therefore, strongly connected blocks are often placed relatively close when other constraints allow.

However:

```text
Closer
≠
Always Better
```

Macros placed too close may leave insufficient routing space.

Therefore macro placement requires a tradeoff between:

```text
Physical Proximity
and
Routability
```

---

# 9. Macro Placement Near the Core Boundary

Large macros are often placed near the core boundary because placing a large macro directly in the middle of the core may block:

* standard-cell placement
* routing paths
* routing resources

However:

```text
Macros must always be placed at the boundary
```

is incorrect.

Macro placement must still consider:

* connectivity
* timing
* routing
* pin accessibility
* power delivery

A macro may need a more central position if that produces a better overall physical design.

Therefore:

```text
Macro Placement
= Connectivity-aware
+ Congestion-aware
+ Timing-aware
+ Routability-aware
```

---

# 10. Macro Orientation

Macro placement includes not only location but also orientation.

Possible orientations may include:

```text
R0
R90
R180
MX
MY
```

The detailed legal orientations depend on the macro and design rules.

Changing orientation changes the physical location of macro pins.

Therefore:

```text
Macro Orientation
↓
Pin Locations Change
↓
Wirelength / Pin Access / Congestion Change
```

A rotation or mirror operation may either improve or worsen routing.

Macro orientation should therefore consider which side of the macro communicates with surrounding logic.

---

# 11. Channel

A channel is a reserved space between macros or large physical structures.

Example:

```text
+----------+          +----------+
| Macro A  |          | Macro B  |
|          |          |          |
+----------+          +----------+
       ↑
   Routing Channel
```

Channels can provide space for:

* signal routing
* power routing
* pin access

If macros are placed too close together:

```text
Channel Width ↓
↓
Routing Capacity ↓
↓
Pin Access Difficulty ↑
↓
Congestion Risk ↑
```

However, an excessively large channel may waste area and increase wirelength.

Therefore channel width is also a physical-design tradeoff.

---

# 12. Halo

A halo is a reserved region surrounding a macro.

Simplified representation:

```text
..............
. +--------+ .
. | Macro  | .
. |        | .
. +--------+ .
..............
     Halo
```

A halo is often used to prevent standard cells from being placed too close to a macro.

Macro boundaries may contain:

* many pins
* complex signal routing
* power connections
* high routing demand

Without enough spacing, standard cells may crowd the macro boundary and make routing difficult.

Therefore:

```text
Halo
= Reserved placement buffer zone around a macro
```

---

# 13. Blockage

A blockage is a physical constraint that restricts tool usage in a specific region.

Blockages are not all the same.

## Placement Blockage

A placement blockage restricts or prevents standard cells or instances from being placed in a region.

Possible uses include:

* macro surroundings
* reserved routing areas
* high-congestion regions
* special physical structures

---

## Routing Blockage

A routing blockage restricts routing in a region, often on specified metal layers.

Therefore:

```text
Blockage
= Physical-region restriction
```

It should not simply be defined as:

```text
No cells and no wires allowed
```

because the exact restriction depends on the blockage type.

---

# 14. Channel vs Halo vs Blockage

## Channel

Space intentionally left between macros or large structures to support routing and pin access.

## Halo

Reserved buffer region surrounding a macro, mainly to keep standard-cell placement away from the macro boundary.

## Blockage

A tool constraint that restricts placement or routing in a defined region.

Memory rule:

```text
Channel
= Space between structures

Halo
= Buffer around a macro

Blockage
= Explicit physical restriction
```

---

# 15. RTL Ports vs Physical Pins

An RTL module may contain:

```verilog
module top (
    input clk,
    input reset,
    input [7:0] data_in,
    output [7:0] data_out
);
```

These are logical ports.

RTL does not normally specify:

* x/y coordinates
* chip side
* metal-layer geometry
* physical pin shape

Therefore:

```text
RTL Port
= Logical interface

Physical Pin
= Physical location and geometry used for implementation
```

Macro orientations such as R90 or R180 are a separate physical-design concept and are not defined by an RTL port declaration.

---

# 16. Pin Planning

Pin planning determines appropriate physical positions for design pins.

Pin locations should consider:

* internal connectivity
* routing demand
* pin density
* nearby macros
* timing-critical paths

For example, if an input bus mainly connects to a macro on the left side of the core but its physical pins are placed on the far right side, the design may experience:

```text
Wirelength ↑
Routing Demand ↑
Delay ↑
Congestion Risk ↑
```

Therefore:

```text
Logical Connectivity
should influence
Physical Pin Location
```

---

# 17. Pin Density

Placing too many pins in a small region can create a routing bottleneck.

Conceptually:

```text
Many Nets
↓
Small Physical Entry Region
↓
Routing Demand Concentrated
↓
Congestion
```

Pin planning should therefore consider both connectivity and available routing capacity.

---

# 18. Core Margin and Power Planning

All standard cells and macros require power connections such as:

```text
VDD
VSS / GND
```

The power network cannot rely on a single thin wire.

A simplified Power Distribution Network, or PDN, may contain:

```text
External Power
↓
Power Ring
↓
Power Stripes / Mesh
↓
Standard-Cell Power Rails
↓
Individual Cells
```

---

# 19. Power Ring

A power ring is a relatively wide power-distribution structure surrounding the core or major design regions.

It commonly distributes:

```text
VDD
VSS
```

around the design.

Power rings can be considered major power-distribution trunks.

---

# 20. Power Stripes and Mesh

A power ring alone may not efficiently deliver power to cells deep inside the core.

Therefore, the design may use:

```text
Power Stripes
or
Power Mesh
```

to distribute power across the core.

The simplified hierarchy is:

```text
Power Ring
↓
Power Stripes / Mesh
↓
Standard-Cell Rails
↓
Cells
```

---

# 21. Floorplanning vs Power Planning

Floorplanning and power planning may appear as separate stages in an RTL-to-GDS flow:

```text
Floorplanning
↓
Power Planning
↓
Placement
```

However, floorplanning must already consider the physical requirements of the power network.

The power network requires:

* metal resources
* physical space
* vias
* macro power connections

Therefore:

```text
Floorplanning
→ Creates suitable physical conditions for the PDN

Power Planning
→ Builds the detailed VDD/VSS distribution network
```

Power cannot be treated as something that is considered only after placement and routing are complete.

---

# 22. IR Drop

Power-distribution metals have electrical resistance.

When current flows through the PDN:

```text
Vdrop = I × R
```

a voltage drop may occur.

For example:

```text
Ideal VDD = 1.0 V

PDN resistance causes voltage loss

Local cell voltage = 0.95 V
```

A lower local supply voltage may cause:

```text
Drive Strength ↓
↓
Cell Delay ↑
↓
Timing May Worsen
```

Therefore PDN quality can directly influence timing.

---

# 23. Electromigration

Electromigration, or EM, is a reliability concern associated with excessive current density in metal interconnects.

If too much current flows through a narrow metal structure:

```text
Current Density ↑
↓
Reliability Risk ↑
```

Power networks therefore require:

* sufficient metal width
* sufficient vias
* appropriate current distribution

This is another reason power planning must be considered early.

---

# 24. Routability

Routability describes whether the required nets can be physically routed in a practical and legal way.

A floorplan may have enough area to contain every cell but still have poor routability.

Therefore:

```text
Enough Placement Area
≠
Enough Routing Capacity
```

Poor routability may result from:

* excessive utilization
* bad macro placement
* narrow channels
* concentrated pins
* large routing blockages
* poor connectivity-aware planning

---

# 25. Routing Congestion

Routing congestion occurs when routing demand approaches or exceeds available routing capacity in a region.

Conceptually:

```text
Routing Demand > Routing Capacity
→ Congestion
```

Possible causes include:

* high utilization
* narrow macro channels
* excessive pin density
* badly placed macros
* many nets crossing the same region

High utilization increases congestion risk but does not automatically guarantee congestion.

Congestion depends on the entire physical topology.

---

# 26. Congestion and Timing

When a direct route is unavailable because of congestion, the router may create a detour.

Conceptually:

```text
Congestion
↓
Routing Detour
↓
Wirelength ↑
↓
Wire Resistance ↑
Wire Capacitance ↑
↓
Interconnect Delay ↑
↓
Timing May Worsen
```

Therefore floorplanning directly affects later timing closure.

---

# 27. Floorplanning and Placement Difficulty

A poor floorplan may also create difficulties during placement.

Examples include:

* insufficient standard-cell area
* fragmented placement regions
* high utilization
* poorly positioned macros
* inadequate optimization space

This can make it harder to:

* legalize cells
* insert buffers
* fix timing
* repair hold violations
* reduce congestion

Therefore:

```text
Poor Floorplan
↓
Placement Difficulty
↓
Routing Difficulty
↓
Timing Closure Difficulty
```

---

# 28. Floorplanning and PPA

Floorplanning affects:

```text
Power
Performance
Area
```

or:

```text
PPA
```

Examples:

## Area

Higher utilization may reduce core area but increase congestion risk.

## Performance

Poor macro placement and routing detours can increase wire delay.

## Power

Longer wires and extra buffers may increase switching power and total cell count.

Therefore floorplanning is already a PPA optimization problem.

---

# 29. What Makes a Good Floorplan?

A good floorplan should consider:

1. Reasonable utilization

2. Appropriate aspect ratio

3. Connectivity-aware macro placement

4. Suitable macro orientation

5. Sufficient channels

6. Appropriate halos and blockages

7. Connectivity-aware pin planning

8. Manageable pin density

9. Reasonable conditions for power distribution

10. Low routing-congestion risk

11. Limited unnecessary long connections

12. Enough flexibility for later optimization

A good floorplan is not simply the smallest floorplan.

It should provide a physically feasible starting point for:

```text
Placement
Routing
CTS
Timing Closure
Power Delivery
```

---

# 30. Complete Floorplanning Flow

A simplified conceptual sequence is:

```text
Gate-Level Netlist
│
├─ Standard-cell instances
├─ Macros
└─ Connectivity
        ↓

Define Die and Core
        ↓

Choose Aspect Ratio
and Utilization
        ↓

Place and Orient Macros
        ↓

Plan Channels
Halos
Blockages
        ↓

Plan I/O and Pins
        ↓

Consider Power-Distribution Requirements
        ↓

Evaluate
Placement Feasibility
Routing Congestion
Timing Risk
Power Feasibility
        ↓

Proceed to Detailed Placement
```

---

# Key Differences

## Netlist vs Floorplan

Netlist describes logical connectivity.

Floorplan creates the initial physical organization.

---

## Floorplanning vs Placement

Floorplanning decides large-scale physical structure.

Placement mainly determines detailed standard-cell locations.

---

## Die Area vs Core Area

Die area is the entire silicon boundary.

Core area is the main internal implementation region.

---

## Standard Cell vs Macro

Standard cells are small library-based logic elements placed in rows.

Macros are larger, less flexible physical blocks such as SRAM.

---

## Channel vs Halo

Channel is space between macros or major structures.

Halo is reserved spacing around a macro.

---

## Placement Blockage vs Routing Blockage

Placement blockage restricts instance placement.

Routing blockage restricts routing, often on selected metal layers.

---

## RTL Port vs Physical Pin

RTL port defines logical connectivity.

Physical pin defines implementation location and geometry.

---

# Final Checklist

After studying floorplanning, I should be able to explain:

* Why a gate-level netlist is not yet a physical layout
* The difference between floorplanning and placement
* Die area and core area
* Core margin
* Aspect ratio
* Utilization
* Standard cells and macros
* Connectivity-aware macro placement
* Macro orientation
* Channels
* Halos
* Placement and routing blockages
* RTL ports vs physical pins
* Pin planning
* Pin density
* Power ring
* Power stripes and mesh
* IR drop
* Electromigration
* Routability
* Routing congestion
* Routing detours
* Why floorplanning affects timing and PPA

---

# One-Sentence Summary

Floorplanning transforms the synthesized design into an initial physical organization by defining the die/core structure, utilization, macro and pin organization, routing space, and power-planning conditions so that later placement, routing, timing closure, and power delivery can be successfully completed.
