# Clock Tree Synthesis and Routing

## 1. Objective

This report analyzes the post-placement implementation stages of the official Nangate45 GCD OpenROAD flow:

> Detailed placement  
> → Clock Tree Synthesis  
> → Global routing  
> → Detailed routing  
> → Final SPEF-based timing

The goal is to understand how the clock network, routing resources, physical geometry, parasitic model, timing results, and instance population change across these stages.

The design and flow used in this report are:

| Item | Value |
|---|---|
| Platform | Nangate45 |
| Design | GCD |
| Design configuration | `./designs/nangate45/gcd/config.mk` |
| Results directory | `/work/results/nangate45/gcd/base` |
| Reports directory | `/work/reports/nangate45/gcd/base` |
| Logs directory | `/work/logs/nangate45/gcd/base` |
| Clock period constraint | 0.46 ns |

This is an analysis of an official ORFS baseline design. It is not an independently created physical-design implementation.

## 2. Stage Checkpoints

The following OpenDB checkpoints were inspected:

| Stage | Database |
|---|---|
| Detailed placement | `3_5_place_dp.odb` |
| Clock Tree Synthesis | `4_1_cts.odb` |
| Global routing | `5_1_grt.odb` |
| Detailed routing | `5_2_route.odb` |
| Final implementation | `6_final.odb` |

The database sizes increased as routing information and final physical objects were added:

| Database | Size |
|---|---:|
| `3_5_place_dp.odb` | 672 KB |
| `4_1_cts.odb` | 675 KB |
| `5_1_grt.odb` | 925 KB |
| `5_2_route.odb` | 1.1 MB |
| `6_final.odb` | 1.2 MB |

Database size is only an auxiliary indicator. It does not directly quantify the number of wires, vias, parasitic elements, or design-rule checks.

## 3. Clock Tree Synthesis

### 3.1 Pre-CTS and Post-CTS Instance Counts

The detailed-placement checkpoint contained 606 instances. The CTS checkpoint contained 614 instances.

| Stage | Total instances |
|---|---:|
| Detailed placement | 606 |
| Post-CTS | 614 |
| Net increase | 8 |

A direct database query found no clock-related instances in the pre-CTS checkpoint and eight clock-related instances in the post-CTS checkpoint.

### 3.2 CTS-Added Instances

The eight CTS-added instances were:

| Instance | Master | Role |
|---|---|---|
| `clkbuf_0_clk` | `CLKBUF_X3` | Root clock buffer |
| `clkbuf_2_0__f_clk` | `CLKBUF_X3` | Leaf clock buffer |
| `clkbuf_2_1__f_clk` | `CLKBUF_X3` | Leaf clock buffer |
| `clkbuf_2_2__f_clk` | `CLKBUF_X3` | Leaf clock buffer |
| `clkbuf_2_3__f_clk` | `CLKBUF_X3` | Leaf clock buffer |
| `clkload0` | `INV_X1` | Dummy clock load |
| `clkload1` | `INV_X1` | Dummy clock load |
| `clkload2` | `CLKBUF_X1` | Dummy clock load |

The five `CLKBUF_X3` instances form the active clock-distribution structure. The three `clkload` instances are sink-only dummy loads. Their input pins are connected to leaf clock nets, while their outputs do not continue the clock tree.

### 3.3 Reconstructed Clock-Tree Topology

The clock connectivity was reconstructed from OpenDB instance and net queries:

> Top-level clock port `clk`  
> → `clkbuf_0_clk / CLKBUF_X3`  
> → `clknet_0_clk`  
> → four leaf `CLKBUF_X3` instances  
> → four leaf clock nets  
> → 35 flip-flop clock pins and 3 dummy loads

The four leaf buffers are connected as follows:

| Leaf buffer | Input net | Output net |
|---|---|---|
| `clkbuf_2_0__f_clk` | `clknet_0_clk` | `clknet_2_0__leaf_clk` |
| `clkbuf_2_1__f_clk` | `clknet_0_clk` | `clknet_2_1__leaf_clk` |
| `clkbuf_2_2__f_clk` | `clknet_0_clk` | `clknet_2_2__leaf_clk` |
| `clkbuf_2_3__f_clk` | `clknet_0_clk` | `clknet_2_3__leaf_clk` |

This is a two-buffer-level clock tree:

> Root buffer level  
> → Leaf buffer level  
> → Sequential sinks

The numerical suffixes in automatically generated names do not independently prove the logical tree depth. The topology was determined from connectivity.

