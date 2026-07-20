# Placement

## 1. Overview

Placement is the physical design stage that assigns physical locations to standard-cell instances inside the core area.

The overall physical design flow is:

`RTL → Synthesis → Netlist → Floorplanning → Placement → CTS → Routing → STA`

Floorplanning defines the chip structure, including:

* Die area
* Core area
* Macros
* Channels
* Halos
* Placement blockages
* I/O pins
* Power planning conditions

Placement then determines where standard-cell instances should be located.

Examples of standard-cell instances include:

* Inverters
* Buffers
* NAND gates
* NOR gates
* Multiplexers
* Flip-flops

Placement mainly handles standard cells because macros are normally positioned during floorplanning.

The purpose of placement is not simply to put every cell into an empty location. The tool must optimize multiple objectives at the same time:

* Wirelength
* Timing
* Congestion
* Density
* Power
* Placement legality

Therefore, placement is a multi-objective optimization problem.

---

## 2. Placement Inputs

Typical placement inputs include:

* Gate-level netlist
* Floorplan
* Standard-cell libraries
* Macro locations
* Placement rows and sites
* Timing constraints
* Placement blockages
* Power network information
* Physical library data
* Design rules

The gate-level netlist provides logical connectivity.

The physical libraries provide information such as:

* Cell dimensions
* Pin locations
* Legal orientations
* Routing obstructions
* Placement-site requirements

Timing constraints define the required clock periods, input delays, output delays, and other timing requirements.

---

## 3. Why Cell Locations Matter

Suppose the netlist contains:

`U1 → U2 → U3`

If the cells are placed far apart, the interconnect becomes longer.

Longer interconnect usually causes:

* Higher wire resistance
* Higher wire capacitance
* Larger interconnect delay
* Higher dynamic power
* More difficult routing

A shorter physical distance can reduce wirelength and interconnect delay.

However, placing every connected cell extremely close together is also not always good.

Excessive clustering can cause:

* High local density
* High pin concentration
* Routing congestion
* Poor pin access
* Insufficient space for buffers
* Insufficient space for later optimization

Placement must balance short wirelength against available routing resources.

---

## 4. Placement Stages

The main placement stages are:

1. Global Placement
2. Legalization
3. Detailed Placement
4. Placement Optimization
5. Placement Checks

---

## 5. Global Placement

Global placement determines the approximate physical distribution of standard cells.

Its main objectives include:

* Reducing estimated wirelength
* Improving timing
* Balancing cell density
* Reducing estimated congestion
* Distributing cells across the core

Global placement focuses on the overall placement solution.

At this stage, cells may:

* Slightly overlap
* Fail to align with legal placement sites
* Occupy approximate continuous coordinates

Therefore:

`Global Placement ≠ Final Legal Placement`

Global placement can temporarily allow illegal positions because the main goal is to find a good global distribution.

A useful interpretation is:

> Global placement determines the approximate region where each cell should be located.

---

## 6. Placement Rows and Sites

Standard cells cannot be placed at arbitrary coordinates.

The core is divided into horizontal placement rows.

Each row is divided into smaller legal placement units called sites.

A standard cell normally has:

* A fixed or standardized height
* A width equal to one or more placement sites

A cell must usually:

* Align with a legal row
* Align with a legal site
* Remain inside the legal placement region
* Avoid overlapping other cells
* Avoid macros
* Avoid placement blockages
* Use a legal orientation

A cell can be inside the core and still be illegally placed.

For example, it may:

* Be misaligned with the site grid
* Overlap another cell
* Enter a placement blockage
* Use an illegal orientation

Therefore:

`Inside the core ≠ Legal placement`

---

## 7. Cell Orientation

Adjacent placement rows may use alternating orientations.

Common orientations include:

* `R0`
* `MX`

Alternating orientations help align the power rails of neighboring standard-cell rows.

This allows neighboring rows to correctly share or connect:

* VDD rails
* VSS rails

Cell orientation is therefore related to:

* Placement legality
* Power-rail alignment
* Well structure
* Manufacturing rules

It is not only a visual or geometric choice.

---

## 8. Legalization

