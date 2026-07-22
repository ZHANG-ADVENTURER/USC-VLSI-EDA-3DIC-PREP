# Clock Tree Synthesis

## 1. Overview

Clock Tree Synthesis, commonly abbreviated as CTS, is the physical design stage that builds the physical clock-distribution network.

The simplified backend flow is:

`RTL → Synthesis → Floorplanning → Placement → CTS → Routing → Signoff`

Before CTS, the clock is usually treated as ideal or estimated.

After CTS, the design contains actual clock-network elements such as:

* Clock buffers
* Clock inverters
* Clock-gating cells
* Clock branches
* Clock routing
* Clock-tree parasitics

The main purpose of CTS is to deliver the clock signal to all required sequential elements with controlled:

* Clock skew
* Clock latency
* Clock transition
* Clock fanout
* Clock capacitance
* Clock power
* Routability

CTS does not simply minimize clock delay. It attempts to create a balanced, reliable, and physically implementable clock network.

---

## 2. Why a Clock Tree Is Necessary

A large digital design may contain thousands or millions of sequential elements.

A single clock source cannot directly drive every clock sink because the total load would be too large.

A direct connection would create:

* Very high fanout
* Large load capacitance
* Slow clock transition
* Large clock delay
* Poor signal integrity
* Excessive clock power
* Large clock-arrival differences

Before CTS:

`Clock Source → All Flip-Flops`

After CTS:

`Clock Source → Clock Buffers → Clock Branches → Clock Sinks`

A hierarchical buffer tree divides one large load into many smaller loads.

This improves:

* Fanout distribution
* Clock slew
* Clock delay
* Load balance
* Signal integrity
* Clock-arrival control

---

## 3. Clock Source, Clock Root, and Clock Sink

### Clock Source

The clock source is the original point where the clock is generated or enters the design.

Typical clock sources include:

* PLL
* Oscillator
* External clock pin
* Clock generator
* Output of another clock block

### Clock Root

The clock root is the point from which CTS begins building the clock tree.

The clock root may be:

* A top-level clock port
* A PLL output
* A generated-clock output
* An internal clock-control point

### Clock Sink

A clock sink is an endpoint pin that must receive the clock signal.

Typical clock sinks include:

* Flip-flop clock pins
* Latch clock pins
* Memory clock pins
* Clock-gating cell clock pins

A clock sink normally refers to the clock pin, not the entire sequential cell.

---

## 4. Clock Fanout

Clock fanout is the number of clock loads directly driven by one clock driver.

Example:

`CLK_BUF1 → FF1, FF2, FF3, FF4`

Then:

`Fanout of CLK_BUF1 = 4`

High fanout usually causes:

* Larger total load capacitance
* Slower clock transition
* Larger driver delay
* Higher dynamic power
* Poorer clock quality

High fanout mainly increases the total capacitance connected to the driver.

It does not directly increase the driver’s internal output resistance.

A simplified relationship is:

`Delay ∝ Driver Output Resistance × Load Capacitance`

CTS controls fanout by:

* Inserting additional clock buffers
* Dividing sinks into smaller groups
* Changing clock-tree topology
* Resizing clock buffers

---

## 5. Clock Slew

Clock slew, also called clock transition, describes how quickly the clock signal changes between logic levels.

A fast clock transition has a sharp edge.

A slow clock transition has a gradual edge.

Slow clock slew can cause:

* Larger cell delay
* Timing uncertainty
* Increased short-circuit power
* Signal-integrity problems
* Maximum-transition violations

Clock buffers improve slew by dividing a large load into smaller branch loads.

However, inserting unlimited buffers is not a valid solution.

Too many buffers increase:

* Area
* Dynamic power
* Leakage power
* Clock capacitance
* Clock latency
* Routing demand
* Placement complexity

CTS must balance clock slew against power, area, and routing cost.

---

## 6. Clock Latency

Clock latency is the time required for the clock signal to travel from its source to a clock sink.

If the clock leaves the source at `0 ns` and reaches a flip-flop clock pin at `0.8 ns`, then:

`Clock latency = 0.8 ns`

Different clock sinks may have different clock latencies.

Example:

* FF1 clock latency = `0.80 ns`
* FF2 clock latency = `0.92 ns`
* FF3 clock latency = `1.05 ns`

Clock latency can be divided into:

`Total Clock Latency = Source Latency + Network Latency`

---

## 7. Source Latency

Source latency is the delay from the original clock-generation point to the CTS clock-tree root.

Example:

`PLL → Clock-Tree Root`

If this path takes `0.4 ns`, then:

`Source latency = 0.4 ns`

Source latency may come from:

* PLL delay
* External package delay
* Input-clock path
* Upstream clock logic
* Clock-generation circuitry

CTS mainly controls the clock network after the tree root, not necessarily the full source latency.

---

## 8. Network Latency

Network latency is the delay from the clock-tree root to a clock sink.

It is caused by:

* Clock buffers
* Clock inverters
* Clock wires
* Vias
* Clock-tree parasitics

Example:

`Clock-Tree Root → Buffers → FF Clock Pin`

If this path takes `0.8 ns`, then:

`Network latency = 0.8 ns`

Network latency is also commonly associated with clock insertion delay.

---

## 9. Clock Skew

Clock skew is the difference in clock arrival time between two clock sinks.

For a register-to-register timing path:

`Clock Skew = Capture Clock Arrival − Launch Clock Arrival`

Example:

* Launch clock arrival = `0.8 ns`
* Capture clock arrival = `1.0 ns`

Then:

`Clock skew = 1.0 − 0.8 = +0.2 ns`

Clock latency refers to one clock path.

Clock skew compares two clock paths.

A clock tree may have large latency but small skew.

Example:

* FF1 arrival = `1.50 ns`
* FF2 arrival = `1.52 ns`

Then:

* Clock latency is approximately `1.5 ns`
* Clock skew is only `0.02 ns`

---

## 10. Positive Clock Skew

Positive clock skew occurs when the capture clock arrives later than the launch clock.

Example:

* Launch clock arrival = `0.8 ns`
* Capture clock arrival = `1.0 ns`

Then:

`Clock skew = +0.2 ns`

Positive skew usually:

* Helps setup timing
* Hurts hold timing

For setup, the capture edge arrives later, so the data path receives more propagation time.

For hold, the capture register requires the old data to remain stable until a later clock reference, which can make early-arriving new data more dangerous.

---

## 11. Negative Clock Skew

Negative clock skew occurs when the capture clock arrives earlier than the launch clock.

Example:

* Launch clock arrival = `1.0 ns`
* Capture clock arrival = `0.8 ns`

Then:

`Clock skew = −0.2 ns`

Negative skew usually:

* Hurts setup timing
* Helps hold timing

For setup, the available data-propagation time is reduced.

For hold, the capture timing reference occurs earlier, which may provide more margin against new data arriving too early.

---

## 12. Setup Timing with Skew

A simplified setup relationship is:

`Available Setup Time ≈ Clock Period + Clock Skew − Setup Time − Clock Uncertainty`

Positive skew increases the available setup time.

Negative skew decreases the available setup time.

Example:

* Clock period = `2.0 ns`
* Clock skew = `+0.2 ns`
* Setup time = `0.1 ns`
* Clock uncertainty = `0.1 ns`

Then:

`Available setup time = 2.0 + 0.2 − 0.1 − 0.1 = 2.0 ns`

Skew must be evaluated together with all other setup terms.

---

## 13. Hold Timing with Skew

Hold timing checks whether new data arrives too early.

A simplified interpretation is:

* Positive skew usually makes hold timing harder.
* Negative skew usually makes hold timing easier.

Positive skew delays the capture clock reference.

If new data propagates quickly, it may reach the capture register before the required hold window has been satisfied.

Hold timing is especially sensitive to:

* Very short data paths
* Fast process conditions
* Strong data drivers
* Small interconnect delay
* Unfavorable clock skew

---

## 14. Useful Skew

Useful skew is the intentional adjustment of clock arrival times to improve timing.

For example, delaying the capture clock of a critical setup path may improve setup slack.

However, one register may be:

* A capture register for one path
* A launch register for another path

Consider:

`FF1 → Logic A → FF2 → Logic B → FF3`

