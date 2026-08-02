# Day 35 Daily Log

## Topic

Static Timing Analysis Summary

## What I Learned

Today I integrated the major Static Timing Analysis concepts into one complete engineering flow.

STA is a vectorless timing-verification method. It does not require a functional testbench because it does not depend on applying input vectors and observing logical outputs. Instead, it builds a timing graph from the design structure and timing models, then propagates arrival times and required times through every valid constrained timing path.

The four core STA inputs are:

- Gate-level netlist
- SDC constraints
- Liberty timing library
- SPEF parasitic data

The gate-level netlist defines the cells, registers, combinational logic, pin connections, and logical connectivity. SDC defines the timing intent, including clocks, input and output delays, uncertainty, false paths, multicycle paths, and clock relationships. The Liberty library defines cell timing behavior such as clock-to-Q delay, propagation delay, setup time, hold time, input capacitance, slew dependence, load dependence, and PVT-corner data. SPEF describes the extracted interconnect resistance and capacitance after physical implementation.

I reviewed how STA transforms these inputs into a timing graph. Pins and timing points become nodes, while cell arcs and net connections become edges. The timing engine then identifies startpoints and endpoints and evaluates path types such as input-to-register, register-to-register, register-to-output, and input-to-output.

For register-to-register analysis, data arrival time is formed from launch clock arrival, clock-to-Q delay, cell delays, and net delays. Setup analysis uses the maximum or late arrival, while hold analysis uses the minimum or early arrival.

I also reviewed required-time calculations. Setup required time is based on the next capture edge, capture clock arrival, setup time, and uncertainty. Hold required time is based on the current capture edge, capture clock arrival, hold time, and hold uncertainty.

The corresponding slack relationships are:

> Setup Slack = Required Time − Arrival Time

> Hold Slack = Arrival Time − Required Time

A negative setup slack means data arrives too late. A negative hold slack means new data arrives too early.

I practiced reading both setup and hold timing reports. For setup, I identified the startpoint, endpoint, path type, clock arrivals, incremental delay, cumulative path time, required time, and slack. I compared total combinational cell delay with total net delay to determine whether the path was cell-delay dominated or net-delay dominated.

In the setup example, the combinational cell delay was 0.70 ns and the net delay was 1.20 ns. Net 2 contributed 0.72 ns and was the largest individual delay component, so the path was net-delay dominated. The first repair direction should therefore focus on placement, routing, fanout, capacitance, congestion, and possible long-RC-net buffering rather than aggressive cell upsizing.

In the hold example, data arrived at 0.26 ns while the required time was 0.31 ns, producing −0.05 ns hold slack. Positive clock skew made hold worse by moving the hold required boundary later. The preferred repair was a localized delay buffer or hold cell near the violating endpoint branch.

I also reinforced why hold repairs can create setup violations. A hold buffer increases minimum data-path delay, which improves hold, but it usually also increases maximum data-path delay, which consumes setup margin. Therefore, every hold repair must be followed by setup analysis.

Finally, I organized the concepts into interview-ready explanations. A strong engineering explanation should identify the violation type, startpoint, endpoint, slack, dominant delay category, largest delay component, likely root cause, proposed localized repair, and required reanalysis after implementation.

## What I Built

I completed the four-step STA Summary module:

1. Full STA Flow Integration
2. Setup and Hold Timing Report Reading
3. Interview and Engineering Explanation
4. Ninety-Second English STA Explanation

I created the following Markdown files:

- `03_sta_notes/03_sta_summary/notes/sta_summary.md`
- `03_sta_notes/03_sta_summary/README.md`

The Notes file contains the complete STA reference, including timing inputs, timing-graph construction, path types, arrival time, required time, slack, setup and hold analysis, clock skew, timing-report examples, WNS and TNS, timing closure, and interview explanations.

The README provides the module overview, file list, topic summary, and the required Testbench and Waveform sections.

## Key Concepts

### Static Timing Analysis

A vectorless method that verifies all valid constrained timing paths without applying functional input vectors.

### Timing Graph

A graph representation of timing points and delay arcs used by the STA engine.

### Arrival Time

The time at which data actually reaches a timing endpoint.

### Required Time

The timing boundary that the arriving data must satisfy.

### Setup Analysis

Maximum-delay analysis that checks whether data arrives before the next capture edge.

### Hold Analysis

Minimum-delay analysis that checks whether new data arrives too early after the current capture edge.

### Incremental Delay

The delay added by the current cell arc or net.

### Cumulative Path Time

The total propagated time from the path start to the current timing point.

### WNS

The most negative slack among violating paths.

### TNS

The sum of negative slack across all violating endpoints.

## Problems / Fixes

### Problem 1: Incomplete gate-level netlist definition

I initially described the gate-level netlist as containing only combinational logic and pin connections.

Fix:

The netlist also contains sequential cells, standard-cell instances, and complete logical connectivity.

### Problem 2: Incomplete SPEF description

I described SPEF as containing only extracted resistance.

Fix:

SPEF includes extracted resistance, ground capacitance, coupling capacitance, and RC-network topology.

### Problem 3: Misclassified a setup path as a hold path

I misidentified a setup-report question as a hold problem.

Fix:

A `max` timing path with negative setup slack means the path is too slow. The largest delay component should be investigated before choosing a repair.

### Problem 4: Confused hold time with hold required time

I said positive skew increases hold time.

Fix:

Positive skew does not change the library hold-time requirement. It moves the hold required boundary later and therefore reduces hold slack.

### Problem 5: Incorrect explanation of hold-buffer behavior

I described a hold buffer as weakening the original cell's drive capability.

Fix:

The primary purpose of a hold buffer is to add controlled minimum data-path delay. It may also divide the net and improve slew.

### Problem 6: Incorrect explanation of setup degradation after hold repair

I said hold repair mainly changes the difference between launch and capture clock arrival.

Fix:

Most hold repairs modify the data path. They increase minimum delay to improve hold, but they also increase maximum delay and may worsen setup.

## Connection to VLSI / EDA / 3D IC

STA is a central connection point between logic design, timing constraints, standard-cell libraries, physical implementation, parasitic extraction, and signoff.

For Physical Design, STA converts placement, routing, clock-tree, and parasitic effects into measurable timing results. The distinction between cell-delay-dominated and net-delay-dominated paths determines whether the engineer should focus on cells, logic structure, placement, routing, fanout, or clock behavior.

For EDA, STA is a graph-based analysis problem that combines logical connectivity, timing models, constraints, and extracted RC data. Timing-closure tools must repeatedly diagnose violations, select repairs, update implementation data, and rerun multi-corner and multi-mode analysis.

For 3D IC, the same timing framework applies to paths that cross dies, chiplets, TSVs, redistribution layers, and package interconnects. These structures introduce additional resistance, capacitance, latency, coupling, and variation, making accurate parasitic extraction and timing modeling even more important.

## One Sentence Summary

STA combines the netlist, timing constraints, cell libraries, and extracted parasitics to calculate arrival time, required time, and slack, then uses timing reports to guide root-cause-matched timing closure.

## Next Step

Begin the OpenROAD practice phase and connect the previously learned RTL-to-GDSII and STA concepts to an actual open-source physical-design workflow.
