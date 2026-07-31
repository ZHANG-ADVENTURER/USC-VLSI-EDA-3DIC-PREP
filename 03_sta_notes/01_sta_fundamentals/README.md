# Project Title

Static Timing Analysis Fundamentals

# Overview

This module introduces the fundamental concepts used in Static Timing Analysis.

It explains how timing tools analyze data propagation from valid startpoints to valid endpoints without requiring functional testbench stimulus.

The main analysis relationship is:

> Gate-level netlist + SDC + `.lib` + SPEF
> → Static Timing Analysis
> → Arrival Time and Required Time
> → Setup and Hold Slack

The module covers register-to-register timing paths, path types, launch and capture clocks, cell and net delay, arrival time, required time, clock skew, setup and hold analysis, timing reports, WNS, and TNS.

# Files

* `notes/sta_fundamentals.md` — Complete technical notes for Static Timing Analysis fundamentals
* `README.md` — Module overview and file navigation

# Module Description

Static Timing Analysis verifies whether data can propagate through a digital design while satisfying timing requirements.

A typical register-to-register timing path is:

> Launch Register `Q`
> → Combinational Cells and Nets
> → Capture Register `D`

The complete timing relationship contains:

> Launch Clock Path
>
> * Data Path
> * Capture Clock Path

The launch clock determines when new data begins propagating. The data path determines how long propagation takes. The capture clock and sequential timing requirements determine when the data must be stable.

The main path types are:

| Path Type            | Startpoint    | Endpoint       |
| -------------------- | ------------- | -------------- |
| Input-to-Register    | Primary input | Register `D`   |
| Register-to-Register | Register `Q`  | Register `D`   |
| Register-to-Output   | Register `Q`  | Primary output |
| Input-to-Output      | Primary input | Primary output |

A register-to-register data arrival time includes:

> Launch Clock Arrival
>
> * Clock-to-Q Delay
> * Cell Delays
> * Net Delays
>   = Data Arrival Time

Cell delay is the propagation delay through a library cell. Within one timing corner, it mainly depends on input slew and output load capacitance.

Net delay is the propagation delay through physical interconnect. It depends on resistance, capacitance, routing geometry, metal layers, wire length, vias, and coupling.

Arrival time and required time serve different purposes:

| Concept       | Meaning                                                  |
| ------------- | -------------------------------------------------------- |
| Arrival Time  | The cumulative time at which data reaches a timing point |
| Required Time | The timing boundary imposed at an endpoint               |
| Delay         | The incremental time added by one cell or net            |
| Slack         | The timing margin between arrival time and required time |

For setup analysis:

> Setup Slack = Required Time - Arrival Time

Setup checks whether data arrives too late for the next capture edge.

For hold analysis:

> Hold Slack = Arrival Time - Required Time

Hold checks whether new data arrives too early near the current capture edge.

For both checks:

> Slack ≥ 0
> → Timing requirement met

> Slack < 0
> → Timing violation

The module also distinguishes clock latency, clock skew, and clock period.

Clock latency is the propagation time from a clock source to one clock sink.

Clock skew is the difference between capture clock arrival and launch clock arrival.

> Clock Skew = Capture Clock Arrival - Launch Clock Arrival

Positive skew may improve setup but worsen hold. Negative skew may worsen setup but improve hold.

Increasing the clock period moves the next-cycle capture edge later and may improve setup. It normally does not repair hold because the same-cycle launch and capture relationship remains approximately unchanged.

Timing reports commonly contain:

* Startpoint
* Endpoint
* Path group
* Path type
* Incremental delay
* Cumulative path time
* Data arrival time
* Data required time
* Slack

A `max` path generally represents setup analysis, while a `min` path generally represents hold analysis.

WNS represents the most severe negative slack.

TNS represents the sum of all negative slacks.

These metrics help engineers evaluate both the worst violation and the overall timing-closure workload.

# Testbench

This module does not contain a dedicated Verilog testbench.

Static Timing Analysis does not require input vectors to activate timing paths. It builds a timing graph from the gate-level netlist and analyzes paths covered by timing constraints.

Simulation verifies behavior exercised by testbench stimulus, while STA systematically evaluates constrained timing paths.

# Waveform

This module does not produce one dedicated waveform.

The primary outputs associated with this topic are timing-analysis results rather than simulated waveforms.

Typical STA outputs include:

* Setup timing reports
* Hold timing reports
* Startpoint and endpoint information
* Cell and net delay breakdowns
* Data arrival times
* Data required times
* Setup and hold slack
* WNS
* TNS
* Critical-path information