Legalization converts the global-placement result into a physically legal placement.

Its main tasks include:

* Removing cell overlap
* Aligning cells to legal rows
* Aligning cells to legal sites
* Avoiding macros
* Avoiding placement blockages
* Enforcing legal orientations
* Keeping cells inside legal placement regions

Legalization should disturb the global-placement result as little as possible.

The distance that a cell moves during legalization is called displacement.

A legalizer tries to minimize displacement because excessive movement can degrade:

* Wirelength
* Timing
* Density distribution
* Congestion

Legalization is mainly responsible for legality.

It is not primarily responsible for solving routing congestion.

A useful summary is:

`Global Placement = Optimization first`

`Legalization = Legality first`

---

## 9. Detailed Placement

Detailed placement performs local optimization after legalization.

It maintains placement legality while improving local quality.

Typical detailed-placement operations include:

* Moving cells within a row
* Swapping neighboring cells
* Reordering cells
* Shifting cells
* Reducing local wirelength
* Improving timing
* Reducing local congestion

For example, if the connectivity is:

`U1 → U2 → U3`

but the placement order is:

`U1 | U3 | U2`

detailed placement may reorder the cells to:

`U1 | U2 | U3`

This can reduce local wirelength while preserving legality.

The relationship among the three major stages is:

`Global Placement → Legalization → Detailed Placement`

Global placement finds a good global distribution.

Legalization makes the placement physically legal.

Detailed placement performs legal local optimization.

---

## 10. Manhattan Distance

Before routing, the tool does not know the exact routed path.

It still needs a fast way to estimate the physical distance between pins.

For two pins at:

`A = (x1, y1)`

`B = (x2, y2)`

the Manhattan distance is:

`|x2 - x1| + |y2 - y1|`

For example:

`A = (2, 4)`

`B = (9, 10)`

The Manhattan distance is:

`|9 - 2| + |10 - 4| = 7 + 6 = 13`

Manhattan distance is used because on-chip routing mainly follows horizontal and vertical directions.

It is more relevant than straight-line Euclidean distance for early physical-design estimation.

---

## 11. Half-Perimeter Wirelength

A net may connect more than two pins.

For a multi-pin net, a common early wirelength estimate is HPWL.

HPWL stands for:

`Half-Perimeter Wirelength`

For all pins in a net:

`HPWL = (max x - min x) + (max y - min y)`

This is the width plus the height of the smallest rectangle that contains all pins.

For example:

`A = (1, 1)`

`B = (6, 3)`

`C = (4, 8)`

Then:

`min x = 1`

`max x = 6`

`min y = 1`

`max y = 8`

Therefore:

`HPWL = (6 - 1) + (8 - 1) = 5 + 7 = 12`

HPWL is only an estimate.

It does not accurately include:

* Macro detours
* Routing blockages
* Congestion
* Metal-layer assignment
* Via locations
* Detailed routing topology
* Design-rule spacing
* Shielding
* Power-grid interference

Therefore:

`Estimated HPWL ≠ Final Routed Wirelength`

HPWL is still useful because it is fast to calculate and update during placement optimization.

---

## 12. Why Minimum HPWL Is Not Enough

Minimizing total HPWL does not guarantee the best placement.

If all strongly connected cells are clustered into one small region:

* Estimated HPWL may decrease
* Local density may increase
* Pin concentration may increase
* Routing demand may increase
* Congestion may become severe

Severe congestion can later cause routing detours.

As a result:

* Actual routed wirelength may increase
* Wire parasitics may increase
* Timing may become worse

Therefore, placement must optimize:

* Wirelength
* Density
* Congestion
* Timing
* Legality

at the same time.

---

## 13. Placement Density

Placement density describes how much of the available placement area is occupied by standard cells.

A simplified expression is:

`Placement Density = Cell Area / Available Placement Area`

For example:

`Available placement area = 100`

`Total cell area = 85`

Then:

`Placement density = 85%`

High placement density means that cells are tightly packed.

High density can cause:

* Less whitespace
* Difficult buffer insertion
* Difficult cell movement
* Larger legalization displacement
* Higher congestion risk
* Poor pin access

