# Day 27 Daily Log

## Topic

Placement in the ASIC Physical Design Flow

## What I Learned

Today I learned how standard-cell instances are physically arranged inside the core after floorplanning.

I studied the main placement stages:

* Global placement
* Legalization
* Detailed placement
* Placement optimization
* Placement quality checks

Global placement determines an approximate overall distribution of standard cells while optimizing wirelength, timing, density, and congestion.

Legalization removes overlap and aligns cells with legal placement rows and sites.

Detailed placement performs local cell movement, swapping, and reordering while preserving legality.

I also learned that placement is not only a geometric packing problem. It is a multi-objective optimization problem involving:

* Physical legality
* Wirelength
* Timing
* Density
* Congestion
* Power
* Electrical constraints

## What I Built

I created a complete placement study module that explains:

* The role of placement in the physical design flow
* Standard-cell rows and placement sites
* Cell orientation
* Global placement
* Legalization
* Detailed placement
* Wirelength estimation
* Congestion estimation
* Timing-driven placement
* Placement optimization
* Placement result analysis

The documentation structure is:

`02_physical_design_notes/04_placement/`

with:

* `notes/placement.md`
* `README.md`

## Produced

* Complete English placement notes
* Placement project README
* Placement optimization flow summary
* HPWL calculation examples
* Congestion and routing-overflow examples
* Timing-driven placement explanations
* WNS and TNS calculation examples
* Placement quality evaluation framework

## Key Concepts

### Placement

Placement assigns physical coordinates to standard-cell instances inside the legal core area.

### Global Placement

Global placement determines the approximate distribution of cells while optimizing overall physical design quality.

Its results may temporarily contain overlap or non-grid-aligned positions.

### Placement Rows

Placement rows are horizontal regions where standard cells can be legally placed.

### Placement Sites

Placement sites are the smallest legal horizontal placement units inside a row.

### Legalization

Legalization removes overlap and moves cells onto legal rows and sites while minimizing displacement.

### Displacement

Displacement is the distance a cell moves from its global-placement location to its legal location.

### Detailed Placement

Detailed placement improves a legal placement through local movement, swapping, shifting, and cell reordering.

### Manhattan Distance

Manhattan distance is the horizontal distance plus the vertical distance between two pins.

For two pins:

`A = (x1, y1)`

`B = (x2, y2)`

the distance is:

`|x2 - x1| + |y2 - y1|`

### HPWL

HPWL stands for Half-Perimeter Wirelength.

It estimates the wirelength of a multi-pin net using:

`HPWL = (max x - min x) + (max y - min y)`

HPWL is an early estimate and does not include detailed routing detours, vias, blockages, or layer assignment.

### Placement Density

Placement density describes how much available placement area is occupied by standard cells.

High density reduces whitespace and makes later optimization more difficult.

### Routing Demand

Routing demand represents the amount of routing resource required in a region.

### Routing Capacity

Routing capacity represents the amount of routing resource available in a region.

### Routing Overflow

Routing overflow occurs when routing demand exceeds routing capacity.

`Overflow = Demand - Capacity`

when demand is greater than capacity.

### Congestion

Congestion occurs when too many nets need to use limited routing resources in the same region.

High placement density can increase congestion risk, but density and congestion are not identical.

### Cell Spreading

Cell spreading moves cells apart to reduce local density and congestion.

Its possible cost is increased wirelength and timing delay.

### Timing-Driven Placement

Timing-driven placement gives higher priority to timing-critical paths and nets.

Paths with worse slack usually receive higher optimization weight.

### Cell Delay

Cell delay is the delay through logic cells such as gates, buffers, multiplexers, and flip-flops.

### Interconnect Delay

Interconnect delay comes from wires, vias, resistance, capacitance, and routing geometry.

A timing path can be simplified as:

`Path Delay = Cell Delay + Interconnect Delay`

### Cell Sizing

Cell sizing replaces a cell with another drive-strength version of the same logical function.

Upsizing may improve drive strength and delay, but it can increase:

* Area
* Power
* Input capacitance
* Density
* Congestion risk

### Buffer Insertion

Buffer insertion helps drive long wires, large capacitance, high fanout, or slow transitions.

Its cost includes additional area, power, routing, and placement space.

### Utilization

Utilization is the ratio of occupied standard-cell area to available placement area.

High utilization means less whitespace is available for buffers, resized cells, and future optimization.

### Pre-CTS Timing

Pre-CTS timing is timing analysis performed before the real clock tree has been constructed.

The clock network is still ideal or estimated at this stage.

### WNS

WNS stands for Worst Negative Slack.

It represents the worst timing slack among all timing endpoints.

