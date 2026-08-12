# Capstone to VLSI / EDA Notes

## 1. Overview

This note translates a TSV-based advanced semiconductor packaging capstone from fabrication-process language into VLSI, Physical Design, EDA, and 3D IC engineering language.

The key idea is:

> Fabrication constraints  
> → physical geometry and material properties  
> → electrical parasitics and reliability behavior  
> → placement, routing, timing, power, thermal, manufacturability, and yield constraints

The goal is not to describe process steps in isolation, but to explain how process choices propagate into design-level consequences.

## 2. Project Context

The capstone focused on advanced 3D semiconductor packaging using through-silicon vias.

The broader integration flow included:

> Photolithography  
> → DRIE  
> → Dielectric Liner  
> → Barrier Layer  
> → Copper Seed  
> → Copper Electroplating Preparation
> → CMP  
> → RDL  
> → Bump / Flip-Chip Integration

The main value of this experience is understanding the physical origin of constraints that later appear in package-aware Physical Design and EDA.

## 3. TSV Geometry as a Design Variable

### Diameter

Increasing TSV diameter generally increases conductor cross-sectional area.

Possible consequences include:

- Lower resistance
- Higher current-carrying capability
- Changed capacitance
- Larger physical footprint
- Lower TSV density
- Larger keep-out impact
- Reduced placement and routing resources

Therefore:

> Larger TSV diameter can improve electrical performance while increasing physical-design cost.

### Depth

Increasing TSV depth increases conductor length.

Possible consequences include:

- Higher resistance
- Longer vertical interconnect path
- Higher aspect ratio
- More difficult etch and metallization integration

### Aspect Ratio

Aspect ratio is:

> Aspect Ratio = Depth / Diameter

Two project examples were:

- Georgia Tech: approximately 46 µm diameter and 200 µm depth → aspect ratio ≈ 4.35
- University of Washington: approximately 46 µm diameter and 83 µm depth → aspect ratio ≈ 1.80

High aspect ratio can make DRIE, sidewall control, liner conformality, barrier coverage, seed continuity, and copper fill more difficult.

Aspect ratio is therefore not only a fabrication metric. It affects manufacturability, defect probability, electrical quality, reliability, and yield.

## 4. TSV Keep-Out Zone

A TSV and its surrounding stress-affected region can create a keep-out zone.

From a Physical Design perspective:

> TSV KOZ behaves like a placement restriction.

Consequences include:

- Reduced effective placement area
- Reduced local routing access
- Higher local utilization
- Higher congestion risk
- More difficult block and TSV co-placement

A useful analogy is:

> TSV KOZ ↔ placement blockage / macro halo

## 5. DRIE and Sidewall Profile

DRIE defines the TSV depth, geometry, and sidewall profile.

A nonideal profile can affect downstream integration because liner, barrier, seed, and copper fill are formed on or within the etched structure.

Possible process issues include:

- Incorrect depth
- Sidewall roughness
- Taper
- Nonuniform profile
- Opening residue
- Incomplete etch

The process-integration chain is:

> DRIE Profile  
> → Liner / Barrier / Seed Quality  
> → Copper Fill Quality  
> → Electrical and Reliability Behavior

## 6. Dielectric Liner

The project included a PECVD SiO₂ liner.

Its main electrical purpose is to isolate the copper TSV from the surrounding silicon.

Liner properties can affect:

- Electrical isolation
- Leakage
- TSV capacitance
- Reliability

## 7. Barrier Layer

A Ti barrier was included in the TSV integration flow.

The barrier helps prevent copper diffusion into surrounding materials.

Barrier integrity is connected to:

- Material stability
- Leakage control
- Long-term reliability
- Interconnect lifetime

## 8. Copper Seed Layer

The seed layer provides a continuous conductive path for copper electroplating.

If seed coverage is discontinuous:

> Plating Current Distribution Becomes Nonuniform  
> → Incomplete Fill / Voids / Seams May Form  
> → Electrical Continuity and Reliability Can Degrade

## 9. Copper Electroplating Preparation

The documented project work included preparation for copper electroplating. The fill-defect discussion below describes general process and design risks; it is not a claim that completed copper fill or the listed defects were experimentally demonstrated in this project.

Possible copper-fill defects include:

- Voids
- Seams
- Incomplete fill
- Nonuniform conductor cross-section

A Cu void should not normally be described as a short.

A more accurate chain is:

> Cu Void  
> → Effective Conductive Cross-Section ↓  
> → Resistance and Local Current Density ↑  
> → Signal Delay or Power IR Drop ↑  
> → Electromigration / Reliability Risk ↑

A severe defect may produce an open connection.

For a signal TSV:

> Resistance ↑  
> → Delay ↑  
> → Timing Margin ↓

For a power TSV:

> Resistance ↑  
> → IR Drop ↑  
> → Local VDD ↓  
> → Cell Delay ↑

## 10. CMP and Planarity

CMP removes excess metal and provides a planar surface for downstream integration.

Planarity affects:

- RDL formation
- Lithography
- Contact quality
- Bump formation
- Bonding
- Assembly reliability

## 11. RDL

RDL provides lateral redistribution between vertical interconnect structures and package-level connection points.

> TSV = Vertical Interconnect  
> RDL = Lateral Redistribution

## 12. Bump and Flip-Chip Interface

Bumps provide both mechanical and electrical connection between dies, interposers, and package structures.

Relevant properties include:

- Resistance
- Capacitance
- Pitch
- Alignment
- Current capacity
- Signal and power allocation

These properties can affect timing, Signal Integrity, Power Integrity, routing, and assembly yield.

## 13. Photoresist Residue as a Process-Integration Issue

Photoresist residue was observed near TSV openings in the project.

The correct engineering statement is not:

> The residue increased TSV resistance.

