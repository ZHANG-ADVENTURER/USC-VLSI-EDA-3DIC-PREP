# Static Timing Analysis Summary

## 1. Overview

Static Timing Analysis, or STA, is a vectorless method used to verify whether all constrained timing paths in a digital design satisfy their timing requirements.

STA does not apply functional input vectors. Instead, it builds a timing graph from the design netlist, timing constraints, standard-cell timing models, and interconnect parasitics. It then propagates arrival times and required times through all valid constrained timing paths.

The complete flow is:

> Gate-Level Netlist + SDC + Liberty Library + SPEF  
> → Build Timing Graph  
> → Identify Startpoints and Endpoints  
> → Propagate Arrival Times  
> → Calculate Required Times  
> → Calculate Setup and Hold Slack  
> → Generate Timing Reports  
> → Diagnose Root Causes  
> → Apply Targeted Repairs  
> → Re-extract Parasitics  
> → Rerun STA Until Timing Closure

STA is used throughout synthesis, placement, clock-tree synthesis, routing, post-route optimization, and signoff.

## 2. STA Versus Functional Simulation

Functional simulation and STA solve different problems.

| Functional Simulation | Static Timing Analysis |
|---|---|
| Uses a testbench and input vectors | Uses a timing graph |
| Checks logical behavior and output values | Checks timing requirements |
| Covers activated input scenarios | Analyzes all valid constrained paths |
| Detects functional errors | Detects timing violations |
| Depends on stimulus coverage | Depends on constraint and timing coverage |

STA is called vectorless because it does not need to simulate every input combination.

Instead, STA evaluates:

> Netlist Connectivity  
> + Timing Constraints  
> + Cell Delay Models  
> + Interconnect Delay Models  
> → Timing Path Analysis

STA cannot replace functional verification because it does not prove that RTL behavior, state transitions, protocols, or output values are correct.

## 3. Core STA Inputs

### 3.1 Gate-Level Netlist

The gate-level netlist defines:

- Standard-cell instances
- Sequential-cell instances
- Combinational logic
- Pin connections
- Logical connectivity

It answers:

> What cells exist, and how are they connected?

The netlist provides the logical structure of the timing graph, but it does not provide accurate cell delays, interconnect parasitics, or timing requirements.

### 3.2 SDC

SDC defines timing intent and timing constraints.

Common SDC information includes:

- Primary clocks
- Generated clocks
- Clock periods
- Clock uncertainty
- Input delays
- Output delays
- False paths
- Multicycle paths
- Clock relationships

It answers:

> What timing relationships and requirements must be satisfied?

A clean timing report generated from incorrect or incomplete constraints is not valid timing closure.

### 3.3 Liberty Library

The Liberty `.lib` file defines standard-cell timing and electrical behavior.

Important information includes:

- Timing arcs
- Clock-to-Q delay
- Propagation delay
- Setup time
- Hold time
- Recovery and removal time
- Input capacitance
- Output transition
- Slew dependence
- Load dependence
- PVT-corner data

It answers:

> How does each cell behave under a specific slew, load, and PVT condition?

Cell delay is not a fixed number.

> Cell Delay = Function of Input Slew, Output Load, and PVT Condition

### 3.4 SPEF

SPEF contains extracted interconnect parasitics from the physical implementation.

It may include:

- Net resistance
- Ground capacitance
- Coupling capacitance
- RC-network topology

It answers:

> How does the implemented interconnect behave electrically?

After placement or routing changes, wire length, topology, routing layer, vias, resistance, and capacitance may change. Parasitics must therefore be re-extracted and STA must be rerun.

## 4. Timing Graph

The STA engine combines the netlist, SDC, `.lib`, and SPEF into a timing graph.

In the timing graph:

- Pins and timing points act as nodes.
- Cell timing arcs and net connections act as edges.
- Edge delays come from cell models and extracted parasitics.
- Constraints define valid startpoints, endpoints, and timing requirements.

A simplified register-to-register path is:

> Launch Clock Path  
> → Launch Register  
> → Clock-to-Q Delay  
> → Combinational Cell and Net Delays  
> → Capture Register  
> → Capture Clock Path