However:

`High Placement Density ≠ Guaranteed Routing Congestion`

A dense region may still have mostly short local nets and manageable routing demand.

---

## 14. Routing Demand and Routing Capacity

Routing demand represents how many routing resources are required in a region.

Routing capacity represents how many routing resources are available in that region.

Routing capacity is affected by:

* Number of routing tracks
* Available metal layers
* Macros
* Routing blockages
* Power stripes
* Design-rule spacing
* Pin-access restrictions

The basic congestion relationship is:

`Routing Demand > Routing Capacity → Routing Congestion`

For example:

`Routing demand = 130`

`Routing capacity = 100`

Then:

`Routing overflow = 130 - 100 = 30`

If:

`Routing demand = 85`

`Routing capacity = 100`

then the estimated overflow is zero.

However, zero estimated overflow does not guarantee that detailed routing will be completely clean.

---

## 15. Bins and Congestion Estimation

The placement tool divides the core into smaller analysis regions called bins.

For each bin, the tool can estimate:

* Cell density
* Routing demand
* Routing capacity
* Routing overflow
* Congestion risk

This allows the tool to identify congestion hot spots.

Common congestion hot spots include:

* Macro corners
* Narrow channels
* Pin-dense macro edges
* Regions between macros
* Regions between a macro and the core boundary
* Areas crossed by many buses
* High-density standard-cell clusters

Congestion must be analyzed spatially.

A single global average cannot show local routing problems.

---

## 16. Cell Spreading

Cell spreading moves cells away from an overly dense region.

Its possible benefits include:

* Lower local density
* Lower pin concentration
* More distributed routing demand
* Lower congestion risk
* More whitespace for optimization

Its possible costs include:

* Higher wirelength
* Larger parasitic delay
* Possible timing degradation
* Larger occupied region

Therefore:

`Cell Spreading → Congestion may improve`

but:

`Cell Spreading → Wirelength may increase`

The tool must balance these effects.

---

## 17. Timing-Driven Placement

Not all timing paths have equal importance.

Consider:

`Path A slack = -0.3 ns`

`Path B slack = +2.0 ns`

Path A has a timing violation and is more critical.

Timing-driven placement gives higher optimization priority to critical paths and nets.

A simplified relationship is:

`Worse Slack → Higher Criticality → Higher Placement Priority`

The placement tool may move cells on a critical path closer together to reduce interconnect delay.

For example:

`Reg_A → U1 → U2 → Reg_B`

If these cells are physically far apart, the path may have excessive wire delay.

Reducing the physical distance can reduce:

* Estimated wirelength
* Wire capacitance
* Wire resistance
* Interconnect delay

However, critical cells cannot be clustered without limit.

Over-clustering can cause:

* High local density
* Severe congestion
* Routing detours
* Lack of optimization space
* Worse post-route timing

Timing-driven placement still has to consider:

* Congestion
* Density
* Legality
* Power
* Wirelength

---

## 18. Cell Delay and Interconnect Delay

A timing path can be simplified as:

`Path Delay = Cell Delay + Interconnect Delay`

Cell delay comes from logic cells such as:

* Inverters
* NAND gates
* Multiplexers
* Buffers
* Flip-flops

Cell delay depends on:

* Cell type
* Drive strength
* Input slew
* Output load
* PVT corner

Interconnect delay comes from physical wires and vias.

It depends on:

* Wirelength
* Wire resistance
* Wire capacitance
* Routing layer
* Number of vias
* Routing detours
* Coupling effects

Placement mainly influences interconnect delay by changing physical distances.

It also changes cell loading because different placements produce different estimated wire capacitances.

---

## 19. Placement-Stage Timing Accuracy

Placement occurs before final routing.

Therefore, the exact routed geometry is not yet available.

Placement-stage timing uses estimated parasitics.

The simplified estimation flow is:

`Cell Locations → Estimated Wirelength → Estimated Parasitics → Estimated Timing`

After routing:

`Actual Routed Geometry → Extracted Parasitics → More Accurate STA`

Therefore:

`Placement-Stage Timing = Estimated Timing`

