# Routing

## 1. Overview

Routing is the physical design stage that converts logical connectivity into actual metal wires and vias.

The simplified ASIC physical design flow is:

`RTL → Synthesis → Floorplanning → Placement → Clock Tree Synthesis → Routing → Signoff`

Before routing, the design already contains:

* A gate-level netlist
* Placed standard cells
* Placed macros
* A power-distribution network
* A synthesized clock tree
* Timing constraints
* Estimated interconnect delay

However, the exact signal wires and vias have not yet been completely created.

Routing determines:

* Which metal layers each net uses
* Which routing tracks each wire occupies
* Where vias are inserted
* How blockages and macros are avoided
* How congestion is managed
* How manufacturing rules are satisfied
* How timing and signal integrity are protected

Routing is successful only when the design satisfies connectivity, timing, physical, signal-integrity, and reliability requirements.

---

## 2. Logical Net versus Routed Wire

A logical net defines which pins must be electrically connected.

Example:

`U1/Y → U2/A`

This connectivity statement does not define:

* Wire coordinates
* Metal layers
* Via locations
* Routing tracks
* Detours
* Wire width
* Wire spacing

A routed wire is the physical implementation of that logical net.

Example:

`U1/Y → M2 Wire → Via → M3 Wire → Via → M2 Wire → U2/A`

Therefore:

* A logical net defines what must be connected.
* A routed wire defines how the connection is physically implemented.

---

## 3. Why Placement Is Not Enough

Placement determines where cells and macros are located.

Example:

* `U1` is placed at one coordinate.
* `U2` is placed at another coordinate.

Placement does not determine the exact physical path between their pins.

The route may need to avoid:

* Macros
* Routing blockages
* Power rings
* Power stripes
* Clock routes
* Other signal nets
* Pin-access restrictions
* Layer restrictions
* Design-rule constraints

Therefore:

`Estimated Straight-Line Distance ≠ Final Routed Wirelength`

The final route is often longer than the early estimated distance.

---

## 4. Metal Layers

Modern integrated circuits contain multiple metal routing layers.

A simplified stack may be:

`M8 → Upper Metal`

`M7`

`M6`

`M5`

`M4`

`M3`

`M2`

`M1 → Lower Metal`

Different metal layers may have different:

* Width
* Thickness
* Resistance
* Capacitance
* Routing pitch
* Preferred direction
* Via rules
* Current capacity
* Manufacturing rules

Lower metal layers are commonly used for:

* Standard-cell pin access
* Short local connections
* Dense local routing

Upper metal layers are commonly used for:

* Long-distance signal nets
* Clock routing
* Power distribution
* High-current nets
* Timing-critical nets

This is a general pattern and may vary by process technology.

---

## 5. Why Multiple Metal Layers Are Required

Routing every net on one metal layer would create severe congestion and shorts.

Multiple metal layers provide:

* More routing capacity
* Independent crossing paths
* Different routing directions
* Ways to avoid obstacles
* Better long-distance routing
* Separation between intersecting nets

Two different nets may cross without a short if:

* They are on different metal layers.
* No via connects them at the crossing point.

The layers are physically separated by dielectric material.

---

## 6. Preferred Routing Direction

Adjacent metal layers commonly use alternating preferred routing directions.

Example:

* M1: Horizontal
* M2: Vertical
* M3: Horizontal
* M4: Vertical

A route that must move horizontally and then vertically may use:

`Horizontal M3 Segment → Via → Vertical M4 Segment`

Alternating preferred directions help:

* Organize routing resources
* Reduce routing conflicts
* Simplify turns
* Improve track utilization
* Improve congestion estimation

Non-preferred routing may still be allowed, but it may have additional cost or restrictions.

---

## 7. Via

A via is a vertical conductor connecting metal on adjacent layers.

Example:

`M3 → Via3 → M4`

A via allows a route to:

* Change metal layers
* Change routing direction
* Avoid a blockage
* Use a lower-resistance upper layer
* Access pins on different layers

Vias introduce:

* Resistance
* Capacitance
* Physical-area usage
* Manufacturing complexity
* Reliability risk

Therefore, vias are necessary but not free.

---

## 8. Via Naming

A simplified via naming convention is:

* V1 connects M1 and M2.
* V2 connects M2 and M3.
* V3 connects M3 and M4.

Actual names depend on the process technology and design kit.

---

## 9. Via Enclosure

A via must be surrounded by sufficient metal.

The surrounding metal must extend beyond the via edges.

This requirement is called via enclosure.

Via enclosure provides:

* Tolerance to manufacturing misalignment
* Better electrical contact
* Lower risk of partial connection
* Better reliability

Insufficient enclosure creates a via-enclosure DRC violation.

---

## 10. Single-Cut and Multi-Cut Vias

### Single-Cut Via

A single-cut via contains one via opening.

Advantages:

* Small area
* Easier placement in congested regions

Disadvantages:

* Higher effective resistance
* Lower current capacity
* Lower redundancy

### Multi-Cut Via

A multi-cut via contains multiple parallel openings.

Advantages:

* Lower effective resistance
* Higher current capacity
* Better electromigration reliability
* Better manufacturing tolerance

Disadvantages:

* Larger physical area
* Larger enclosure requirement
* More routing-resource usage

---

