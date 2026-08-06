# Project Title

Static Timing Analysis and Timing Closure Notes

# Overview

This module develops the Static Timing Analysis framework required to evaluate timing from constraints, timing libraries, clock definitions, netlists, and extracted parasitics.

The learning progression is:

> Timing-path fundamentals  
> → setup and hold analysis  
> → clock latency and skew  
> → WNS and TNS  
> → path classification  
> → constraint and coverage validation  
> → timing closure and PPA tradeoffs  
> → consolidated STA review

The module connects theoretical STA concepts with the stage-specific timing reports examined in the OpenROAD practice module.

# Files

| Path | Main focus |
|---|---|
| `01_sta_fundamentals/` | Timing paths, startpoints, endpoints, setup, hold, arrival time, required time, slack, clocks, and corners |
| `02_timing_closure_ppa/` | Timing-closure workflow, root-cause classification, repair selection, and PPA tradeoffs |
| `03_sta_summary/` | Consolidated STA terminology, relationships, and review |

# Module Description

## Timing Paths

STA analyzes paths between valid timing startpoints and endpoints.

Common path classes include:

- Input to register
- Register to register
- Register to output
- Input to output

A register-to-register path contains:

> Launch clock path  
> → clock-to-Q delay  
> → combinational cell and net delay  
> → setup or hold requirement  
> → capture clock path

## Arrival Time, Required Time, and Slack

Arrival time describes when data reaches an endpoint.

Required time describes the timing deadline imposed at that endpoint.

For setup analysis:

> Setup slack = data required time − data arrival time

For hold analysis, the tool compares the earliest data arrival against the minimum required retention interval.

Positive slack passes the analyzed check. Negative slack is a violation.

## Setup and Hold

Setup checks maximum-delay behavior and asks whether new data arrives early enough before the capture edge.

Hold checks minimum-delay behavior and asks whether new data arrives too early after the capture edge.

A repair that improves setup may reduce hold margin, and a hold repair can affect area, power, routing, and setup timing.

## Clock Effects

Clock analysis includes:

- Source latency
- Network latency
- Launch latency
- Capture latency
- Clock skew
- Jitter
- Clock reconvergence pessimism
- Ideal and propagated clocks

Clock skew must be interpreted relative to the specific setup or hold path. It is not inherently beneficial or harmful without path context.

## WNS and TNS

WNS is the worst slack among the analyzed paths.

TNS is the sum of negative slack across violating endpoints or paths according to the tool's reporting method.

A passing WNS does not by itself prove:

- Complete timing coverage
- Correct constraints
- Passing hold
- Multi-corner closure
- Physical or power signoff

## Parasitic Models Across the Flow

Timing accuracy changes with implementation stage:

| Stage | Typical interconnect model |
|---|---|
| Synthesis | Wire-load or early estimate |
| Placement | Placement-based estimation |
| Post-CTS | Propagated clock with placement-estimated data parasitics |
| Global routing | Global-route parasitic estimation |
| Final routing | Extracted parasitics such as SPEF |

Critical paths can migrate when the parasitic model changes.

## Timing Closure

Timing closure is an iterative engineering process:

> Validate constraints and timing coverage  
> → identify the violation  
> → classify the root cause  
> → select a targeted repair  
> → update the implementation  
> → re-extract parasitics  
> → rerun setup and hold analysis  
> → check PPA and physical side effects  
> → repeat

Root causes may be dominated by:

- Cell delay
- Net delay
- Clock behavior
- Congestion or placement
- Electrical violations
- Incorrect or incomplete constraints

## PPA Tradeoffs

Timing repairs affect power and area.

Examples include:

- Upsizing a cell may reduce delay but increase input capacitance, area, and power.
- Buffer insertion may improve transition or net delay but consume area and routing resources.
- Logic restructuring may reduce depth but change power and placement.
- Hold buffers intentionally add delay and may affect congestion.

Timing closure therefore requires targeted changes rather than indiscriminate optimization.

# Testbench

No RTL testbench is defined in this module.

STA analyzes timing graphs constructed from a netlist, timing constraints, library models, clocks, and parasitic information. It does not apply functional simulation vectors in the same way as an RTL testbench.

Functional correctness and timing correctness are separate requirements.

# Waveform

No simulation waveform is generated in this module.

STA evaluates timing paths mathematically rather than by enumerating functional input sequences.

Timing evidence consists of path reports, clock reports, constraint coverage, WNS, TNS, electrical checks, and stage-to-stage comparisons. Practical examples are documented under `../04_openroad_practice/`.
