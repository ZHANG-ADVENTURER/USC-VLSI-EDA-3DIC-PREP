# Day 28 Daily Log

## Topic

Clock Tree Synthesis in the ASIC Physical Design Flow

## What I Learned

Today I learned how Clock Tree Synthesis converts an ideal or estimated clock into a real physical clock-distribution network.

Before CTS, the clock is usually modeled using ideal or estimated latency and skew.

After CTS, the design contains actual:

* Clock buffers
* Clock inverters
* Clock branches
* Clock-gating cells
* Clock routing
* Clock-network parasitics

I learned that CTS does not simply minimize clock delay. It must balance multiple objectives, including:

* Clock skew
* Clock latency
* Clock transition
* Clock fanout
* Clock capacitance
* Setup timing
* Hold timing
* Clock power
* Congestion
* Physical legality

I also studied how the clock network affects timing after placement and why a design that passes pre-CTS timing may fail post-CTS timing.

## What I Built

I created a complete Clock Tree Synthesis study module that explains:

* Why a physical clock tree is required
* How clock buffers divide large fanout
* How clock latency and skew are defined
* How positive and negative skew affect setup and hold timing
* How CTS balances clock branches
* How clock routing is protected using NDR and shielding
* How clock gating reduces dynamic power
* How post-CTS timing and physical checks are performed
* How CTS is analyzed across PVT corners and operating modes

The documentation structure is:

`02_physical_design_notes/05_clock_tree_synthesis/`

with:

* `notes/clock_tree_synthesis.md`
* `README.md`

## Produced

* Complete English Clock Tree Synthesis notes
* Clock Tree Synthesis project README
* Clock-source, root, and sink definitions
* Clock latency and skew calculation examples
* Positive-skew and negative-skew analysis
* Clock uncertainty and jitter explanations
* Clock-tree balancing examples
* Clock routing and NDR explanations
* Clock-gating and ICG explanations
* Post-CTS setup and hold optimization framework
* MMMC, OCV, and CRPR summaries
* Complete CTS quality checklist

## Key Concepts

### Clock Tree Synthesis

Clock Tree Synthesis is the physical design stage that builds the physical clock-distribution network after placement.

### Clock Source

The clock source is the original point where the clock is generated or enters the design.

Typical examples include:

* PLL
* Oscillator
* External clock port
* Internal clock generator

### Clock Root

The clock root is the point from which CTS begins building the clock tree.

### Clock Sink

A clock sink is an endpoint pin that must receive the clock signal.

Typical clock sinks include:

* Flip-flop clock pins
* Latch clock pins
* Memory clock pins
* Clock-gating cell clock pins

### Clock Buffer

A clock buffer drives clock branches, distributes clock load, controls fanout, improves transition, and helps balance clock arrival times.

### Clock Fanout

Clock fanout is the number of clock loads directly driven by one clock driver.

High fanout usually increases total load capacitance and worsens clock transition.

### Clock Transition

Clock transition, also called clock slew, describes how quickly the clock signal changes between logic levels.

Slow clock transition can cause:

* Larger delay
* Maximum-transition violations
* Higher short-circuit power
* Poor signal integrity

### Clock Latency

Clock latency is the time required for the clock to travel from its source to a clock sink.

### Source Latency

Source latency is the delay between the original clock source and the CTS clock-tree root.

### Network Latency

Network latency is the delay between the clock-tree root and a clock sink.

The relationship is:

`Total Clock Latency = Source Latency + Network Latency`

### Clock Skew

Clock skew is the difference in clock arrival time between two clock sinks.

For a register-to-register path:

`Clock Skew = Capture Clock Arrival − Launch Clock Arrival`

### Positive Clock Skew

Positive clock skew occurs when the capture clock arrives later than the launch clock.

It usually:

* Helps setup timing
* Hurts hold timing

### Negative Clock Skew

Negative clock skew occurs when the capture clock arrives earlier than the launch clock.

It usually:

* Hurts setup timing
* Helps hold timing

### Useful Skew

Useful skew is the intentional adjustment of clock arrival times to improve timing across the complete timing graph.

### Clock Uncertainty

Clock uncertainty is a timing margin used to account for imperfect clock behavior and modeling.

It may include:

* Jitter
* Estimated skew
* Process variation
* Voltage variation
* Temperature variation
* Modeling margin

### Clock Jitter

Clock jitter is the variation of clock edges over time.

The distinction is:

* Jitter compares different clock cycles.
* Skew compares different clock sinks.

### Clock Tree Balancing