## 11. Redundant Vias

A redundant via is an additional via placed in parallel with an existing via.

Benefits include:

* Better manufacturing yield
* Better reliability
* Lower effective resistance
* Greater current capacity

If one via fails, the second via may preserve connectivity.

---

## 12. Via Stack

A route that moves across several metal layers may use a via stack.

Example:

`M2 → V2 → M3 → V3 → M4 → V4 → M5`

A tall via stack may introduce:

* More resistance
* Larger enclosure requirements
* Additional DRC constraints
* Reliability concerns
* More complex routing

The detailed router must verify that the stack is legal.

---

## 13. Fewest Vias Is Not Always Best

A route with fewer vias may remain on a high-resistance lower layer.

A route with additional vias may reach a lower-resistance upper layer.

Example:

### Lower-Layer Route

* Fewer vias
* Higher wire resistance
* More local congestion
* Potentially larger delay

### Upper-Layer Route

* More vias
* Lower long-distance wire resistance
* Better routability
* Potentially smaller total delay

The router evaluates total route cost rather than via count alone.

---

## 14. Global Routing

Global routing creates an approximate routing plan.

The chip is divided into routing regions commonly called G-cells.

The global router determines:

* Approximate regions crossed by each net
* Approximate metal-layer usage
* Approximate routing direction
* Estimated routing demand
* Estimated routing capacity
* Estimated congestion
* Approximate via requirements

Global routing does not necessarily create exact wire geometry.

Example:

`Source Pin → G-Cell A → G-Cell B → G-Cell C → Destination Pin`

---

## 15. Detailed Routing

Detailed routing converts the global-routing plan into exact physical geometry.

It determines:

* Exact routing tracks
* Exact wire coordinates
* Exact metal layers
* Exact via locations
* Exact pin-access locations
* Exact wire widths
* Exact spacing
* Final manufacturable route shapes

Detailed routing must satisfy all required process design rules.

---

## 16. Why Global Routing Comes First

A modern chip may contain millions of nets and an enormous number of possible:

* Tracks
* Layers
* Via positions
* Detours
* Pin-access points

Directly searching all detailed-routing possibilities would be computationally expensive.

Global routing first reduces the search space.

Therefore:

`Global Routing → Approximate Plan → Reduced Search Space → Detailed Routing`

---

## 17. Global Routing versus Detailed Routing

### Global Routing

Main objective:

* Plan approximate paths
* Estimate congestion
* Allocate routing regions and layers

Main output:

* G-cell paths
* Routing demand
* Routing capacity
* Congestion estimates
* Layer guidance

### Detailed Routing

Main objective:

* Create exact legal geometry

Main output:

* Final wires
* Final vias
* Exact tracks
* Exact pin access
* DRC-compliant route shapes

---

## 18. Routing Track

A routing track is a predefined legal path on which the centerline of a metal wire may be placed.

A track is not a net.

The distinction is:

* Net: required connectivity
* Track: legal wire-placement position
* Wire: physical metal placed on one or more tracks

Detailed routing normally places wires according to the routing grid rather than arbitrary coordinates.

---

## 19. Available Routing Capacity

Not every physical track is available.

Tracks may be occupied or blocked by:

* Signal routes
* Clock routes
* Power stripes
* Macros
* Routing blockages
* Pin-access requirements
* Layer restrictions

Therefore:

`Physical Track Count ≠ Available Routing Capacity`

---

## 20. Wire Width

Wire width is the physical width of a metal segment.

A wider wire generally provides:

* Lower resistance
* Greater current capacity
* Better electromigration margin

However, it also causes:

* Greater area consumption
* Fewer available routing tracks
* More spacing demand
* Potentially larger capacitance
* Greater congestion risk

Therefore:

`Wire Width ↑ → Resistance ↓ → Routing Resource Usage ↑`

---

## 21. Wire Spacing

Wire spacing is the edge-to-edge distance between neighboring metal shapes.

Minimum spacing rules help prevent:

* Manufacturing shorts
* Excessive coupling
* Crosstalk
* Reliability problems
* Patterning defects

If two wires are closer than permitted, the design has a spacing violation.

---

## 22. Routing Pitch

Routing pitch is the center-to-center distance between adjacent routing tracks.

A simplified relationship is:

`Pitch ≈ Wire Width + Required Spacing`

The three concepts are:

* Width: physical width of one wire
* Spacing: edge-to-edge gap between wires
* Pitch: center-to-center distance between adjacent tracks

---

## 23. Pitch and Routing Capacity

Smaller pitch allows more tracks in the same physical region.

Example:

* Routing-region width = `1.2 μm`
* Routing pitch = `0.1 μm`

Approximate track count:

`1.2 / 0.1 = 12 tracks`

This simplified estimate ignores boundary effects and complex process rules.

---

## 24. Default Routing Rules and NDR

Ordinary signal nets normally use default routing rules.

Critical nets may use an NDR.

NDR stands for:

`Non-Default Rule`

An NDR may specify:

* Wider wires
* Larger spacing
* Special via rules
* Preferred routing layers
* Multi-cut vias

NDR improves electrical behavior but consumes more routing resources.

---

## 25. Open Circuit

An open occurs when a required electrical connection is incomplete.

Possible causes include:

* Missing wire segment
* Missing via
* Incomplete pin access
* Broken metal shape
* Routing failure

An open may cause:

* Floating nodes
* Signal loss
* Incorrect logic
* Functional failure
* LVS failure

Therefore:

`Open = Required Connection Is Missing`

---

## 26. Short Circuit

A short occurs when two nets that should remain separate become unintentionally connected.

Possible consequences include:

* Incorrect logic values
* Excessive current
* Functional failure
* Power-to-ground paths
* Reliability damage

Therefore:

`Short = Separate Nets Are Accidentally Connected`

---

## 27. Legal Crossing

Two nets can cross legally if:

* They are on different metal layers.
* No via connects them.
* Required spacing and enclosure rules are satisfied.

A crossing in the top view does not necessarily indicate a short.

---

## 28. Design Rule Check

DRC stands for:

`Design Rule Check`

DRC verifies whether physical geometry satisfies manufacturing rules.

Routing-related DRC categories include:

* Minimum width
* Minimum spacing
* Via enclosure
* Via spacing
* End-of-line spacing
* Parallel-run spacing
* Minimum metal area
* Via-stack restrictions
* Metal density

A route may be electrically connected but still fail DRC.

Therefore:

`Connected ≠ Manufacturable`

---

## 29. Minimum Width Violation

A minimum-width violation occurs when a wire is narrower than the process permits.

Possible effects include:

* Manufacturing difficulty
* Excessive resistance
* Poor reliability
* Possible wire breakage

---

## 30. Minimum Spacing Violation

A minimum-spacing violation occurs when neighboring metal shapes are too close.

Possible effects include:

* Manufacturing shorts
* Excessive coupling
* Crosstalk
* Reliability problems

---

## 31. Minimum Area Violation

A metal shape may satisfy minimum width but still be too short.

If its total area is below the required minimum, it has a minimum-area violation.

A common fix is:

* Extend the metal shape
* Add a metal patch

A minimum-area violation is not a spacing violation.

---

## 32. Pin Access

Pin access is the detailed router’s ability to create a legal physical connection to a cell or macro pin.

Pin access must satisfy:

* Track alignment
* Layer rules
* Via rules
* Enclosure rules
* Spacing rules
* Obstruction rules

A visible physical pin may still be inaccessible.

Therefore:

`Visible Pin ≠ Legally Accessible Pin`

---

## 33. Standard-Cell Pin Access

Standard-cell pin access can be difficult because of:

* Dense neighboring cells
* Nearby power rails
* Limited routing tracks
* Closely spaced pins
* Existing signal wires
* Limited via locations

A route may need to:

* Approach from another direction
* Use another track
* Use a different via
* Reroute a neighboring net
* Spread nearby cells

---

## 34. Macro Pin Access

Macro pins may be difficult to access because macros often:

* Block lower metal layers
* Allow pins only on specific edges
* Require access from specific layers
* Concentrate many pins in small areas
* Have power rings around their boundaries
* Create narrow channels

Possible fixes include:

* Macro movement
* Macro rotation
* Wider channels
* Pin reassignment
* Layer reassignment
* Routing blockages

---

## 35. Placement and Pin Access

Poor placement can put cells and pins too close together.

This may leave insufficient space for:

* Routing tracks
* Vias
* Legal spacing
* Pin entry

Therefore:

`Poor Placement → High Pin Density → Poor Pin Access → DRC Violations or Opens`

Routing problems may require placement changes.

---

## 36. Routing Demand

Routing demand is the routing resource required by nets passing through a region.

It depends on:

* Number of nets
* Net directions
* Wire width
* Spacing
* Via requirements
* Bus width
* Pin density
* Clock and power structures

---

## 37. Routing Capacity

Routing capacity is the legal routing resource available in a region.

It depends on:

* Number of available tracks
* Metal layers
* Blockages
* Power stripes
* Clock routes
* Macros
* Track pitch
* Design-rule restrictions

---

## 38. Routing Overflow

Routing overflow occurs when demand exceeds capacity.

`Overflow = Demand − Capacity`

Example:

* Demand = `180`
* Capacity = `145`

Then:

`Overflow = 35`

Overflow indicates that the region needs more routing resources than are available.

---

## 39. Routing Congestion

Routing congestion occurs when demand approaches or exceeds capacity.

Congestion may cause:

* Long detours
* More vias
* Increased delay
* Higher capacitance
* Difficult pin access
* DRC violations
* Unrouted nets
* Routing failure

---

## 40. Common Congestion Hot Spots

Congestion commonly occurs near:

* Macro corners
* Narrow channels
* High-density standard-cell regions
* High-pin-density regions
* Power stripes
* Clock routes
* Large buses
* Highly connected logic blocks

---

## 41. Macro Corner Congestion

Macro corners are common hot spots because:

* The macro blocks routing through its interior.
* Nets have fewer escape directions.
* Many routes must turn around the same corner.
* Routing tracks become concentrated in a limited area.
* Power rings and blockages may occupy nearby space.

The issue is not that the macro corner has fewer pins.

The main issue is concentrated routing demand around an obstacle.

---

## 42. Cell Density and Congestion

Higher placement density usually creates:

* More cells per unit area
* More pins per unit area
* More nets
* Less whitespace
* Less room for vias and routing

Therefore:

`Cell Density ↑ → Pin Density ↑ → Routing Demand ↑ → Congestion Risk ↑`

Low density alone does not guarantee routability because macro placement, pin location, and power routing also matter.

---

## 43. Directional Congestion

Congestion may differ by direction.

Example:

* Horizontal demand exceeds horizontal capacity.
* Vertical capacity remains available.

The router may respond by:

* Changing layers
* Adding vias
* Using a detour
* Moving through another region

---

## 44. Congestion Fixes

Possible congestion fixes include:

* Cell spreading
* Lower placement density
* Macro movement
* Macro rotation
* Wider channels
* Layer reassignment
* Net rerouting
* Buffer movement
* Routing blockages
* Logic restructuring

Each fix may affect timing, area, power, or routability elsewhere.

---

## 45. Cell Spreading Tradeoff

Cell spreading creates more whitespace and improves pin access.

However:

`Cells Farther Apart → Wirelength ↑ → R and C ↑ → Delay ↑`

Therefore, cell spreading may reduce congestion while worsening timing.

---

## 46. Timing-Aware Routing

Modern routing is timing-aware.

The router prioritizes nets according to timing criticality.

A critical net may receive:

* Shorter routing
* Lower-resistance metal
* Fewer detours
* Controlled via count
* More spacing
* Higher routing priority

A non-critical net may be allowed to take a longer detour.

---

## 47. Critical Net

A critical net is a net whose delay significantly affects the slack of a timing-critical path.

Slack is normally associated with an entire timing path, not an isolated net.

A net becomes critical because its delay contributes strongly to path timing.

---

## 48. Non-Critical Net

A non-critical net has sufficient positive slack.

The router may detour it to:

* Reduce congestion
* Protect critical routing resources
* Avoid blockages
* Improve overall routability

The detour may increase the non-critical net’s delay, but the available slack can tolerate it.

---

## 49. Wire Resistance and Capacitance

Routed wires introduce parasitic resistance and capacitance.

Longer wires generally have:

* More resistance
* More ground capacitance
* More coupling capacitance
* More delay
* More dynamic power

Therefore:

`Wirelength ↑ → R ↑ and C ↑ → Delay Generally ↑`

---

## 50. Upper Metal for Critical Nets

Upper metal layers are often:

* Wider
* Thicker
* Lower in resistance per unit length

Therefore, they are useful for long timing-critical nets.

The metal layer itself does not have drive strength.

Drive strength is a property of the driving cell or buffer.

---

## 51. Setup-Critical Routing

A setup-critical path needs lower maximum data delay.

Possible routing treatment includes:

* Shorter routes
* Lower-resistance metal
* Fewer detours
* Buffer insertion
* Driver upsizing
* Reduced coupling
* Controlled via count

---

## 52. Hold-Critical Routing

A hold-critical path has data arriving too early.

Possible fixes include:

* Hold-fix buffer
* Delay cell
* Controlled routing detour
* Cell downsizing
* Useful-skew adjustment

Cell-based delay insertion is often more predictable than relying only on route length.

---

## 53. Pre-Route versus Post-Route Timing

Before routing, interconnect delay is estimated using:

* HPWL
* Global-routing estimates
* Statistical wire models
* Approximate layers
* Estimated congestion

After routing, timing uses:

* Actual wirelength
* Actual metal layers
* Actual vias
* Extracted resistance
* Extracted capacitance
* Coupling effects

Therefore:

`Pre-Route Timing Clean ≠ Guaranteed Post-Route Timing Clean`

---

## 54. Crosstalk

Crosstalk occurs when switching on one net affects a nearby net through coupling capacitance.

The disturbing net is the aggressor.

The affected net is the victim.

The nets are not physically shorted.

Their interaction occurs through the electric field between nearby conductors.

---

## 55. Coupling Capacitance

Coupling capacitance generally increases with:

* Smaller spacing
* Longer parallel run length
* Larger facing metal surfaces
* Faster aggressor transitions

Therefore:

`Smaller Spacing + Longer Parallel Run → Greater Coupling → Higher Crosstalk Risk`

---

## 56. Crosstalk Noise

If an aggressor switches while the victim should remain stable, the victim may experience a temporary voltage pulse.

Possible consequences include:

* Noise
* Glitches
* False switching
* Functional failure

---

## 57. Crosstalk Delay

Crosstalk may change victim-net delay.

If aggressor and victim switch in opposite directions, the victim may become slower.

If they switch in the same direction, the victim may become faster.

This behavior is often explained using the Miller effect.

---

## 58. Crosstalk and Setup

If crosstalk slows the data path:

`Data Delay ↑ → Data Arrives Later → Setup Slack ↓`

This may create or worsen a setup violation.

---

## 59. Crosstalk and Hold

If crosstalk speeds up the data path:

`Data Delay ↓ → New Data Arrives Earlier → Hold Slack ↓`

This may create or worsen a hold violation.

---

## 60. Crosstalk Reduction

Possible physical fixes include:

* Increase spacing
* Reduce parallel run length
* Change routing layers
* Add VDD or VSS shielding
* Reroute one net
* Use a stronger driver
* Insert buffers

These fixes consume additional routing, area, or power resources.

---

## 61. Signal Integrity