That would require direct electrical evidence.

A more rigorous interpretation is:

> Photoresist residue at the TSV opening created a potential downstream integration risk because it could affect the effective opening geometry, DRIE profile, and subsequent conformal deposition or metallization steps.

This distinction separates observed process fact from plausible engineering consequence.

## 14. Ring-Like Residue at the Via Opening

A ring-like residue near the via opening was another observed process issue.

The safe engineering interpretation is:

> The nonideal opening condition was identified as a potential risk to subsequent etch and deposition uniformity.

Without direct measurement, it should not be claimed that the residue definitely caused a specific resistance or reliability failure.

## 15. Wafer Thickness and Backgrinding

Wafer thickness affects the required TSV depth for through-wafer connectivity.

The wafer thickness was approximately 200 µm, while the planned thinning target was approximately 100 µm. The wafer was not back-ground to the originally planned thickness.

A design-oriented interpretation is:

> Because the wafer remained thicker than planned, the required TSV depth remained larger, increasing aspect ratio and process-integration difficulty while potentially increasing vertical-interconnect resistance.

Thinning can reduce required TSV depth, but thinner wafers can introduce:

- Mechanical fragility
- Warpage risk
- Handling difficulty
- Assembly challenges

Therefore:

> Wafer thinning is an electrical, mechanical, and manufacturing tradeoff.

## 16. Backside SiN

Backside SiN was considered as a protection or etch-control strategy to reduce unwanted lateral etching.

The design-relevant interpretation is:

> Better process control improves geometric predictability, which improves the consistency of the physical parameters assumed by design and extraction models.

## 17. DRIE Platform Experience

The project involved TSV etch work across different DRIE platforms.

The important engineering value is not the equipment list alone.

The broader lesson is:

> Different etch platforms and process conditions influence TSV depth, profile, aspect ratio, and downstream integration constraints.

## 18. Manufacturing Variation and EDA Models

EDA tools do not directly model photoresist residue or every fabrication defect.

Instead, they use abstractions such as:

- TSV dimensions
- Parasitic resistance
- Parasitic capacitance
- Keep-out zones
- Current capacity
- Reliability limits
- Yield assumptions

If fabrication variation changes the real structure:

> Designed TSV ≠ Manufactured TSV

then the electrical and physical model can become less representative.

## 19. Capstone to Physical Design Mapping

| Fabrication / Packaging Concept | Physical Design / EDA Meaning |
| --- | --- |
| TSV Diameter | Resistance, capacitance, current capacity, footprint |
| TSV Depth | Resistance, path length, aspect ratio |
| Aspect Ratio | Manufacturability and fill difficulty |
| TSV KOZ | Placement blockage / reduced effective area |
| DRIE Profile | Downstream layer and geometry quality |
| Oxide Liner | Isolation and capacitance |
| Barrier | Diffusion control and reliability |
| Seed Layer | Plating continuity |
| Copper Fill | Resistance, current density, EM, opens |
| CMP | Planarity and downstream integration |
| RDL | Lateral redistribution |
| Bump | Die/package electrical interface |
| Wafer Thickness | TSV depth, AR, resistance, mechanical tradeoff |
| Process Variation | Model uncertainty / yield impact |

## 20. Transferable Engineering Concepts

The capstone naturally connects to six VLSI / EDA concepts:

1. TSV Geometry
2. Process Integration
3. Parasitics
4. Keep-Out Zone
5. Power and Reliability
6. Manufacturability and Yield

## 21. Connection to OpenROAD Physical Design

OpenROAD work exposes:

- Placement
- Routing
- Congestion
- Timing
- Parasitics
- Power
- IR drop

TSV fabrication exposes the physical origins of advanced-package constraints:

- Geometry
- KOZ
- Vertical parasitics
- Current-carrying limits
- Process variation
- Reliability
- Manufacturability

The combined perspective is:

> Physical Design tools optimize constraints, while fabrication experience explains where many of those constraints originate.

## 22. Interview Framing

A weak description is:

> I worked with photolithography, DRIE, PECVD, PVD, copper-electroplating preparation, CMP, and related integration steps for TSV structures.

A stronger description is:

> I worked on TSV process integration and learned how via geometry, aspect ratio, dielectric isolation, barrier and seed continuity, copper-fill quality, and surface planarity affect the electrical and physical constraints of vertical interconnects. That experience helped me understand the physical origins of TSV parasitics, keep-out zones, power-delivery limits, reliability, manufacturability, and yield in 2.5D and 3D systems.

## 23. Physical Design Interview Answer

> My TSV fabrication experience helps me understand the physical origins of several Physical Design constraints. High-aspect-ratio TSVs make etch, liner, barrier, seed, and copper-fill integration more difficult, while TSV diameter and keep-out zones reduce available placement and routing resources. These fabrication parameters eventually translate into parasitic, manufacturability, power-delivery, routing, and reliability constraints that Physical Design and EDA tools must account for.

## 24. Larger TSV Tradeoff

A larger TSV is not automatically better.

Potential electrical benefit:

> Diameter ↑  
> → Conductive Area ↑  
> → Resistance ↓  
> → Current Capacity Potentially ↑

Physical-design cost:

> Diameter ↑  
> → Footprint ↑  
> → KOZ Impact ↑  
> → Placement Density ↓  
> → Routing Resources ↓  
> → Congestion Risk ↑

Therefore:

> TSV sizing is a tradeoff between electrical performance and physical-design cost.

## 25. Engineering Summary

> Fabrication steps should not be described as isolated operations. Process choices and process defects propagate into geometry, parasitics, placement constraints, routing resources, power delivery, thermal behavior, reliability, manufacturability, and yield.

This process-aware perspective is directly relevant to packaging-aware Physical Design, 3D IC CAD, and EDA.
