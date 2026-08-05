# Day 40 Daily Log

## Topic

Clock Tree Synthesis, Global Routing, Detailed Routing, and Final SPEF-Based Timing

## What I Learned

Today I analyzed the implementation stages after detailed placement in the official Nangate45 GCD OpenROAD flow.

I first examined Clock Tree Synthesis. The pre-CTS detailed-placement checkpoint contained 606 instances, while the post-CTS checkpoint contained 614 instances. By querying OpenDB instance names, masters, pins, and connected nets, I confirmed that CTS inserted eight clock-related instances:

- One root `CLKBUF_X3`
- Four leaf `CLKBUF_X3` cells
- Two dummy-load `INV_X1` cells
- One dummy-load `CLKBUF_X1`

The reconstructed clock structure is:

> Top-level clock `clk`  
> → one root clock buffer  
> → four leaf clock buffers  
> → four leaf clock nets  
> → 35 DFF clock pins and 3 dummy loads

The four leaf branches contained 9, 10, 9, and 10 input-pin loads. All 35 flip-flop clock pins identified during synthesis were covered by the clock tree. The dummy loads were connected only as clock-net sinks and were used to help balance electrical loading.

The worst reported clock skew after CTS was approximately 1.1 ps. This value was small relative to the 0.46 ns clock period. I also learned that a virtual clock can constrain I/O timing without having a physical propagated clock tree. Therefore, `vclk_core_clock` correctly participated in input/output path analysis but had no internal launch/capture clock paths.

I then compared timing across implementation stages. CTS used propagated clocks with placement-estimated parasitics. Global routing used global-route-based parasitic estimation. The detailed-route GUI still used the global-routing parasitic model, even though exact routed geometry was present. The final GUI loaded the stage-6 database and final SPEF, allowing final extracted timing analysis.

The worst setup slack changed from +5.5 ps after CTS to +0.8 ps after global routing, then improved to +16.0 ps with final SPEF. The worst hold slack remained positive throughout the flow and ended at +110.8 ps.

The critical setup path also changed across stages:

> CTS: register-to-output path ending at `resp_msg[11]`  
> → Global routing: register-to-output path ending at `resp_msg[15]`  
> → Final SPEF: internal register-to-register path from `a_reg[15]` to `a_reg[5]`

This demonstrated that the critical path is not fixed. Changes in parasitic estimation can change both path delays and path ranking.

Global routing completed 617 nets and reported zero horizontal, vertical, and total congestion overflow. Metal2 and Metal3 carried most of the routing demand. The routing-congestion heat map still showed several relatively high-pressure internal regions, but the numerical report confirmed that demand did not exceed capacity.

Detailed routing converted the global guides into exact track-level wires and vias. The router reduced its reported violations from 59 to 29, then 20, and finally zero. The final routed geometry contained 3625 µm of signal wirelength and 3281 vias. Approximately 89.4% of the reported wirelength was on Metal2 and Metal3.

The detailed-routing checkpoint contained 1068 total instances. Direct database queries confirmed that 454 were filler cells, leaving 614 non-filler instances. The filler cells explained the entire instance increase after global routing.

## What I Built

I completed the following report:

> `04_openroad_practice/03_reports/cts-routing-notes.md`

The report includes:

- CTS instance and connectivity analysis
- Clock-tree topology and leaf-load distribution
- Post-CTS timing and clock-skew analysis
- Global-routing congestion, wirelength, timing, and power results
- Detailed-routing iteration history, wirelength, vias, and antenna results
- Filler-cell analysis
- Route-GUI versus final-SPEF timing-model comparison
- Final setup, hold, and critical-path analysis
- Engineering limitations of OpenROAD routing and DRC results

I also identified the following screenshot set for Day 40:

> `04_openroad_practice/04_screenshots/day40_cts_routing/`

Recommended evidence:

- `cts-clock-tree-connectivity.png`
- `global-routing-congestion.png`
- `detailed-routing-wires-vias.png`

## Key Concepts

### Clock Tree Synthesis

CTS inserts and connects clock buffers to distribute a clock from its source to sequential sinks while controlling latency, skew, transition, capacitance, power, and routing impact.

### Clock Latency