### 3.4 Leaf-Branch Load Distribution

The four leaf nets cover all 35 DFF clock pins identified during synthesis analysis.

| Leaf net | DFF clock pins | Dummy loads | Total input-pin loads |
|---|---:|---:|---:|
| `clknet_2_0__leaf_clk` | 8 | 1 | 9 |
| `clknet_2_1__leaf_clk` | 10 | 0 | 10 |
| `clknet_2_2__leaf_clk` | 8 | 1 | 9 |
| `clknet_2_3__leaf_clk` | 9 | 1 | 10 |
| **Total** | **35** | **3** | **38** |

The load counts are closely balanced at 9, 10, 9, and 10 input pins. Equal pin count does not imply equal capacitance because DFF clock pins, inverter inputs, and clock-buffer inputs can have different input capacitances. CTS balances electrical load, wire RC, transition, latency, and skew rather than only the number of sinks.

### 3.5 `report_cts` Limitation After Reading a Checkpoint

After the CTS checkpoint was loaded into a new OpenROAD GUI process, `report_cts` returned zero roots, buffers, subnets, and sinks. This did not mean CTS had failed.

The OpenDB checkpoint clearly contained the inserted clock cells and their connectivity. The most defensible interpretation is that the database restored the implemented objects, while the CTS runtime statistics used by `report_cts` were not reconstructed in the new process.

Database queries were therefore used as the source of truth for the implemented clock tree.

## 4. Post-CTS Timing

The CTS GUI used propagated clocks and placement-estimated parasitics.

The design contains:

| Clock | Period | Waveform |
|---|---:|---|
| `core_clock` | 0.46 ns | 0.00 ns to 0.23 ns |
| `vclk_core_clock` | 0.46 ns | 0.00 ns to 0.23 ns |

`core_clock` is connected to the physical clock network. `vclk_core_clock` is a virtual I/O reference clock and therefore has no physical launch/capture clock paths.

### 4.1 Clock Latency and Skew

The reported worst clock-sink pair had:

| Item | Value |
|---|---:|
| Source latency | 0.0720 ns |
| Target latency | 0.0709 ns |
| Setup skew | 0.0011 ns |
| Hold skew | 0.0011 ns |

The worst reported skew was therefore approximately 1.1 ps, which is small relative to the 460 ps clock period.

### 4.2 CTS Timing Summary

| Check | Result |
|---|---:|
| Worst setup slack | +0.0055 ns |
| Worst hold slack | +0.1108 ns |
| Setup status | Met |
| Hold status | Met |

The overall CTS-stage setup bottleneck was a register-to-output path with only 5.5 ps of margin. Hold had substantially more margin.

### 4.3 Representative CTS Paths

The worst internal setup path was:

> `dpath.a_reg.out[15]`  
> → multi-level combinational logic  
> → `dpath.a_reg.out[5]`

Its slack was +18.6 ps.

The overall worst setup path was:

> `dpath.a_reg.out[8]`  
> → combinational logic  
> → `resp_msg[11]`

Its slack was +5.5 ps.

The worst internal hold path was a feedback path:

> `dpath.b_reg.out[8]/Q`  
> → `INV_X1`  
> → `OAI21_X1`  
> → `dpath.b_reg.out[8]/D`

Its slack was +110.8 ps. The startpoint and endpoint were the same DFF because the Q output returned to its D input through combinational logic.

## 5. Global Routing

### 5.1 Purpose

Global routing operates on a coarse routing grid. It assigns approximate routing regions, layers, and resource usage, then produces routing guides for detailed routing.

It does not yet define every final track, jog, wire segment, or via location.

### 5.2 Instance Count

The global-routing checkpoint contained 614 instances, equal to the post-CTS count.

| Stage | Instances |
|---|---:|
| Post-CTS | 614 |
| Global routing | 614 |
| Net change | 0 |

Global routing created routing data without causing a net change in the instance population.

### 5.3 Congestion Report

The final global-routing congestion report was:

| Layer | Resource | Demand | Usage | Max H / Max V / Total overflow |
|---|---:|---:|---:|---:|
| Metal1 | 0 | 0 | 0.00% | 0 / 0 / 0 |
| Metal2 | 935 | 552 | 59.04% | 0 / 0 / 0 |
| Metal3 | 1353 | 586 | 43.31% | 0 / 0 / 0 |
| Metal4 | 935 | 145 | 15.51% | 0 / 0 / 0 |
| Metal5 | 975 | 43 | 4.41% | 0 / 0 / 0 |
| Metal6 | 991 | 0 | 0.00% | 0 / 0 / 0 |
| Metal7 | 291 | 0 | 0.00% | 0 / 0 / 0 |
| Metal8 | 341 | 0 | 0.00% | 0 / 0 / 0 |
| Metal9 | 143 | 0 | 0.00% | 0 / 0 / 0 |
| Metal10 | 143 | 0 | 0.00% | 0 / 0 / 0 |
| **Total** | **6107** | **1326** | **21.71%** | **0 / 0 / 0** |