Signal integrity describes whether a signal maintains acceptable electrical behavior while traveling through interconnect.

Signal-integrity problems include:

* Crosstalk noise
* Crosstalk delay
* Slow transition
* Glitches
* Excessive coupling
* Clock disturbance

A route may be connected and DRC-clean but still have signal-integrity risk.

---

## 62. SI-Aware Timing Analysis

SI stands for:

`Signal Integrity`

SI-aware timing analysis includes coupling and aggressor-switching effects.

It evaluates:

* Crosstalk slowdown
* Crosstalk speedup
* Noise violations
* Transition degradation
* Setup impact
* Hold impact

---

## 63. Antenna Effect

The antenna effect is a fabrication-stage reliability problem.

During plasma processing, a long metal wire connected to a MOS gate may collect charge.

The accumulated charge may create excessive voltage across the thin gate oxide.

Therefore:

`Collected Plasma Charge → High Gate Voltage → Gate-Oxide Damage`

The antenna effect is not related to radio-frequency signal reception.

---

## 64. Gate-Oxide Risk

The physical structure at risk is the thin transistor gate oxide.

The gate is insulated and may temporarily lack a safe discharge path during intermediate manufacturing steps.

A large metal structure connected to a small gate can collect excessive charge.

---

## 65. Antenna Ratio

A simplified antenna ratio is:

`Antenna Ratio ≈ Exposed Metal Area / Gate Area`

A larger exposed metal area and smaller gate area produce a larger antenna ratio.

Actual foundry rules may include:

* Metal area
* Metal perimeter
* Via area
* Layer-specific rules
* Cumulative ratios

---

## 66. Antenna Diode

An antenna diode provides a safe charge-discharge path.

Its purpose is to protect the transistor gate oxide.

Benefits:

* Reduces antenna risk
* Provides controlled charge discharge

Costs:

* Additional area
* Additional capacitance
* More routing demand
* Possible timing impact

---

## 67. Layer Jumping

Layer jumping moves a long portion of a route to a higher metal layer.

Example:

`Gate → Short Lower-Metal Segment → Via → Long Upper-Metal Segment`

This reduces the amount of early-fabricated lower metal directly connected to the gate.

Layer jumping may avoid adding an antenna diode, but it uses vias and upper-layer resources.

---

## 68. Electromigration

Electromigration, abbreviated as EM, is the gradual movement of metal atoms caused by high current density during chip operation.

Unlike antenna damage, EM occurs during long-term normal operation.

```text id="8k0zls"
High Current Density
→ Metal-Atom Movement
→ Wire or Via Degradation
```

---

## 69. Current Density

A simplified current-density relationship is:

`Current Density = Current / Cross-Sectional Area`

For the same current:

`Wire Area ↓ → Current Density ↑ → EM Risk ↑`

---

## 70. Void and Hillock

### Void

A void is a region where metal atoms move away.

Possible results:

* Increased resistance
* Open circuit
* Complete wire failure

### Hillock

A hillock is a region where metal atoms accumulate.

Possible results:

* Metal protrusion
* Short circuit
* Spacing violation

---

## 71. Via Electromigration

A single via may carry excessive current density.

Multi-cut and redundant vias distribute current across several openings.

Therefore:

`More Parallel Via Cuts → Lower Current Density per Cut → Better EM Reliability`

---

## 72. Temperature and Electromigration

Higher temperature generally accelerates metal-atom movement.

Therefore:

`Current Density ↑ + Temperature ↑ → EM Risk ↑`

High-current and high-temperature regions require careful routing.

---

## 73. Electromigration Fixes

Common EM fixes include:

* Increase wire width
* Use thicker metal
* Add parallel wires
* Add multi-cut vias
* Add redundant vias
* Reduce current
* Reduce temperature
* Strengthen power connections

---

## 74. IR Drop

IR drop is the voltage loss that occurs when current flows through resistance.

The basic relationship is:

`Vdrop = I × R`

Example:

* Supply voltage = `1.0 V`
* IR drop = `0.1 V`
* Cell voltage = `0.9 V`

---

## 75. IR Drop and Timing

Lower cell supply voltage reduces transistor drive current.

Therefore:

`Supply Voltage ↓ → Drive Strength ↓ → Cell Delay ↑ → Timing Risk ↑`

Excessive IR drop may cause:

* Slow cells
* Slow transitions
* Setup violations
* Functional failure

---

## 76. Static IR Drop

Static IR drop is based on average or steady current flow through the resistive power network.

It evaluates:

* Average cell current
* Power-grid resistance
* Macro current
* Long-term current distribution

---

## 77. Dynamic IR Drop

Dynamic IR drop is temporary voltage droop caused by sudden switching current.

Example:

`Many Cells Switch Together → Instantaneous Current ↑ → Temporary Voltage Droop ↑`

Dynamic IR drop is especially important near clock edges and high-activity regions.

---

## 78. Power Distribution Path

A simplified power path is:

`Power Pads → Power Rings → Power Stripes → Standard-Cell Rails → Cell Power Pins`

Each segment contributes resistance.

Cells far from strong power connections may experience greater voltage drop.

---

## 79. IR-Drop Fixes

Possible fixes include:

* Wider power stripes
* Additional power stripes
* More power vias
* Denser via arrays
* Lower local cell density
* Better pad distribution
* Decap insertion
* Improved package power delivery

