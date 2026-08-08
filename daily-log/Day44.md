# Day 44 Daily Log

## Topic

Chiplet Basics and Packaging-Aware EDA

## What I Learned

Today I studied why modern systems use chiplet architectures and how chiplets change the Physical Design and EDA problem.

A monolithic SoC places major compute, cache, memory-control, I/O, and PHY functions on one continuous silicon die. A chiplet system instead partitions the system into multiple smaller dies and integrates them through advanced packaging.

One major motivation is manufacturing yield. Smaller dies generally have a lower probability of containing a random fabrication defect than a very large monolithic die. However, I clarified that this improves individual die yield rather than guaranteeing higher final package yield. A multi-die system still depends on good bonding, bumps or hybrid bonds, interposer or substrate integrity, assembly yield, and package-level testing.

I also learned that chiplets enable heterogeneous integration. Compute logic may benefit strongly from an advanced logic node, while I/O, analog, or PHY functions may be more economical or technically appropriate on a mature or specialized process. The correct engineering principle is to use the process that best fits the function rather than forcing every block onto the newest process node.

Another important advantage is reuse. A validated I/O chiplet can potentially be reused with multiple generations of compute chiplets, reducing redesign, repeated verification and validation, implementation effort, mask-related development cost, and time to market.

The major tradeoff is that splitting a system creates die boundaries. Communication that was previously an on-chip connection may now require a die-to-die PHY, bumps or bonds, package or interposer routing, and a receiving PHY. This can increase latency, interface power, physical area, and verification complexity.

I also clarified the difference between chiplet partitioning and floorplanning. Chiplet partitioning decides which physical die should contain each function. Floorplanning occurs after that decision and determines where blocks are placed within the selected die or package.

## What I Built

I created a technical note that organizes the main chiplet concepts from manufacturing, architecture, Physical Design, and EDA perspectives.

The note includes:

- Monolithic versus chiplet architecture
- Yield and Known Good Die concepts
- Reticle and scaling constraints
- Heterogeneous integration
- Process-node specialization
- Chiplet reuse
- Functional partitioning
- Die-to-die PHY responsibilities
- Bandwidth and latency
- Communication power
- Bump planning
- Package and interposer routing
- Thermal and power-delivery tradeoffs
- Clocking and synchronization
- Verification challenges
- Standardized die-to-die interfaces
- System-technology co-optimization

The main technical artifact is:

> chiplet_eda_notes.md

## Key Concepts

### Chiplet

A smaller functional die that is integrated with other dies through advanced packaging to form a larger system.

### Monolithic SoC

A system in which major functions are implemented on one continuous silicon die.

### Functional Partitioning

The architectural decision that assigns system functions to different physical dies.

### Heterogeneous Integration

The integration of dies built with different functions, process nodes, or technology types into one package.

### Known Good Die

A die that has been tested before assembly to reduce the risk of integrating a defective component into an expensive multi-die system.

### Process-Node Specialization

The use of different process technologies for different chiplets based on performance, voltage, analog, reliability, and cost requirements.

### Die-to-Die PHY

The physical interface responsible for electrically transmitting and receiving data across a chiplet boundary.

### Interface Bandwidth

The amount of data that a die-to-die interface can transfer per unit time.

### Chiplet Reuse

The reuse of a validated silicon building block across multiple products or product generations.

### System-Technology Co-Optimization

The joint optimization of system architecture, process technology, package design, interconnect, power, thermal behavior, yield, and cost.

## Problems / Fixes

### Problem 1: Confusing Higher Chiplet Yield with Easier Replacement

I initially explained higher chiplet yield mainly by saying that a defective small die could be replaced without replacing an entire monolithic die.

Fix:

I now understand that the main individual-die yield advantage comes from smaller silicon area and the lower probability of containing a random fabrication defect. Known Good Die screening then allows good dies to be selected before expensive package assembly.

### Problem 2: Assuming Mature Nodes Are Only Used Because I/O Is Slow

I initially associated mature-node I/O mainly with lower speed requirements.

Fix:

I now understand that I/O, analog, and PHY functions may not benefit from advanced-node scaling in the same way as dense digital compute logic. Mature or specialized technologies may provide appropriate voltage capability, analog behavior, reliability, and lower cost.

### Problem 3: Confusing Chiplet Partitioning with 3D Placement

I initially described chiplet partitioning as different from floorplanning because chiplets can use the Z dimension.

Fix:

I now understand that the fundamental difference is abstraction level. Chiplet partitioning decides which functions belong on which die, while floorplanning decides where blocks are placed after the die boundary has already been defined. Chiplet systems can be 2.5D and do not require vertically stacked active dies.

### Problem 4: Using IR Drop to Explain Communication Power

I associated the extra resistance of chiplet connections with both latency and communication power through IR drop.

Fix:

I now distinguish communication power from power-delivery integrity. Cross-die communication energy increases because larger interface capacitance must be driven and additional PHY, clocking, and protocol circuits operate. IR drop is instead a power-delivery problem that becomes important when power and ground connectivity are insufficient.

## Connection to VLSI / EDA / 3D IC

Chiplets extend the Physical Design concepts I learned earlier into a system-level optimization problem.

Traditional floorplanning determines the placement of macros and blocks within one die. Chiplet design adds a higher-level partitioning problem that decides which functions belong on which die and which process technology each die should use.

Pin placement expands into bump planning. On-chip routing expands into interposer, bridge, and package routing. PDN and IR-drop analysis expand into multi-die package power integrity. Timing analysis expands into cross-die interface timing. Verification expands into die-to-die protocol, synchronization, reset, power sequencing, and link-training behavior.

This makes chiplet-aware EDA a natural continuation of single-die Physical Design rather than a separate subject. The same core resource constraints remain, but the optimization now spans silicon, package, process technology, thermal behavior, yield, and cost.

## One Sentence Summary

Chiplets trade monolithic simplicity for better yield economics, process specialization, reuse, and scalability while introducing new die-to-die communication, packaging, power, thermal, routing, and verification constraints.

## Next Step

Study thermal, signal-integrity, and power-integrity fundamentals for advanced packaging and learn how these effects constrain 2.5D, 3D, and chiplet Physical Design.