Delaying the clock at FF2 may:

* Help setup from FF1 to FF2
* Hurt setup from FF2 to FF3
* Create hold risk on another path

Useful skew must therefore be optimized across the full timing graph.

It does not mean creating unlimited or random skew.

---

## 15. Clock Uncertainty

Clock uncertainty is the timing margin reserved to account for imperfect clock behavior.

It may include:

* Clock jitter
* Estimated pre-CTS skew
* Process variation
* Voltage variation
* Temperature variation
* Modeling margin
* Clock-generation variation

Clock uncertainty is not the same as clock jitter.

Jitter is one possible contributor to uncertainty.

For setup timing:

`Uncertainty ↑ → Available setup time ↓`

For hold timing:

`Uncertainty ↑ → Required minimum delay ↑`

Increasing clock uncertainty makes timing closure more difficult because the timing requirements become more conservative.

---

## 16. Clock Jitter

Clock jitter is the variation of clock edges over time.

Example:

Expected edges:

* `2.00 ns`
* `4.00 ns`
* `6.00 ns`

Actual edges:

* `2.00 ns`
* `4.03 ns`
* `5.97 ns`

The clock period is not perfectly constant.

This variation is clock jitter.

The key distinction is:

* Jitter compares different clock cycles.
* Skew compares different clock sinks.

---

## 17. Pre-CTS and Post-CTS Timing

### Pre-CTS Timing

Before CTS:

* The real clock tree does not exist.
* Clock latency may be ideal or estimated.
* Clock skew may be assumed.
* Clock parasitics are not fully implemented.

### Post-CTS Timing

After CTS:

* Clock buffers are inserted.
* Clock branches have physical locations.
* Clock latency is more realistic.
* Clock skew can be measured.
* Clock transition can be checked.
* Clock-tree parasitics are included more accurately.

Therefore:

`Pre-CTS clean ≠ Post-CTS clean`

A design that passes timing before CTS may fail after CTS.

---

## 18. Clock Tree Balancing

Clock-tree balancing attempts to make clock arrival times at different sinks reasonably similar.

CTS may balance branches by adjusting:

* Buffer count
* Buffer size
* Wirelength
* Routing layer
* Sink grouping
* Branch topology
* Load distribution

A faster branch may intentionally receive an additional buffer.

This adds delay to the fast branch and reduces skew relative to a slower branch.

The objective is not to make every clock path as fast as possible.

The objective is to create controlled and balanced arrival times.

---

## 19. Balanced Electrical Behavior versus Identical Geometry

A balanced clock tree does not require every branch to have identical:

* Wirelength
* Buffer count
* Buffer size
* Physical shape

For example:

* Branch A may use a short wire and a small buffer.
* Branch B may use a long wire and a stronger buffer.

Both branches may still reach their sinks at approximately the same time.

CTS balances electrical delay, not visual symmetry.

---

## 20. Clock Tree Topology

Clock-tree topology describes how clock buffers and branches are connected.

A simple topology may be:

`Clock Root → Regional Buffers → Local Buffers → Clock Sinks`

Common structures include:

* Hierarchical clock tree
* Balanced binary tree
* H-tree
* Clock mesh
* Hybrid tree-mesh structure

Real designs are rarely perfectly symmetric because they contain:

* Macros
* Blockages
* Irregular sink distributions
* Power networks
* Congestion hot spots

---

## 21. H-Tree

An H-tree uses geometric symmetry to distribute the clock.

Its symmetric structure can help balance wirelength.

However, a perfect H-tree may be impractical because of:

* Macro placement
* Uneven sink distribution
* Routing blockages
* Power-grid interference
* Irregular core shape

H-trees are useful as a conceptual clock-distribution structure, but real EDA tools often generate more flexible topologies.

---

## 22. Clock Tree versus Clock Mesh

### Clock Tree

Advantages:

* Lower capacitance
* Lower power
* Lower routing usage
* Common implementation method

Disadvantages:

* More sensitive to branch variation
* Requires careful skew balancing

### Clock Mesh

Advantages:

* Strong clock distribution
* Lower sensitivity to local variation
* Potentially lower local skew

Disadvantages:

* Very high metal capacitance
* Very high clock power
* Large routing-resource usage
* More complex implementation

A clock mesh consumes high power because the entire metal grid must be charged and discharged every clock cycle.

---

## 23. Clock Dynamic Power

Clock networks have high switching activity.

A simplified dynamic-power relationship is:

`Dynamic Power ∝ Capacitance × Voltage² × Frequency × Activity`

Clock activity is typically high because the clock toggles continuously.

Clock power increases with:

* More clock buffers
* Larger clock buffers
* Longer clock wires
* Wider clock wires
* Higher clock capacitance
* Higher clock frequency
* Clock mesh usage

Clock power is therefore a major CTS optimization objective.

---

## 24. Clock Buffer Sizing

Clock libraries usually contain multiple buffer sizes.

Examples:

* `CLKBUF_X2`
* `CLKBUF_X4`
* `CLKBUF_X8`
* `CLKBUF_X16`

Upsizing a clock buffer may improve:

* Drive strength
* Clock transition
* Delay under heavy load

Possible costs include:

* Larger area
* Higher dynamic power
* Higher leakage power
* Larger input capacitance
* Higher upstream load

Upsizing one clock buffer can improve its output while making the previous stage slower.

Buffer sizing must therefore consider the entire clock tree.

---

## 25. Clock Buffer Insertion

Clock buffers are inserted to:

* Divide high fanout
* Improve slew
* Balance branch delay
* Drive long clock wires
* Control load distribution

A branch with excessive fanout may be split.

Before:

`CLK_BUF1 → 60 sinks`

After:

* `CLK_BUF1 → CLK_BUF2 → 30 sinks`
* `CLK_BUF1 → CLK_BUF3 → 30 sinks`

This reduces the direct fanout on the lower-level drivers.

Replacing a fanout-60 buffer with a stronger buffer may improve slew, but the fanout count remains 60.

Fanout violations normally require branch splitting.

---

## 26. Clock Routing

Clock nets receive special routing treatment because clock quality affects many timing paths.

Clock routing may use:

* Upper metal layers
* Wider wires
* Larger spacing
* Shielding
* Special via rules
* Multiple-cut vias
* Non-default routing rules

Clock routing attempts to control:

* Resistance
* Capacitance
* Crosstalk
* Delay variation
* Signal integrity
* Reliability

---

## 27. Upper Metal Layers

Clock nets are often routed on upper metal layers.

Upper layers are commonly:

* Wider
* Thicker
* Lower in resistance
* Better suited for long-distance routing

Lower resistance can improve:

* Clock delay
* Clock transition
* Signal integrity
* Variation tolerance

Upper metal layers are limited and valuable, so they must be allocated carefully among:

* Clock nets
* Power networks
* Long signal nets
* High-current nets

---

## 28. Non-Default Rules

NDR stands for:

`Non-Default Rule`

An NDR defines routing rules that differ from the default signal-routing rules.

Clock NDRs may specify:

* Wider wires
* Larger spacing
* Special routing layers
* Special via rules
* Multiple-cut vias

Example:

Default routing:

* Width = `1 unit`
* Spacing = `1 unit`

Clock NDR:

* Width = `2 units`
* Spacing = `2 units`

NDR does not mean using two nets or two layers.

It means using special routing constraints.

---

## 29. Wider Clock Wires

A wider clock wire generally has lower resistance.

Possible benefits:

* Lower RC delay
* Better slew
* Better reliability
* Better electromigration margin

Possible costs:

* More routing area
* Lower routing capacity for nearby nets
* Higher capacitance
* More congestion

Wider wires are a tradeoff, not a free improvement.

---

## 30. Larger Clock Spacing

Larger spacing reduces coupling capacitance between the clock and nearby signal nets.

This can reduce:

* Crosstalk noise
* Clock delay variation
* Transition degradation
* Jitter-like disturbance
* Signal-integrity risk

The cost is increased routing-resource usage.

---

## 31. Clock Shielding

Clock shielding places a stable VDD or VSS wire near the clock net.

Example:

* VSS shield
* Clock net
* VSS shield

Shielding can improve:

* Crosstalk immunity
* Signal integrity
* Clock stability
* Delay predictability

Possible costs include:

* More routing tracks
* Higher capacitance
* More routing congestion
* Increased implementation complexity

---

## 32. Crosstalk

Crosstalk occurs when switching on one net affects a nearby net through coupling capacitance.

The disturbing net is called the aggressor.

The affected net is called the victim.

For clock routing:

* Nearby data signal = aggressor
* Clock net = victim

Clock crosstalk may cause:

* Clock delay changes
* Transition degradation
* Noise pulses
* Increased uncertainty
* Setup degradation
* Hold degradation

Clock nets require stronger crosstalk protection because they serve as timing references.

---

## 33. Clock Gating

Clock gating disables the clock for inactive logic blocks.

Without clock gating:

`Clock → Register`

With clock gating:

`Clock → Integrated Clock-Gating Cell → Register`

Clock gating reduces:

* Unnecessary clock transitions
* Clock-network dynamic power
* Sequential-cell switching power

Even if register data does not change, the clock network and internal flip-flop clock circuitry still consume power when the clock toggles.

---

## 34. Integrated Clock-Gating Cell

ASIC libraries normally provide an Integrated Clock-Gating cell.

Abbreviation:

`ICG`

An ICG commonly contains:

* A latch
* Clock-gating logic
* Optional test-enable logic

The latch captures the enable signal during the safe phase of the clock.

This prevents the enable from changing during a phase that could create a partial clock pulse.

The ICG ensures that a clock pulse is either:

* Fully passed
* Fully blocked

---

## 35. Why a Normal AND Gate Is Unsafe

A normal AND gate may appear to implement:

`Gated Clock = Clock AND Enable`

However, if enable changes while the clock is high, the output may contain a narrow pulse.

This is called a clock glitch.

A clock glitch may accidentally trigger downstream sequential elements.

Therefore, ordinary combinational gates should not be inserted casually into clock paths.

---

## 36. Clock-Gating Timing Checks

Clock-gating cells introduce special timing checks on the enable signal.

The enable must be stable during the required timing window.

These checks are called:

* Clock-gating setup checks
* Clock-gating hold checks

They are different from ordinary register data-path setup and hold checks.

Their purpose is to guarantee glitch-free clock gating.

---

## 37. Clock-Gating Cells in CTS

CTS must recognize ICG cells and build clock branches around them.

A clock network may contain:

`Clock Root → Buffer → ICG → Local Clock Buffers → Registers`

CTS may build:

* A tree before the ICG
* A tree after the ICG

The ICG output is treated as a clock signal.

If one ICG drives too many registers, CTS may insert buffers after the ICG.

---

## 38. Test Enable

ICG cells may include a test-enable input.

During normal operation:

`Test Enable = 0`

During scan testing:

`Test Enable = 1`

The test-enable input allows the test clock to propagate even when the functional clock-gating enable is disabled.

This is necessary for scan and manufacturing test modes.

---

## 39. CTS Inputs

Typical CTS inputs include:

* Placed netlist
* Standard-cell placement
* Clock definitions
* Clock roots
* Clock sinks
* Clock constraints
* Timing constraints
* Clock-gating cells
* Physical libraries
* Timing libraries
* Placement blockages
* Routing-layer rules
* Clock NDR rules
* Maximum fanout limits
* Maximum transition limits
* Maximum capacitance limits
* Target skew
* Target latency

CTS depends strongly on placement quality.

Poor placement may produce:

* Long clock branches
* High congestion
* Difficult sink clustering
* Excessive clock power
* Poor skew

---

## 40. Stop Pins and Ignore Pins

### Stop Pin

A stop pin tells CTS to build the clock tree up to that pin but not continue normal balancing through it.

A clock-gating input may act as a stopping point for one tree stage.

### Ignore Pin

An ignore pin is excluded from normal clock-tree balancing.

It may still be connected, but CTS does not treat it as a normal clock sink.

The exact behavior depends on the EDA tool and constraints.

---

## 41. CTS Outputs

After CTS, the design normally contains:

* Inserted clock buffers
* Inserted clock inverters
* Clock-tree topology
* Updated clock connectivity
* Updated physical netlist
* Updated cell placement
* Clock latency reports
* Clock skew reports
* Clock transition reports
* Clock fanout reports
* Clock-capacitance reports
* Post-CTS timing reports

CTS changes the physical netlist because it adds clock-network instances and modifies clock connectivity.

The logical function of the design remains equivalent.

---

## 42. Legalization after CTS

Clock buffers require real physical placement area.

After insertion, the design must be checked for:

* Cell overlap
* Row alignment
* Site alignment
* Macro overlap
* Placement-blockage violations
* Legal orientation

CTS is often followed by:

* Incremental placement
* Legalization
* Post-CTS optimization

Placement legality must be preserved.

---

## 43. CTS and Congestion

CTS can worsen congestion because it adds:

* Clock buffers
* Clock inverters
* Clock branches
* Special-width clock wires
* Larger clock spacing
* Shielding wires

The result may be:

`Cell Density ↑`

`Routing Demand ↑`

`Available Routing Resources ↓`

Placement should preserve sufficient whitespace before CTS.

A design that was routable before CTS may develop new congestion hot spots afterward.

---

## 44. Post-CTS Checks

Major post-CTS checks include:

* Clock skew
* Clock latency
* Clock transition
* Clock fanout
* Clock capacitance
* Clock routing quality
* Setup timing
* Hold timing
* Placement legality
* Congestion
* Clock power

A CTS result is not clean simply because placement legality passes.

All required clock, timing, and physical checks must be satisfied.

---

## 45. Maximum Skew Violation

Example:

* Target maximum skew = `0.10 ns`
* Actual maximum skew = `0.16 ns`

The violation is:

`0.16 − 0.10 = 0.06 ns`

Possible fixes include:

* Add delay to a faster branch
* Strengthen a slower branch
* Resize clock buffers
* Move clock buffers
* Rebalance sink groups
* Change clock routing
* Modify clock topology

---

## 46. Maximum Transition Violation

Example:

* Maximum allowed transition = `0.20 ns`
* Actual transition = `0.29 ns`

Possible causes:

* High fanout
* Large capacitance
* Weak clock driver
* Long wire
* High wire resistance

Possible fixes:

* Upsize the driver
* Insert another buffer stage
* Split the sink load
* Use wider routing
* Use a lower-resistance layer
* Shorten the branch

---

## 47. Maximum Fanout Violation

Example:

* Maximum fanout = `32`
* Actual fanout = `47`

This is a fanout violation.

A stronger buffer may improve transition but does not reduce the fanout count.

The proper fix usually requires branch splitting.

---

## 48. Maximum Capacitance Violation

Example:

* Maximum load capacitance = `0.20 pF`
* Actual load capacitance = `0.28 pF`

Possible fixes include:

* Buffer insertion
* Driver upsizing
* Load splitting
* Shorter wire
* Lower-capacitance routing

Clock capacitance strongly affects dynamic power because the clock switches frequently.

---

## 49. Post-CTS Setup Timing

After CTS, real clock arrival times affect setup analysis.

Positive skew may help some setup paths.

Negative skew may hurt some setup paths.

Possible setup fixes include:

* Upsize data-path cells
* Insert repeaters on long data nets
* Move critical cells closer
* Reduce wirelength
* Reduce logic depth
* Use useful skew carefully
* Improve routing

Setup optimization must be followed by hold reanalysis.

---

## 50. Post-CTS Hold Timing

Hold timing often becomes more important after CTS because real clock skew is now present.

A hold violation means that new data arrives too early.

A common hold fix is to insert a small buffer or delay cell into the data path.

Before:

`Launch FF → Capture FF`

After:

`Launch FF → Hold-Fix Buffer → Capture FF`

The added delay increases the minimum data-path delay.

Clock period changes usually do not directly solve same-cycle hold violations.

---

## 51. Clock Buffer versus Hold-Fix Buffer

### Clock Buffer

Location:

* Clock path

Purpose:

* Clock distribution
* Fanout control
* Slew improvement
* Skew balancing
* Clock-load driving

### Hold-Fix Buffer

Location:

* Data path

Purpose:

* Increase minimum data delay
* Prevent new data from arriving too early
* Repair hold timing

