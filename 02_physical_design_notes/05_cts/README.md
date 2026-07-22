# Clock Tree Synthesis

## Overview

This project documents the Clock Tree Synthesis stage of the ASIC physical design flow.

Clock Tree Synthesis builds the physical clock-distribution network after placement and before routing. It inserts clock buffers, balances clock branches, controls clock skew and latency, improves clock transition, limits fanout, and prepares the design for post-CTS timing analysis.

CTS must balance:

* Clock skew
* Clock latency
* Clock transition
* Clock fanout
* Clock capacitance
* Setup timing
* Hold timing
* Clock power
* Congestion
* Physical legality

## Files

* `notes/clock_tree_synthesis.md` — Detailed notes covering CTS concepts, clock-tree construction, skew, latency, clock gating, clock routing, post-CTS optimization, and MMMC analysis.
* `README.md` — Project overview and file description.

## Module Description

This project explains how an ideal or estimated clock is converted into a physical clock network.

The documented topics include:

* Clock source, root, and sinks
* Clock buffers and inverters
* Clock fanout
* Clock transition
* Source latency
* Network latency
* Clock skew
* Positive and negative skew
* Useful skew
* Clock uncertainty
* Clock jitter
* Clock-tree balancing
* Clock-tree topology
* Clock tree versus clock mesh
* Clock routing
* Non-default routing rules
* Shielding and crosstalk
* Clock gating and ICG cells
* Post-CTS setup and hold timing
* Clock-quality checks
* PVT corners
* MMMC analysis
* OCV
* CRPR
* CTS closure tradeoffs

The notes also explain why CTS is a multi-objective optimization problem rather than a simple delay-minimization stage.

## Testbench

This project does not include an RTL testbench because Clock Tree Synthesis is a physical design stage rather than a functional RTL module.

CTS quality is evaluated using physical design and timing reports, including:

* Clock-skew reports
* Clock-latency reports
* Clock-transition reports
* Clock-fanout reports
* Clock-capacitance reports
* Setup timing reports
* Hold timing reports
* Clock-gating checks
* Placement-legality checks
* Congestion reports
* Clock-power reports
* MMMC timing reports

## Waveform

This project does not generate an RTL simulation waveform.

Clock behavior is analyzed using timing reports and physical design views such as:

* Clock-tree topology views
* Clock-buffer placement
* Clock-route visualization
* Clock-arrival reports
* Skew reports
* Latency reports
* Transition reports
* Setup and hold timing paths
* Congestion maps
* Clock-power reports
