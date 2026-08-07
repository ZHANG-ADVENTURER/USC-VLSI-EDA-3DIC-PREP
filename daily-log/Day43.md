# Day 43 Daily Log

## Topic

2.5D vs 3D IC Integration and EDA Constraints

## What I Learned

Today I compared 2.5D and 3D IC integration from an architecture and Physical Design perspective.

The most important distinction is how the major active dies are arranged. In a 2.5D system, major dies such as a logic die, chiplets, and HBM stacks are placed side-by-side and communicate through a high-density interposer or bridge. In a 3D IC, active dies are vertically stacked and communicate through direct vertical interconnects such as TSVs, microbumps, or hybrid-bond connections.

I clarified an important classification issue from the previous HBM lesson. An HBM stack internally contains vertically stacked DRAM dies, but a package with an HBM stack and a logic die placed side-by-side on a silicon interposer is still considered a 2.5D system at the overall package-integration level. The classification depends on how the major functional dies are integrated, not simply on whether TSVs or stacked structures exist somewhere in the package.

I also learned why 3D integration can improve die-to-die communication. A 2.5D signal often travels from one die through a microbump, across lateral interposer routing, and through another microbump into the destination die. In a 3D stack, two active dies can be placed directly above and below one another, which can significantly shorten the communication path and increase vertical connection density.

However, shorter interconnect does not automatically make the complete design better. Vertically stacking active dies can increase power density and make heat removal more difficult, especially for dies located away from the heat sink. Thermal hotspots and vertical temperature gradients can increase leakage, degrade timing, and reduce reliability.

I compared 2.5D and 3D systems across integration, interconnect, thermal behavior, routing, testing, cost, and yield. The main engineering conclusion is that 2.5D and 3D are different system-level tradeoffs rather than a simple ranking where 3D is always better.

## What I Built

I created a technical comparison note for 2.5D and 3D integration.

The note includes:

- Architecture differences between side-by-side and vertically stacked active dies
- Interconnect-path comparisons
- Thermal and routing tradeoffs
- Testing and Known Good Die considerations
- Cost and yield considerations
- A Physical Design and EDA mapping table
- A constraint comparison table covering integration, timing, power, routing, thermal, test, yield, and cost
- A connection between TSV fabrication parameters and 3D IC design constraints

The main technical artifact is:

> 05_3dic_tsv_brief/02_2.5d_vs_3d/2.5d-vs-3d.md

## Key Concepts

### 2.5D Integration

A packaging architecture in which major active dies are placed side-by-side and connected through a high-density interposer or bridge.

### 3D Integration

An architecture in which active dies are vertically stacked and connected using direct vertical interconnect structures.

### Heterogeneous Integration

The integration of dies with different functions or process technologies into one system, allowing logic, I/O, memory, and other functions to use technologies optimized for their individual requirements.

### Tier Assignment

The process of deciding which functional blocks or dies belong on different vertical layers in a 3D IC.

### Vertical Interconnect Congestion

A condition in which the required cross-die connectivity exceeds the available TSV, microbump, or hybrid-bond connection capacity.

### Thermal-Aware Placement

A placement strategy that considers temperature and power density in addition to wirelength, timing, and congestion.

### Known Good Die

A die that has been tested before package or stack assembly to reduce the risk of integrating a defective die into an expensive multi-die system.

### Cross-Die Timing

Timing analysis for signal paths that travel across die boundaries and therefore include die-to-die interconnect parasitics in addition to on-die cell and wire delay.

## Problems / Fixes

### Problem 1: Classifying an HBM Package as 2.5D or 3D

I initially described a typical HBM package as 2.5D because it contains both horizontal placement and vertical stacking. That description was incomplete because the presence of vertical structures alone does not determine the system-level classification.

Fix:

I now use the placement of the major functional dies as the primary classification rule. If the logic die and HBM stacks are side-by-side on an interposer, the overall package is 2.5D even though the HBM stack internally contains vertically stacked DRAM dies.

### Problem 2: Treating Minimum Wirelength as the Main Placement Goal

It is easy to assume that the shortest possible connection should always produce the best design.

Fix:

I now recognize that 3D placement is a multi-objective optimization problem. Shorter wirelength can improve timing and communication energy, but a placement can still be poor if it creates severe thermal hotspots, power-delivery problems, routing congestion, or reliability risks.

### Problem 3: Understanding Routing Congestion Across Different Integration Levels

At first, interposer congestion and vertical interconnect congestion appeared to be separate problems.

Fix:

I recognized that both are forms of the same physical-resource problem: connectivity demand exceeds available routing capacity. In a single die the limited resource is metal routing capacity, in a 2.5D system it includes interposer routing capacity, and in a 3D system it also includes TSV, bump, or bonding-site capacity.

## Connection to VLSI / EDA / 3D IC

Today's topic extends the single-die Physical Design concepts I previously practiced with OpenROAD into multi-die integration.

Single-die floorplanning becomes die placement or tier assignment. Pin placement becomes bump planning. Placement blockages become TSV keep-out zones. Routing expands into interposer routing and vertical interconnect planning. Static Timing Analysis expands into cross-die timing analysis. Power delivery expands into chip-interposer-package or vertical stack power integrity.

The same optimization mindset remains important. A design cannot be judged by timing alone. The implementation must balance timing, power, area, routing capacity, thermal behavior, reliability, testability, yield, and cost.

This also strengthens the connection between my TSV fabrication background and packaging-aware EDA. TSV geometry and process quality are not only fabrication parameters; they influence parasitics, keep-out zones, power delivery, routing density, reliability, and yield. This gives me a process-aware perspective when thinking about 2.5D and 3D Physical Design.

## One Sentence Summary

2.5D and 3D integration trade interconnect locality against thermal, routing, power, testing, yield, and manufacturing complexity, turning multi-die Physical Design into a broader multi-objective EDA problem.

## Next Step

Study chiplet fundamentals, including why chiplets are used, how yield and heterogeneous integration affect system architecture, how chiplets change cost structure, and why die-to-die interfaces and advanced packaging create new EDA challenges.
