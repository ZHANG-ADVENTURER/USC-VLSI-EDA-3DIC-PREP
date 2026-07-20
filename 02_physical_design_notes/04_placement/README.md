# Placement

## Overview

This project documents the placement stage of the ASIC physical design flow.

Placement assigns physical locations to standard-cell instances after floorplanning and before Clock Tree Synthesis. The placement process must balance physical legality, estimated wirelength, timing, density, congestion, power, and electrical constraints.

The main placement stages are:

* Global placement
* Legalization
* Detailed placement
* Placement optimization
* Placement quality checks

## Files

* `notes/placement.md` — Detailed notes covering placement concepts, optimization objectives, congestion estimation, timing-driven placement, legalization, and placement reports.
* `README.md` — Project overview and file description.

## Module Description

This project explains how standard cells are physically arranged inside the core area.

The documented topics include:

* Placement rows and sites
* Cell orientation
* Global placement
* Legalization
* Detailed placement
* Manhattan distance
* Half-Perimeter Wirelength
* Placement density
* Routing demand and capacity
* Routing overflow
* Cell spreading
* Timing-driven placement
* Cell sizing
* Buffer insertion
* Pre-CTS timing
* WNS and TNS
* Placement legality and quality checks

The notes also explain why placement is a multi-objective optimization problem and why a good placement must balance timing, routability, wirelength, density, and physical legality.

## Testbench

This project does not include an RTL testbench because placement is a physical design stage rather than a functional RTL module.

Placement quality is evaluated using physical design reports and checks, including:

* Placement legality
* Cell overlap
* Row and site alignment
* Total HPWL
* Local density
* Congestion hot spots
* Routing overflow
* WNS
* TNS
* Maximum transition
* Maximum capacitance
* Maximum fanout

## Waveform

This project does not generate a simulation waveform.

Placement results are analyzed using physical design views and reports such as:

* Standard-cell placement layout
* Density maps
* Congestion maps
* Timing reports
* Wirelength reports
* Legality reports
* Electrical violation reports