Global routing reported zero horizontal, vertical, and total overflow.

The GUI congestion heat map still showed several relatively high-pressure internal regions. This is not contradictory. A red or orange region can be more congested than other regions while remaining below its routing capacity.

The heat map is evidence of relative routing pressure, not detailed-routing DRC violations.

### 5.4 Global-Routing Statistics

| Metric | Result |
|---|---:|
| Routed nets | 617 |
| Total global-route wirelength | 6421 µm |
| Global-route vias | 3288 |
| Final 3D usage | 11190 |
| Global-routing runtime | Less than 1 second |

Global-route wirelength and via count are coarse-routing statistics. They are not strictly comparable with final detailed-routing geometry.

### 5.5 Global-Routing Parasitic Model

The log explicitly executed:

> `estimate_parasitics -global_routing`

Timing after global routing therefore used global-route-based parasitic estimation rather than placement-only estimation.

### 5.6 Global-Routing Timing and Electrical Checks

| Metric | Result |
|---|---:|
| Worst setup slack | +0.0008 ns |
| Worst hold slack | +0.1123 ns |
| Setup violations | 0 |
| Hold violations | 0 |
| Maximum slew violations | 0 |
| Maximum fanout violations | 0 |
| Maximum capacitance violations | 0 |

Setup still passed, but its margin was only 0.8 ps.

The overall critical path changed to:

> `dpath.a_reg.out[3]`  
> → combinational logic  
> → `resp_msg[15]`

The worst internal register-to-register setup path remained:

> `dpath.a_reg.out[15]`  
> → `dpath.a_reg.out[5]`

The critical-path change shows that path ranking can change when the parasitic model changes.

### 5.7 Global-Routing Power Estimate

| Group | Power | Share |
|---|---:|---:|
| Sequential | 0.616 mW | 24.2% |
| Combinational | 1.63 mW | 64.0% |
| Clock | 0.299 mW | 11.8% |
| **Total** | **2.54 mW** | **100%** |

Power components were:

| Component | Value |
|---|---:|
| Internal | 1.33 mW |
| Switching | 1.20 mW |
| Leakage | 0.0158 mW |

No workload-accurate VCD or SAIF was confirmed, so these values are tool estimates rather than application-accurate power measurements.

## 6. Detailed Routing

### 6.1 Purpose

Detailed routing converts the global-routing guides into legal track-level geometry. It determines:

- Exact routing tracks
- Wire segments and jogs
- Layer transitions
- Via locations
- Spacing-compliant local detours
- Final signal-routing geometry

The detailed-routing GUI showed dense horizontal and vertical signal wires on multiple metal layers, as well as layer-to-layer via geometry. These objects are distinct from the wider PDN straps already present before signal routing.

### 6.2 Filler-Cell Population

The detailed-routing checkpoint contained 1068 instances. Direct name and master queries found 454 filler cells.

| Category | Count |
|---|---:|
| Non-filler instances | 614 |
| Filler instances | 454 |
| Total instances | 1068 |

The entire increase from 614 to 1068 was explained by filler cells.

Filler cells do not implement ordinary logic. They fill placement-row gaps and help maintain well, implant, and power-rail continuity. They are different from metal fill.

### 6.3 Detailed-Router Iterations

The detailed router did not begin with a clean solution. Its reported violations changed across iterations:

> 59  
> → 29  
> → 20  
> → 0

The early violations included shorts, metal-spacing violations, and a cut-spacing violation. Shorts were the dominant initial category.

The final router state reported zero remaining violations.

### 6.4 Final Detailed-Routing Geometry

| Metric | Result |
|---|---:|
| Total detailed wirelength | 3625 µm |
| Total vias | 3281 |
| Detailed-routing runtime | 9.66 seconds |
| Final reported router violations | 0 |

Wirelength by layer was:

| Layer | Wirelength |
|---|---:|
| Metal1 | 0 µm |
| Metal2 | 1588 µm |
| Metal3 | 1652 µm |
| Metal4 | 279 µm |
| Metal5 | 64 µm |
| Metal6 | 41 µm |
| Metal7–Metal10 | 0 µm |