Clock latency is the delay from the clock source to a sequential clock pin. After CTS, different sinks have nonzero physical clock-network latency.

### Clock Skew

Clock skew is the clock-arrival-time difference between two sequential sinks. The final worst reported skew in this design was approximately 1.1 ps.

### Dummy Clock Load

A dummy clock load is a sink-only buffer or inverter input added to a clock branch to help balance its electrical load and arrival behavior.

### Global Routing

Global routing assigns approximate routing regions, layers, and routing resources on a coarse grid. It produces routing guides rather than final track-level geometry.

### Routing Congestion

Routing congestion compares routing demand with available capacity. A relatively high-pressure heat-map region does not automatically imply overflow or a DRC violation.

### Detailed Routing

Detailed routing converts global guides into exact tracks, wire segments, jogs, layer transitions, and vias while repairing shorts, spacing violations, and other supported routing-rule violations.

### Filler Cell

A filler cell occupies gaps between placed standard cells and supports well, implant, and power-rail continuity. It does not implement ordinary logic and is different from metal fill.

### SPEF-Based Timing

SPEF-based timing uses extracted interconnect resistance and capacitance from the implemented routing geometry. It is more physically specific than placement-based or global-routing-based estimation.

### Critical-Path Migration

Critical-path migration occurs when the worst timing path changes after placement, routing, or parasitic extraction changes path delays and path ranking.

## Problems / Fixes

### Problem 1: `report_cts` Returned Zero Statistics

After loading the CTS checkpoint into a new GUI process, `report_cts` showed zero roots, buffers, subnets, and sinks.

Fix:

I did not interpret the zeros as evidence that CTS failed. I queried the OpenDB checkpoint directly and confirmed eight CTS-added instances, their masters, pins, nets, and complete clock-tree connectivity.

### Problem 2: Tcl Variables Were Missing After Reopening a GUI

The `$block` variable caused a `no such variable` error after a new GUI session was opened.

Fix:

I recreated the session-local variable with:

> `set block [ord::get_db_block]`

I learned that Tcl variables are not stored in the ODB and do not persist across OpenROAD processes.

### Problem 3: Shell Commands Were Entered in the Tcl Console

Commands such as `grep` produced `invalid command name` errors in the OpenROAD GUI.

Fix:

I separated the two environments:

- Docker shell for `grep`, `find`, `wc`, `sed`, and `make`
- OpenROAD Tcl Console for `report_checks`, `report_worst_slack`, and OpenDB queries

### Problem 4: The Filler-Cell Match Initially Returned Zero

The first filler query used exact strings without wildcard characters, so names such as `FILLER_*` did not match.

Fix:

I used wildcard matching for instance and master names. The corrected query found 454 filler instances, exactly explaining the increase from 614 to 1068 total instances.

### Problem 5: Route and Final GUI Timing Results Were Mixed

A timing report from the route GUI was initially mistaken for final SPEF timing.

Fix:

I reopened `gui_final`, confirmed that `ODB_FILE` pointed to `6_final.odb`, confirmed that `6_final.spef` existed, and reran the timing reports in the same final GUI session. The final timing values were +16.0 ps setup slack and +110.8 ps hold slack.

## Connection to VLSI / EDA / 3D IC

This work connects directly to Physical Design and STA responsibilities. A physical-design engineer must understand how CTS, congestion, routing, filler insertion, and parasitic extraction alter the implemented database and timing results.

The analysis also shows why EDA work is not only running automated tools. The engineer must determine which checkpoint is loaded, which parasitic model is active, whether a report reflects runtime state or database state, and what conclusions the result can support.

For advanced packaging and 3D IC, the same reasoning becomes more important because clock and signal paths may include additional interconnect structures, longer vertical connections, package parasitics, and cross-die timing effects. Accurate extraction and stage-aware timing analysis remain essential.

## One Sentence Summary

I traced the GCD design from CTS through global and detailed routing to final SPEF timing, reconstructed its clock tree, quantified routing behavior, and verified that the final implementation passed setup and hold with +16.0 ps and +110.8 ps slack.

## Next Step

Analyze the final implementation and signoff-oriented outputs, including final area, power, extracted parasitics, output databases, and the limits of the available DRC, antenna, and timing evidence.
