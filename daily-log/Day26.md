# Day 26 Daily Log

## Topic

Floorplanning

## What I Learned

Today I studied floorplanning, the first major physical-design stage after logic synthesis.

I learned that a synthesized gate-level netlist contains standard-cell instances and logical connectivity, but it does not normally contain the final physical coordinates, routing paths, or extracted parasitics.

Floorplanning establishes the initial large-scale physical organization of the chip before detailed standard-cell placement.

I learned the differences among die area, core area, and core margin, as well as how aspect ratio and utilization affect physical-design feasibility.

I also studied the differences between standard cells and macros and learned why macro placement must consider connectivity, routing demand, timing, pin locations, and available routing space.

Important floorplanning structures and constraints include channels, halos, placement blockages, and routing blockages.

I also learned that RTL ports only define logical interfaces, while physical pins require actual locations and geometry. Pin placement should therefore consider internal connectivity and routing capacity.

Finally, I learned how floorplanning must provide suitable conditions for power planning and how poor floorplanning can cause congestion, routing detours, increased parasitic resistance and capacitance, timing degradation, and more difficult PPA optimization.

## What I Built / Produced

* `02_physical_design_notes/03_floorplanning/notes/floorplanning.md`
* `02_physical_design_notes/03_floorplanning/README.md`
* Floorplanning concept diagrams and physical-design sketches
* A structured understanding of floorplanning tradeoffs and their effect on downstream Physical Design stages

## Key Concepts

### Gate-Level Netlist

A gate-level netlist describes standard-cell instances and logical connectivity but normally does not contain final physical coordinates or routing information.

### Floorplanning

Floorplanning defines the large-scale physical organization of a design before detailed placement.

### Die Area

The complete physical boundary of the silicon die.

### Core Area

The main internal region used for standard cells, macros, routing, and related physical structures.

### Core Margin

The reserved region between the die boundary and core boundary that can support power structures, routing resources, I/O-related structures, and required physical spacing.

### Aspect Ratio

The shape proportion of the core.

An extreme aspect ratio may increase wirelength, routing difficulty, timing difficulty, and power-distribution complexity.

### Utilization

The fraction of available placement area occupied by standard cells.

Very high utilization may increase congestion and reduce optimization flexibility, while very low utilization may increase area and wirelength.

### Standard Cell

A small library-based logic element such as an inverter, NAND gate, buffer, or flip-flop.

### Macro

A large physical block such as SRAM, ROM, PLL, analog IP, or another pre-designed block.

Macros usually have predefined dimensions, layout, and pin locations.

### Macro Placement

Macro placement determines where large blocks should be located based on connectivity, routing, timing, power, and physical constraints.

### Macro Orientation

Rotation or mirroring changes the physical positions of macro pins and can improve or worsen routing.

### Channel

A reserved space between macros or large structures that supports routing and pin access.

### Halo

A reserved buffer region around a macro that prevents standard cells from being placed too close to the macro boundary.

### Placement Blockage

A physical constraint that restricts or prevents instance placement in a defined region.

### Routing Blockage

A physical constraint that restricts routing in a defined region or on selected routing layers.

### RTL Port

A logical input or output defined in RTL.

It does not specify final physical location or geometry.

### Physical Pin

A physical implementation of a logical interface with an actual location and geometric representation.

### Pin Planning

The process of assigning physical pin locations based on connectivity, routing capacity, pin density, and timing requirements.

### Power Ring

A major VDD/VSS distribution structure placed around the core or important physical regions.

### Power Stripes / Mesh

Internal power-distribution structures that carry VDD and VSS deeper into the core.

### IR Drop

Voltage loss caused by current flowing through the resistance of the power-distribution network.

IR drop may reduce local supply voltage and increase cell delay.

### Electromigration

A reliability problem caused by excessive current density in metal interconnects.

### Routability

The ability to physically route all required nets in a practical and legal way.

### Congestion

A condition where routing demand approaches or exceeds available routing capacity.

### Routing Detour

A longer routing path caused by blocked or congested direct routing paths.

Routing detours can increase wire resistance, capacitance, and delay.

### Floorplanning Tradeoff

Floorplanning requires balancing:

* Area
* Routability
* Timing
* Power
* Connectivity
* Placement flexibility

The smallest floorplan is not automatically the best floorplan.

## Problems and Fixes

### Problem 1

I initially described core margin mainly as a space used to prevent the core boundary from overlapping the die boundary.

### Fix

Core margin is more accurately understood as reserved physical space between the core and die boundaries that supports power structures, routing, I/O-related structures, and required spacing.

---

### Problem 2

I initially connected RTL ports with orientation terms such as `R90`.

### Fix

RTL ports only define logical interfaces.

Orientation terms such as `R0`, `R90`, `R180`, `MX`, and `MY` apply to physical instances or macros and affect physical pin locations.

---

### Problem 3

I initially described blockage as a region where neither cells nor connections are allowed.

### Fix

Blockages have different types.

A placement blockage restricts instance placement, while a routing blockage restricts routing, often on selected metal layers.

---

### Problem 4

I initially described poor aspect ratio as something that might directly affect the logical function of the design.

### Fix

Aspect ratio mainly affects physical implementation quality, including wirelength, congestion, timing, clock distribution, and power delivery.

Functional correctness and physical-design quality are different concepts.

---

### Problem 5

I initially described macro placement mainly using the idea that macros should be placed close together.

### Fix

Macro placement requires a tradeoff.

Strongly connected macros should often be relatively close, but enough channel space must remain for routing and pin access.

## Connection to VLSI / EDA / 3D IC

### VLSI

Floorplanning connects synthesized logic with physical implementation by transforming logical connectivity into a physical chip organization.

### Physical Design

Floorplanning is one of the most important early Physical Design stages because it strongly affects placement, CTS, routing, timing closure, and PPA.

### EDA

EDA tools use physical constraints such as utilization, macro positions, blockages, pin locations, and power structures to optimize downstream implementation.

Understanding these constraints is necessary for interpreting and controlling an RTL-to-GDS flow.

### 3D IC

Many floorplanning ideas also extend naturally to 2.5D and 3D IC design.

Macro placement, connectivity, routing density, power delivery, and physical proximity become even more important when multiple dies, chiplets, TSVs, or interposers are involved.

My TSV and semiconductor fabrication background can help me understand why physical geometry, routing resources, manufacturability, power delivery, and layout constraints must be considered together.

## One Sentence Summary

Floorplanning defines the large-scale physical organization of a synthesized design and creates the foundation for successful placement, routing, timing closure, and power delivery.

## Next Step

Study standard-cell placement and learn how global placement, legalization, wirelength, congestion, and timing-driven placement determine the detailed physical locations of cells inside the floorplan.