---

## 80. Decoupling Capacitor

A decoupling capacitor, or decap, stores charge near active logic.

During a sudden current demand:

`Local Current Demand → Decap Releases Charge → Voltage Droop Reduced`

Costs include:

* Placement area
* Leakage power
* Reduced logic-placement space

---

## 81. IR Drop versus Electromigration

### IR Drop

Main issue:

* Voltage loss

Main effect:

* Cells receive insufficient supply voltage

### Electromigration

Main issue:

* Excessive current density

Main effect:

* Metal and vias degrade over time

A narrow power wire can suffer from both high resistance and high current density.

---

## 82. Power Integrity versus Routability

Adding more power stripes improves:

* IR drop
* EM reliability
* Current distribution

However, power stripes consume routing tracks.

Therefore:

`Stronger Power Grid → Better Power Integrity → Less Signal-Routing Capacity`

Power design and signal routing must be optimized together.

---

## 83. Parasitics

Physical interconnect introduces parasitic:

* Wire resistance
* Via resistance
* Ground capacitance
* Coupling capacitance

These affect:

* Delay
* Slew
* Dynamic power
* Setup timing
* Hold timing
* Crosstalk

---

## 84. Wire Resistance

A simplified wire-resistance relationship is:

`R = ρL / A`

where:

* `ρ` is resistivity
* `L` is wire length
* `A` is cross-sectional area

Therefore:

* Longer wire increases resistance.
* Wider or thicker wire decreases resistance.

---

## 85. Ground Capacitance

A wire has capacitance relative to substrate and reference conductors.

The driver must charge and discharge this capacitance.

Therefore:

`Capacitance ↑ → Transition Slower → Delay and Dynamic Power ↑`

---

## 86. Coupling Capacitance

Coupling capacitance exists between neighboring signal wires.

Its effect depends on how the neighboring nets switch.

It is the main physical source of crosstalk.

---

## 87. RC Delay

A simplified interconnect-delay relationship is:

`Delay ∝ R × C`

For long interconnects, resistance and capacitance are distributed along the route.

A single lumped resistor and capacitor may not accurately represent the net.

---

## 88. Distributed RC Network

A routed net may be modeled as multiple resistance and capacitance segments.

Example:

`Driver → R1 → Node → R2 → Node → R3 → Load`

Capacitances are attached at intermediate nodes.

This model improves estimation of:

* Delay
* Slew
* Noise
* Branch behavior

---

## 89. Parasitic Extraction

Parasitic extraction calculates resistance and capacitance from actual physical geometry.

The extraction tool analyzes:

* Actual wirelength
* Metal layers
* Wire width
* Wire spacing
* Via count
* Neighboring geometry
* Dielectric properties

---

## 90. SPEF

SPEF stands for:

`Standard Parasitic Exchange Format`

A SPEF file may contain:

* Distributed resistance
* Via resistance
* Ground capacitance
* Coupling capacitance
* Net connectivity
* Total net capacitance

---

## 91. Post-Route STA Inputs

A simplified post-route STA flow uses:

`Gate-Level Netlist + .lib + SDC + SPEF → Post-Route STA`

The roles are:

* Netlist: cells and logical connectivity
* `.lib`: cell timing models
* SDC: clocks and timing constraints
* SPEF: extracted interconnect parasitics

---

## 92. RC Extraction Corners

Resistance and capacitance vary across process conditions.

Extraction may use:

* High-resistance corners
* Low-resistance corners
* High-capacitance corners
* Low-capacitance corners
* Combined RC corners

The worst setup corner may differ from the worst hold corner.

---

## 93. DRC versus Parasitic Extraction

DRC checks geometry.

Parasitic extraction calculates electrical properties.

A design may be:

* DRC-clean but timing-failing
* Timing-clean but DRC-failing

Both checks are required.

---

## 94. Post-Route Optimization

Post-route optimization repairs violations discovered after actual parasitics are extracted.

Possible violations include:

* Setup violations
* Hold violations
* Maximum-transition violations
* Maximum-capacitance violations
* Crosstalk problems
* DRC problems
* Power-integrity problems

---

## 95. Setup Violation

A setup violation means data arrives too late.

Typical causes include:

* Long wire
* High resistance
* Large capacitance
* Excessive detour
* Too many vias
* Weak driver
* Crosstalk slowdown

---

## 96. Setup Fixes

Possible setup fixes include:

* Cell upsizing
* Buffer insertion
* Shorter routing
* Lower-resistance metal
* Reduced via count
* Cell movement
* Logic restructuring
* Reduced coupling

The objective is to reduce maximum data-path delay.

---

## 97. Buffer Insertion on a Long Wire

A long wire behaves like a distributed RC network.

Before buffer insertion:

`Driver → Long RC Wire → Load`

After buffer insertion:

`Driver → Shorter Wire → Buffer → Shorter Wire → Load`

The buffer adds cell delay but divides the long RC load into smaller segments.

If the original wire is sufficiently long, the total path delay may decrease.

---

## 98. Hold Violation

A hold violation means new data arrives too early.

Possible fixes include:

* Hold-fix buffer
* Delay cell
* Cell downsizing
* Controlled routing detour
* Useful-skew adjustment

The objective is to increase minimum data-path delay.

