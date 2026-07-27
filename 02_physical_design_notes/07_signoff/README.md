# Project Title

Physical Design Signoff

# Overview

This module summarizes the final verification and tapeout-preparation stage of the ASIC physical-design flow.

It explains how the completed routed layout is verified for:

* Manufacturing geometry
* Circuit connectivity
* Electrical safety
* Timing closure
* Signal integrity
* Power integrity
* Interconnect reliability
* Metal density
* Final database integrity

The main goal of signoff is to determine whether the exact final design revision is ready for tapeout.

A routed design is not automatically signoff-clean. It must pass every mandatory signoff category, and any accepted exception must be formally reviewed and documented.

# Files

* `notes/signoff.md` — Detailed notes covering physical verification, timing, reliability, power integrity, final database generation, and tapeout preparation
* `README.md` — Module overview and file description

# Module Description

The signoff flow covered in this module includes:

* Physical Design Signoff fundamentals
* Implementation checks versus signoff checks
* Final DRC
* Final LVS
* ERC
* Final parasitic extraction
* SPEF
* Signoff STA
* Setup and hold verification
* WNS and TNS
* MMMC analysis
* Signal-integrity analysis
* Aggressor and victim nets
* Crosstalk noise and delay
* Antenna verification
* Electromigration
* Static IR drop
* Dynamic IR drop
* Power-integrity verification
* Metal-density and fill verification
* GDSII and OASIS generation
* Stream-out and layer mapping
* Tapeout-package preparation
* Checksums
* Waivers
* ECO and re-signoff
* Final release checklist

Important distinctions include:

* DRC checks whether the layout geometry is manufacturable.
* LVS checks whether the extracted layout matches the intended netlist.
* ERC checks whether devices and electrical connections are used safely.
* Antenna violations are fabrication-stage gate-oxide risks.
* Electromigration is a long-term interconnect-reliability risk.
* IR drop is a voltage-delivery problem.
* Static IR drop uses average current.
* Dynamic IR drop analyzes transient current spikes.
* Metal fill supports manufacturing density and CMP uniformity.
* Decap cells provide local charge for transient power demand.
* SPEF contains extracted interconnect parasitics.
* GDSII or OASIS contains final manufacturing geometry.

The final signoff principle is:

> Tapeout is permitted only when the exact final design revision passes every mandatory verification category, all approved waivers are documented, and the submitted layout database is identical to the verified database.

# Testbench

This module does not contain a Verilog testbench.

Verification is represented through physical-design and signoff analyses, including:

* DRC reports
* LVS reports
* ERC reports
* Timing reports
* SI reports
* Antenna reports
* EM reports
* Static and dynamic IR-drop reports
* Density reports
* Final database checksums

The signoff reports serve as evidence that the completed physical design satisfies tapeout requirements.

# Waveform

This module does not produce a simulation waveform.

Relevant outputs include:

* Setup and hold timing reports
* WNS and TNS summaries
* MMMC scenario tables
* Crosstalk and noise reports
* IR-drop voltage maps
* Electromigration current-density maps
* Metal-density maps
* DRC and LVS summaries
* Final GDSII or OASIS database
* Tapeout signoff checklist
