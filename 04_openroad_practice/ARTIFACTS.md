# OpenROAD Artifact Manifest

## Purpose

This manifest distinguishes evidence stored in this repository from outputs that were generated during the original OpenROAD-flow-scripts run but were not preserved here. It also explains historical `/work/...` paths recorded in the analysis notes.

## Run Context

| Item | Value |
|---|---|
| Flow | OpenROAD-flow-scripts (ORFS) official baseline |
| Platform | Nangate45 |
| Design | GCD |
| Analysis purpose | Educational physical-implementation and report interpretation |

The repository is not a complete, self-contained reproduction package for the original run.

## Artifacts Stored in This Repository

### Documentation and analysis

- [Environment and setup log](01_setup_log/setup_log.md)
- [First-flow summary](02_example_design/first-flow-summary.md)
- [Synthesis-output analysis](03_reports/synthesis-output-notes.md)
- [Floorplan and placement analysis](03_reports/floorplan-placement-notes.md)
- [CTS, routing, and final-timing analysis](03_reports/cts-routing-notes.md)
- [Consolidated PPA and signoff-boundary summary](05_ppa_summary/openroad-ppa-table.md)

### Screenshots

- `04_screenshots/day37_first_flow/`
- `04_screenshots/day38_synthesis/`
- `04_screenshots/day39_floorplan_placement/`
- `04_screenshots/day40_cts_routing/`

These screenshots preserve selected GUI and report views. They do not replace raw logs, databases, or machine-readable reports.

## Generated During the Original Run but Not Stored Here

The original ORFS run generated outputs including:

- Final OpenDB database: `6_final.odb`
- Final gate-level netlist: `6_final.v`
- Final constraints: `6_final.sdc`
- Final parasitics: `6_final.spef`
- Final physical exchange file: `6_final.def`
- Final layout geometry: `6_final.gds`
- Stage databases, raw logs, reports, and intermediate flow outputs

These files are referenced and analyzed in the repository documentation but are not present in this Git repository. Their absence means the stored repository alone cannot reproduce or independently recheck every reported result.

## Historical Run-Environment Paths

Paths such as:

```text
/work/results/nangate45/gcd/base/6_final.odb
/work/results/nangate45/gcd/base/6_final.v
/work/results/nangate45/gcd/base/6_final.sdc
/work/results/nangate45/gcd/base/6_final.spef
/work/results/nangate45/gcd/base/6_final.def
/work/results/nangate45/gcd/base/6_final.gds
```

are historical paths inside the original Docker/ORFS run environment. They are not repository-relative paths and should not be interpreted as files accessible through this GitHub repository.

## Supported Claims

The stored documentation and screenshots support a documented educational analysis of:

- Synthesis, floorplanning, placement, CTS, and routing stages
- Reported routing demand, congestion, wires, vias, and router-supported violations
- Final timing values reported for the analyzed environment
- Tool-estimated power and single-die static power-grid results under the documented limitations
- Engineering interpretation of the official Nangate45 GCD baseline

## Unsupported Claims

The stored artifacts do not establish:

- Full repository reproducibility
- Independently authored RTL or an independently designed physical implementation
- Foundry signoff DRC, LVS, or ERC
- Multi-mode multi-corner timing signoff
- Workload-accurate power
- Dynamic IR-drop or electromigration signoff
- Package-aware or 3D-IC Power Integrity
- Silicon frequency guarantees
- Tapeout readiness
