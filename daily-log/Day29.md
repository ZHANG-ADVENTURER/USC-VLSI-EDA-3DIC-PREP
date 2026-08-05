# Day 29 Daily Log

## Topic

Routing in the ASIC Physical Design Flow

## What I Learned

Today I learned how routing converts logical netlist connectivity into actual physical metal wires and vias.

Before routing, the design already contains:

* A placed gate-level netlist
* Standard-cell and macro locations
* A power-distribution network
* A synthesized clock tree
* Timing constraints
* Estimated interconnect delay

Routing determines:

* Which metal layers are used
* Which tracks wires occupy
* Where vias are inserted
* How blockages are avoided
* How congestion is managed
* How timing-critical nets are protected
* How manufacturing rules are satisfied

I learned that routing is divided into two major stages:

`Global Routing → Detailed Routing`

Global routing creates an approximate routing plan and estimates congestion.

Detailed routing creates exact legal wires, tracks, vias, and pin connections.

I also learned that a design is not routing-clean simply because every net has been routed.

Routing closure also requires:

* No opens
* No shorts
* No DRC violations
* Clean setup timing
* Clean hold timing
* Acceptable signal integrity
* Clean antenna checks
* Acceptable electromigration
* Acceptable IR drop
* Clean LVS

## What I Built

I created a complete Routing study module covering the physical implementation of signal interconnect.

The documentation structure is:

`02_physical_design_notes/06_routing/`

with:

* `notes/routing.md`
* `README.md`

The module explains the complete process from logical connectivity to routing signoff.

## Produced

* Routing notes
* Routing project README
* Logical-net and routed-wire comparison
* Global-routing and detailed-routing explanations
* Metal-layer and preferred-direction analysis
* Routing-track, wire-width, spacing, and pitch definitions
* Via, enclosure, redundant-via, and via-stack explanations
* Pin-access analysis
* Routing-demand, capacity, and overflow calculations
* Congestion causes and fixes
* Open, short, and DRC explanations
* Timing-aware routing framework
* Crosstalk and signal-integrity analysis
* Antenna-effect and antenna-repair explanations
* Electromigration analysis
* Static and dynamic IR-drop explanations
* Parasitic-extraction and SPEF explanations
* Post-route ECO framework
* Routing-closure checklist

## Key Concepts

### Routing

Routing is the physical design stage that creates actual metal wires and vias for logical nets.

### Logical Net

A logical net defines which pins must be electrically connected.

It does not define:

* Exact coordinates
* Metal layers
* Routing tracks
* Via locations
* Wire width
* Wire spacing

### Routed Wire

A routed wire is the physical metal implementation of a logical net.

### Metal Layer

A metal layer is a conductive layer used to create physical interconnect.

Lower metal layers are commonly used for:

* Local routing
* Standard-cell pin access
* Short connections

Upper metal layers are commonly used for:

* Long nets
* Clock routing
* Power distribution
* Timing-critical connections

### Preferred Routing Direction

Adjacent metal layers commonly use alternating routing directions.

For example:

* M2: Vertical
* M3: Horizontal
* M4: Vertical

This organizes routing resources and reduces conflicts.

### Via

A via is a vertical conductor connecting adjacent metal layers.

It allows a route to:

* Change layers
* Change direction
* Avoid blockages
* Reach pins
* Use lower-resistance upper metal

### Via Enclosure

Via enclosure is the required amount of metal surrounding a via.

It improves:

* Manufacturing tolerance
* Electrical contact
* Reliability

### Multi-Cut Via

A multi-cut via uses several parallel via openings.

It provides:

* Lower effective resistance
* Greater current capacity
* Better electromigration reliability

Its cost is greater physical area and routing-resource usage.

### Via Stack

A via stack connects a route across several metal layers using multiple vias.

### Global Routing

Global routing plans approximate net paths through routing regions.

It estimates:

* Routing demand
* Routing capacity
* Congestion
* Layer usage
* Approximate via requirements

### Detailed Routing

Detailed routing creates exact physical routing geometry.

It determines:

* Exact tracks
* Exact layers
* Exact coordinates
* Exact vias
* Exact pin access
* Exact spacing

### G-Cell

A G-cell is a region used by the global router to model routing demand and capacity.

### Routing Track

A routing track is a predefined legal path on which the centerline of a wire may be placed.

The distinction is:

* Net: required connectivity
* Track: legal wire-placement location
* Wire: physical metal placed on tracks

### Wire Width

Wire width is the physical width of one metal segment.

Increasing width generally:

* Reduces resistance
* Increases current capacity
* Improves EM reliability
* Consumes more routing space

### Wire Spacing

Wire spacing is the edge-to-edge distance between neighboring metal shapes.

Larger spacing reduces:

* Manufacturing-short risk
* Coupling capacitance
* Crosstalk risk

### Routing Pitch

Routing pitch is the center-to-center distance between adjacent routing tracks.

A simplified relationship is:

`Pitch ≈ Width + Spacing`

### Open Circuit

An open occurs when a required connection is incomplete.

Possible causes include:

* Missing wire
* Missing via
* Failed pin access
* Broken metal connection

### Short Circuit

A short occurs when two nets that should remain separate become unintentionally connected.

### Legal Crossing

Two different nets may cross legally when:

* They are on different metal layers.
* No via connects them.
* All design rules are satisfied.

### DRC

DRC stands for Design Rule Check.

DRC verifies that physical geometry satisfies manufacturing rules.

### Minimum Width Violation

A minimum-width violation occurs when a wire is narrower than permitted.

### Minimum Spacing Violation

A minimum-spacing violation occurs when neighboring metal shapes are too close.

### Minimum Area Violation

A minimum-area violation occurs when a metal shape has insufficient total area, even if its width is legal.

### Pin Access

Pin access is the ability of the detailed router to create a legal physical connection to a cell or macro pin.

### Pin Density

Pin density describes how many pins exist in a small physical region.

High pin density increases:

* Pin-access difficulty
* Local congestion
* Via conflicts
* DRC risk

### Routing Demand

Routing demand is the routing resource required by nets in a region.

### Routing Capacity

Routing capacity is the legal routing resource available in a region.

### Routing Overflow

Routing overflow occurs when demand exceeds capacity.

The simplified relationship is:

`Overflow = Demand − Capacity`

### Routing Congestion

Routing congestion occurs when routing demand approaches or exceeds routing capacity.

Congestion may cause:

* Detours
* More vias
* Longer wirelength
* Timing degradation
* Unrouted nets
* DRC violations

### Macro Corner Congestion

Macro corners are congestion hot spots because many nets must route around the same physical obstacle.

### Cell Spreading

Cell spreading moves cells farther apart to create more routing space.

It may reduce congestion but increase wirelength and delay.

### Critical Net

A critical net is a net whose delay significantly affects the slack of a timing-critical path.

### Non-Critical Net

A non-critical net has enough positive timing slack to tolerate a longer route or detour.

### Timing-Aware Routing

Timing-aware routing prioritizes important nets based on timing criticality.

Critical nets may receive:

* Shorter routing
* Lower-resistance metal
* Fewer detours
* More spacing
* Higher routing priority

### Crosstalk

Crosstalk occurs when switching on one net affects a nearby net through coupling capacitance.

### Aggressor

The aggressor is the net causing the coupling disturbance.

### Victim

The victim is the net affected by the coupling disturbance.

### Coupling Capacitance

Coupling capacitance is the electrical coupling between neighboring signal wires.

It increases with:

* Smaller spacing
* Longer parallel routing length
* Larger facing metal area

### Crosstalk Noise

Crosstalk noise is an unintended voltage disturbance induced on a victim net.

### Crosstalk Delay

Crosstalk may make a victim net faster or slower depending on aggressor switching behavior.

A slowdown may hurt setup timing.

A speedup may hurt hold timing.

### Signal Integrity

Signal integrity describes whether a signal maintains acceptable electrical behavior through physical interconnect.

### Antenna Effect

The antenna effect is a fabrication-stage reliability problem.

A long metal structure may collect plasma charge and damage the transistor gate oxide.

### Antenna Ratio

A simplified antenna ratio is:

`Antenna Ratio ≈ Exposed Metal Area / Gate Area`

### Antenna Diode

An antenna diode provides a safe discharge path for collected plasma charge.

### Layer Jumping

Layer jumping moves a long route to an upper metal layer to reduce the lower-layer metal area connected to a gate during early fabrication.

### Electromigration

Electromigration is the movement of metal atoms caused by excessive current density during operation.

### Current Density

A simplified relationship is:

`Current Density = Current / Cross-Sectional Area`

### Void

A void is a region where metal atoms move away.