Metal2 and Metal3 together carried 3240 µm, approximately 89.4% of the reported detailed signal wirelength.

The detailed-routing via count of 3281 was close to the global-routing estimate of 3288, but the two values come from different routing representations.

### 6.5 Route DRC Report

`5_route_drc.rpt` had a size of 0 bytes.

By itself, an empty report only means that no entries were written to that file. Combined with the detailed-routing log, the stronger conclusion is:

> The OpenROAD detailed router reduced its reported routing violations to zero, and no residual entries were written to `5_route_drc.rpt`.

This is not equivalent to foundry signoff DRC, LVS, ERC, or complete manufacturing verification.

### 6.6 Antenna Check

The route log reported:

| Check | Violations |
|---|---:|
| Net-level antenna violations | 0 |
| Pin-level antenna violations | 0 |

This conclusion is limited to the OpenROAD antenna checker and the technology information used in this flow. It is not a foundry signoff claim.

## 7. Route GUI Timing Model

The detailed-route GUI displayed the same timing values as the global-routing GUI:

| Metric | Global-routing GUI | Detailed-route GUI |
|---|---:|---:|
| Worst setup slack | +0.0008 ns | +0.0008 ns |
| Worst hold slack | +0.1123 ns | +0.1123 ns |

This did not mean detailed routing had no timing effect.

The ORFS `scripts/open.tcl` logic showed:

> Design stage at least 6 and `6_final.spef` exists  
> → read `6_final.spef`

> Otherwise, design stage at least 5 and global routes exist  
> → run `estimate_parasitics -global_routing`

The route GUI is a stage-5 checkpoint, so its timing analysis still used global-routing parasitic estimation even though track-level routing geometry was present.

## 8. Final SPEF-Based Timing

The final GUI loaded:

> `/work/results/nangate45/gcd/base/6_final.odb`

The existence check for:

> `/work/results/nangate45/gcd/base/6_final.spef`

returned 1. Under the verified stage-6 `open.tcl` branch, the final GUI uses the final SPEF rather than global-routing estimation.

### 8.1 Final Timing Summary

| Check | Final result |
|---|---:|
| Worst setup slack | +0.0160 ns |
| Worst hold slack | +0.1108 ns |
| Setup status | Met |
| Hold status | Met |

### 8.2 Final Worst Setup Path

The final overall worst setup path was:

> `dpath.a_reg.out[15]`  
> → multi-level combinational logic  
> → `dpath.a_reg.out[5]`

Its timing calculation was:

| Item | Value |
|---|---:|
| Launch clock arrival | 0.0716 ns |
| Data arrival time | 0.4854 ns |
| Capture clock arrival | 0.5308 ns |
| Library setup time | 0.0294 ns |
| Data required time | 0.5014 ns |
| Slack | +0.0160 ns |

The final worst register-to-output setup path was:

> `dpath.a_reg.out[10]`  
> → combinational logic  
> → `resp_msg[14]`

Its slack was +0.0167 ns, which was 0.7 ps larger than the internal critical-path slack.

### 8.3 Final Worst Hold Path

The final worst hold path remained:

> `dpath.b_reg.out[8]/Q`  
> → `INV_X1`  
> → `OAI21_X1`  
> → `dpath.b_reg.out[8]/D`

Its timing calculation was:

| Item | Value |
|---|---:|
| Launch and capture clock arrival | 0.0716 ns |
| Data arrival time | 0.1869 ns |
| Library hold time | 0.0045 ns |
| Data required time | 0.0761 ns |
| Slack | +0.1108 ns |

The final output min-delay path was:

> `dpath.b_reg.out[0]`  
> → `resp_msg[0]`

Its slack was +0.2128 ns.

### 8.4 Final Clock Skew

The final worst reported clock-sink pair had:

| Item | Value |
|---|---:|
| Source latency | 0.0717 ns |
| Target latency | 0.0706 ns |
| Setup skew | 0.0011 ns |
| Hold skew | 0.0011 ns |

The approximately 1.1 ps skew remained stable from CTS through final extracted timing.

## 9. Timing Progression

