# 3D IC Summary Notes

## 1. Overview

This note consolidates the major concepts studied in the 3D IC module and connects advanced packaging architecture to Physical Design and EDA.

The overall framework is:

> Architecture  
> → Interconnect  
> → Physical Constraints  
> → Electrical / Thermal Effects  
> → EDA Models and Optimization

The major topics include TSV, HBM, interposers, 2.5D versus 3D integration, chiplets, thermal behavior, Signal Integrity, Power Integrity, packaging-aware Physical Design, and EDA optimization.

## 2. Why Advanced Packaging Is Needed

Large monolithic chips face several scaling challenges:

- Large-die yield
- Reticle limits
- Advanced-node cost
- Memory-bandwidth demand
- Heterogeneous function requirements
- Power-delivery complexity
- Thermal constraints

Advanced packaging allows multiple dies to operate as one system and enables chiplet-based architectures, heterogeneous process-node integration, HBM integration, 2.5D systems, and 3D stacked systems.

## 3. Chiplet Fundamentals

A chiplet architecture partitions a larger system into multiple independently manufactured dies that are integrated through advanced packaging.

The key architectural question is:

> Which function should be placed on which die?

Typical partitions may include compute, I/O, cache, memory interface, and accelerator functions.

Chiplet partitioning can provide:

- Better individual die yield
- Reticle-limit relief
- Process-node specialization
- IP reuse
- Lower advanced-node area
- Faster product reuse

However, chiplets also introduce die-to-die PHY overhead, package-routing complexity, additional latency, communication power, testing complexity, assembly yield risk, and thermal coupling.

Therefore:

> Chiplet economics must be evaluated at the system level, not only by individual die yield.

## 4. 2.5D Integration

In 2.5D systems, major active dies are typically placed side-by-side and communicate through a high-density interposer or bridge.

A simplified structure is:

> HBM / Chiplet  
> → Microbumps  
> → Silicon Interposer  
> → Microbumps  
> → Logic Die

The main die-to-die communication path is often:

> Vertical  
> → Lateral  
> → Vertical

The lateral portion is mainly implemented through interposer routing.

Typical 2.5D challenges include interposer-routing congestion, bump planning, package Power Integrity, Signal Integrity, thermal coupling, assembly yield, and cost.

## 5. 3D Integration

In 3D IC systems, major active dies are vertically stacked.

Possible vertical connections include:

- TSVs
- Microbumps
- Hybrid bonding
- Face-to-face or face-to-back interfaces

Potential advantages include shorter inter-die links, higher interconnect density, lower communication latency, lower communication energy, and smaller footprint.

Major challenges include thermal removal, vertical routing resources, power delivery, test access, yield, reliability, and cross-tier timing.

## 6. 2.5D versus 3D

The classification depends mainly on how the major active dies are arranged.

### 2.5D

> Major active dies are side-by-side.

### 3D

> Major active dies are vertically stacked.

The existence of TSVs alone does not define a system as 3D.

For example:

- HBM internally contains vertically stacked DRAM dies and is therefore a 3D-stacked memory.
- A GPU and HBM stacks placed side-by-side on an interposer form a 2.5D system-level architecture.

## 7. HBM Architecture

HBM achieves high aggregate bandwidth using a very wide parallel interface and short package-level communication distance.

A useful relationship is:

> Bandwidth ≈ Number of Data Wires × Data Rate per Wire

HBM benefits from many parallel signal connections, dense microbumps, short links, high-density interposer routing, and multiple channels.

HBM bandwidth is not simply based on extremely high per-pin data rate.

## 8. HBM Internal versus External Connectivity

### Internal HBM Connection

TSVs connect vertically stacked DRAM dies inside the HBM stack.

They may carry data, address, command, clock, power, ground, test, and redundancy.

### HBM-to-Logic Connection

The typical external communication path is:

> HBM Internal TSV Network  
> → HBM Base / Interface Region  
> → Microbumps  
> → Interposer Metal Routing  
> → Microbumps  
> → Logic Die PHY

Therefore:

> HBM TSVs primarily provide vertical connectivity inside the HBM stack, while interposer metal provides the main lateral HBM-to-logic connection.

## 9. TSV versus Microbump

### TSV

A TSV is a conductor that passes through silicon.

### Microbump

A microbump is a fine-pitch surface-to-surface electrical and mechanical interface.

A useful rule is:

> Bump connects surfaces; TSV passes through silicon.

## 10. TSV Is Not an Ideal Wire

A TSV can have resistance, capacitance, coupling, mechanical stress, thermal effects, and process variation.