It may increase resistance or create an open circuit.

### Hillock

A hillock is a region where metal atoms accumulate.

It may create a protrusion or short circuit.

### IR Drop

IR drop is the voltage loss caused by current flowing through power-network resistance.

The basic relationship is:

`Vdrop = I × R`

### Static IR Drop

Static IR drop is caused by average or steady current flow.

### Dynamic IR Drop

Dynamic IR drop is temporary voltage droop caused by sudden switching-current demand.

### Decoupling Capacitor

A decoupling capacitor stores local charge and reduces dynamic voltage droop.

### Parasitics

Physical interconnect introduces:

* Wire resistance
* Via resistance
* Ground capacitance
* Coupling capacitance

### RC Delay

A simplified interconnect-delay relationship is:

`Delay ∝ R × C`

### Parasitic Extraction

Parasitic extraction calculates resistance and capacitance from actual routed geometry.

### SPEF

SPEF stands for Standard Parasitic Exchange Format.

It contains extracted interconnect parasitics.

### Post-Route STA

Post-route Static Timing Analysis uses:

`Netlist + .lib + SDC + SPEF`

### Setup Violation

A setup violation means data arrives too late.

The path is too slow.

### Hold Violation

A hold violation means new data arrives too early.

The path is too fast.

### ECO

ECO stands for Engineering Change Order.

It is a small incremental design modification used to repair late-stage violations.

### Spare Cell

A spare cell is an unused logic cell placed in advance for possible late-stage ECO use.

### Metal-Only ECO

A metal-only ECO changes routing layers while keeping transistor and base-layer structures unchanged.

### Metal Fill

Metal fill is dummy metal inserted to satisfy density requirements and improve manufacturing uniformity.

It may increase parasitic capacitance.

### LVS

LVS stands for Layout Versus Schematic.

It verifies that layout-extracted connectivity matches the intended circuit.

### Routing Closure

Routing closure means that all required connectivity, geometry, timing, signal-integrity, reliability, and power-integrity checks pass.

## Problems and Fixes

### Problem 1: Confusing a Routing Track with a Net

I initially described a routing track as the connection between two pins.

#### Fix

A net defines the required connection.

A routing track is a predefined legal location where a physical wire may be placed.

`Net → Connectivity Requirement`

`Track → Legal Wire Position`

`Wire → Physical Metal Implementation`

---

### Problem 2: Assuming Wider Wire Means More Wires

I initially said that increasing wire width meant more wires.

#### Fix

A wider wire occupies more physical space.

Therefore:

`Wire Width ↑ → Resistance ↓ → Fewer Wires Fit → Routing Difficulty ↑`

---

### Problem 3: Describing Open as Only a Gap in One Track

I initially defined an open only as an empty space in a routing track.

#### Fix

An open is any incomplete required electrical connection.

It may be caused by:

* Missing wire
* Missing via
* Failed pin access
* Disconnected metal shape

---

### Problem 4: Confusing Connectivity Checks with DRC

I initially said that a completely connected route should not have opens or shorts when asked why it could still fail DRC.

#### Fix

Open and short checks verify connectivity.

DRC verifies manufacturing geometry.

A route may have no opens or shorts but still violate:

* Width
* Spacing
* Via enclosure
* Minimum area

Therefore:

`Connectivity Clean ≠ DRC Clean`

---

### Problem 5: Confusing Minimum Area with Spacing

I initially classified a legal-width but undersized metal shape as a spacing violation.

#### Fix

The correct violation is:

`Minimum Area Violation`

The metal shape may need to be extended or patched.

---

### Problem 6: Misunderstanding Macro Corner Congestion

I initially said macro corners were congested because they had fewer pins.

#### Fix

Macro corners are congested because the macro blocks routing and forces many nets to turn around the same limited region.

The problem is concentrated routing demand, not simply pin count.

---

### Problem 7: Misstating the Effect of Non-Critical-Net Detours

I initially said that detouring a non-critical net reduced both congestion and delay.

#### Fix

A detour usually increases that net’s wirelength and delay.

It is acceptable because the net has sufficient positive slack.

Its purpose is to reduce overall congestion and protect faster resources for critical nets.

---

### Problem 8: Assigning Drive Strength to Metal Layers

I initially said upper metal had stronger drive power.

#### Fix

Drive strength belongs to the driving cell or buffer.

