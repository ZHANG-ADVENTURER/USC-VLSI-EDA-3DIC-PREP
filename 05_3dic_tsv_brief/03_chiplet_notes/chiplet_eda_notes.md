# Chiplet EDA Notes

## 1. Overview

A chiplet architecture partitions a larger system into multiple smaller dies and integrates them through advanced packaging.

A monolithic SoC places major functions such as compute, cache, memory control, I/O, PHYs, and accelerators on one continuous silicon die. A chiplet-based system distributes these functions across multiple physical dies.

> System Architecture  
> → Functional Partitioning  
> → Chiplet Implementation  
> → Die-to-Die Integration  
> → Package-Level Optimization

Chiplets are not simply smaller chips. They represent a system-level tradeoff between manufacturing economics, process specialization, reuse, and integration complexity.

## 2. Why Chiplets

### Large-Die Yield

Larger dies cover more silicon area and therefore generally have a higher probability of containing a random fabrication defect.

Smaller dies can improve individual die yield because each die occupies less area.

This does not mean that the final multi-die package automatically has higher yield. Package yield still depends on bonding, interconnects, assembly, testing, and the yield of every required die.

### Reticle and Scaling Limits

A monolithic die cannot grow indefinitely because lithography exposure fields impose practical die-size limits.

Chiplets enable system scaling beyond the size of a single monolithic die by combining multiple dies inside one package.

### Advanced-Node Cost

Not every circuit function benefits equally from the most advanced process node.

Compute logic may strongly benefit from:

- Higher transistor density
- Better switching performance
- Lower energy per operation

I/O, analog, and PHY circuits may instead benefit from:

- Higher voltage capability
- Mature device characteristics
- Established reliability
- Lower manufacturing cost

The best process is therefore not automatically the newest process.

## 3. Heterogeneous Integration

Heterogeneous integration combines dies built for different functions or technologies in one system.

| Function | Possible Technology Choice |
| --- | --- |
| Compute Chiplet | Advanced logic node |
| I/O Die | Mature logic node |
| Analog / RF | Specialized analog process |
| HBM | DRAM process |
| Accelerator | Function-optimized logic process |

> Use the process technology that best fits each function.

## 4. Known Good Die and Yield

A practical manufacturing flow is:

> Manufacture Dies  
> → Test Dies  
> → Identify Known Good Dies  
> → Select Good Dies  
> → Assemble Package  
> → Perform Post-Bond and Package Testing

Known Good Die screening reduces the risk of integrating a defective component into an expensive multi-die package.

> Higher individual chiplet yield does not guarantee higher final system yield.

The final system also depends on:

- Die-to-die bonding
- Bump or hybrid-bond quality
- Interposer or substrate integrity
- Assembly yield
- Package power delivery
- System-level test coverage

## 5. Chiplet Reuse

A validated chiplet can potentially be reused across multiple product generations.

Reuse can reduce:

- Architecture redesign
- Circuit and RTL redesign
- Physical implementation effort
- Verification and validation effort
- Mask and tapeout-related development cost
- Time to market

## 6. Functional Partitioning

Chiplet partitioning decides which functions belong on which physical die.

> Chiplet partitioning asks: Which die should contain this function?

> Floorplanning asks: Where should this block be placed inside the chosen die?

A typical hierarchy is:

> System Architecture  
> → Functional Partitioning  
> → Process-Node Assignment  
> → Chiplet Sizing  
> → Die Placement  
> → Bump Planning  
> → Package Routing  
> → Per-Die Physical Design

Blocks with heavy communication demand may be poor candidates for separation because crossing a die boundary introduces additional communication cost.

## 7. Die-to-Die Communication

A monolithic on-chip path may be:

> Logic Block A  
> → On-Chip Metal  
> → Logic Block B

After chiplet partitioning, the path may become:

> Chiplet A Logic  
> → On-Die Routing  
> → Die-to-Die PHY  
> → Bump or Bond  
> → Interposer / Bridge / Package Routing  
> → Bump or Bond  
> → Die-to-Die PHY  
> → Chiplet B Logic

A chiplet boundary is therefore both a logical boundary and an electrical boundary.

## 8. Die-to-Die PHY

The die-to-die PHY is responsible for physically transferring bits between chiplets.

Typical responsibilities include:

- Drivers
- Receivers
- Clocking
- Sampling
- Timing alignment
- Link training
- Lane alignment
- Error detection