---

## 99. Setup and Hold Interaction

Setup fixes usually make the path faster.

Hold fixes usually make the path slower.

Therefore:

`Setup Fix → Recheck Hold`

`Hold Fix → Recheck Setup`

Timing closure is iterative.

---

## 100. Maximum Transition

A maximum-transition violation means a signal edge is too slow.

Possible causes:

* Weak driver
* High fanout
* Large capacitance
* Long wire
* High resistance

Possible fixes:

* Upsize the driver
* Insert a buffer
* Split the load
* Shorten the route
* Use lower-resistance metal

---

## 101. Maximum Capacitance

A maximum-capacitance violation means the load connected to a driver exceeds its allowed limit.

Possible fixes include:

* Buffer insertion
* Load splitting
* Shorter wire
* Reduced coupling
* Layer reassignment
* Stronger driver, when permitted

A stronger driver may tolerate more capacitance but does not remove the physical capacitance.

---

## 102. ECO

ECO stands for:

`Engineering Change Order`

An ECO is a small incremental design modification.

Examples include:

* Cell resizing
* Buffer insertion
* Delay-cell insertion
* Cell movement
* Net rerouting
* Logic-equivalent replacement

The goal is to fix local violations without rebuilding the entire design.

---

## 103. Spare Cells

Spare cells are unused cells distributed through the design before routing.

Examples include:

* Buffers
* Inverters
* NAND gates
* NOR gates
* Flip-flops

They can support late-stage ECOs with less placement disturbance.

---

## 104. Metal-Only ECO

A metal-only ECO changes only interconnect layers while leaving transistor and base-layer structures unchanged.

It may use spare cells that already exist in the layout.

Advantages:

* Lower mask-change cost
* Shorter turnaround
* Less physical disturbance

Limitations:

* Limited spare resources
* Restricted logic changes
* Limited routing flexibility

---

## 105. ECO Side Effects

A local fix may create new problems.

Example:

`Insert Buffer → Setup Improves → Power and Congestion Increase`

Example:

`Widen Wire → Resistance Decreases → Spacing Demand Increases`

Therefore, every ECO must be fully reverified.

---

## 106. Checks after an ECO

After an ECO, engineers must recheck:

* Setup timing
* Hold timing
* Maximum transition
* Maximum capacitance
* DRC
* Connectivity
* LVS
* Crosstalk
* Antenna
* EM
* IR drop
* Placement legality
* Congestion
* MMMC scenarios

---

## 107. Routing Closure

Routing closure means that the routed design satisfies all required:

* Connectivity
* DRC
* Timing
* Electrical rules
* Signal integrity
* Antenna rules
* Electromigration limits
* IR-drop limits
* Physical legality
* Manufacturability

Therefore:

`All Nets Routed ≠ Routing Closure`

---

## 108. Connectivity Closure

Connectivity closure requires:

* No unrouted nets
* No opens
* No shorts
* Correct pin connections

Connectivity may be checked using router checks, LVS, or extracted-netlist comparison.

---

## 109. DRC Closure

DRC closure requires all required manufacturing geometry rules to pass.

A design with unresolved critical DRC violations is not ready for tapeout.

---

## 110. Timing Closure

Post-route timing closure normally requires:

* Setup WNS greater than or equal to zero
* Setup TNS equal to zero
* Hold WNS greater than or equal to zero
* Hold TNS equal to zero

Timing must pass across all required:

* Modes
* PVT corners
* RC corners
* Clock scenarios
* Variation conditions

---

## 111. Electrical-Rule Closure

The routed design must also satisfy:

* Maximum transition
* Maximum capacitance
* Maximum fanout
* Driver-load rules
* Other library electrical limits

A design may have positive slack but still fail an electrical rule.

---

## 112. Signal-Integrity Closure

Signal-integrity closure verifies that coupling does not cause unacceptable:

* Noise
* Crosstalk slowdown
* Crosstalk speedup
* Clock disturbance
* Setup degradation
* Hold degradation

---

## 113. Antenna Closure

Antenna closure requires all antenna ratios and layer-specific antenna rules to pass.

Common fixes include:

* Antenna diodes
* Layer jumping
* Route restructuring
* Additional vias

---

## 114. EM Closure

EM closure verifies that current density remains within reliability limits for:

* Signal wires
* Clock wires
* Power wires
* Ground wires
* Vias
* Macro connections

---

## 115. IR-Drop Closure

IR-drop closure verifies that cells receive sufficient supply voltage under required operating conditions.

It includes:

* Static IR analysis
* Dynamic IR analysis
* Voltage-droop analysis
* Power-grid resistance analysis

---

## 116. Metal Density and Fill

Foundries require acceptable metal density for manufacturing uniformity.

Dummy metal fill may be inserted in low-density regions.

Metal fill does not normally carry functional signals, but it may add:

* Ground capacitance
* Coupling capacitance
* Crosstalk
* Timing delay

After metal-fill insertion, the flow may repeat:

* Parasitic extraction
* STA
* Signal-integrity analysis

---

## 117. LVS

LVS stands for:

`Layout Versus Schematic`

LVS compares the electrical connectivity extracted from the physical layout against the intended circuit netlist.

It checks:

* Devices
* Connections
* Pins
* Nets
* Power connections