Upper metal layers help timing because they are generally wider, thicker, and lower in resistance.

---

### Problem 9: Assuming Routing Adds Timing Cells Automatically

I initially said detailed routing adds real timing cells.

#### Fix

Routing mainly adds actual interconnect geometry and more accurate parasitic resistance and capacitance.

Post-route optimization may later insert buffers or delay cells, but routing itself does not necessarily add timing cells.

---

### Problem 10: Explaining Crosstalk Only as Noise

I initially said long parallel wires create crosstalk because they have noise.

#### Fix

The physical cause is increased coupling capacitance.

`Long Parallel Run → Larger Coupling Capacitance → Greater Crosstalk`

---

### Problem 11: Naming the Entire MOSFET as the Antenna-Damage Structure

I initially said the MOSFET was the structure damaged by the antenna effect.

#### Fix

The specific vulnerable structure is the thin gate oxide.

Accumulated plasma charge can create excessive voltage across the gate oxide and cause breakdown.

---

### Problem 12: Omitting the Purpose of an Antenna Diode

I did not initially answer the antenna-diode question.

#### Fix

An antenna diode provides a safe discharge path for plasma-induced charge and protects the transistor gate oxide.

---

### Problem 13: Treating Fewest Vias as Automatically Best

I learned that minimizing vias alone does not always produce the best route.

#### Fix

Extra vias may allow a long net to use a lower-resistance upper layer.

The router evaluates total:

* Delay
* Congestion
* Resistance
* Via cost
* DRC risk

---

### Problem 14: Treating DRC-Clean as Timing-Clean

I learned that a route can satisfy manufacturing rules but still have excessive electrical delay.

#### Fix

DRC verifies geometry.

Post-route STA verifies timing using extracted parasitics.

`DRC Clean ≠ Timing Clean`

---

### Problem 15: Treating All Nets as Equally Important

I learned that routing resources should be allocated according to timing criticality.

#### Fix

Critical nets may receive faster routing.

Non-critical nets may accept detours when sufficient slack exists.

## Connection to VLSI / EDA / 3D IC

Routing is one of the central stages of digital VLSI physical implementation.

A Physical Design Engineer must understand:

* Logical and physical connectivity
* Metal-stack properties
* Track assignment
* Via insertion
* Pin access
* Congestion
* Timing-aware routing
* Signal integrity
* Parasitic extraction
* Physical verification
* Reliability
* Power integrity

Routing is strongly connected to EDA because the router must solve a very large constrained optimization problem.

The EDA tool must choose among:

* Multiple paths
* Multiple layers
* Thousands or millions of tracks
* Different via structures
* Different spacing options
* Timing and congestion tradeoffs

The tool must simultaneously optimize:

* Connectivity
* Wirelength
* Delay
* Congestion
* DRC
* Crosstalk
* Power
* Reliability
* Manufacturability

Routing is also connected to Static Timing Analysis because actual wire resistance and capacitance can become a major part of total path delay.

Post-route STA relies on:

* Gate-level netlist
* Timing libraries
* Timing constraints
* Extracted SPEF parasitics

Routing is connected to Design Verification because incorrect physical connectivity may produce:

* Opens
* Shorts
* Wrong pin connections
* Clock-routing errors
* Functional failure

LVS helps verify that the physical implementation matches the intended circuit.

In 3D IC and chiplet systems, routing extends beyond ordinary on-die metal interconnect.

It may also include:

* Through-silicon vias
* Micro-bumps
* Hybrid bonds
* Interposer routing
* Redistribution layers
* Die-to-die interfaces

Additional challenges include:

* Vertical interconnect resistance
* TSV capacitance
* Micro-bump reliability
* Inter-die crosstalk
* Package-level routing congestion
* Thermal effects
* Cross-die clock and power delivery
* Die-to-die signal integrity

The same principle remains:

> Logical connectivity must be transformed into physically legal, electrically correct, reliable, and manufacturable interconnect.

## One Sentence Summary

Routing converts logical nets into exact physical metal and via structures while closing connectivity, DRC, timing, signal-integrity, reliability, and power-integrity requirements.

## Next Step

Study physical design signoff, including:

* DRC signoff
* LVS signoff
* Final parasitic extraction
* Post-route Static Timing Analysis
* Signal-integrity signoff
* Electromigration signoff
* IR-drop signoff
* Metal-density verification
* GDSII generation
* Tapeout preparation