`Post-Route Timing = More Accurate Timing`

A poor placement-stage result should not be ignored.

Routing usually adds more realistic parasitics and may make timing worse.

---

## 20. Placement Optimization Operations

Placement optimization can modify more than cell coordinates.

Common optimization operations include:

* Cell movement
* Cell sizing
* Buffer insertion
* Cell spreading
* Cell swapping
* Cell reordering
* Cell cloning

---

## 21. Cell Movement

Cell movement changes the physical distance between connected cells.

Moving critical cells closer together can reduce:

* Wirelength
* Interconnect capacitance
* Interconnect delay

However, moving one cell can improve one net while making another net worse.

The tool must consider all connected nets.

---

## 22. Cell Sizing

Standard-cell libraries often contain multiple drive strengths.

For example:

* `INV_X1`
* `INV_X2`
* `INV_X4`
* `INV_X8`

Replacing:

`BUF_X1 → BUF_X4`

is called upsizing.

Possible benefits include:

* Higher drive strength
* Lower output resistance
* Better output slew
* Lower delay for a heavy load

Possible costs include:

* Larger cell area
* Higher dynamic power
* Higher leakage power
* Higher input capacitance
* Higher local density
* Higher congestion risk

The increased input capacitance can also slow down the previous stage.

Therefore, cell upsizing is not a free optimization.

---

## 23. Buffer Insertion

A buffer may be inserted to drive:

* A long wire
* A high-capacitance load
* A high-fanout net
* A slow-transition signal

For example:

`Driver → Load`

may become:

`Driver → Buffer → Load`

Buffer insertion can improve:

* Slew
* Signal integrity
* Delay
* Load distribution
* Fanout control

Its costs include:

* More cells
* More area
* More dynamic power
* More leakage power
* More placement space
* More routing

This is why placement must preserve enough whitespace.

---

## 24. Utilization and Whitespace

Utilization describes how much of the placement area is occupied.

A simplified expression is:

`Utilization = Total Standard-Cell Area / Available Placement Area`

High utilization means little whitespace remains.

High utilization does not necessarily mean that the design contains more logical cells.

It means that the current cells occupy a large percentage of the available placement area.

The correct relationship is:

`High Utilization`

`→ Less Available Whitespace`

`→ Buffer Insertion Becomes Difficult`

`→ Legalization Displacement Increases`

`→ Congestion Risk Increases`

`→ Timing Optimization Becomes More Difficult`

High utilization makes later optimization harder because there may be no legal location for new buffers or resized cells.

---

## 25. Placement May Modify the Netlist

Placement optimization may change the physical-design netlist.

For example:

`BUF_X1`

may be replaced with:

`BUF_X4`

or:

`U1 → U2`

may become:

`U1 → New_Buffer → U2`

Therefore:

`Placement ≠ Only Changing X/Y Coordinates`

Placement optimization can change:

* Cell types
* Instance count
* Net connectivity
* Buffer structure

The logical functionality must remain equivalent.

---

## 26. Pre-CTS Timing

Placement normally occurs before Clock Tree Synthesis.

Therefore, placement timing is often called:

`Pre-CTS Timing`

At this stage, the real clock tree has not yet been built.

The tool may use:

* Ideal clock
* Estimated clock latency
* Estimated clock model

After CTS, the design contains:

* Clock buffers
* Clock inverters
* Clock routing
* Clock latency
* Clock skew
* Clock parasitics

Therefore:

`Pre-CTS Timing = Data-path placement exists, but clock network is still ideal or estimated`

`Post-CTS Timing = Real clock network effects are included`

Pre-CTS timing is not final timing, but it is still important.

A severely failing data path before CTS is usually difficult to repair later.

---

## 27. Placement Optimization Loop

Placement is iterative.

A simplified optimization loop is:

`Place Cells`

`→ Estimate Timing, Wirelength, Density, and Congestion`

`→ Move or Resize Cells`

`→ Insert Buffers`

`→ Legalize`

`→ Reanalyze`

`→ Continue Optimization`

This can be summarized as:

`Analyze → Optimize → Legalize → Analyze Again`

