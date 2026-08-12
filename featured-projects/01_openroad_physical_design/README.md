# OpenROAD Physical Design

## Project Scope

This project analyzes the official OpenROAD-flow-scripts Nangate45 GCD baseline from synthesis through final routing and extracted timing. The emphasis is engineering interpretation: how CTS, congestion, routing, parasitic extraction, STA, timing closure, and static power-grid analysis interact during physical implementation.

This is not independently authored RTL or a production physical-design implementation. It is an educational baseline run used for systematic report and database analysis.

## Representative Results

| Analysis area | Result |
|---|---:|
| Final setup WNS | +0.0160 ns |
| Final hold WNS | +0.1108 ns |
| Setup / hold TNS | 0 ns / 0 ns |
| Detailed-router violations | 59 → 29 → 20 → 0 |
| Global-routing overflow | 0 reported |
| Worst static VDD drop | approximately 5.93 mV |
| Worst static VSS bounce | approximately 3.17 mV |

The detailed-routing sequence is the router's iterative reduction of its supported violations. It should not be interpreted as a sequence of manually authored engineering ECOs.

## What the Work Demonstrates

- Physical implementation stage relationships
- CTS topology and reported clock skew interpretation
- Global-routing demand, capacity, and congestion analysis
- Detailed-routing wires, vias, and router-supported violation closure
- Final SPEF-based setup and hold analysis
- PPA and physical-only cell interpretation
- Single-die static VDD and VSS power-grid analysis
- Careful separation of observed results from broader signoff claims

## Primary Evidence

- [OpenROAD project overview](../../04_openroad_practice/README.md)
- [Consolidated PPA and signoff-boundary table](../../04_openroad_practice/05_ppa_summary/openroad-ppa-table.md)
- [CTS, routing, and final timing analysis](../../04_openroad_practice/03_reports/cts-routing-notes.md)
- [Floorplan and placement analysis](../../04_openroad_practice/03_reports/floorplan-placement-notes.md)
- [Synthesis-output analysis](../../04_openroad_practice/03_reports/synthesis-output-notes.md)
- [Repository artifact manifest](../../04_openroad_practice/ARTIFACTS.md)

## Visual Evidence

- [Final routed layout](../../04_openroad_practice/04_screenshots/day37_first_flow/final_routed_layout.png)
- [Placement-density heat map](../../04_openroad_practice/04_screenshots/day39_floorplan_placement/placement-density-heatmap.png)
- [Clock-tree connectivity](../../04_openroad_practice/04_screenshots/day40_cts_routing/cts-clock-tree-connectivity.png)
- [Global-routing congestion](../../04_openroad_practice/04_screenshots/day40_cts_routing/global-routing-congestion.png)
- [Detailed-routing wires and vias](../../04_openroad_practice/04_screenshots/day40_cts_routing/detailed-routing-wires-vias.png)

## Analysis Boundary

The results apply only to the educational ORFS Nangate45 GCD configuration and analyzed timing environment. They do not establish foundry signoff DRC, LVS, ERC, electromigration signoff, dynamic IR drop, multi-mode multi-corner timing, package-aware Power Integrity, workload-accurate power, silicon frequency, full repository reproducibility, or tapeout readiness.
