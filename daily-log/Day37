# Day 37 Daily Log

## Topic

Running the First Complete OpenROAD RTL-to-GDSII Example Flow

## What I Learned

Today I ran the official Nangate45 GCD example through a complete OpenROAD Flow Scripts implementation flow. The main objective was not to optimize the design, but to connect the RTL-to-GDSII concepts studied earlier with real tool execution, stage databases, reports, and final layout output.

The flow used:

> Platform: `nangate45`  
> Design: `gcd`  
> Configuration: `designs/nangate45/gcd/config.mk`

The main command was:

> `make DESIGN_CONFIG=./designs/nangate45/gcd/config.mk`

The flow completed synthesis, floorplanning, power-distribution-network generation, placement, clock tree synthesis, global routing, detailed routing, fill insertion, GDS merge, and final reporting. The complete run took approximately 15 seconds and reached a peak memory usage of approximately 994 MB.

I learned that OpenROAD preserves intermediate implementation states as `.odb` files. Each database is a physical-design snapshot after a specific stage. For example, `1_synth.odb` represents the synthesized design imported into OpenROAD, `3_5_place_dp.odb` represents detailed placement, `4_1_cts.odb` represents the design after clock tree synthesis, and `5_2_route.odb` represents the routed design. This makes the flow easier to inspect and debug because the engineer can identify the stage at which a problem appears.

I also learned the distinction between the three major output categories:

> Results contain design artifacts.  
> Reports contain quality and analysis results.  
> Logs contain tool execution details.

The final results included the gate-level netlist, physical database, DEF, SDC, SPEF, and GDSII files. The final GDSII file was `6_final.gds`, while `6_final.spef` stored the extracted interconnect parasitics used for post-route timing and power analysis.

The final timing report showed a clock-period constraint of 0.46 ns, a reported minimum period of approximately 0.44 ns, and an estimated maximum frequency of approximately 2.25 GHz. The worst setup slack was +0.02 ns and setup TNS was 0.00 ns. The flow reported zero setup, hold, max-slew, max-capacitance, and max-fanout violations.

I verified timing coverage more carefully by loading the final database and SPEF in the OpenROAD GUI and running:

> `check_setup -unconstrained_endpoints`

The command returned a successful Boolean result and did not list any unconstrained endpoint objects. This showed that the final design did not report an unconstrained-endpoint problem under the current constraints.

The final power estimate was 2.45 mW. Internal power was 1.33 mW, switching power was 1.11 mW, and leakage power was 15.8 µW. Combinational logic contributed 63.3% of the total power, sequential logic contributed 24.8%, and the clock network contributed 11.9%. Because no workload-accurate VCD or SAIF activity result was confirmed, this number must be treated as a tool estimate rather than measured or workload-accurate power.

The final design area was 683 µm² with 63% utilization. The initial configuration used 55% core utilization, but the final utilization increased because later implementation stages may resize cells, insert buffers, build the clock tree, and repair timing or electrical constraints.

Finally, I opened the routed design in the OpenROAD GUI. The final view showed the die and core boundaries, standard-cell rows, flip-flops, combinational cells, filler cells, PDN straps, signal routing, vias, and boundary I/O pins. The design did not contain a large SRAM or hard macro.

## What I Built

I completed one full official OpenROAD RTL-to-GDSII run for the Nangate45 GCD design.

The generated final artifacts included:

- `6_final.odb`
- `6_final.def`
- `6_final.v`
- `6_final.sdc`
- `6_final.spef`
- `6_final.gds`

I also captured the final routed-layout view and prepared:

> `04_openroad_practice/02_example_design/first-flow-summary.md`

The routed-layout screenshot is intended for:

> `04_openroad_practice/04_screenshots/day37-final-routed-layout.png`

## Key Concepts

### OpenROAD Flow Scripts

OpenROAD Flow Scripts is the automation framework that connects synthesis, physical implementation, analysis, reports, logs, and final layout generation into one reproducible flow.

### OpenROAD Database

An `.odb` file stores the OpenROAD physical-design database at a particular implementation stage. Intermediate ODB files allow stage-by-stage inspection and debugging.

### Results

Results are the actual design outputs, such as ODB, Verilog, DEF, SDC, SPEF, and GDSII files.

### Reports

Reports describe design quality and implementation status, including timing, power, placement, routing, congestion, and violation information.

### Logs

Logs record tool commands, warnings, errors, runtime, memory usage, and optimization messages.

### SPEF

SPEF stores extracted interconnect resistance and capacitance after routing. These parasitics affect post-route timing and power analysis.

### Timing Coverage

Timing coverage means that the required startpoints and endpoints are properly constrained. Zero violations are meaningful only when the constraints cover the relevant paths.

### Core Utilization

Core utilization is the ratio of placed design-cell area to available core area. It does not represent the percentage of visible layout pixels occupied by all routing and physical geometry.

## Problems / Fixes

### Problem 1: Docker Was Not Available Inside Ubuntu

The first attempt to enter the ORFS Docker environment failed because the `docker` command was not available in the WSL2 Ubuntu distribution.

Fix:

Docker Desktop was opened, WSL integration for Ubuntu was enabled, and Ubuntu was restarted. After that, `util/docker_shell bash` successfully entered the OpenROAD container.

### Problem 2: The Meaning of the Unconstrained-Path Report Was Misinterpreted

The `report_checks -unconstrained` section still displayed normal constrained timing paths. Treating every displayed path as an unconstrained path would have produced an incorrect conclusion.

Fix:

The final design was loaded in the OpenROAD GUI, and `check_setup -unconstrained_endpoints` was used instead. The command returned success and did not list unconstrained endpoint objects.

### Problem 3: A Zero-Byte DRC Report Could Be Overstated

The generated `5_route_drc.rpt` file was empty. It would be inaccurate to claim that this proves complete foundry signoff DRC success.

Fix:

The result was recorded narrowly:

> No routing DRC entries were written to the generated routing DRC report.

No claim was made about full foundry DRC, LVS, antenna, EM, IR-drop, or multi-corner signoff completion.

## Connection to VLSI / EDA / 3D IC

This exercise converted the RTL-to-GDSII flow from a conceptual sequence into a real EDA workflow. It directly supports Physical Design, STA, and EDA/CAD preparation because it required running the flow, identifying implementation artifacts, reading timing and power reports, checking timing coverage, and inspecting the final routed database.

The database-driven flow is also relevant to larger 2.5D and 3D IC systems. Each die or chiplet still requires synthesis, placement, clock distribution, routing, parasitic extraction, timing analysis, power analysis, and physical verification. Packaging-aware design adds die-to-die interconnect, thermal, power-delivery, and integration constraints on top of these core implementation steps.

## One Sentence Summary

I completed and analyzed my first official OpenROAD RTL-to-GDSII flow, producing a final routed GDSII design with passing reported timing checks and documented timing, power, area, and utilization results.

## Next Step

compare the original `gcd.v` RTL with the synthesized `1_2_yosys.v` gate-level netlist.
