# Thermal, Signal Integrity, and Power Integrity Notes

## 1. Overview

Advanced 2.5D, 3D, and chiplet systems must satisfy more than logical correctness, routing completion, and timing closure.

Thermal behavior, Signal Integrity, and Power Integrity directly affect timing, reliability, communication quality, and system feasibility.

These effects are coupled:

> Power  
> → Heat  
> → Temperature  
> → Leakage / Delay / Reliability

> Crosstalk / Reflection / Poor Return Path  
> → Waveform Degradation  
> → Reduced Signal and Timing Margin

> Current Demand + PDN Impedance  
> → IR Drop / Ground Bounce  
> → Supply Instability  
> → Timing and Signal Integrity Degradation

The main lesson is that advanced-package Physical Design is a multi-objective optimization problem.

## 2. Thermal Fundamentals

Thermal analysis studies how electrical power is converted into heat, how that heat spreads through materials, and how effectively it is removed from the package.

A useful qualitative relationship is:

> Temperature Rise ∝ Power × Thermal Resistance

Higher power does not automatically imply higher temperature. Temperature also depends on power density and the thermal path to the heat sink.

## 3. Power Density and Hotspots

Two blocks can consume the same total power but have different thermal behavior.

A smaller block with the same power has higher power density and is therefore more likely to develop a hotspot.

A hotspot is a localized region whose temperature is significantly higher than surrounding regions.

Typical causes include:

- High switching activity
- Dense compute units
- Concentrated current demand
- Poor heat spreading
- Strong thermal coupling from nearby dies

## 4. Thermal Effects on Timing and Leakage

Temperature changes transistor characteristics.

In common digital operating regions:

> Temperature ↑  
> → Cell delay can increase  
> → Data arrival becomes later  
> → Setup margin decreases

Temperature can also increase leakage:

> Temperature ↑  
> → Leakage ↑  
> → Power ↑  
> → Temperature ↑

This creates positive thermal feedback.

Thermal behavior therefore affects timing, leakage power, reliability, placement, tier assignment, and lifetime.

## 5. Thermal Challenges in 2.5D and 3D

In a 2.5D system, a high-power logic die can thermally affect nearby components such as HBM stacks.

> Shorter Interconnect  
> ↔ Higher Thermal Coupling

3D systems stack active dies vertically and can create:

- Higher power density per package footprint
- More difficult heat-removal paths
- Vertical thermal gradients
- Hotspots in inner tiers
- Greater thermal coupling between active layers

An inner die may be farther from the heat spreader or heat sink and must conduct heat through additional silicon, bonding layers, or interface materials.

## 6. Thermal-Aware Placement and Tier Assignment

Minimum wirelength is not always the best placement objective.

Two high-power blocks directly aligned above and below one another may have excellent communication latency but severe thermal interaction.

Thermal-aware placement may intentionally increase distance or offset hotspots to reduce peak temperature.

Tier assignment must consider timing, routing, communication, power delivery, thermal resistance, hotspot locations, and reliability.

## 7. TSVs and Thermal Behavior

TSVs are not only electrical interconnects. Their material, geometry, density, and placement can affect local heat conduction as well as stress and placement constraints.

This creates a direct connection between TSV fabrication knowledge and electro-thermal EDA.

## 8. Signal Integrity Fundamentals

Signal Integrity asks whether the electrical waveform arriving at a receiver still represents a valid and reliably sampled digital signal.

Real interconnects are not ideal wires. They include resistance, capacitance, inductance, coupling, and interface discontinuities.

A multi-die signal path can include:

> Driver  
> → On-Die Routing  
> → PHY  
> → Bump / Bond  
> → Interposer / Package Routing  
> → Bump / Bond  
> → Receiver PHY

## 9. Crosstalk

Crosstalk occurs when one conductor electrically influences another nearby conductor.

Important mechanisms include:

- Capacitive coupling
- Inductive coupling

The signal causing interference is the aggressor. The affected signal is the victim.

Crosstalk can cause noise pulses, slower or faster transitions, timing variation, and reduced noise margin.

> Crosstalk can become a timing problem.

## 10. Routing Density and Crosstalk

High-bandwidth interfaces often use many parallel signals.

Higher signal density can lead to smaller spacing, stronger coupling, more simultaneous switching, and higher crosstalk risk.

Increasing spacing can improve Signal Integrity but consumes additional routing resources.

> Better Signal Integrity  
> ↔ Lower Routing Density

## 11. Reflection and Waveform Distortion

A high-speed signal can reflect when it encounters an impedance discontinuity.

Possible discontinuities include transitions between on-die routing, bumps, interposer traces, package routing, and bond structures.

Reflection can produce:

- Overshoot
- Undershoot
- Ringing

These effects can reduce voltage margin or create sampling errors.

## 12. Clock Sensitivity

Clock signals are especially sensitive to Signal Integrity problems because they define timing reference points.

Clock waveform degradation can contribute to jitter, edge distortion, sampling uncertainty, and reduced setup or hold margin.

## 13. Return Path

Signal current must form a closed loop.

A high-speed signal path requires a low-impedance return path, usually through nearby ground or power-reference structures.

Poor return paths can increase loop inductance, ground noise, crosstalk, EMI, and signal distortion.

Ground bumps are therefore important for both Signal Integrity and Power Integrity.

## 14. Shielding, Length Matching, and Eye Margin

Sensitive high-speed signals may require larger spacing, ground shielding, layer assignment constraints, and controlled return paths.

Parallel interfaces may also require length matching to reduce lane-to-lane skew.

An eye diagram summarizes voltage and timing margin. Noise, jitter, crosstalk, and reflection can reduce the eye opening.

## 15. Power Integrity Fundamentals