| Stage | Clock and parasitic model | Worst setup slack | Worst hold slack |
|---|---|---:|---:|
| Detailed placement | Ideal clock, placement estimation | Approximately +0.01 ns | Approximately +0.11 ns |
| CTS | Propagated clock, placement estimation | +0.0055 ns | +0.1108 ns |
| Global routing | Propagated clock, global-route estimation | +0.0008 ns | +0.1123 ns |
| Detailed-route GUI | Propagated clock, global-route estimation | +0.0008 ns | +0.1123 ns |
| Final | Propagated clock, final SPEF | +0.0160 ns | +0.1108 ns |

The overall critical path changed across stages:

| Stage | Overall setup bottleneck |
|---|---|
| CTS | `a_reg[8] → resp_msg[11]` |
| Global routing | `a_reg[3] → resp_msg[15]` |
| Final SPEF | `a_reg[15] → a_reg[5]` |

This demonstrates that the critical path is not fixed. Changes in the parasitic model can alter path delays and reorder the most timing-critical endpoints.

For the internal path `a_reg[15] → a_reg[5]`:

| Metric | Global-route estimate | Final SPEF | Change |
|---|---:|---:|---:|
| Data arrival time | 0.4970 ns | 0.4854 ns | −11.6 ps |
| Data required time | 0.5033 ns | 0.5014 ns | −1.9 ps |
| Slack | +6.2 ps | +16.0 ps | +9.8 ps |

In this design, the final extracted data arrival was earlier than the global-routing estimate. This improved setup slack. This result must not be generalized into a rule that detailed routing always improves timing.

## 10. Global Routing Versus Detailed Routing

| Topic | Global routing | Detailed routing |
|---|---|---|
| Representation | Coarse routing grid and guides | Exact track-level geometry |
| Main decision | Approximate regions and routing layers | Exact tracks, segments, jogs, and vias |
| Congestion analysis | Resource demand versus capacity | Rule-clean implementation of wires and vias |
| Wirelength result | 6421 µm coarse-model statistic | 3625 µm final track-level geometry |
| Via result | 3288 estimated routing vias | 3281 final routed vias |
| DRC meaning | Overflow and routability indicators | Detailed-router spacing, short, and cut checks |
| Timing in GUI | Global-route parasitic estimate | Still global-route estimate at stage 5 |
| Final extracted timing | Not available | Available only after loading final SPEF |

The 6421 µm and 3625 µm wirelength values are not an apples-to-apples comparison because the two routing stages use different representations and accounting methods.

## 11. Selected Screenshot Evidence

The selected screenshots for Day 40 are:

- `cts-clock-tree-connectivity.png`
- `global-routing-congestion.png`
- `detailed-routing-wires-vias.png`

The CTS connectivity screenshot provides structural evidence for the root buffer, four leaf buffers, leaf nets, and dummy loads.

The global-routing congestion screenshot shows the routing-congestion heat map with relatively higher internal pressure and lower pressure near much of the perimeter.

The detailed-routing screenshot shows track-level signal wires, routing layers, and via geometry. Timing-path overlays should be disabled in the clean screenshot so that routing geometry remains visible.

## 12. Engineering Conclusions

1. CTS increased the instance count from 606 to 614 by inserting five active clock buffers and three dummy loads.

2. The implemented clock tree contains one root `CLKBUF_X3`, four leaf `CLKBUF_X3` cells, four leaf clock nets, 35 DFF clock sinks, and three dummy loads.

3. The four leaf branches have 9, 10, 9, and 10 input-pin loads, and the final worst reported skew is approximately 1.1 ps.

4. Global routing completed 617 nets with zero reported horizontal, vertical, and total overflow. Metal2 and Metal3 carried most of the routing demand.

5. Global-route-based timing reduced setup margin to only 0.8 ps, showing that a passing timing result can still be extremely fragile.

6. Detailed routing iteratively reduced reported routing violations from 59 to 29, then 20, and finally zero.

7. The detailed-routing checkpoint contains 454 filler cells, but the non-filler instance count remains 614.

8. Final detailed-routing geometry contains 3625 µm of reported signal wirelength and 3281 vias, with approximately 89.4% of the wirelength on Metal2 and Metal3.

9. The route GUI still uses global-routing-based parasitic estimation. Final timing must be evaluated from the final stage that loads `6_final.spef`.

10. Final SPEF-based timing reports +16.0 ps setup slack and +110.8 ps hold slack.

11. The critical path changed from one register-to-output path at CTS, to another register-to-output path after global routing, and finally to an internal register-to-register path after final extraction.

12. Zero OpenROAD routing violations, an empty route DRC report, and zero OpenROAD antenna violations do not establish foundry signoff DRC, LVS, ERC, EM, IR, or full multi-corner signoff.
