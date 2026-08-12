# OpenROAD PPA Summary

## 1. Design and Flow

| Item | Value |
|---|---|
| Platform | Nangate45 |
| Design | GCD |
| Design configuration | `./designs/nangate45/gcd/config.mk` |
| Clock constraint | 0.4600 ns |
| Final database (historical run path) | `/work/results/nangate45/gcd/base/6_final.odb` |
| Final netlist (historical run path) | `/work/results/nangate45/gcd/base/6_final.v` |
| Final constraints (historical run path) | `/work/results/nangate45/gcd/base/6_final.sdc` |
| Final parasitics (historical run path) | `/work/results/nangate45/gcd/base/6_final.spef` |
| Final physical exchange file (historical run path) | `/work/results/nangate45/gcd/base/6_final.def` |
| Final layout geometry (historical run path) | `/work/results/nangate45/gcd/base/6_final.gds` |

This summary is based on the official ORFS Nangate45 GCD baseline flow. It is not an independently created physical-design implementation.

The listed `/work/results/...` locations are historical paths from the original ORFS container. The corresponding final outputs are not stored in this repository; see the [artifact manifest](../ARTIFACTS.md).

## 2. Performance Summary

| Metric | Final result |
|---|---:|
| Clock period constraint | 0.4600 ns |
| Worst setup slack | +0.0160 ns |
| Worst hold slack | +0.1108 ns |
| Setup TNS | 0.0000 ns |
| Hold TNS | 0.0000 ns |
| Reported minimum period | Approximately 0.44 ns |
| Estimated maximum frequency | 2.2523 GHz |
| Setup violations | 0 |
| Hold violations | 0 |
| Maximum slew violations | 0 |
| Maximum fanout violations | 0 |
| Maximum capacitance violations | 0 |

The final worst setup path was:

> `dpath.a_reg.out[15]`  
> → multi-level combinational logic  
> → `dpath.a_reg.out[5]`

The final worst hold path was:

> `dpath.b_reg.out[8]/Q`  
> → `INV_X1`  
> → `OAI21_X1`  
> → `dpath.b_reg.out[8]/D`

The reported maximum frequency applies only to the current single timing environment, Nangate45 library data, SDC constraints, and final SPEF. It is not a silicon frequency guarantee or a multi-corner signoff result.

## 3. Power Summary

| Power component | Final result |
|---|---:|
| Internal power | 1.32856 mW |
| Switching power | 1.10858 mW |
| Leakage power | 0.0157785 mW |
| **Total power** | **2.45292 mW** |

| Design group | Power | Share |
|---|---:|---:|
| Sequential | 0.609 mW | 24.8% |
| Combinational | 1.55 mW | 63.3% |
| Clock | 0.291 mW | 11.9% |
| **Total** | **2.45 mW** | **100%** |

| Power type | Share |
|---|---:|
| Internal | 54.2% |
| Switching | 45.2% |
| Leakage | 0.6% |

No workload-accurate VCD or SAIF activity source was confirmed. These values are tool-estimated power results and should be used as a baseline rather than as application-accurate measurements.

## 4. Area Summary

| Metric | Final result |
|---|---:|
| Die area | 1278.42 µm² |
| Core area | 1076.77 µm² |
| Counted instance area | 683.354 µm² |
| Standard-cell utilization | 63.4634% |
| Macro area | 0 µm² |
| Pad-cell area | 0 µm² |

The final DEF uses:

> `UNITS DISTANCE MICRONS 2000`

The reported die boundary is:

> `(0, 0)` to `(71510, 71510)`

This corresponds to:

> 35.755 µm × 35.755 µm  
> = approximately 1278.42 µm²

The utilization relationship is:

> 683.354 µm² / 1076.77 µm²  
> = 63.4634%

Filler-cell area is excluded from the utilization numerator.

## 5. Instance and Cell-Area Breakdown

