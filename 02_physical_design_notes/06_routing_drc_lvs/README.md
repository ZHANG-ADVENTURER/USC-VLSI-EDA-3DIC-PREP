# Routing

## Overview

This project documents the routing stage of the ASIC physical design flow.

Routing converts logical netlist connectivity into actual physical metal wires and vias after placement and Clock Tree Synthesis.

The routing process includes:

* Global routing
* Detailed routing
* Track assignment
* Metal-layer assignment
* Via insertion
* Pin-access resolution
* Congestion management
* Design-rule repair
* Timing-aware optimization
* Signal-integrity analysis
* Antenna repair
* Electromigration analysis
* IR-drop analysis
* Parasitic extraction
* Post-route timing closure

A routing result is complete only when connectivity, timing, manufacturability, signal integrity, reliability, and power integrity all satisfy the required constraints.

## Files

* `notes/routing.md` — Detailed notes covering routing fundamentals, global and detailed routing, metal layers, tracks, vias, congestion, DRC, timing, signal integrity, parasitic extraction, and routing closure.
* `README.md` — Project overview and file description.

## Module Description

This project explains how logical nets are transformed into legal and manufacturable physical interconnect.

The documented topics include:

* Logical nets and routed wires
* Metal layers and preferred routing directions
* Routing tracks
* Wire width, spacing, and pitch
* Vias, via enclosure, and via stacks
* Single-cut and multi-cut vias
* Global routing
* Detailed routing
* Routing demand and capacity
* Routing overflow
* Congestion analysis
* Pin access
* Macro pin access
* Opens and shorts
* Design Rule Check
* Minimum width, spacing, and area violations
* Timing-aware routing
* Critical and non-critical nets
* Crosstalk and coupling capacitance
* Signal-integrity analysis
* Antenna effect and antenna repair
* Electromigration
* Static and dynamic IR drop
* Parasitic extraction
* SPEF
* Post-route Static Timing Analysis
* Engineering Change Orders
* Spare cells
* Metal-only ECOs
* Metal fill
* DRC and LVS
* Routing closure

The notes also explain the tradeoffs among routing congestion, timing, signal integrity, power integrity, reliability, and manufacturing constraints.

## Testbench

This project does not include an RTL testbench because routing is a physical design stage rather than a functional RTL module.

Routing quality is evaluated using physical design, timing, and signoff reports, including:

* Global-routing congestion reports
* Routing-demand and capacity reports
* Detailed-routing reports
* Unrouted-net reports
* Open and short reports
* DRC reports
* Pin-access reports
* Antenna reports
* Parasitic-extraction reports
* SPEF files
* Post-route setup reports
* Post-route hold reports
* Maximum-transition reports
* Maximum-capacitance reports
* Crosstalk and signal-integrity reports
* Electromigration reports
* Static and dynamic IR-drop reports
* LVS reports
* Routing-closure summaries

## Waveform

This project does not generate an RTL simulation waveform.

Routing behavior is analyzed through physical layout and timing views such as:

* Global-routing paths
* Detailed metal routes
* Routing tracks
* Via locations
* Congestion heat maps
* Pin-access views
* DRC markers
* Crosstalk reports
* Extracted RC networks
* Setup and hold timing paths
* Power-grid voltage maps
* Electromigration current-density maps
* DRC and LVS signoff results
