# Day 33 Daily Log

## Topic

Static Timing Analysis Fundamentals

## What I Learned

Today I built the fundamental framework required to understand Static Timing Analysis.

The main STA input relationship is:

> Gate-level netlist + SDC + `.lib` + SPEF
> → Static Timing Analysis

The gate-level netlist provides cell instances and connectivity. SDC provides clock definitions and timing requirements. The `.lib` files provide cell timing models, and SPEF provides extracted interconnect resistance and capacitance.

A typical register-to-register timing path is:

> Launch Register `Q`
> → Combinational Cells and Nets
> → Capture Register `D`

The complete analysis includes the launch clock path, data path, and capture clock path.

The launch register clock pin is not the data-path startpoint. The clock reaches the launch register, triggers it, and new data appears at the `Q` output after the clock-to-Q delay. The `Q` pin is therefore the data-path startpoint, while the capture register `D` pin is the endpoint.

I also learned the four main timing path types:

* Input-to-Register
* Register-to-Register
* Register-to-Output
* Input-to-Output

For an input path, `set_input_delay` represents time already consumed outside the current design before data reaches the input port. For an output path, `set_output_delay` reserves timing budget for the external receiving system.

The main data-arrival relationship is:

> Data Arrival Time
> = Launch Clock Arrival
>
> * Clock-to-Q Delay
> * Cell Delays
> * Net Delays

Delay is incremental, while arrival time is cumulative. A cell or net adds delay, and the accumulated result at each timing point is its arrival time.

Cell delay mainly depends on input slew and output load within a selected timing corner. Net delay depends on interconnect resistance, capacitance, routing geometry, metal layers, vias, and coupling.

Required time is established from the capture side. For setup, it is the latest permitted arrival time. For hold, it is the earliest permitted arrival time for new data.

The slack formulas are:

> Setup Slack = Required Time - Arrival Time

> Hold Slack = Arrival Time - Required Time

Positive slack means the timing requirement is met. Negative slack means a violation exists.

Setup analysis checks maximum or late data arrival because setup is concerned with data arriving too late. Hold analysis checks minimum or early data arrival because hold is concerned with new data arriving too early.

I also distinguished clock period from clock skew. Increasing the clock period moves the next-cycle capture edge later and may improve setup. It normally does not repair hold because hold checks same-cycle launch and capture edges.

Clock skew is the relative arrival difference between the capture and launch clocks.

> Clock Skew = Capture Clock Arrival - Launch Clock Arrival

Positive skew may improve setup but worsen hold. Negative skew may worsen setup but improve hold.

Finally, I learned the basic structure of timing reports, including startpoint, endpoint, path group, path type, incremental delay, cumulative path time, arrival time, required time, and slack.

## What I Built

I completed the Static Timing Analysis Fundamentals learning module and prepared the following repository documents:

* `02_physical_design_notes/10_sta_fundamentals/notes/sta_fundamentals.md`
* `02_physical_design_notes/10_sta_fundamentals/README.md`
* `daily-log/Day33.md`

The module provides a structured technical reference for timing-path analysis, setup and hold relationships, clock behavior, slack calculation, and basic timing-report interpretation.

No Verilog source file, dedicated testbench, simulation waveform, or EDA timing-tool result was produced during this module.

## Key Concepts

### Timing Path

A path through which timing information propagates from a valid startpoint to a valid endpoint.

### Startpoint

The point where timed data propagation begins, such as a register `Q` pin or primary input.

### Endpoint

The point where a timing requirement is checked, such as a register `D` pin or primary output.

### Clock-to-Q Delay

The delay between the active clock edge reaching a register and new data appearing at its `Q` output.

### Cell Delay

The propagation delay through a library cell, mainly determined by input slew and output load within a selected timing corner.

### Net Delay

The propagation delay through physical interconnect, influenced by resistance, capacitance, routing geometry, vias, and coupling.

### Arrival Time

The cumulative time at which data reaches a timing point.

### Required Time

The latest or earliest timing boundary imposed at an endpoint.

### Setup Slack

The remaining margin before the setup deadline.

### Hold Slack

The remaining margin above the earliest safe new-data arrival time.

### Clock Skew

The difference between capture clock arrival and launch clock arrival.

### WNS

The most severe negative slack among violating paths.

### TNS

The sum of all negative slacks.

## Problems / Fixes

### Problem 1: Misinterpreted input delay

The initial understanding treated `set_input_delay` as time given to an input signal for preparation.

Fix:

`set_input_delay` represents time already consumed outside the current design before data reaches the input port.

### Problem 2: Misunderstood the hold edge relationship

The same-cycle hold relationship was initially explained as a convenient calculation method.

Fix:

Hold uses same-cycle launch and capture edges because it checks whether new data arrives too early and disturbs the value captured at the current edge.

### Problem 3: Confused setup and hold requirements with propagation delay

Setup time was initially treated as time consumed by another register or path, while hold time was treated as additional transmission time.

Fix:

Setup time and hold time are sequential timing requirements of the capture register.

* Setup requires data to become stable before the capture edge.
* Hold requires data to remain stable after the capture edge.

### Problem 4: Confused arrival and required sides

Arrival time was initially associated only with an input, while required time was associated only with an output.

Fix:

Arrival time is mainly determined by the launch side and data path. Required time is mainly determined by the capture side and timing requirement.

### Problem 5: Made decimal errors in hold calculations

A hold required time of `0.35 ns` was initially calculated as `0.31 ns`.

A hold slack of `-0.07 ns` was initially written as `-0.7 ns`.

Fix:

Timing calculations must preserve decimal positions and units because a factor-of-ten difference substantially changes the reported violation severity.

### Problem 6: Confused clock period with positive skew

Moving the next capture edge by increasing the period was initially expected to worsen hold.

Fix:

Increasing the period affects the next-cycle setup edge. Positive skew changes the same-cycle capture-clock arrival relative to the launch clock and can worsen hold.

## Connection to VLSI / EDA / 3D IC

STA fundamentals are essential for Physical Design, STA, synthesis, and EDA engineering roles.

Physical Design engineers use timing paths to evaluate the effects of placement, routing, cell sizing, buffering, and clock-tree implementation.

STA engineers analyze arrival time, required time, slack, WNS, TNS, constraints, and timing reports across multiple operating conditions.

EDA engineers develop timing engines and optimization algorithms that propagate slew, load, delay, and arrival information through timing graphs.

In 3D IC and advanced packaging systems, the same timing principles extend across die-to-die interconnects, TSVs, interposers, microbumps, and package routing. Additional interconnect parasitics can increase net delay and complicate timing closure.

This module provides the foundation for timing repair, timing closure, and PPA tradeoff analysis.

## One Sentence Summary

Static Timing Analysis determines whether data can propagate from valid startpoints to valid endpoints while satisfying setup, hold, clock, and path-delay requirements.

## Next Step

Study Timing Closure and PPA Tradeoff, including root-cause analysis, setup repair, hold repair, and the power, performance, area, and routing consequences of timing optimization.