---

## 28. Placement Legality Checks

Placement legality checks verify that:

* No cells overlap
* Cells align with legal rows
* Cells align with legal sites
* Cells do not overlap macros
* Cells do not enter placement blockages
* Cells use legal orientations
* Cells remain inside legal placement regions

Timing clean does not mean placement legal.

For example:

`WNS = 0`

`TNS = 0`

does not matter if two cells physically overlap.

Therefore:

`Timing Clean ≠ Placement Legal`

Both must be checked independently.

---

## 29. WNS

WNS stands for:

`Worst Negative Slack`

WNS is the worst slack among all timing endpoints.

For example:

* Path A slack = `-0.3 ns`
* Path B slack = `+0.5 ns`
* Path C slack = `-0.7 ns`
* Path D slack = `-0.2 ns`

Then:

`WNS = -0.7 ns`

WNS indicates the severity of the single worst timing violation.

A WNS closer to zero is better.

A positive worst slack means there is no negative slack for that analysis.

---

## 30. TNS

TNS stands for:

`Total Negative Slack`

TNS is the sum of all negative endpoint slacks.

Using the previous example:

`TNS = -0.3 + (-0.7) + (-0.2)`

`TNS = -1.2 ns`

Positive slack values are not included.

TNS indicates the total scale of timing violations.

WNS and TNS provide different information:

`WNS = Severity of the worst violation`

`TNS = Total amount of negative slack`

A design may have:

* One very bad path
* Many slightly bad paths
* Both

Therefore, WNS and TNS should be analyzed together.

---

## 31. Electrical Checks

Placement optimization also checks electrical constraints.

Common checks include:

* Maximum transition
* Maximum capacitance
* Maximum fanout

### Maximum Transition

Maximum transition checks whether a signal edge is too slow.

Possible fixes include:

* Cell upsizing
* Buffer insertion
* Shorter wire
* Lower load

### Maximum Capacitance

Maximum capacitance checks whether a driver sees excessive total load capacitance.

Possible fixes include:

* Buffer insertion
* Load splitting
* Stronger driver
* Shorter wire

### Maximum Fanout

Maximum fanout checks whether a driver connects to too many loads.

Possible fixes include:

* Buffer trees
* Driver cloning
* Logic restructuring

These electrical violations can affect timing, power, and routability.

---

## 32. Placement Quality Evaluation

A good placement result must be evaluated using multiple categories.

### Legality

Check:

* Cell overlap
* Row alignment
* Site alignment
* Macro overlap
* Blockage violations
* Orientation

### Wirelength

Check:

* Total HPWL
* Critical-net wirelength
* Long nets

### Density

Check:

* Average utilization
* Maximum local density
* Density hot spots
* Available whitespace

### Congestion

Check:

* Routing demand
* Routing capacity
* Routing overflow
* Congestion hot spots

### Timing

Check:

* WNS
* TNS
* Critical paths
* Setup violations
* Electrical violations

### Electrical Quality

Check:

* Maximum transition
* Maximum capacitance
* Maximum fanout

A good placement is not the result with the best single number.

It is a balanced result across:

* Legality
* Timing
* Wirelength
* Congestion
* Density
* Power
* Electrical constraints

---

## 33. Global Average Versus Local Hot Spots

A reasonable average utilization does not guarantee a good local distribution.

For example:

`Average utilization = 68%`

`Local density near macro = 96%`

The local density of 96% is more important for that region because it may cause:

* No whitespace
* Poor pin access
* Buffer-insertion difficulty
* Severe congestion
* Large legalization displacement

Therefore:

`Global Average ≠ Local Physical Condition`

Physical-design analysis must inspect local maps and hot spots.

---

## 34. Macro-Related Congestion

Macros reduce available placement and routing resources.

Common macro-related congestion causes include:

* Narrow channels
* Macro corners
* Dense macro pins
* Poor macro orientation
* Large numbers of crossing nets
* Macro placement near the core boundary

If a macro-to-boundary channel is too narrow, placement optimization may not be enough.

Cell sizing cannot increase the channel width.

Upsizing may even make congestion worse because cell area increases.

