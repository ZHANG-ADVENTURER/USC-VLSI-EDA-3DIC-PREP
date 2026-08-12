# Project Title

OpenROAD RTL-to-GDSII Baseline Practice

# Overview

This module documents a complete baseline OpenROAD implementation flow using the official Nangate45 GCD example design.

The work follows the design from environment setup and first-flow execution through synthesis, floorplanning, placement, Clock Tree Synthesis, global routing, detailed routing, final parasitic extraction, PPA analysis, and signoff-boundary review.

The main implementation sequence is:

> Environment setup  
> → Official GCD flow execution  
> → Synthesis analysis  
> → Floorplanning and placement analysis  
> → Clock Tree Synthesis  
> → Global routing  
> → Detailed routing  
> → Final SPEF-based timing  
> → PPA and IR-drop summary

This module analyzes an official OpenROAD-flow-scripts baseline. It is not an independently created RTL or physical-design implementation.

# Files

| Path | Description |
|---|---|
| `01_setup_log/setup_log.md` | Records the OpenROAD and Docker environment setup and initial flow bring-up. |
| `02_example_design/first-flow-summary.md` | Summarizes the first successful Nangate45 GCD RTL-to-GDSII flow. |
| `03_reports/synthesis-output-notes.md` | Analyzes synthesis outputs, hierarchy, cell population, area, and timing checks. |
| `03_reports/floorplan-placement-notes.md` | Analyzes the die, core, rows, power distribution network, placement, density, and timing changes. |
| `03_reports/cts-routing-notes.md` | Analyzes CTS, clock connectivity, global routing, detailed routing, final SPEF timing, filler cells, and routing checks. |
| `04_screenshots/day37_first_flow/` | Contains first-flow evidence, including final layout, area/utilization, and power views. |
| `04_screenshots/day38_synthesis/` | Contains synthesis-stage hierarchy, statistics, cell-area, instance, and check evidence. |
| `04_screenshots/day39_floorplan_placement/` | Contains floorplan, row, PDN, placement, and density evidence. |
| `04_screenshots/day40_cts_routing/` | Contains clock-tree connectivity, congestion, and detailed-routing evidence. |
| `05_ppa_summary/openroad-ppa-table.md` | Consolidates final performance, power, area, routing, clock, IR-drop, handoff, and signoff-boundary results. |
| [`ARTIFACTS.md`](ARTIFACTS.md) | Distinguishes repository-stored evidence, unpreserved ORFS outputs, and historical run-environment paths. |

Related daily logs are stored separately under the repository-level `daily-log/` directory.

# Module Description

## Environment and First Flow

The module begins with Docker-based OpenROAD setup and execution of the official Nangate45 GCD flow.

The first-flow review establishes the major RTL-to-GDSII stages and verifies that OpenROAD generated final databases, reports, routed geometry, timing results, power estimates, and GDSII output.

## Synthesis Analysis

The synthesis report examines:

- Synthesized hierarchy
- Gate-level instance population
- Sequential and combinational cells
- Area distribution
- Timing constraints
- Initial setup and hold results
- Logical netlist structure

The analysis uses only files and reports produced by the official flow.

## Floorplanning and Placement

The floorplan and placement report examines:

- Die and core boundaries
- Standard-cell rows
- Alternating row orientation
- Power-distribution structures
- Placement population
- Placement density
- Timing changes after placement
- The difference between placement geometry and routed geometry

## Clock Tree Synthesis

The CTS analysis reconstructs the implemented clock network from OpenDB connectivity.

The clock tree contains:

> Top-level clock `clk`  
> → one root `CLKBUF_X3`  
> → four leaf `CLKBUF_X3` cells  
> → four leaf clock nets  
> → 35 DFF clock pins and 3 dummy loads

The final worst reported clock skew is approximately 1.1 ps.

The DEF confirms that `CTS_NDR_0` is assigned to the top-level clock net and shared clock trunk.

## Routing

Global routing reports 617 routed nets and zero total overflow. Most routing demand is concentrated on Metal2 and Metal3.

Detailed routing converts global guides into track-level wires and vias. The router reduces its reported violations from 59 to 29, then 20, and finally zero.

The final detailed-routing statistics include:

| Metric | Result |
|---|---:|
| Detailed wirelength | 3625 µm |
| Final vias | 3281 |
| Final router violations | 0 |
| Net-level antenna violations | 0 |
| Pin-level antenna violations | 0 |

## Final Timing and PPA

Final timing uses the final OpenROAD database and `6_final.spef`.

| Metric | Final result |
|---|---:|
| Clock constraint | 0.4600 ns |
| Worst setup slack | +0.0160 ns |
| Worst hold slack | +0.1108 ns |
| Setup TNS | 0 ns |
| Hold TNS | 0 ns |
| Estimated Fmax | 2.2523 GHz |

Final power is 2.45292 mW. Final counted instance area is 683.354 µm², core area is 1076.77 µm², and utilization is 63.4634%.

The final power-grid report gives a worst VDD IR drop of 5.93 mV and a worst VSS ground bounce of 3.17 mV.

## Final Handoff

The original ORFS run generated the following final handoff set, which is referenced in the analysis but is not stored in this repository:

- `6_final.v`
- `6_final.sdc`
- `6_final.spef`
- `6_final.def`
- `6_final.odb`
- `6_final.gds`

In the original run, the logical netlist preserved functional and clock-tree connectivity but excluded physical-only filler and tap cells. The DEF and ODB preserved the physical implementation. See [`ARTIFACTS.md`](ARTIFACTS.md) for the boundary between stored evidence and unpreserved run outputs.

The available results support baseline timing, routing, antenna, and static power-grid conclusions. They do not establish foundry signoff DRC, LVS, ERC, electromigration, dynamic IR drop, multi-mode multi-corner timing, package-aware analysis, or tapeout readiness.

# Testbench

No standalone RTL testbench was created for this module.

The module uses the official Nangate45 GCD example design and focuses on physical implementation, report interpretation, database inspection, and final handoff analysis rather than independent RTL functional verification.

# Waveform

No simulation waveform was generated for this module.

The evidence stored here consists of analysis notes and GUI screenshots derived from the original run. Raw logs, OpenDB checkpoints, DEF, SPEF, GDSII, and other final run outputs were not preserved in this repository.
