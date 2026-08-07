# Day 42 Daily Log

## Topic

TSV, HBM, Silicon Interposer, and Packaging-Aware Physical Design

## What I Learned

Today I studied the architecture of a typical 2.5D HBM system and connected it to my previous TSV fabrication experience. The central structure is a logic die and one or more HBM stacks placed side by side on a silicon interposer. The logic die performs computation and system control, while the HBM stack provides high-capacity, high-bandwidth memory through vertically stacked DRAM dies.

The most important architectural distinction is that HBM and the logic die are not normally stacked directly on top of each other in a standard 2.5D system. They are connected through microbumps and lateral metal routing in the silicon interposer. TSVs inside the HBM stack provide vertical connectivity between DRAM dies, while TSVs inside the interposer connect the interposer top side to the package substrate below.

I also learned why HBM can provide very high bandwidth. Its main advantage does not come only from an extremely high data rate per individual wire. Instead, HBM uses a very wide interface with many short, parallel connections. The short distance between the HBM stack and the logic die reduces interconnect parasitics and I/O energy, while the large number of connections increases total bandwidth.

The memory controller and HBM PHY have different responsibilities. The memory controller decides what operation should occur, which channel and bank should be accessed, which address should be used, and when commands should be scheduled. The HBM PHY handles the physical and electrical transmission of signals, including timing alignment, data sampling, training, calibration, skew management, and signal driving and receiving.

I studied the difference between vertical and lateral interconnects. TSVs, microbumps, C4 bumps, and BGA balls provide vertical connections between layers or structures. On-die metal, interposer metal, RDL, package-substrate routing, and PCB traces mainly provide lateral routing. A complete data path therefore alternates between lateral and vertical interconnect levels rather than using only one direction.

I also analyzed TSV design parameters. TSV pitch is the center-to-center spacing between adjacent TSVs. TSV diameter, depth, and aspect ratio affect resistance, current capacity, manufacturability, density, and reliability. A larger diameter can reduce resistance and lower aspect ratio, which can simplify etching, liner deposition, seed formation, and copper filling. However, it also occupies more silicon area, lowers TSV density, increases routing obstruction, and may enlarge the effective keep-out-zone cost.

The keep-out zone around a TSV is required because copper and silicon have different coefficients of thermal expansion. Temperature changes can create mechanical stress around the TSV and affect nearby transistors. This stress may change mobility, leakage, threshold behavior, timing, and long-term reliability. The keep-out zone therefore acts like a TSV-aware placement restriction and has a direct impact on utilization and routing congestion.

Finally, I studied the system-level tradeoffs of 2.5D HBM integration. Wider interfaces improve bandwidth but require more bumps and routing resources. Shorter die-to-die distance reduces delay and power but may increase routing congestion and thermal coupling. More signal bumps increase interface capacity, while more power and ground bumps improve power integrity. The final design must balance performance, power delivery, thermal behavior, signal integrity, yield, testability, cost, and manufacturability.

## What I Built

I completed an English technical note that summarizes the structure and design implications of TSV, HBM, and silicon interposer integration.

The note is stored at:

> 05_3dic_tsv_brief/01_tsv_hbm_interposer/tsv_hbm_interposer.md

I also created a detailed architecture diagram showing:

- The logic die and its compute core, cache, memory controller, and HBM PHY
- The HBM stack with multiple DRAM dies and a base die
- HBM TSVs and microbumps
- Silicon interposer metal routing and interposer TSVs
- C4 bumps, package substrate, BGA balls, and PCB
- Read-command and read-data paths
- Vertical and lateral interconnect categories
- Major design tradeoffs and TSV process-to-design relationships

The diagram is stored at:

> 05_3dic_tsv_brief/01_tsv_hbm_interposer/sketch.png

## Key Concepts

### 2.5D Integration

A packaging architecture in which multiple dies are placed side by side on a high-density interposer instead of being manufactured as one monolithic die or stacked directly on top of one another.

### HBM Stack

A high-bandwidth memory structure composed of multiple vertically stacked DRAM dies connected through a TSV network and an external interface near the bottom of the stack.

### Silicon Interposer

A high-density interconnect platform that provides lateral routing between side-by-side dies and may use TSVs to connect its top-side routing to the package substrate.

### HBM PHY

The physical-layer interface that drives, receives, aligns, trains, and calibrates HBM signals across the die-to-die connection.

### Memory Controller

The logic that schedules memory requests and determines the operation, channel, bank, address, and command order.

### TSV Pitch

The center-to-center distance between adjacent through-silicon vias.

### Keep-Out Zone

A restricted placement region around a TSV that protects sensitive devices from mechanical stress, electrical coupling, reliability risks, and manufacturability limitations.

### Packaging-Aware EDA

The extension of physical-design and analysis methods beyond a single die to include bump planning, TSV placement, interposer routing, package power delivery, thermal behavior, signal integrity, test, yield, and cost.

## Problems / Fixes

### Problem 1: Confusing HBM TSVs with Interposer TSVs

I initially treated TSVs as one general connection type without clearly separating their locations and functions.

Fix:

HBM TSVs connect vertically stacked DRAM dies inside the memory stack, while interposer TSVs connect the interposer top side to the package substrate below.

### Problem 2: Reversing the Roles of the Memory Controller and HBM PHY

I initially mixed logical scheduling with physical transmission responsibilities.

Fix:

The memory controller decides what, where, and when to access memory, while the HBM PHY manages how the electrical signals physically cross the interface.

### Problem 3: Adding a Logic-Die TSV to the Typical 2.5D Data Path

I included a logic-die TSV in the return path from HBM to the logic die.

Fix:

In the typical 2.5D architecture studied today, data enters the logic die through microbumps and on-die routing to the HBM PHY. A TSV through the logic die is not a required part of this standard path.

### Problem 4: Treating a Larger TSV Diameter as an Unqualified Improvement

I first focused only on the lower resistance and easier etching associated with a larger TSV diameter.

Fix:

A larger diameter can reduce resistance and aspect ratio, but it also consumes more silicon area, reduces TSV density, increases keep-out-zone impact, and can worsen placement and routing constraints.

## Connection to VLSI / EDA / 3D IC

This topic extends the Physical Design concepts I learned in OpenROAD from a single die to a multi-die package. Standard-cell placement becomes die and PHY placement. Pin planning becomes bump and TSV assignment. Routing congestion extends into the interposer. SPEF-style parasitic thinking expands to include TSVs, bumps, interposer wires, and package routing. On-chip IR-drop analysis becomes chip-interposer-package power-integrity analysis.

My TSV fabrication background is directly relevant because TSV geometry and process quality influence electrical resistance, capacitance, mechanical stress, keep-out zones, routing density, reliability, power delivery, assembly yield, and manufacturability. This allows me to describe my fabrication experience as a foundation for packaging-aware Physical Design and EDA rather than as an isolated process project.

## One Sentence Summary

A 2.5D HBM system uses vertically connected memory dies and high-density interposer routing to achieve high bandwidth, but its performance depends on cross-layer optimization of parasitics, placement, routing, power, thermal behavior, reliability, test, yield, and cost.

## Next Step

The next learning topic is the planned Day 44 module, 2.5D versus 3D IC, with a structured comparison of integration method, interconnect, thermal behavior, routing, test, yield, and cost.
