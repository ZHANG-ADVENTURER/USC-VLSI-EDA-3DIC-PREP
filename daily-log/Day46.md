# Day 46 Daily Log

## Topic

Translating a TSV Fabrication Capstone into VLSI and EDA Language

## What I Learned

Today I learned how to reinterpret my TSV fabrication capstone from a sequence of semiconductor process steps into a set of VLSI, Physical Design, EDA, and 3D IC engineering constraints.

The main shift was from describing what equipment or process was used to explaining how each process parameter affects downstream electrical and physical behavior.

For TSV geometry, I connected diameter, depth, and aspect ratio to resistance, capacitance, current capacity, keep-out zones, placement density, routing resources, manufacturability, and reliability. I clarified that aspect ratio and TSV diameter must not be treated as the same design variable. High aspect ratio mainly increases etch, conformal-deposition, and fill difficulty, while large diameter mainly increases footprint and keep-out impact.

I also learned to treat the entire fabrication flow as a process-integration chain. DRIE quality affects sidewall geometry, which influences liner, barrier, seed, and copper-fill quality. A local fabrication issue can therefore propagate into later electrical or reliability problems.

I clarified the role of the dielectric liner, barrier, seed layer, copper fill, CMP, RDL, and bumps in system-level terms. These steps determine isolation, capacitance, continuity, resistance, current density, planarity, package connectivity, and assembly quality.

A major communication lesson was to distinguish observed facts from inferred consequences. For example, photoresist residue near a TSV opening was directly observed, but without electrical measurement I should not claim that it definitely increased TSV resistance. The rigorous statement is that the residue created a potential downstream integration risk because it could affect the opening geometry, etch profile, and later deposition or metallization.

I also connected wafer thickness and backgrinding to TSV depth and aspect ratio. A wafer that remains thicker than planned can require deeper TSVs, which increases process difficulty and can potentially increase vertical-interconnect resistance. At the same time, wafer thinning introduces mechanical and handling tradeoffs.

The final perspective is that my fabrication experience explains the physical origin of constraints that EDA tools later model through parasitic values, keep-out zones, routing capacity, current-density limits, timing effects, and reliability rules.

## What I Built

I created a technical reference that translates the major fabrication elements of my TSV capstone into VLSI and EDA terminology.

The note includes:

- TSV diameter, depth, and aspect-ratio tradeoffs
- TSV keep-out zones
- DRIE and sidewall-profile effects
- Dielectric liner and capacitance
- Barrier-layer reliability
- Seed-layer continuity
- Copper-fill defects
- CMP planarity
- RDL and bump interfaces
- Photoresist residue as a process-integration risk
- Wafer thickness and backgrinding
- Manufacturing variation and EDA model accuracy
- OpenROAD-to-TSV Physical Design mapping
- Interview-oriented project framing

The main technical artifact is:

> capstone_to_vlsi_notes.md

## Key Concepts

### Process Integration

The idea that semiconductor fabrication steps are physically coupled and that an upstream process condition can affect multiple downstream steps.

### TSV Aspect Ratio

The ratio of TSV depth to diameter. Higher aspect ratio generally increases etch, deposition, and filling difficulty.

### TSV Keep-Out Zone

A region around a TSV where normal placement may be restricted because of stress, manufacturing, electrical, or reliability concerns.

### Parasitic-Aware Design

The recognition that TSVs, bumps, and package interconnects have nonzero resistance, capacitance, coupling, and delay.

### Manufacturing Variation

Differences between nominal design geometry and the physical structure produced by fabrication.

### Electrical Continuity

The ability of a conductive structure such as a TSV or seed layer to provide a continuous current path without voids or opens.

### Manufacturability

The ability to fabricate a design reliably within the available process capability and design rules.

### Process-to-EDA Mapping

The translation of fabrication geometry, variation, and material limitations into models and constraints used by Physical Design and EDA tools.

## Problems / Fixes

### Problem 1: Treating a Cu Void as a Short

I initially described a TSV copper void as creating a short and reducing delivered electrical current.

Fix:

A copper void normally reduces the effective conductive cross-section. This can increase resistance and local current density, which may increase signal delay or power IR drop and worsen electromigration reliability. A severe fill defect can create an open rather than a short.

### Problem 2: Mixing Aspect Ratio with TSV Footprint

I initially stated that a small aspect ratio would necessarily occupy more wafer area.

Fix:

Aspect ratio is depth divided by diameter and does not independently determine footprint. A larger diameter can reduce aspect ratio while increasing physical area, but aspect ratio can also decrease because TSV depth is reduced with no change in footprint. High aspect ratio is primarily a manufacturability concern, while large diameter is a major placement and routing resource concern.

### Problem 3: Making Unsupported Electrical Claims from Process Observations

I initially considered saying that observed photoresist residue increased TSV resistance.

Fix:

Without direct electrical measurement, I should separate the observed process fact from the inferred engineering consequence. The residue can be described as a potential downstream integration risk because it may affect opening geometry, etch quality, and conformal deposition or metallization.

### Problem 4: Describing Fabrication Steps as Isolated Operations

It is easy to describe lithography, DRIE, liner deposition, metallization, plating, and CMP as separate tasks.

Fix:

I now describe them as a process-integration chain. Each step changes geometry, material condition, or surface quality and can therefore affect later electrical, mechanical, or assembly behavior.

## Connection to VLSI / EDA / 3D IC

This capstone now connects directly to the Physical Design and EDA concepts I studied earlier.

TSV footprint and keep-out zones map to placement restrictions and reduced routing resources. TSV resistance and capacitance map to extracted parasitics and cross-die timing. Power TSV resistance and current capacity map to IR drop and electromigration. Manufacturing variation affects the accuracy and margin of design models. TSV geometry and process quality also influence reliability, yield, and manufacturability.

My OpenROAD work showed how tools optimize placement, routing, timing, congestion, and power. My TSV fabrication work provides a physical understanding of where many advanced-package constraints originate.

This combination gives me a process-aware view of packaging-aware Physical Design and 3D IC EDA.

## One Sentence Summary

My TSV capstone taught me how fabrication geometry and process integration become parasitic, placement, routing, power, reliability, manufacturability, and yield constraints that must be modeled and optimized in advanced VLSI and EDA flows.

## Next Step

Prepare a concise advisor brief that summarizes my VLSI, Physical Design, EDA, OpenROAD, and 3D IC preparation and identifies the most important technical topics to discuss with a USC advisor or professor.