### TNS

TNS stands for Total Negative Slack.

It is the sum of all negative timing slacks.

### Placement Legality

Placement legality requires:

* No cell overlap
* Legal row alignment
* Legal site alignment
* Legal orientation
* No macro overlap
* No placement-blockage violation

### Placement Quality

Placement quality must be evaluated using multiple metrics:

* Legality
* HPWL
* Density
* Congestion
* Routing overflow
* WNS
* TNS
* Maximum transition
* Maximum capacitance
* Maximum fanout

## Problems and Fixes

### Problem 1: Confusing Congestion with Legalization

I initially treated congestion as one of the main problems solved by legalization.

#### Fix

Legalization mainly solves physical legality problems such as:

* Cell overlap
* Row alignment
* Site alignment
* Blockage violations
* Illegal orientations

Congestion is mainly addressed through placement optimization, spreading, floorplan improvement, and routing-resource management.

---

### Problem 2: Assuming Legalization Always Increases Wirelength

I initially used cell displacement alone to conclude that wirelength had increased.

#### Fix

Cell displacement does not directly determine whether wirelength increases or decreases.

The effect depends on the positions of all connected pins.

Legalization may increase or decrease local wirelength, although its main goal is to achieve legality with minimal displacement.

---

### Problem 3: Assuming High Density Always Means High Congestion

I initially connected high placement density directly with routing congestion.

#### Fix

High density increases congestion risk, but congestion depends on both routing demand and routing capacity.

A dense region with short local nets may remain routable.

A less dense narrow channel with many crossing nets may still have severe congestion.

---

### Problem 4: Assuming Minimum HPWL Means Best Timing

I initially focused too strongly on wirelength reduction.

#### Fix

Minimum total HPWL does not guarantee the best timing because:

* Critical nets may not receive enough priority
* Cell delay may remain large
* Congestion may cause routing detours
* Macro blockages may increase actual routed length
* Post-route parasitics may be worse than early estimates

Timing-driven placement must prioritize critical paths instead of treating every net equally.

---

### Problem 5: Misunderstanding High Utilization

I initially thought high utilization automatically meant that the optimization tool would insert more buffers.

#### Fix

High utilization means the existing cells occupy a large percentage of the available placement area.

The main problem is reduced whitespace.

This makes buffer insertion, legalization, cell sizing, and timing optimization more difficult.

---

### Problem 6: Using the Term “Time Buffer”

I initially referred to buffers inserted during CTS as time buffers.

#### Fix

The correct terms are:

* Clock buffer
* Clock inverter
* Clock tree
* Clock routing

CTS builds a real clock-distribution network and introduces clock latency, skew, and parasitics.

---

### Problem 7: Treating Placement Legality as a Routing Problem

I initially described overlap and blockage entry as problems that might appear during routing.

#### Fix

Cell overlap, row misalignment, site misalignment, and placement-blockage violations are placement legality problems.

Routing has its own legality and design-rule checks, but cell placement must already be legal before routing begins.

## Connection to VLSI / EDA / 3D IC

Placement is a major stage of the digital VLSI backend flow.

It transforms a logical gate-level netlist into a physical arrangement of standard cells.

EDA placement tools perform large-scale optimization using:

* Netlist connectivity
* Timing constraints
* Physical libraries
* Floorplan geometry
* Routing estimates
* Density constraints
* Congestion estimates

Placement directly affects:

* Setup timing
* Interconnect delay
* Power
* Area
* Routability
* Clock Tree Synthesis
* Post-route timing closure

For a Physical Design Engineer, placement analysis requires understanding both logical timing and physical geometry.

For EDA development, placement is an optimization problem involving algorithms for:

* Global optimization
* Legalization
* Detailed placement
* Congestion prediction
* Timing weighting
* Cell spreading
* Buffer insertion
* Cell sizing

In 3D IC systems, placement concepts remain important because logic blocks, macros, memory dies, chiplets, and inter-die connections must also be physically organized.

Poor placement near TSVs, micro-bumps, or die-to-die interfaces may create:

* Local congestion
* Long interconnect paths
* Thermal hot spots
* Power-delivery pressure
* Routing bottlenecks

The same general principle remains valid:

> Logical connectivity must be converted into a legal, timing-aware, power-aware, and routable physical structure.

## One Sentence Summary

Placement assigns legal physical locations to standard cells while balancing wirelength, timing, congestion, density, power, and future routability.

## Next Step

Study Clock Tree Synthesis, including:

* Clock tree structure
* Clock buffers
* Clock latency
* Clock skew
* Clock uncertainty
* Clock routing
* Setup and hold timing after CTS
* Post-CTS optimization