## 5. Timing Path Types

The four common path categories are:

1. Input-to-Register
2. Register-to-Register
3. Register-to-Output
4. Input-to-Output

### 5.1 Input-to-Register

> Design Input  
> → Combinational Logic  
> → Capture Register

This path depends on input delay, internal delay, and the capture-clock requirement.

### 5.2 Register-to-Register

> Launch Register  
> → Combinational Logic  
> → Capture Register

This is the standard synchronous path used to explain setup and hold analysis.

### 5.3 Register-to-Output

> Launch Register  
> → Combinational Logic  
> → Design Output

This path depends on internal delay and the output-delay requirement.

### 5.4 Input-to-Output

> Design Input  
> → Combinational Logic  
> → Design Output

This path contains no internal launch or capture register.

## 6. Startpoints and Endpoints

A startpoint is where data propagation begins.

Common startpoints include:

- Primary inputs
- Register Q pins

An endpoint is where data is checked against a timing requirement.

Common endpoints include:

- Register D pins
- Primary outputs

For a register-to-register path:

> Startpoint = Launch Register Q  
> Endpoint = Capture Register D

## 7. Data Arrival Time

Data Arrival Time represents when data actually reaches the endpoint.

For a register-to-register path:

> Data Arrival Time  
> = Launch Clock Arrival  
> + Clock-to-Q Delay  
> + Cell Delays  
> + Net Delays

Setup analysis uses the late or maximum arrival.

Hold analysis uses the early or minimum arrival.

### 7.1 Setup Arrival

Setup asks:

> What is the latest possible time at which data reaches the endpoint?

Therefore, setup analysis uses maximum-delay behavior.

### 7.2 Hold Arrival

Hold asks:

> What is the earliest possible time at which new data reaches the endpoint?

Therefore, hold analysis uses minimum-delay behavior.

## 8. Data Required Time

Data Required Time represents the timing boundary that data must satisfy.

### 8.1 Setup Required Time

Setup checks the next capture edge.

> Setup Required Time  
> = Next Capture Edge  
> + Capture Clock Arrival  
> − Setup Time  
> − Clock Uncertainty

It defines the latest acceptable data-arrival time.

### 8.2 Hold Required Time

Hold normally checks the current capture edge.

> Hold Required Time  
> = Current Capture Clock Arrival  
> + Hold Time  
> + Hold Uncertainty

It defines the earliest acceptable arrival time for new data.

## 9. Slack

Slack measures the margin between actual arrival and required time.

### 9.1 Setup Slack

> Setup Slack = Required Time − Arrival Time

- Positive: data arrives on time.
- Zero: data arrives exactly at the limit.
- Negative: data arrives too late.

### 9.2 Hold Slack

> Hold Slack = Arrival Time − Required Time

- Positive: new data does not arrive too early.
- Zero: new data arrives exactly at the limit.
- Negative: new data arrives too early.

The subtraction direction differs because setup checks whether data is late, while hold checks whether data is early.

## 10. Setup Analysis

Setup verifies that data arrives early enough before the next capture clock edge.

A setup violation means:

> Data arrives too late.

Common causes include:

- Excessive cell delay
- Excessive net delay
- Deep combinational logic
- Poor input slew
- Large output load
- High fanout
- Long routing
- Congestion
- Unfavorable clock skew
- Excessive clock uncertainty
- Incorrect timing constraints

Common repairs include:

- Cell upsizing
- Low-Vt replacement
- Buffer insertion on long RC nets
- Fanout reduction
- Logic restructuring
- Placement improvement
- Routing optimization
- Useful skew
- Pipelining

The repair must match the root cause.

## 11. Hold Analysis

Hold verifies that old data remains stable long enough after the current capture edge.

A hold violation means:

> New data arrives too early.

Common causes include:

- Very short data path
- Very small minimum cell delay
- Very small minimum net delay
- Strong drivers
- Fast low-Vt cells
- Short physical distance
- Positive clock skew
- Incorrect constraints

Common repairs include:

- Local delay-buffer insertion
- Dedicated hold-cell insertion
- Cell downsizing
- Higher-Vt replacement
- Routing detour
- Clock-skew adjustment

A hold repair should be localized whenever possible so that unrelated paths are not unnecessarily delayed.

## 12. Clock Skew

Clock skew is:

> Clock Skew = Capture Clock Arrival − Launch Clock Arrival

### Setup Effect

- Positive skew usually helps setup.
- Negative skew usually hurts setup.

### Hold Effect

- Positive skew usually hurts hold.
- Negative skew usually helps hold.

Clock skew changes the clock relationship. It does not directly make the data signal faster or slower.

## 13. Clock Period Versus Capture Latency

Increasing the clock period and increasing capture-clock latency are different operations.

| Change | Setup Effect | Hold Effect |
|---|---|---|
| Increase clock period | Usually improves setup | Usually unchanged |
| Increase capture clock latency | Usually improves setup | Usually worsens hold |
| Increase data-path delay | Worsens setup | Improves hold |

Lowering frequency usually cannot repair an ordinary hold violation because the current launch and capture edges remain in the same relationship.

## 14. Reading a Timing Report

A timing report commonly includes:

- Startpoint
- Endpoint
- Path group
- Path type
- Launch clock
- Capture clock
- Cell names and types
- Pin names
- Incremental delay
- Cumulative path time
- Data arrival time
- Data required time
- Slack

### 14.1 `Incr`

`Incr` is the delay added by the current cell arc or net.

### 14.2 `Path`

`Path` is the cumulative time from the path start to the current point.

### 14.3 Recommended Reading Order

> Confirm Startpoint and Endpoint  
> → Confirm Path Type  
> → Read Arrival-Time Accumulation  
> → Read Required-Time Calculation  
> → Confirm Slack  
> → Compare Cell Delay and Net Delay  
> → Inspect the Largest Incremental Delays  
> → Check Clock Arrivals and Skew  
> → Identify the Root Cause  
> → Select a Targeted Repair

## 15. Setup Timing Report Example

Assume the path:

> `reg_a/Q`  
> → Net 1  
> → Combinational Cell 1  
> → Net 2  
> → Combinational Cell 2  
> → Net 3  
> → `reg_b/D`

### 15.1 Header

| Item | Value |
|---|---:|
| Startpoint | `reg_a/Q` |
| Endpoint | `reg_b/D` |
| Path type | `max` |
| Clock period | 2.00 ns |
| Launch clock arrival | 0.10 ns |
| Capture clock arrival | 0.15 ns |
| Setup time | 0.10 ns |
| Clock uncertainty | 0.08 ns |

### 15.2 Delay Breakdown

| Point | Type | Incremental Delay | Cumulative Time |
|---|---|---:|---:|
| Launch clock arrival | Clock | 0.10 ns | 0.10 ns |
| Clock-to-Q | Cell | 0.12 ns | 0.22 ns |
| Net 1 | Net | 0.25 ns | 0.47 ns |
| Combinational Cell 1 | Cell | 0.38 ns | 0.85 ns |
| Net 2 | Net | 0.72 ns | 1.57 ns |
| Combinational Cell 2 | Cell | 0.32 ns | 1.89 ns |
| Net 3 | Net | 0.23 ns | 2.12 ns |
| Capture register D | Endpoint | — | 2.12 ns |

Combinational cell delay:

> 0.38 + 0.32 = 0.70 ns

Net delay:

> 0.25 + 0.72 + 0.23 = 1.20 ns

Setup required time:

> 2.00 + 0.15 − 0.10 − 0.08 = 1.97 ns

Setup slack:

> 1.97 − 2.12 = −0.15 ns

This is a setup violation.

The path is net-delay dominated because the net delay is larger than the combinational cell delay.

Net 2 is the largest individual component at 0.72 ns. Possible causes include:

- Long routing
- Poor placement
- Routing detour
- Congestion
- Large fanout
- Heavy capacitance
- Excessive vias

The first repair direction should be placement or routing optimization rather than aggressive cell upsizing.

## 16. Hold Timing Report Example

Assume the path:

> `reg_c/Q`  
> → Net 1  
> → Buffer 1  
> → Net 2  
> → `reg_d/D`

### 16.1 Header

| Item | Value |
|---|---:|
| Startpoint | `reg_c/Q` |
| Endpoint | `reg_d/D` |
| Path type | `min` |
| Launch clock arrival | 0.12 ns |
| Capture clock arrival | 0.20 ns |
| Hold time | 0.08 ns |
| Hold uncertainty | 0.03 ns |

### 16.2 Delay Breakdown

| Point | Type | Incremental Delay | Cumulative Time |
|---|---|---:|---:|
| Launch clock arrival | Clock | 0.12 ns | 0.12 ns |
| Clock-to-Q minimum delay | Cell | 0.05 ns | 0.17 ns |
| Net 1 | Net | 0.03 ns | 0.20 ns |
| Buffer 1 | Cell | 0.04 ns | 0.24 ns |
| Net 2 | Net | 0.02 ns | 0.26 ns |
| Capture register D | Endpoint | — | 0.26 ns |

Hold required time:

> 0.20 + 0.08 + 0.03 = 0.31 ns

Hold slack:

> 0.26 − 0.31 = −0.05 ns

This is a hold violation because new data arrives 0.05 ns too early.

Clock skew:

> 0.20 − 0.12 = +0.08 ns

The positive skew hurts hold.

The preferred repair is usually a local delay buffer or hold cell near the violating endpoint branch.

## 17. Why Hold Repair Can Create Setup Violations

A hold buffer increases minimum data-path delay.

> Minimum Delay Increases  
> → New Data Arrives Later  
> → Hold Slack Improves

The same buffer usually also increases maximum data-path delay.

> Maximum Delay Increases  
> → Setup Arrival Becomes Later  
> → Setup Slack Decreases

Therefore:

> Every hold repair must be followed by setup analysis.

The reverse interaction is also possible. A setup repair may make the minimum path faster and worsen hold.

## 18. WNS and TNS

### 18.1 WNS

Worst Negative Slack is the most negative slack among the violating paths.

> WNS = −0.30 ns

This means the worst path violates timing by 0.30 ns.

### 18.2 TNS

Total Negative Slack is the sum of negative slack across all violating endpoints.

Example:

> Endpoint A = −0.30 ns  
> Endpoint B = −0.20 ns  
> Endpoint C = −0.10 ns  
> TNS = −0.60 ns

WNS measures the worst individual violation.

TNS measures the total violation magnitude.

## 19. STA Across the Physical-Design Flow

### 19.1 Pre-Layout STA

Main inputs:

- Netlist
- SDC
- Liberty libraries
- Estimated wire delay

Main purposes:

- Detect logic-depth problems
- Detect constraint problems
- Guide synthesis optimization

### 19.2 Post-Placement STA

Placement information allows more accurate wire-delay estimation.

Main purposes:

- Identify long nets
- Evaluate placement quality
- Detect congestion-related timing risk

### 19.3 Post-CTS STA

The clock tree is available.

Main purposes:

- Analyze clock latency
- Analyze clock skew
- Evaluate setup and hold interaction

### 19.4 Post-Route STA

Actual routing parasitics are extracted into SPEF.

Main purposes:

- Analyze realistic net delays
- Perform final timing optimization
- Prepare timing ECOs

### 19.5 Signoff STA

Signoff analysis commonly includes:

- Multiple operating modes
- Multiple PVT corners
- On-chip variation
- Crosstalk effects
- Setup and hold
- Constraint coverage
- Unconstrained-path review

## 20. Timing Closure Integration

STA identifies timing problems, while timing closure repairs them.

> Run STA  
> → Identify Violating Paths  
> → Validate Constraints  
> → Classify the Root Cause  
> → Select the Smallest Appropriate Repair  
> → Update the Netlist or Physical Implementation  
> → Re-extract Parasitics  
> → Rerun Setup and Hold STA  
> → Review PPA and Physical Effects  
> → Repeat Until All Required Scenarios Pass

Timing closure requires:

- Correct constraints
- Complete timing coverage
- Passing setup and hold
- Required modes and corners
- Acceptable power
- Acceptable area
- Acceptable congestion
- Acceptable physical verification

## 21. Root-Cause Classification

### 21.1 Cell-Delay Dominated

Evidence:

- Cell delay is much larger than net delay.
- Slow timing arcs dominate the report.
- Poor slew or heavy load affects cells.

Possible repairs:

- Upsizing
- Low-Vt replacement
- Logic restructuring
- Pipelining

### 21.2 Net-Delay Dominated

Evidence:

- Net delay is much larger than cell delay.
- One or more nets have large incremental delay.
- Physical data shows long routing or congestion.

Possible repairs:

- Placement optimization
- Routing optimization
- Fanout reduction
- Local buffer insertion

### 21.3 Clock Dominated

Evidence:

- Unfavorable skew
- Excessive latency
- Large uncertainty
- Clock-path imbalance

Possible repairs:

- Clock-tree optimization
- Useful-skew optimization
- Constraint review

### 21.4 Constraint Dominated

Evidence:

- Missing clocks
- Missing input or output delays
- Incorrect false paths
- Incorrect multicycle paths
- Incorrect uncertainty
- Incorrect mode or corner

A constraint should only be changed when the original timing model is wrong. A correct performance requirement must not be relaxed merely to hide a violation.

## 22. Engineering Explanation Template

> This is a setup or hold violation from startpoint X to endpoint Y.  
> The slack is negative by Z ns.  
> The path is primarily dominated by cell delay, net delay, clock behavior, or constraints.  
> The largest delay component is X.  
> The likely root cause is Y.  
> I would first apply a localized repair such as Z.  
> After the change, I would re-extract parasitics and rerun both setup and hold analysis across all required modes and corners.

## 23. Ninety-Second STA Explanation

Static Timing Analysis, or STA, is a vectorless method used to verify whether all constrained timing paths in a digital design satisfy their timing requirements.

The main STA inputs are the gate-level netlist, SDC constraints, Liberty timing libraries, and extracted parasitic data such as SPEF. The netlist defines the cells and their logical connections. The SDC defines clocks, input and output delays, timing exceptions, and other timing requirements. The Liberty library provides cell delays, setup and hold requirements, and electrical characteristics. SPEF provides the resistance and capacitance of the implemented interconnects.

STA builds a timing graph and propagates arrival times and required times through the design. Setup analysis checks whether data arrives early enough before the next capture clock edge, while hold analysis checks whether new data arrives too early after the current capture edge.

Slack is used to determine whether a path passes or fails. Negative setup slack means the data is too late, while negative hold slack means the data is too early.

When a violation occurs, I first verify the constraints and classify whether the path is dominated by cell delay, net delay, clock behavior, or physical implementation. I then apply a targeted repair, re-extract parasitics, and rerun both setup and hold analysis across the required modes and corners.

## 24. Short Interview Version

 STA is a vectorless timing-verification method that analyzes all constrained timing paths without requiring a functional testbench. It uses the netlist, SDC, Liberty libraries, and extracted parasitics to calculate arrival time, required time, and slack. Setup checks whether data arrives too late, while hold checks whether new data arrives too early. When a violation occurs, I verify the constraints, identify whether the path is dominated by cell delay, net delay, or clock behavior, apply a targeted repair, and rerun both setup and hold analysis.

## 25. Final Summary

The essential STA relationship is:

> Netlist defines connectivity.  
> SDC defines timing intent.  
> Liberty defines cell behavior.  
> SPEF defines interconnect behavior.  
> STA calculates arrival time, required time, and slack.  
> Timing reports identify violations.  
> Timing closure applies targeted repairs and verifies the updated design.

A complete STA engineer must be able to:

- Understand every major STA input
- Distinguish setup from hold
- Calculate arrival, required, and slack
- Read setup and hold reports
- Identify cell-delay and net-delay dominance
- Interpret clock skew
- Select root-cause-matched repairs
- Understand setup and hold interaction
- Re-extract parasitics after physical changes
- Verify all required modes and corners
- Explain the result clearly in engineering and interview contexts