---

## 118. DRC versus LVS

DRC asks:

> Is the geometry manufacturable?

LVS asks:

> Does the physical layout implement the intended circuit?

A design may:

* Pass DRC and fail LVS.
* Pass LVS and fail DRC.

Both are required.

---

## 119. Routing Closure Loop

A typical routing-closure loop is:

`Global Routing`

`→ Congestion Analysis`

`→ Detailed Routing`

`→ Connectivity Check`

`→ DRC Repair`

`→ Antenna Repair`

`→ Parasitic Extraction`

`→ Post-Route STA`

`→ SI Analysis`

`→ Setup and Hold ECO`

`→ EM and IR Analysis`

`→ Metal Fill`

`→ Final Extraction`

`→ DRC and LVS Signoff`

`→ Routing Closure`

The loop may repeat multiple times.

---

## 120. Routing Quality Checklist

### Connectivity

* No unrouted nets
* No opens
* No shorts
* Correct pin connectivity

### Geometry

* Minimum width clean
* Minimum spacing clean
* Via enclosure clean
* Via spacing clean
* Minimum area clean
* Metal density acceptable

### Timing

* Setup WNS acceptable
* Setup TNS acceptable
* Hold WNS acceptable
* Hold TNS acceptable
* All required MMMC scenarios clean

### Electrical Rules

* Maximum transition clean
* Maximum capacitance clean
* Fanout clean
* Driver-load rules clean

### Signal Integrity

* Crosstalk noise acceptable
* Crosstalk delay acceptable
* Clock integrity acceptable

### Reliability

* Antenna clean
* Electromigration clean
* Via-current limits clean

### Power Integrity

* Static IR drop acceptable
* Dynamic IR drop acceptable
* Voltage droop acceptable

### Verification

* DRC clean
* LVS clean
* Post-fill extraction complete
* Final STA complete

---

## 121. Complete Routing Flow

`CTS-Completed Design`

`→ Read Routing Constraints`

`→ Build Global-Routing Grid`

`→ Estimate Demand and Capacity`

`→ Analyze Congestion`

`→ Assign Approximate Net Paths`

`→ Perform Detailed Routing`

`→ Resolve Pin Access`

`→ Insert Vias and Layer Changes`

`→ Repair Opens and Shorts`

`→ Repair DRC Violations`

`→ Repair Antenna Violations`

`→ Extract Parasitics`

`→ Perform Post-Route STA`

`→ Perform SI Analysis`

`→ Optimize Setup and Hold`

`→ Check EM and IR Drop`

`→ Insert Metal Fill`

`→ Repeat Extraction and Timing`

`→ Run Final DRC and LVS`

`→ Achieve Routing Closure`

---

## 122. Key Concepts

### Routing

The physical design stage that creates metal wires and vias for logical nets.

### Logical Net

A required electrical connection between pins.

### Routed Wire

The physical metal implementation of a net.

### Global Routing

Approximate path planning and congestion estimation.

### Detailed Routing

Exact legal wire, via, track, and pin-access implementation.

### Routing Track

A predefined legal path for a wire centerline.

### Wire Width

The physical width of a metal segment.

### Wire Spacing

The edge-to-edge distance between neighboring metal shapes.

### Routing Pitch

The center-to-center distance between adjacent routing tracks.

### Via

A vertical conductor connecting adjacent metal layers.

### Via Enclosure

The required metal extension around a via.

### Open

A missing required connection.

### Short

An unintended connection between separate nets.

### DRC

Design Rule Check for manufacturing geometry.

### Pin Access

The router’s ability to legally connect to a physical pin.

### Routing Demand

The routing resources required in a region.

### Routing Capacity

The legal routing resources available in a region.

### Routing Overflow

The amount by which demand exceeds capacity.

### Critical Net

A net whose delay significantly affects timing-path slack.

### Aggressor

A net that causes coupling disturbance.

### Victim

A net affected by coupling disturbance.

### Antenna Effect

Fabrication-stage gate-oxide damage risk caused by plasma-charge collection.

### Electromigration

Long-term metal-atom movement caused by high current density.

### IR Drop

Voltage loss caused by current flowing through power-grid resistance.

### SPEF

Standard Parasitic Exchange Format.

### ECO

Engineering Change Order.

### LVS

Layout Versus Schematic.

### Routing Closure

Completion of connectivity, geometry, timing, signal-integrity, reliability, and power-integrity requirements.

---

## 123. Final Summary

Routing converts logical netlist connections into exact physical metal wires and vias.

The routing process includes:

* Global routing
* Detailed routing
* Track assignment
* Layer assignment
* Via insertion
* Pin-access resolution
* Congestion management
* DRC repair
* Timing-aware optimization
* Crosstalk analysis
* Antenna repair
* EM and IR-drop verification
* Parasitic extraction
* Post-route STA
* ECO optimization
* DRC and LVS signoff

A routed design is not complete simply because every net has a wire.

True routing closure requires acceptable:

* Connectivity
* Manufacturability
* Setup timing
* Hold timing
* Electrical rules
* Signal integrity
* Antenna behavior
* Electromigration reliability
* Power integrity
* Physical verification

Routing is therefore a multi-objective optimization and closure process that connects physical implementation directly to timing, power, reliability, and manufacturability.