Both may be physical buffer cells, but their purposes and locations differ.

---

## 52. Setup and Hold Tradeoff

A hold-fix buffer improves hold timing by increasing delay.

However, the same added delay may worsen setup timing.

Similarly, speeding up a data path may improve setup timing but create hold risk.

Therefore:

`Setup Fix → Recheck Hold`

`Hold Fix → Recheck Setup`

Timing closure is iterative.

---

## 53. PVT Corners

PVT stands for:

* Process
* Voltage
* Temperature

Clock-cell delay and wire delay change across PVT conditions.

### Process

Fast process:

`Cell delay generally decreases`

Slow process:

`Cell delay generally increases`

### Voltage

Higher voltage:

`Drive strength increases and cell delay generally decreases`

Lower voltage:

`Drive strength decreases and cell delay generally increases`

### Temperature

Higher temperature often causes:

* Higher wire resistance
* Slower transistor performance in many operating regions
* Larger delay

Actual behavior depends on the technology and operating range.

---

## 54. Setup and Hold Corners

Setup timing checks maximum delay.

A slower data path is generally more dangerous for setup timing.

Hold timing checks minimum delay.

A faster data path is generally more dangerous for hold timing.

A useful first-order rule is:

* Setup usually fears slow conditions.
* Hold usually fears fast conditions.

Actual worst-case scenarios depend on:

* Technology
* RC corner
* Clock path
* Data path
* Analysis method
* Variation model

---

## 55. MMMC

MMMC stands for:

`Multi-Mode Multi-Corner`

Modern timing analysis checks the design across multiple modes and corners.

Possible modes include:

* Functional mode
* Scan mode
* Low-power mode
* High-performance mode
* Different clock configurations

Possible corners include:

* Slow process, low voltage, high temperature
* Fast process, high voltage, low temperature
* Different RC extraction corners

A design that is clean in one scenario may fail in another.

---

## 56. OCV

OCV stands for:

`On-Chip Variation`

OCV models variation between different paths and regions within the same chip.

Possible causes include:

* Local process variation
* Local voltage drop
* Temperature gradients
* Different wire environments

Launch-clock, capture-clock, and data paths may not experience identical delay variation.

---

## 57. CRPR

CRPR stands for:

`Clock Reconvergence Pessimism Removal`

Launch and capture clock paths may share a common portion of the clock tree.

If STA assumes that the same shared segment is simultaneously slow for one path and fast for another, it creates artificial pessimism.

CRPR removes this unrealistic double counting.

Detailed CRPR calculations belong to advanced STA, but the core purpose is to remove unnecessary timing pessimism from shared clock paths.

---

## 58. Why Clock Skew Changes across Corners

Two clock branches may contain different proportions of:

* Buffer delay
* Wire delay
* Via delay
* Load capacitance

Example:

Branch A:

* More buffers
* Shorter wire

Branch B:

* Fewer buffers
* Longer wire

At one corner, the delays may be balanced.

At another corner, cell delay and wire delay may scale differently.

Therefore:

`Balanced at One Corner ≠ Balanced at Every Corner`

CTS quality must be checked across all required MMMC scenarios.

---

## 59. CTS Optimization Tradeoffs

CTS is a multi-objective optimization problem.

### Skew versus Power

More buffers may reduce skew but increase:

* Clock capacitance
* Dynamic power
* Area
* Congestion

### Slew versus Upstream Load

Upsizing a buffer may improve its output slew but increase its input capacitance, making the previous stage slower.

### Hold versus Setup

Adding data-path delay improves hold but may worsen setup.

### Setup versus Hold

Speeding up the data path improves setup but may create hold risk.

### Clock Quality versus Congestion

Special routing, shielding, wider wires, and extra buffers improve clock quality but consume routing resources.

---

## 60. CTS Closure Loop

A typical CTS closure loop is:

`Build Clock Tree`

`→ Check Skew, Latency, Transition, Fanout, and Capacitance`

`→ Optimize Clock Tree`

`→ Legalize Placement`

`→ Check Setup and Hold`

`→ Insert Timing-Fix Cells`

`→ Check Congestion and Power`