These properties can affect delay, Signal Integrity, Power Integrity, placement, routing, reliability, and yield.

## 11. TSV Diameter Tradeoff

Increasing TSV diameter increases conductor cross-sectional area.

Potential benefits include:

- Lower resistance
- Higher current capability
- Lower fixed-depth aspect ratio

Potential costs include:

- Larger footprint
- Larger keep-out impact
- Lower TSV density
- Reduced placement resources
- Reduced routing resources
- Possible capacitance changes

Therefore:

> Larger TSV diameter is not always better.

It is a tradeoff between electrical benefit and Physical Design cost.

## 12. TSV Depth and Aspect Ratio

Aspect ratio is:

> Aspect Ratio = Depth / Diameter

Higher depth generally increases aspect ratio for a fixed diameter.

High aspect ratio can make DRIE, sidewall control, liner deposition, barrier coverage, seed continuity, and copper fill more difficult.

Greater conductor length can also potentially increase resistance.

Therefore:

> TSV geometry affects both manufacturability and electrical behavior.

## 13. TSV Keep-Out Zone

A TSV can create a keep-out zone because of mechanical stress, electrical concerns, or process requirements.

From a Physical Design perspective:

> TSV KOZ behaves like a placement restriction.

Potential effects include:

- Effective placement area ↓
- Local utilization ↑
- Routing access ↓
- Congestion risk ↑

A useful analogy is:

> TSV KOZ ↔ Placement Blockage / Macro Halo

## 14. Bump Planning

Bump sites are finite physical resources.

They must be allocated among:

- Signal
- VDD
- GND
- Clock
- Test
- Redundancy

Increasing signal-bump count can improve communication bandwidth, but may reduce the number of available power and ground bumps.

This creates a tradeoff:

> Bandwidth ↑  
> ↔  
> Power Integrity Risk ↑

## 15. Vertical Congestion

In single-die routing:

> Routing Demand > Routing Capacity  
> → Congestion

In 3D systems:

> Required Vertical Connections > Available TSV / Bump Sites  
> → Vertical Congestion

The EDA concept is still demand versus capacity, but the routing resource now includes vertical interconnects.

## 16. Thermal Fundamentals

Power consumption generates heat.

Temperature depends on power, power density, thermal resistance, and the heat-removal path.

A simplified relationship is:

> Temperature Rise ∝ Power × Thermal Resistance

High power density increases hotspot risk.

## 17. Thermal Challenges in 3D IC

3D stacking makes thermal management more difficult because:

- Multiple active dies generate heat in the same footprint
- Inner dies can be farther from the heat sink
- Heat must cross additional material interfaces
- Thermal coupling becomes stronger

This creates a tradeoff:

> Communication Distance ↓  
> ↔  
> Thermal Difficulty ↑

## 18. Thermal and Timing

In common operating regions:

> Temperature ↑  
> → Cell Delay May ↑  
> → Setup Slack ↓

Temperature can also increase leakage:

> Temperature ↑  
> → Leakage ↑  
> → Power ↑  
> → Heat ↑  
> → Temperature ↑

Thermal behavior therefore affects timing, power, reliability, and placement.

## 19. Signal Integrity

Digital signals are physically analog waveforms traveling through nonideal interconnects.

Real interconnects contain resistance, capacitance, inductance, and coupling.

Signal Integrity problems can include crosstalk, reflection, ringing, overshoot, undershoot, jitter, and lane skew.

## 20. Crosstalk

Crosstalk occurs when an aggressor signal affects a nearby victim signal through electromagnetic coupling.

Important coupling mechanisms include capacitive coupling and inductive coupling.

Crosstalk can cause noise, glitches, edge degradation, and delay variation.

Therefore:

> Signal Integrity problems can become timing problems.

## 21. Return Path

Signal current must complete a closed loop.

Ground bumps and ground structures provide important return paths.

Poor return paths can increase loop inductance, ground bounce, noise, and Signal Integrity risk.

Ground connections therefore support both Power Integrity and Signal Integrity.

## 22. Power Integrity

Power Integrity asks whether VDD and GND remain sufficiently stable during circuit operation.

A multi-die power path may include:

> Voltage Source / Board  
> → Package  
> → BGA / C4  
> → Interposer  
> → Microbump / TSV  
> → Die PDN  
> → Cells

Every part of this path has nonzero impedance.

## 23. IR Drop and Timing

A key causal chain is:

> IR Drop ↑  
> → Local VDD ↓  
> → Drive Strength ↓  
> → Cell Delay ↑  
> → Data Arrival Later  
> → Setup Slack ↓  
> → Possible Setup Violation

This demonstrates:

> Power Integrity → Timing

## 24. Ground Bounce

Simultaneous switching can create large transient return currents.

Because ground paths have finite impedance:

> Return Current ↑  
> → Ground Bounce ↑  
> → Reference Voltage Stability ↓  
> → Signal Margin ↓

This demonstrates:

> Power Integrity → Signal Integrity

## 25. Coupling among Thermal, SI, and PI

Thermal, Signal Integrity, and Power Integrity should not be treated as isolated problems.

Example:

> Signal Bumps ↑  
> → Bandwidth Potential ↑

But also:

> P/G Bumps ↓  
> → IR Drop / Ground Bounce Risk ↑

and:

> Signal Density ↑  
> → Crosstalk Risk ↑

If routing spacing is increased to improve SI:

> Routing Capacity ↓  
> → Congestion ↑

If high-power chiplets are placed close together to reduce communication distance:

> Thermal Coupling ↑

This creates a multi-objective optimization problem.

## 26. Single-Die to Multi-Die Physical Design Mapping

| Single-Die Physical Design | 2.5D / 3D Extension |
| --- | --- |
| Block / Macro Placement | Chiplet Placement / Tier Assignment |
| Pin Assignment | Bump Assignment |
| Placement Blockage | TSV KOZ |
| Metal Routing | Interposer / Vertical Routing |
| Routing Congestion | Bump / TSV / Inter-Die Congestion |
| PDN | Package + Interposer + Die PDN |
| SPEF / Net Parasitics | TSV / Bump / Interposer Parasitics |
| STA | Cross-Die Timing |
| Local Hotspot | Cross-Tier Thermal Coupling |

## 27. Fabrication-to-EDA Mapping

| Fabrication Parameter | Physical / Electrical Effect | EDA Impact |
| --- | --- | --- |
| TSV Diameter | R, C, footprint, KOZ | Timing, PI, placement, congestion |
| TSV Depth | R, aspect ratio | Timing, manufacturability |
| Cu Fill Quality | R, current density | Timing, IR, EM, reliability |
| TSV Stress | KOZ | Placement |
| Bump Pitch | Interface density | Bandwidth, routing |
| Wafer Thickness | TSV depth / mechanical behavior | Parasitics, manufacturability |
| Process Variation | Geometry variation | Model uncertainty, yield |

## 28. Example: TSV Diameter to EDA Objective

A complete causal chain is:

> TSV Diameter ↑  
> → Conductive Cross-Section ↑  
> → Resistance ↓  
> → Signal Delay or Power IR Drop May Improve

At the same time:

> TSV Diameter ↑  
> → Footprint / KOZ Impact ↑  
> → Placement Resources ↓  
> → Routing Resources ↓  
> → Congestion Risk ↑

Therefore:

> EDA must jointly optimize timing, power, area, and congestion rather than minimizing TSV resistance alone.

## 29. Packaging-Aware EDA

Packaging-aware EDA extends traditional design optimization to include package and multi-die constraints.

Important optimization targets include:

- Placement
- Routing
- Timing
- Power
- Thermal behavior
- Signal Integrity
- Power Integrity
- Reliability
- Manufacturability
- Yield
- Cost

The central problem is:

> Multiple objectives must be optimized simultaneously under limited physical resources.

## 30. Current Technical Direction

> Main Field: EDA  
> Research Space: 2.5D / 3D IC  
> Primary Interest: Physical Design Optimization  
> Supporting Strengths: Physical Design + STA  
> Practical Evidence: OpenROAD  
> Differentiator: TSV Process Integration  
> Next Skill Gaps: Algorithms + C++ / Programming

## 31. Final Mental Model

> Architecture  
> Chiplet / HBM / 2.5D / 3D  
>
> ↓
>
> Interconnect  
> TSV / Microbump / Interposer / RDL  
>
> ↓
>
> Physical Constraints  
> KOZ / Pitch / Routing Capacity / Bump Resources / Parasitics  
>
> ↓
>
> System Effects  
> Timing / Thermal / SI / PI / Reliability / Yield  
>
> ↓
>
> EDA  
> Model + Analyze + Optimize

## 32. Final Summary

Advanced 2.5D and 3D IC design is fundamentally a system-level Physical Design and EDA problem in which architecture, interconnect geometry, manufacturing constraints, timing, power, thermal behavior, Signal Integrity, reliability, yield, and cost must be optimized together.
