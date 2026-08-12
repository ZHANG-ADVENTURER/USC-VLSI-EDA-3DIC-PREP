# 3D IC / TSV-Aware EDA

## Project Scope

This feature connects hands-on TSV process-integration experience to the Physical Design abstractions used in 2.5D and 3D EDA.

The central causal chain is:

> TSV fabrication → physical geometry and process constraints → parasitics, KOZ, power, thermal behavior, and reliability → Physical Design constraints → packaging-aware EDA optimization

## Project Facts

- Approximate TSV diameter: 46 µm
- Georgia Tech TSV depth: approximately 200 µm; aspect ratio approximately 4.35
- University of Washington TSV depth: approximately 83 µm; aspect ratio approximately 1.80
- Wafer thickness: approximately 200 µm
- Planned thinning: approximately 100 µm
- Process flow included lithography, DRIE, dielectric-liner work, barrier/seed metallization, copper electroplating preparation, CMP, RDL, and bump/flip-chip-related integration

These are project facts. The notes separately identify potential design consequences. They do not claim that electrical effects were experimentally measured when no such measurement is documented.

## EDA Relevance

| Fabrication or package consideration | Physical Design / EDA interpretation |
|---|---|
| TSV diameter and depth | Parasitic, current-capacity, footprint, and manufacturability tradeoffs |
| TSV keep-out zone | Placement restriction and reduced routing access |
| TSV and bump resources | Vertical routing capacity and congestion |
| Interposer and package interconnect | Cross-die timing, SI, and routing constraints |
| Power/ground interconnect | Multi-level power-delivery planning and PI analysis |
| Thermal coupling | Placement, timing, leakage, and reliability constraints |
| Process variation | Model uncertainty, manufacturability, reliability, and yield considerations |

Observed photoresist residue is described only as an observed process condition and a potential downstream integration risk. It is not evidence of proven resistance, reliability, or yield degradation.

## Primary Evidence

- [TSV capstone translated into VLSI and EDA constraints](../../05_3dic_tsv_brief/05_tsv_to_3dic_research_brief/capstone_to_vlsi_notes.md)
- [Consolidated 3D IC summary](../../05_3dic_tsv_brief/07_3dic_summary/3dic_summary_notes.md)
- [TSV, HBM, and silicon-interposer fundamentals](../../05_3dic_tsv_brief/01_tsv_hbm_interposer/tsv_hbm_interposer.md)
- [2.5D versus 3D integration](../../05_3dic_tsv_brief/02_2.5d_vs_3d/2.5d-vs-3d.md)
- [Chiplet and EDA notes](../../05_3dic_tsv_brief/03_chiplet_notes/chiplet_eda_notes.md)
- [Thermal, Signal Integrity, and Power Integrity notes](../../05_3dic_tsv_brief/04_thermal_si_pi/thermal_si_pi_notes.md)
- [TSV / HBM / interposer sketch](../../05_3dic_tsv_brief/01_tsv_hbm_interposer/sketch.png)

## Current Research Direction

The longer-term objective is to study how EDA algorithms model and jointly optimize placement, routing, timing, power, thermal behavior, reliability, and manufacturability under limited TSV, bump, interposer, and die-level resources.