Power Integrity asks whether VDD and ground remain sufficiently stable during operation.

The complete power-delivery path can include:

> Voltage Regulator  
> → PCB  
> → Package Substrate  
> → C4 / Bumps  
> → Interposer  
> → Microbumps  
> → On-Die PDN  
> → Standard Cells

Every section has electrical impedance.

## 16. IR Drop

IR drop is the voltage loss caused by current flowing through resistance.

> Voltage Drop ≈ Current × Resistance

IR drop reduces the local supply voltage seen by cells.

The timing chain is:

> IR Drop ↑  
> → Local VDD ↓  
> → Transistor Drive Strength ↓  
> → Cell Delay ↑  
> → Data Arrival Time Becomes Later  
> → Setup Slack ↓  
> → Possible Setup Violation

## 17. Static and Dynamic IR Drop

Static IR-drop analysis estimates voltage loss under relatively steady or averaged current conditions.

Dynamic IR drop captures time-dependent voltage droop caused by switching activity.

Large simultaneous switching events can create high transient current demand and temporarily reduce local supply voltage.

## 18. Ground Bounce and Simultaneous Switching

Ground bounce occurs when local ground voltage temporarily shifts away from the ideal reference because high transient return current flows through a finite-impedance ground path.

Ground bounce can reduce effective signal margin because the receiver's reference voltage is moving.

> Power Integrity Noise  
> → Signal Integrity Degradation

Simultaneous switching can affect both SI and PI:

> More Simultaneous Switching  
> → Current Demand ↑  
> → Voltage Droop / Ground Bounce ↑  
> → Signal and Timing Margin ↓

## 19. Decoupling Capacitors

A decoupling capacitor acts as a local charge reservoir.

It can provide temporary current close to an active block and reduce transient voltage droop before current arrives through the longer package or board-level power path.

More decap can improve local supply stability but consumes physical area.

## 20. Power Bumps and Power TSVs

Bump and TSV resources are finite.

They may be allocated among signal, power, ground, clock, test, and redundancy.

Increasing signal resources can improve interface bandwidth, but can reduce power and ground resources.

> Bandwidth  
> ↔ Power Integrity

Too few power or ground connections can increase IR drop, ground bounce, current density, and supply noise.

## 21. Power Routing vs Signal Routing

Power routing and signal routing compete for physical resources.

More metal allocated to VDD and ground can reduce resistance and improve PI, but reduces signal-routing capacity.

More signal-routing capacity can improve connectivity but weaken the PDN if too few resources remain for power delivery.

## 22. Electromigration

High current density can cause electromigration.

Long-term electromigration can produce voids, resistance increase, open circuits, and reliability failures.

Power TSVs, bumps, and metal paths must therefore satisfy both voltage-drop and current-density constraints.

## 23. TSV Fabrication and Power Integrity

TSV fabrication parameters influence electrical reliability.

Relevant factors include:

- Diameter
- Depth
- Aspect ratio
- Barrier integrity
- Seed continuity
- Copper-fill quality
- Contact quality
- CMP planarity

Defects such as voids, seams, or discontinuous seed layers can increase resistance or create open circuits.

## 24. Thermal, SI, PI, and Timing Coupling

### Power to Thermal

> Current ↑  
> → Power ↑  
> → Heat ↑

### Thermal to Power

> Temperature ↑  
> → Leakage ↑  
> → Power ↑

### Thermal to Timing

> Temperature Changes  
> → Cell Delay Changes  
> → Timing Margin Changes

### PI to Timing

> IR Drop ↑  
> → VDD ↓  
> → Cell Delay ↑  
> → Setup Margin ↓

### PI to SI

> Ground Bounce / Supply Noise  
> → Reference Voltage Disturbance  
> → Noise Margin ↓

### SI to Timing

> Crosstalk / Jitter / Edge Distortion  
> → Transition and Arrival-Time Variation  
> → Timing Margin Changes

## 25. Multi-Objective Design Example

Suppose a chiplet designer increases the number of signal bumps to improve bandwidth.

> Signal Bumps ↑  
> → Signal Density ↑  
> → Crosstalk Risk ↑  
> → SI Worsens

and:

> Signal Bumps ↑  
> → Available Power / Ground Bumps ↓  
> → PI Worsens

To reduce crosstalk:

> Signal Spacing ↑  
> → Routing Capacity ↓  
> → Congestion Risk ↑

To reduce latency:

> High-Power Chiplets Placed Closer  
> → Thermal Coupling ↑  
> → Hotspot Risk ↑

A single architectural decision can therefore affect SI, PI, routing, thermal behavior, timing, and reliability.

## 26. EDA Mapping

| Single-Die Concept | Multi-Die Extension |
| --- | --- |
| Power density | Package / tier thermal density |
| Hotspot analysis | Cross-die thermal coupling |
| Placement optimization | Thermal-aware die / tier placement |
| Crosstalk analysis | Cross-die and package SI |
| Shielding / spacing | Package and interposer SI constraints |
| PDN | Package + interposer + die PDN |
| IR drop | Multi-die power-delivery voltage loss |
| Ground network | Multi-die return-path planning |
| EM | Bump / TSV / package current-density reliability |
| STA | Timing under thermal, SI, and PI effects |

## 27. Engineering Summary

Thermal, Signal Integrity, and Power Integrity are coupled Physical Design constraints in advanced multi-die systems.

> A design that minimizes wirelength or maximizes bandwidth can still fail if it creates thermal hotspots, crosstalk, poor return paths, IR drop, ground bounce, or excessive current density.

The correct optimization target is therefore not one metric alone, but simultaneous satisfaction of timing, power, routing, thermal, SI, PI, reliability, yield, and cost constraints.