Clock-tree balancing adjusts branch delays so that clock arrival times at different sinks are reasonably similar.

CTS may adjust:

* Buffer count
* Buffer size
* Wirelength
* Routing layers
* Branch topology
* Sink grouping
* Load distribution

### Clock Tree Topology

Clock-tree topology describes how clock buffers and branches are connected.

Common structures include:

* Hierarchical tree
* Balanced binary tree
* H-tree
* Clock mesh
* Hybrid tree-mesh network

### Clock Mesh

A clock mesh uses a connected metal grid to distribute the clock.

It can provide robust clock distribution and low local skew, but usually consumes significantly more routing resources and power than a clock tree.

### Clock Dynamic Power

Clock dynamic power depends strongly on clock-network capacitance and switching activity.

A simplified relationship is:

`Dynamic Power ∝ Capacitance × Voltage² × Frequency × Activity`

Because the clock toggles frequently, the clock network can consume a major portion of total chip power.

### Non-Default Rule

A Non-Default Rule, or NDR, applies special routing rules to selected nets.

A clock NDR may specify:

* Wider wire
* Larger spacing
* Special via rules
* Preferred upper metal layers

### Clock Shielding

Clock shielding places VDD or VSS wires near a clock net to reduce crosstalk from nearby signals.

Its benefits include:

* Better signal integrity
* Better crosstalk immunity
* More predictable delay

Its costs include:

* More routing-track usage
* Higher capacitance
* More congestion

### Crosstalk

Crosstalk occurs when switching activity on one net affects a nearby net through coupling capacitance.

The disturbing net is the aggressor.

The affected net is the victim.

### Clock Gating

Clock gating disables clock propagation to inactive logic blocks.

It reduces unnecessary switching activity and dynamic power.

### Integrated Clock-Gating Cell

An Integrated Clock-Gating cell, or ICG, safely controls clock propagation.

It usually contains:

* A latch
* Gating logic
* Optional test-enable logic

The latch prevents the enable signal from creating a partial clock pulse.

### Clock Glitch

A clock glitch is an unwanted narrow clock pulse.

It may occur if an ordinary combinational gate is used to gate a clock and the enable changes during an unsafe clock phase.

### Post-CTS Timing

Post-CTS timing includes more realistic:

* Clock latency
* Clock skew
* Clock transition
* Clock-tree parasitics

Setup and hold timing must be reanalyzed after CTS.

### Hold-Fix Buffer

A hold-fix buffer is inserted into a data path to increase minimum data delay.

It prevents new data from reaching the capture flip-flop too early.

### PVT Corner

PVT stands for:

* Process
* Voltage
* Temperature

Cell and wire delays change across PVT conditions.

### MMMC

MMMC stands for Multi-Mode Multi-Corner.

It analyzes the design across multiple:

* Functional modes
* Test modes
* Power modes
* PVT corners
* RC corners
* Clock configurations

### OCV

OCV stands for On-Chip Variation.

It models delay variation between different paths and physical regions within the same chip.

### CRPR

CRPR stands for Clock Reconvergence Pessimism Removal.

It removes artificial timing pessimism from shared portions of launch and capture clock paths.

### CTS Closure

CTS closure means that the clock network satisfies the required:

* Skew
* Latency
* Transition
* Fanout
* Capacitance
* Setup timing
* Hold timing
* Physical legality
* Congestion
* Power
* MMMC requirements

## Problems and Fixes

### Problem 1: Defining a Clock Sink Too Broadly

I initially described a clock sink only as the end of the clock network.

#### Fix

A clock sink is more precisely an endpoint clock pin that must receive the clock signal.

Examples include:

* Flip-flop clock pin
* Latch clock pin
* Memory clock pin

---

### Problem 2: Assuming High Fanout Increases Driver Resistance

I initially connected high fanout with increased resistance and capacitance.

#### Fix

High fanout mainly increases total load capacitance.

The driver’s effective output resistance already exists.

The larger capacitance takes longer to charge and discharge through that resistance.

The correct relationship is:

`High Fanout → Load Capacitance Increases → Clock Transition Becomes Slower`

---

### Problem 3: Describing Clock Skew as Intentional

I initially distinguished jitter and skew by saying jitter is unexpected while skew is intentional.

#### Fix

Clock skew is not necessarily intentional.

Clock skew is the arrival-time difference between clock sinks.

It may be:

* Unintentional because of unequal branches
* Intentionally adjusted as useful skew

Clock jitter is variation across different clock cycles.

---

### Problem 4: Confusing Clock Uncertainty with Jitter

I initially described clock uncertainty as the small timing variation itself.