> Protocol or controller logic decides what and when.

> The PHY determines how the bits physically cross the interface.

## 9. Bandwidth and Latency

Bandwidth describes how much data can cross an interface per unit time.

> Demand > Capacity  
> → Interface Bottleneck

Cross-die latency can include:

- PHY delay
- Bump or bond parasitics
- Interposer or package delay
- Clocking and sampling
- Protocol overhead

Even a physically short chiplet link is not identical to a local on-die wire.

## 10. Communication Power

Cross-die links can consume more communication energy than short local wires because they must drive larger interface capacitance and operate additional PHY circuits.

Power contributors include:

- Driver activity
- Receiver activity
- Interface capacitance
- Clocking
- Training
- Serialization or protocol overhead

> Manufacturing benefit  
> ↔ Die-to-die communication penalty

## 11. Bump Planning

Bump resources are finite and must be allocated to:

- Signal
- Power
- Ground
- Clock
- Test
- Redundancy

Increasing signal bumps can improve bandwidth but reduce the number of power and ground bumps.

> Bandwidth  
> ↔ Power Integrity

Insufficient power and ground connectivity can increase IR drop, ground bounce, and supply noise.

## 12. Package and Interposer Routing

Chiplet systems move part of the communication problem from on-die routing into package-level routing.

Package-aware routing must consider:

- Die-to-die connectivity
- Bump escape routing
- Interposer routing
- Bridge routing
- Package-substrate routing
- Congestion
- Layer assignment
- Length constraints
- Crosstalk
- Power-routing competition

> Connectivity demand greater than available routing capacity produces congestion.

## 13. Thermal Considerations

Placing high-power compute chiplets close together may reduce communication distance but increase thermal coupling and hotspot risk.

Moving them farther apart may improve thermal behavior but increase wirelength, routing difficulty, and interface latency.

> Minimum wirelength is not necessarily the best package-level placement.

## 14. Power Delivery

A multi-chiplet package must deliver power to multiple dies with different voltage domains, current requirements, and activity patterns.

Package-aware power delivery must consider:

- Power bump allocation
- Ground-return paths
- Current density
- IR drop
- Supply noise
- Package and interposer resistance
- Dynamic activity

## 15. Clocking and Synchronization

Chiplets may use different clock domains or different clock-distribution structures.

Cross-chiplet communication may require:

- Interface clocking
- Clock-data alignment
- Clock-domain crossing
- Synchronization
- Protocol-level buffering

## 16. Verification Challenges

A chiplet system must verify more than each individual die.

Additional targets include:

- Die-to-die protocol behavior
- Link training
- Reset behavior
- Power sequencing
- Error handling
- Cross-die transactions
- Interface failure cases
- Clock-domain interactions

## 17. Standardized Interfaces

Standardized die-to-die interfaces can reduce integration friction and improve interoperability.

They can support:

- Reuse
- Interoperability
- Faster integration
- Ecosystem development

## 18. EDA Impact

Chiplet-aware EDA expands the optimization space:

> System Architecture  
> → Functional Partitioning  
> → Process-Node Assignment  
> → Chiplet Sizing  
> → Die Placement  
> → Bump Planning  
> → Die-to-Die Interface Planning  
> → Package Routing  
> → Power and Thermal Analysis  
> → Cross-Die Timing and Verification  
> → Yield and Cost Evaluation

This moves EDA from chip-level implementation toward system-technology co-optimization.

## 19. Single-Die to Chiplet Mapping

| Traditional Design Concept | Chiplet-Level Extension |
| --- | --- |
| Module partitioning | Functional partitioning across dies |
| Floorplanning | Die placement / package floorplanning |
| Pin placement | Bump planning |
| On-chip routing | Interposer / bridge / package routing |
| PDN | Multi-die package power delivery |
| IR-drop analysis | Package-aware power integrity |
| STA | Cross-die timing |
| Clock distribution | Cross-chiplet clocking / synchronization |
| Design reuse | Reusable silicon chiplets |
| PPA optimization | PPA + yield + thermal + package + cost optimization |

## 20. Engineering Summary

Chiplets improve system scalability by using smaller dies, process specialization, heterogeneous integration, and reuse, but they introduce new die-to-die communication, packaging, thermal, power, routing, test, and verification challenges.

> Chiplet partitioning decides which functions belong on which physical die, while traditional floorplanning decides where blocks should be placed after the die boundary has already been defined.
