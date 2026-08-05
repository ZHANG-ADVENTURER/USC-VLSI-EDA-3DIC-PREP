# Day 34 Daily Log

## Topic

Timing Closure and PPA Tradeoffs

## What I Learned

Today I studied timing closure as an iterative engineering process rather than a single timing-report check.

A positive WNS value from one setup report is not enough to prove that a design has reached timing closure. A complete timing-closure result requires correct constraints, valid timing coverage, passing setup and hold checks, analysis across the required operating modes and PVT corners, and acceptable power, performance, area, congestion, and physical-verification results.

The main timing-closure loop is:

> Validate constraints and timing coverage  
> → Identify the timing violation  
> → Classify the root cause  
> → Select a targeted repair  
> → Update the implementation  
> → Re-extract parasitics  
> → Rerun setup and hold analysis  
> → Check PPA and physical side effects  
> → Repeat until all requirements are satisfied

I learned how to classify a violating path before selecting a repair. A path may be dominated by cell delay, net delay, clock behavior, physical implementation, or incorrect constraints. Cell-delay-dominated paths may be caused by weak drive strength, poor input slew, large output load, slow cell types, or deep combinational logic. Net-delay-dominated paths may be caused by long routing, poor placement, congestion, macro blockages, high fanout, or excessive vias.

I also studied the difference between changing the clock period and changing capture clock latency. Increasing the clock period moves the next setup capture edge and usually improves setup, but it normally does not change the same-cycle relationship used for an ordinary hold check. Increasing capture clock latency can improve setup while worsening hold because it changes the actual launch-to-capture clock relationship.

Setup repair mainly attempts to reduce maximum data-path delay. Common methods include cell upsizing, low-Vt replacement, buffer insertion, fanout reduction, logic restructuring, placement improvement, routing optimization, useful-skew optimization, and pipelining. Each method must match the real root cause. For example, aggressive cell upsizing is not a good first choice for a path dominated by net delay in a highly utilized region.

Hold repair mainly attempts to increase minimum data-path delay. Common methods include delay-buffer insertion, dedicated hold cells, cell downsizing, higher-Vt replacement, routing detours, and clock-skew adjustment. A hold repair should be localized whenever possible. If one launch register drives several capture registers and only one branch violates hold, the buffer should normally be placed on the violating endpoint branch rather than on the shared trunk.

The final part of the lesson focused on PPA tradeoffs. Timing repairs are not free. Upsizing cells, adding buffers, replacing cells with low-Vt variants, inserting pipeline registers, or increasing routing length can affect dynamic power, leakage power, clock power, area, utilization, congestion, routing resources, transition time, capacitance, and other timing paths.

## What I Built

I completed the full six-step Timing Closure and PPA Tradeoffs learning module:

1. Timing Closure Objective and Closure Loop
2. Root-Cause Classification
3. Setup Repair Methods
4. Hold Repair Methods
5. PPA Tradeoffs
6. Timing Closure Case Study

I also prepared the following Markdown files for this module:

- `03_sta_notes/02_timing_closure_ppa/notes/timing_closure_ppa.md`
- `03_sta_notes/02_timing_closure_ppa/README.md`

The technical notes contain the full explanation of timing closure, root-cause diagnosis, setup and hold repairs, PPA tradeoffs, ECO concepts, common mistakes, and the case study.

The README provides a shorter module overview, file navigation, topic list, and the required Testbench and Waveform statements.

## Key Concepts

### Timing Closure

The iterative process of satisfying all required timing checks under correct constraints, operating modes, and PVT corners while controlling PPA and physical-design risk.

### Cell-Delay-Dominated Path

A timing path in which standard-cell timing arcs contribute most of the total data-path delay.

### Net-Delay-Dominated Path

A timing path in which interconnect resistance, capacitance, and routing delay contribute most of the total data-path delay.

### Setup Repair

A repair intended to reduce maximum data-path delay or increase the valid time available for data propagation.

### Hold Repair

A repair intended to increase minimum data-path delay so that new data does not arrive at the capture register too early.

### Localized Hold Fix

A hold repair placed on the violating endpoint branch so that unrelated branches are not unnecessarily delayed.

### ECO

An Engineering Change Order, which is a controlled incremental modification made to an existing design to fix timing, functional, or physical issues.

### PPA Tradeoff

The balance among power, performance, and area when selecting and evaluating a timing-repair method.

### MCMM Analysis

Multi-Corner Multi-Mode analysis used to verify that a timing repair remains valid across all required operating modes and PVT corners.

## Problems / Fixes

### Problem 1: Confused PPA conditions with timing-analysis conditions

The initial understanding treated different PPA conditions as if they were timing-analysis scenarios.

Fix:

PPA refers to power, performance, and area. Timing-analysis coverage is defined by timing checks, operating modes, PVT corners, path groups, and constraints.

### Problem 2: Misinterpreted poor input slew

Poor input slew was initially described as simply wasting signal-arrival time.

Fix:

Poor input slew increases cell propagation delay because the input voltage changes slowly through the switching region. The degraded output slew can also increase the delay of later cells in the path.

### Problem 3: Misunderstood the effect of negative clock skew

Negative skew was initially said to harm setup because data arrives too quickly.

Fix:

Negative skew harms setup because the capture clock arrives earlier relative to the launch clock, reducing the effective propagation time available to the data path.

### Problem 4: Confused clock period with capture clock latency

Increasing the clock period was initially treated as equivalent to increasing capture clock latency.

Fix:

A longer clock period moves the next setup capture edge but normally does not change the current-cycle hold relationship. A later capture clock arrival can improve setup while worsening hold.

### Problem 5: Misstated the leakage effect of higher-Vt cells

Higher-Vt replacement was initially said to increase leakage power.

Fix:

Higher-Vt cells are usually slower but have lower leakage power. They may improve hold and reduce leakage, although they can worsen setup timing.

### Problem 6: Misunderstood the effect of cell downsizing

Cell downsizing was initially described as making the launch clock arrive later.

Fix:

Cell downsizing changes data-path delay rather than clock-path arrival. The weaker cell drives its output load more slowly, causing new data to reach the capture register later.

### Problem 7: Treated clock-period relaxation as a valid repair

Relaxing a correct clock period was initially treated as an acceptable method for fixing a timing violation.

Fix:

Changing a real `2 ns` requirement to `4 ns` only hides the violation by reducing the required performance. A constraint should be changed only when the original requirement is incorrect.


## Connection to VLSI / EDA / 3D IC

Timing closure directly connects STA with synthesis, placement, routing, clock-tree design, parasitic extraction, ECO implementation, and signoff.

For Physical Design, the lesson explains why timing reports must be interpreted together with placement, routing, utilization, congestion, and extracted RC data. A path dominated by net delay requires a physically aware repair rather than a purely logical change.

For EDA, timing closure demonstrates how optimization tools must classify violations, estimate side effects, select transformations, update parasitics, and evaluate many timing scenarios. The repair problem is multi-objective because improving slack may increase power, area, or congestion.

For 3D IC and advanced packaging, the same timing principles remain important because long inter-die paths, TSVs, redistribution layers, package interconnects, and chiplet interfaces introduce additional resistance, capacitance, latency, and variation. Process-aware and interconnect-aware timing analysis becomes increasingly important as communication crosses die and package boundaries.

## One Sentence Summary

Timing closure requires identifying the real root cause of each violation, applying the smallest appropriate repair, and repeatedly verifying setup, hold, parasitics, PPA, and physical effects until every required scenario passes.

## Next Step

Integrate the complete STA flow and practice reading setup and hold timing reports in the STA Summary module.