If the root cause is the floorplan, the design may need to return to floorplanning.

Possible floorplan changes include:

* Moving the macro
* Rotating the macro
* Increasing channel width
* Modifying halos
* Modifying blockages
* Increasing core area

This is called floorplan iteration.

---

## 35. Placement and Floorplanning Iteration

Physical design is not always a strictly one-directional flow.

A common situation is:

`Floorplanning`

`→ Placement`

`→ Severe Congestion Detected`

`→ Return to Floorplanning`

`→ Modify Macro Locations or Core Size`

`→ Run Placement Again`

A poor floorplan cannot always be repaired by placement.

Placement quality strongly depends on:

* Macro locations
* Channel widths
* Pin distribution
* Blockages
* Core utilization
* Power-grid structure

---

## 36. Complete Placement Flow

The complete placement flow can be summarized as:

`Floorplanning`

`→ Global Placement`

`→ Wirelength, Timing, Density, and Congestion Optimization`

`→ Legalization`

`→ Detailed Placement`

`→ Placement Optimization`

`→ Legality Checks`

`→ Timing Checks`

`→ Congestion Checks`

`→ Electrical Checks`

`→ Clock Tree Synthesis`

A more detailed optimization loop is:

`Global Placement`

`→ Estimate HPWL`

`→ Estimate Density`

`→ Estimate Congestion`

`→ Estimate Timing`

`→ Move Cells`

`→ Spread Cells`

`→ Resize Cells`

`→ Insert Buffers`

`→ Legalize`

`→ Detailed Placement`

`→ Recheck Quality`

---

## 37. Key Concepts

### Placement

The physical-design stage that assigns physical locations to standard-cell instances.

### Global Placement

Determines the approximate global distribution of cells while optimizing wirelength, timing, density, and congestion.

### Legalization

Removes overlap and aligns cells to legal rows and sites while minimizing displacement.

### Detailed Placement

Performs local cell movement, swapping, and reordering while maintaining legality.

### Placement Row

A horizontal legal region where standard cells can be placed.

### Placement Site

The smallest legal placement unit within a row.

### Displacement

The distance a cell moves from its global-placement position to its legal position.

### Manhattan Distance

The horizontal distance plus the vertical distance between two points.

### HPWL

A fast estimate of multi-pin net wirelength using the width plus height of the pin bounding box.

### Placement Density

The ratio of occupied standard-cell area to available placement area.

### Routing Demand

The amount of routing resource required in a region.

### Routing Capacity

The amount of routing resource available in a region.

### Routing Overflow

The amount by which routing demand exceeds routing capacity.

### Congestion Hot Spot

A local region where routing demand is high compared with routing capacity.

### Cell Spreading

Moving cells apart to reduce local density and congestion.

### Timing-Driven Placement

Placement optimization that gives higher priority to timing-critical paths and nets.

### Criticality

A measure of how important a path or net is for timing optimization.

### Cell Sizing

Replacing a cell with another drive-strength version of the same logical function.

### Buffer Insertion

Adding buffers to improve slew, delay, fanout, or load distribution.

### Pre-CTS Timing

Timing analysis before the real clock tree has been constructed.

### WNS

The worst slack among all timing endpoints.

### TNS

The sum of all negative endpoint slacks.

---

## 38. Final Summary

Placement determines where standard cells are physically located inside the floorplan.

It is not simply a geometric packing problem.

The placement tool must simultaneously manage:

* Physical legality
* Estimated wirelength
* Timing
* Routing congestion
* Cell density
* Electrical constraints
* Power and area tradeoffs

Global placement finds an overall optimized distribution.

Legalization converts the result into a legal placement.

Detailed placement improves the legal result through local adjustments.

Placement optimization may also resize cells, insert buffers, spread cells, and modify the physical-design netlist while preserving logical equivalence.

The final placement result must be checked using:

* Legality
* HPWL
* Density
* Congestion
* Routing overflow
* WNS
* TNS
* Transition
* Capacitance
* Fanout

A successful placement provides a legal, timing-aware, and routable foundation for Clock Tree Synthesis and routing.