#### Fix

Clock uncertainty is a timing margin used to cover several uncertain effects.

Clock jitter is one possible contributor to uncertainty.

Other contributors include:

* Estimated skew
* PVT variation
* Modeling margin

---

### Problem 5: Misunderstanding Positive Skew and Hold Timing

I initially explained that positive skew gives the logic less time to hold the signal.

#### Fix

Hold timing does not require combinational logic to actively hold the signal.

The real issue is that new data may arrive too early relative to the delayed capture clock edge.

Positive skew can therefore make hold timing more difficult.

---

### Problem 6: Assuming CTS Only Minimizes Delay

I initially treated shorter branches and lower delay as the main objective.

#### Fix

CTS does not simply make every branch as fast as possible.

It may intentionally add delay to a faster branch to reduce clock skew.

The goal is controlled and balanced clock arrival, not minimum branch delay.

---

### Problem 7: Assuming Balanced Branches Must Be Identical

I initially associated balancing with equal physical branch structures.

#### Fix

Balanced branches do not need identical:

* Wirelength
* Buffer count
* Buffer size
* Geometry

Different electrical structures may still produce similar clock arrival times.

---

### Problem 8: Using “Capacity” to Describe Upper Metal Layers

I initially said upper metal layers were preferred because they had better capacity.

#### Fix

Upper metal layers are commonly used because they are wider, thicker, and lower in resistance.

They are therefore more suitable for long-distance clock routing.

---

### Problem 9: Misunderstanding NDR

I initially interpreted NDR as using two nets or two routing layers.

#### Fix

NDR means Non-Default Rule.

It applies routing rules that differ from ordinary signal routing, such as:

* Wider wires
* Larger spacing
* Special via rules
* Preferred routing layers

---

### Problem 10: Assuming a Stronger Buffer Fixes Fanout

I learned that replacing a fanout-violating buffer with a stronger buffer may improve transition but does not reduce the number of connected sinks.

#### Fix

A fanout violation normally requires splitting the loads across multiple branches.

---

### Problem 11: Confusing Clock Buffers and Hold-Fix Buffers

Both cells may be buffers, but they have different locations and purposes.

#### Fix

A clock buffer is placed in the clock path to distribute the clock and control clock quality.

A hold-fix buffer is usually placed in the data path to increase minimum data delay.

---

### Problem 12: Assuming Pre-CTS Timing Closure Guarantees Post-CTS Closure

Before CTS, the clock is ideal or estimated.

After CTS, real clock-tree delays and skew are included.

#### Fix

Setup and hold timing must be analyzed again after CTS.

`Pre-CTS Clean ≠ Post-CTS Clean`

## Connection to VLSI / EDA / 3D IC

Clock Tree Synthesis is a critical part of digital VLSI physical implementation.

It connects logical timing constraints with physical clock-network construction.

A Physical Design Engineer must analyze:

* Clock-tree topology
* Clock-buffer placement
* Skew
* Latency
* Transition
* Fanout
* Setup timing
* Hold timing
* Clock power
* Congestion
* MMMC timing

CTS is strongly connected to EDA because CTS tools must solve a large constrained optimization problem.

They must choose:

* Buffer types
* Buffer sizes
* Buffer locations
* Sink groups
* Branch topology
* Routing layers
* Wire widths
* Wire spacing
* Shielding rules

These choices interact with:

* Timing
* Power
* Area
* Routability
* Physical legality
* PVT variation

CTS is also connected to Design Verification because clock gating, generated clocks, scan clocks, and multiple operating modes must match the intended functional behavior.

In 3D IC and chiplet systems, clock distribution becomes more complex because clock signals may cross:

* Dies
* Chiplets
* Interposers
* Micro-bump interfaces
* TSV structures

Additional challenges may include:

* Inter-die clock skew
* Different die process corners
* Package-level delay
* Thermal gradients
* Power-delivery variation
* Clock synchronization between chiplets

The same core principle remains valid:

> Every sequential element must receive a stable, controlled, and timing-correct clock signal.

## One Sentence Summary

Clock Tree Synthesis builds and optimizes the physical clock network while balancing skew, latency, transition, fanout, timing, power, congestion, and variation across all required operating scenarios.

## Next Step

Study routing, including:

* Logical nets and physical wires
* Global routing
* Detailed routing
* Metal layers
* Preferred routing directions
* Routing tracks
* Wire width
* Wire spacing
* Routing pitch
* Vias
* Opens and shorts
* Routing congestion
* Design Rule Check
* Signal integrity
* Post-route timing analysis