| Cell class | Count | Area |
|---|---:|---:|
| Fill cell | 454 | 393.41 µm² |
| Tap cell | 46 | 12.24 µm² |
| Clock buffer | 6 | 7.45 µm² |
| Timing repair buffer | 62 | 51.60 µm² |
| Inverter | 86 | 48.41 µm² |
| Clock inverter | 2 | 1.06 µm² |
| Sequential cell | 35 | 158.27 µm² |
| Multi-input combinational cell | 377 | 404.32 µm² |
| **Total** | **1068** | **1076.77 µm²** |

The counted instance area is:

> 683.354 µm²

The filler-cell area is:

> 393.414 µm²

Together:

> 683.354 µm² + 393.414 µm²  
> = 1076.768 µm²  
> ≈ 1076.77 µm² core area

This shows that filler cells occupy the remaining placement-row area while remaining excluded from the standard utilization numerator.

## 6. Clock Summary

| Metric | Final result |
|---|---:|
| Root clock buffers | 1 |
| Leaf clock buffers | 4 |
| Dummy clock loads | 3 |
| DFF clock sinks | 35 |
| Worst reported clock skew | 1.1 ps |
| Source latency in worst-skew pair | 71.7 ps |
| Target latency in worst-skew pair | 70.6 ps |

The reconstructed clock tree is:

> `clk`  
> → one root `CLKBUF_X3`  
> → four leaf `CLKBUF_X3` cells  
> → four leaf clock nets  
> → 35 DFF clock pins and 3 dummy loads

The DEF confirmed that `CTS_NDR_0` was assigned to the root clock net `clk` and the shared trunk net `clknet_0_clk`.

## 7. Routing Summary

| Metric | Final result |
|---|---:|
| Global-routed nets | 617 |
| Global-routing total wirelength | 6421 µm |
| Global-routing vias | 3288 |
| Global-routing total overflow | 0 |
| Detailed-routing wirelength | 3625 µm |
| Detailed-routing vias | 3281 |
| Final detailed-router violations | 0 |
| Detailed-routing runtime | 9.66 s |
| Net-level antenna violations | 0 |
| Pin-level antenna violations | 0 |

Detailed-routing wirelength by layer:

| Layer | Wirelength |
|---|---:|
| Metal1 | 0 µm |
| Metal2 | 1588 µm |
| Metal3 | 1652 µm |
| Metal4 | 279 µm |
| Metal5 | 64 µm |
| Metal6 | 41 µm |
| Metal7–Metal10 | 0 µm |

Metal2 and Metal3 together carried:

> 3240 µm

This is approximately:

> 3240 / 3625 = 89.4%

The global-routing and detailed-routing wirelength values use different routing representations and should not be interpreted as a direct wirelength reduction percentage.

## 8. Global-Routing Congestion

| Layer | Resource | Demand | Usage | Overflow |
|---|---:|---:|---:|---:|
| Metal1 | 0 | 0 | 0.00% | 0 |
| Metal2 | 935 | 552 | 59.04% | 0 |
| Metal3 | 1353 | 586 | 43.31% | 0 |
| Metal4 | 935 | 145 | 15.51% | 0 |
| Metal5 | 975 | 43 | 4.41% | 0 |
| Metal6–Metal10 | Available | 0 | 0.00% | 0 |
| **Total** | **6107** | **1326** | **21.71%** | **0** |

The congestion heat map showed relatively higher routing pressure in several internal regions, but the numerical report showed zero horizontal, vertical, and total overflow.

A high-pressure heat-map region is not automatically a routing overflow or detailed-routing DRC violation.

## 9. IR-Drop Summary

### VDD

| Metric | Result |
|---|---:|
| Supply voltage | 1.10 V |
| Worst-case voltage | 1.09407 V |
| Average voltage | 1.09804 V |
| Average IR drop | 1.96 mV |
| Worst-case IR drop | 5.93 mV |
| Percentage drop | 0.54% |

