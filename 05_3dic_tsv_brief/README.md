# 2.5D / 3D IC and TSV-Aware EDA

This module connects advanced-packaging structures and TSV process integration with Physical Design and EDA constraints. It progresses from package architecture and interconnect fundamentals to parasitics, keep-out zones, routing resources, power, thermal behavior, reliability, and multi-objective optimization.

## Recommended Reading Path

1. [TSV, HBM, and silicon-interposer fundamentals](01_tsv_hbm_interposer/tsv_hbm_interposer.md)
2. [2.5D versus 3D integration](02_2.5d_vs_3d/2.5d-vs-3d.md)
3. [Chiplets and EDA constraints](03_chiplet_notes/chiplet_eda_notes.md)
4. [Thermal, Signal Integrity, and Power Integrity](04_thermal_si_pi/thermal_si_pi_notes.md)
5. [TSV capstone translated into VLSI and EDA constraints](05_tsv_to_3dic_research_brief/capstone_to_vlsi_notes.md)
6. [Consolidated 3D IC summary](07_3dic_summary/3dic_summary_notes.md)

## Technical Progression

> TSV fabrication → geometry and process integration → parasitics, KOZ, power, thermal behavior, and reliability → placement, routing, timing, and power-delivery constraints → packaging-aware EDA optimization

## Scope and Evidence Boundary

The module combines project facts with general engineering interpretation. Approximate TSV dimensions and documented process steps are treated as project facts. Potential consequences for resistance, capacitance, KOZ, timing, power, reliability, manufacturability, and yield are not presented as experimentally measured effects unless measurements are explicitly documented.

Observed photoresist residue is treated as a potential downstream process-integration risk, not as proof of resistance, reliability, or yield degradation. Copper processing is described as electroplating preparation unless stronger completion evidence is explicitly available.

For the concise portfolio view, see [3D IC / TSV-Aware EDA](../featured-projects/02_3dic_tsv_aware_eda/README.md).
