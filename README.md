# EDA, Physical Design, and 2.5D / 3D IC Portfolio

This repository documents my progression toward Electronic Design Automation research and engineering, with a primary interest in Physical Design optimization for 2.5D and 3D integrated circuits. It combines practical OpenROAD analysis, Physical Design and Static Timing Analysis foundations, and prior TSV fabrication/process-integration experience.

## Technical Direction

| Area | Current focus |
|---|---|
| Main field | Electronic Design Automation |
| Research space | 2.5D / 3D IC |
| Primary interest | Physical Design optimization |
| Supporting strengths | Physical Design and Static Timing Analysis |
| Practical evidence | Educational OpenROAD / ORFS implementation analysis |
| Differentiating background | TSV fabrication and process integration |
| Next skill priorities | Algorithms, data structures, optimization, and C++ |

## Featured Work — Start Here

| Priority | Project | What it demonstrates |
|---:|---|---|
| 1 | [OpenROAD Physical Design](featured-projects/01_openroad_physical_design/README.md) | CTS, routing, congestion, post-route STA with extracted parasitics, static IR-drop analysis, and iterative implementation closure |
| 2 | [3D IC / TSV-Aware EDA](featured-projects/02_3dic_tsv_aware_eda/README.md) | Translation of TSV fabrication constraints into parasitic, KOZ, power, thermal, reliability, and Physical Design considerations |
| 3 | [RTL / Digital Foundation](featured-projects/03_rtl_digital_foundation/README.md) | Implemented Verilog FIFO, FSM, and register-file designs with self-checking testbenches and waveform evidence |

## Technical Progression

> RTL / Digital Design → Physical Design → Static Timing Analysis → OpenROAD Physical Implementation → 2.5D / 3D IC → Packaging-Aware EDA

RTL establishes the logical design foundation. Physical Design and STA connect logic to placement, routing, parasitics, and timing. OpenROAD provides practical implementation evidence. The 2.5D / 3D IC work then extends these concepts to TSVs, bumps, interposers, multi-die power delivery, thermal constraints, and packaging-aware optimization.

## OpenROAD Results at a Glance

The first featured project analyzes the official OpenROAD-flow-scripts Nangate45 GCD baseline. Representative final results are:

| Metric | Result |
|---|---:|
| Setup WNS | +0.0160 ns |
| Hold WNS | +0.1108 ns |
| Detailed-router violations | 59 → 29 → 20 → 0 |
| Worst static VDD drop | approximately 5.93 mV |
| Worst static VSS bounce | approximately 3.17 mV |

These are educational ORFS / Nangate45 results under the analyzed configuration, not foundry signoff. See the [OpenROAD featured project](featured-projects/01_openroad_physical_design/README.md) and [artifact manifest](04_openroad_practice/ARTIFACTS.md) for detailed scope and limitations.

## From TSV Fabrication to EDA Constraints

My TSV-related process-integration experience provides a physical basis for understanding advanced-package design constraints:

> TSV fabrication → geometry and process constraints → parasitics, keep-out zones, power, thermal behavior, and reliability → Physical Design constraints → packaging-aware EDA optimization

The documented project examples include an approximate TSV diameter of 46 µm and depths of approximately 200 µm and 83 µm, corresponding to aspect ratios of approximately 4.35 and 1.80. These dimensions and the process flow are project facts; their potential electrical and Physical Design consequences are engineering interpretations unless explicitly measured. The detailed distinction is maintained in the [3D IC / TSV-Aware EDA feature](featured-projects/02_3dic_tsv_aware_eda/README.md).

## Technical Foundations

- [RTL and digital design](01_verilog_basics/README.md)
- [Physical Design and RTL-to-GDSII notes](02_physical_design_notes/README.md)
- [Static Timing Analysis and timing-closure notes](03_sta_notes/README.md)
- [OpenROAD practice and report analysis](04_openroad_practice/README.md)
- [2.5D / 3D IC and TSV-aware design](05_3dic_tsv_brief/README.md)

## Chronological Learning Record

The [daily learning record](daily-log/README.md) preserves the complete chronological history behind this portfolio. It demonstrates sustained preparation, while the featured-project layer provides the faster professor- and recruiter-facing path through the strongest work.

## Next Development Priorities

The repository demonstrates domain preparation, foundational RTL implementation, and careful interpretation of an educational physical-implementation flow. My next priority is to move from EDA tool use toward EDA algorithm and tool development through:

- Algorithms and data structures
- C++ programming
- Graph, partitioning, placement, routing, and optimization methods
- Reading and modifying EDA source code
- Reproducible experiments with controlled baselines and metrics
- Packaging-aware Physical Design models and multi-objective optimization

This repository is a technical preparation portfolio, not evidence of foundry tapeout or production signoff.