### VSS

| Metric | Result |
|---|---:|
| Supply voltage | 0.00 V |
| Worst-case voltage | 3.17 mV |
| Average voltage | 1.80 mV |
| Average ground bounce | 1.80 mV |
| Worst-case ground bounce | 3.17 mV |
| Percentage drop | 0.29% |

The power-grid analysis reported:

- All shapes on VDD were connected.
- All shapes on VSS were connected.
- Total analyzed power was 2.45 mW.
- The power-source model used a bump pattern with 140 µm x-pitch, 140 µm y-pitch, 70 µm size, and a 3× reduction factor.

The GUI warned that the IR-drop heat map was not populated with data. Therefore, the numerical log is the available evidence; no validated IR-drop heat-map screenshot was produced.

These IR-drop values come from the OpenROAD power-grid model used in this single baseline run. They do not establish full package-aware, multi-corner, dynamic, or foundry signoff power-integrity closure.

## 10. Final Handoff Files

| File | Size | Function |
|---|---:|---|
| `6_final.v` | 47 KB | Final gate-level logical connectivity |
| `6_final.sdc` | 6.0 KB | Final timing constraints |
| `6_final.spef` | 431 KB | Extracted interconnect parasitics |
| `6_final.def` | 395 KB | Final physical implementation exchange data |
| `6_final.odb` | 1.2 MB | Reloadable OpenROAD physical database |
| `6_final.gds` | 517 KB | Final layout geometry |

The SHA-256 checksums of `6_1_merged.gds` and `6_final.gds` were identical, proving that the two files were byte-for-byte identical.

The checksums of `6_1_fill.odb` and `6_final.odb` were different. This proves that the two serialized databases were not byte-for-byte identical, but the checksum alone does not identify the internal cause of the difference.

## 11. Logical and Physical Handoff Boundary

The final Verilog contained:

| Object | Count |
|---|---:|
| `clkbuf_*` instances | 5 |
| `clkload*` instances | 3 |
| `FILLER_*` instances | 0 |
| `TAPCELL*` instances | 0 |

The final physical database and DEF contained 1068 components, including 454 filler cells and 46 tap cells.

Therefore:

- `6_final.v` preserves functional and clock-tree connectivity.
- `6_final.def` and `6_final.odb` preserve physical-only cells and implementation geometry.
- Physical-only tap and filler cells are intentionally absent from the logical netlist.

## 12. SPEF and DEF Coverage

The final SPEF contained:

> 617 `*D_NET` parasitic sections

The final DEF contained:

| DEF section | Count |
|---|---:|
| Components | 1068 |
| Top-level pins | 54 |
| Special nets | 2 |
| Nets | 636 |

The two special nets were:

- `VDD`, with `USE POWER`
- `VSS`, with `USE GROUND`

The 54 top-level physical pins correspond to the bit-level width of the design interface.

The difference between 636 DEF nets and 617 SPEF `*D_NET` sections was observed but not fully resolved. It should not be described as missing parasitic coverage without a direct net-by-net comparison.

## 13. Signoff Boundaries

The available results support the following statements:

- Final setup and hold checks passed in the analyzed timing environment.
- Setup TNS and hold TNS were zero.
- Maximum slew, fanout, and capacitance violation counts were zero.
- Global routing reported zero congestion overflow.
- Detailed routing reduced its supported routing violations to zero.
- The route DRC report contained no residual entries.
- The OpenROAD antenna checker reported zero net and pin violations.
- The power-grid analysis reported connected VDD and VSS shapes and low static voltage-drop values.

The available results do not establish:

- Foundry signoff DRC
- LVS
- ERC
- Multi-mode multi-corner timing signoff
- Crosstalk-aware noise signoff
- Dynamic IR drop
- Electromigration signoff
- Package-aware or 3D-IC power integrity
- Silicon frequency guarantee
- Workload-accurate power
- Full tapeout readiness