`→ Analyze MMMC Scenarios`

`→ Repeat Until Acceptable`

One fix may create another violation.

Examples:

`Insert Clock Buffer → Fanout improves → Power and congestion worsen`

`Insert Hold Buffer → Hold improves → Setup may worsen`

`Upsize Data Cell → Setup improves → Previous-stage load increases`

CTS closure therefore requires repeated analysis and optimization.

---

## 61. CTS Quality Checklist

### Clock Structure

* Clock roots identified
* Clock sinks identified
* Clock-gating cells recognized
* Clock buffers inserted correctly
* No unintended clock breaks

### Clock Quality

* Skew within target
* Latency acceptable
* Transition within limit
* Fanout within limit
* Capacitance within limit

### Timing

* Setup timing reviewed
* Hold timing reviewed
* WNS acceptable
* TNS acceptable
* Clock-gating checks clean

### Physical Quality

* Placement legal
* No cell overlap
* Congestion acceptable
* Routability acceptable
* Clock cells properly placed

### Power

* Clock-buffer count reasonable
* Clock capacitance controlled
* Clock power acceptable

### Variation

* Required MMMC scenarios analyzed
* OCV included where required
* CRPR applied where appropriate

---

## 62. Complete CTS Flow

`Placed Design`

`→ Read Clock Constraints`

`→ Identify Clock Roots and Sinks`

`→ Recognize Clock-Gating Cells`

`→ Select Clock Cells`

`→ Build Clock-Tree Topology`

`→ Insert and Size Clock Buffers`

`→ Balance Branch Delays`

`→ Control Skew, Latency, Slew, Fanout, and Capacitance`

`→ Apply Clock Routing Rules`

`→ Legalize Clock Cells`

`→ Perform Post-CTS Timing Analysis`

`→ Optimize Setup and Hold`

`→ Analyze Congestion and Power`

`→ Run MMMC Checks`

`→ Close CTS`

`→ Handoff to Routing`

---

## 63. Key Concepts

### Clock Tree Synthesis

The physical design stage that builds the clock-distribution network.

### Clock Source

The original point where the clock is generated or enters the design.

### Clock Root

The point from which CTS begins building the clock tree.

### Clock Sink

An endpoint pin that must receive the clock signal.

### Clock Fanout

The number of clock loads directly driven by one clock driver.

### Clock Slew

The transition time of a clock edge.

### Clock Latency

The time required for the clock to travel from its source to a sink.

### Source Latency

The clock delay before the CTS tree root.

### Network Latency

The clock delay from the tree root to a sink.

### Clock Skew

The difference in clock arrival time between two sinks.

### Positive Skew

The capture clock arrives later than the launch clock.

### Negative Skew

The capture clock arrives earlier than the launch clock.

### Useful Skew

Intentional adjustment of clock arrival times to improve timing.

### Clock Uncertainty

A safety margin used to account for imperfect clock behavior and modeling.

### Clock Jitter

Variation of clock edges across time.

### Clock Tree Balancing

Adjusting branch delays so clock arrival times are reasonably similar.

### Clock Gating

Disabling clock propagation to inactive logic to reduce power.

### ICG

Integrated Clock-Gating cell used for glitch-free clock gating.

### NDR

Non-Default Rule used to apply special clock-routing width, spacing, via, or layer rules.

### OCV

On-Chip Variation.

### CRPR

Clock Reconvergence Pessimism Removal.

### MMMC

Multi-Mode Multi-Corner analysis.

---

## 64. Final Summary

Clock Tree Synthesis converts an ideal or estimated clock into a real physical clock network.

CTS inserts clock buffers, divides clock loads, balances branch delays, controls transition, manages fanout, and applies special clock-routing rules.

The most important CTS metrics include:

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

CTS must also support:

* Clock gating
* Test modes
* PVT variation
* MMMC analysis
* OCV
* CRPR

A successful CTS result is not defined by one metric alone.

It must provide an acceptable balance among:

* Clock quality
* Timing closure
* Power
* Area
* Congestion
* Routability
* Physical legality
* Variation robustness

The final CTS result provides the physical clock infrastructure required for routing and signoff timing analysis.
