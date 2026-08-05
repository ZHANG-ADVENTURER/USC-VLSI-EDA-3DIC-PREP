# Day 30 Daily Log

## Topic

Physical Design Signoff

## What I Learned

Today I learned the complete physical-design signoff flow used to determine whether a chip is ready for tapeout.

Signoff is the final verification stage after placement, CTS, routing, optimization, and metal-fill insertion. It uses the final or near-final design database, extracted parasitics, foundry-qualified rule decks, timing libraries, and required operating scenarios.

A design is not tapeout-ready simply because routing is complete. It must pass every mandatory signoff category.

The main signoff checks include:

* Final DRC
* Final LVS
* ERC
* Final parasitic extraction
* Signoff STA
* MMMC timing analysis
* Signal-integrity analysis
* Antenna verification
* Electromigration analysis
* Static IR-drop analysis
* Dynamic IR-drop analysis
* Power-integrity analysis
* Metal-density and fill verification
* Final GDSII or OASIS verification
* Tapeout-package review

I learned that implementation checks and signoff checks have different purposes.

Implementation checks are usually faster and incremental. They guide placement, routing, and optimization.

Signoff checks are more accurate and comprehensive. They determine whether the final design can be released for fabrication.

I also learned the difference among DRC, LVS, and ERC:

* DRC checks whether physical geometry follows manufacturing rules.
* LVS checks whether the extracted layout matches the intended netlist.
* ERC checks whether electrical connections, voltage domains, body bias, and device usage are safe and legal.

A layout may pass DRC and LVS but still fail ERC.

For example, a geometrically legal `1.8 V` signal may directly drive a device rated for only `0.8 V`. The connection may match the netlist, but it creates an electrical-overstress risk.

I learned that final parasitic extraction produces the interconnect resistance and capacitance required for accurate timing analysis.

Important extracted parasitics include:

* Wire resistance
* Via resistance
* Ground capacitance
* Coupling capacitance

SPEF stores extracted interconnect parasitics, while the gate-level netlist stores cell instances and logical pin connectivity.

Signoff STA verifies setup and hold timing using:

* Final netlist
* Signoff `.lib` files
* SDC constraints
* Extracted SPEF
* Clock definitions
* PVT and RC corners
* Variation models
* Multiple operating modes

The basic timing metrics are:

`Setup Slack = Required Time - Arrival Time`

`Hold Slack = Arrival Time - Minimum Required Time`

WNS is the worst path slack, while TNS is the sum of all negative path slacks.

A design is not timing-clean unless every required MMMC scenario passes.

I learned that signal-integrity analysis evaluates crosstalk noise and crosstalk-induced delay.

* The aggressor net creates the coupled disturbance.
* The victim net receives the disturbance.
* Opposite-direction switching generally slows the victim and creates setup risk.
* Same-direction switching may speed up the victim and create hold risk.

The aggressor and victim timing windows must overlap for a strong dynamic crosstalk effect.

I learned that the antenna effect occurs during fabrication, not during normal chip operation.

Plasma processing may cause exposed metal to collect charge. If the metal is connected to a MOS gate, the charge may damage the thin gate oxide.

A simplified antenna ratio is:

`Antenna Ratio ≈ Exposed Metal Area / Gate Area`

Common fixes include:

* Antenna-diode insertion
* Layer jumping
* Routing segmentation
* Shortening lower-metal segments near the gate

I learned that electromigration is a long-term reliability problem caused by excessive current density.

`J = I / A`

A smaller wire cross-sectional area creates higher current density for the same current.

Electromigration may create:

* Voids
* Hillocks
* Increased resistance
* Open circuits
* Short circuits
* Via failures

Redundant vias improve reliability by distributing current among multiple conductive paths.

I learned the difference between IR drop and electromigration:

* IR drop is a voltage-delivery problem.
* Electromigration is a current-density reliability problem.

Static IR-drop analysis uses average or steady-state current:

`V_drop = I × R`

Dynamic IR-drop analysis evaluates transient current spikes caused by simultaneous switching.

A block may pass static IR-drop analysis but fail dynamic analysis because its average current is acceptable while its instantaneous peak current is too large.

Decoupling capacitors store electrical charge near active logic. During a current spike, they temporarily supply local current and reduce voltage droop.

I learned that package and PDN inductance create voltage disturbances according to:

`V_L = L × (dI/dt)`

This depends on the rate of change of current, not voltage.

Power integrity is broader than IR drop. It includes:

* VDD droop
* Ground bounce
* Static IR drop
* Dynamic IR drop
* Electromigration
* Decap behavior
* Package parasitics
* Bump and power-grid robustness

The effective voltage across a cell is:

`V_effective = local VDD - local VSS`

I learned that metal-density rules are checked using local sliding windows because a valid whole-chip average may hide local sparse or dense regions.

Metal fill improves manufacturing uniformity, especially during CMP. However, it also changes nearby parasitic capacitance.

Therefore, after metal-fill insertion, engineers must rerun:

* DRC
* Parasitic extraction
* STA
* Signal-integrity analysis
* Other affected signoff checks

I learned that GDSII and OASIS store the final physical geometry delivered for mask preparation and fabrication.

They contain:

* Standard-cell geometry
* Macro geometry
* Signal routing
* Clock routing
* Power grid
* Vias and contacts
* Metal fill
* Physical-only cells
* Layer and datatype information

LEF is only an abstract implementation view. It does not necessarily contain every transistor-level manufacturing polygon.

A layer-map file translates internal implementation layers into the correct foundry GDSII or OASIS layer numbers and datatypes.

The final streamed database must be verified because stream-out or merge errors may omit geometry, use incorrect layer mappings, or reference the wrong macro versions.

Finally, I learned that tapeout is a controlled release process rather than simply exporting a GDS file.

The final tapeout package may include:

* Final GDSII or OASIS
* Final netlist
* Layer map
* DRC, LVS, and ERC reports
* Timing and SI reports
* Antenna reports
* EM and IR-drop reports
* Density reports
* Waiver documentation
* Version information
* File checksums

The checksum of the submitted database must match the checksum of the verified database.

One unresolved mandatory violation blocks tapeout.

## What I Built

I completed the Physical Design Signoff learning module.

Created files:

* `02_physical_design_notes/07_signoff/notes/signoff.md`
* `02_physical_design_notes/07_signoff/README.md`
* `daily-log/Day30.md`

The signoff notes integrate:

* Physical verification
* Timing signoff
* Signal integrity
* Reliability
* Power integrity
* Manufacturing-density verification
* Final layout generation
* Tapeout release control

## Key Concepts

### Signoff

Final verification used to determine whether the exact completed design revision is ready for tapeout.

### DRC

Checks whether physical geometry satisfies foundry manufacturing rules.

### LVS

Checks whether the circuit extracted from layout matches the intended netlist.

### ERC

Checks electrical safety, voltage-domain legality, body bias, floating nodes, and device usage.

### SPEF

Stores extracted interconnect resistance and capacitance.

### Signoff STA

Uses final parasitics, timing libraries, constraints, modes, and corners to verify setup and hold timing.

### MMMC

Multi-Mode Multi-Corner timing analysis across all required operating conditions.

### Aggressor

A switching net that creates a coupled disturbance.

### Victim

A net whose voltage or timing is affected by coupling.

### Antenna Effect

Fabrication-stage plasma-charge accumulation that may damage thin MOS gate oxide.

### Electromigration

Long-term movement of metal atoms caused by excessive current density.

### Static IR Drop

Voltage loss calculated using average or steady-state current.

### Dynamic IR Drop

Transient voltage droop caused by sudden current spikes and simultaneous switching.

### Decap

A capacitor that stores local electrical charge and supplies transient current.

### Power Integrity

Verification that the complete power-delivery network maintains stable and safe local supply voltages.

### Metal Fill

Additional metal geometry inserted primarily to satisfy density and CMP uniformity requirements.

### GDSII / OASIS

Final physical-layout geometry formats delivered for mask preparation and fabrication.

### Layer Mapping

Translation from internal design layers to foundry stream-file layer numbers and datatypes.

### Waiver

A reviewed, justified, documented, and formally approved exception to a reported violation.

### Checksum

A file identifier used to verify that the submitted database is identical to the verified database.

### Tapeout

Formal release of the final verified chip-design database for mask preparation and fabrication.

## Problems / Fixes

### Problem 1: Misidentified the antenna-sensitive structure

I initially identified the antenna diode as the vulnerable structure.

Fix:

The vulnerable structure is the thin MOS gate oxide. The antenna diode is a repair structure that provides a safe discharge path.

### Problem 2: Incorrectly described redundant vias as sharing atoms

I initially said that redundant vias share atoms.

Fix:

Redundant vias share current by creating parallel conductive paths. This reduces current per via and lowers local current density.

### Problem 3: Used the term “electrical atoms”

I incorrectly described decap behavior using “electrical atoms.”

Fix:

The correct term is electrical charge. A decap stores charge and temporarily supplies local current during a switching event.

### Problem 4: Confused inductor and capacitor equations

I wrote:

`V = L × (dV/dt)`

Fix:

The correct inductor relationship is:

`V_L = L × (dI/dt)`

The capacitor relationship is:

`I_C = C × (dV/dt)`

### Problem 5: Assumed high-density regions automatically have higher resistance

Fix:

High cell density primarily creates concentrated local current demand. The IR-drop problem becomes worse when this high demand is combined with a weak or resistive local power grid.

### Problem 6: Treated dynamic IR drop as always larger than static IR drop

Fix:

Dynamic IR drop is not always larger. Static and dynamic analyses model different current conditions. A block may fail dynamically because of a short current spike even when its average current is acceptable.

### Problem 7: Described a waiver as intentionally ignoring a problem

Fix:

A waiver is not an ignored violation. It is a formally reviewed, justified, documented, and approved exception that applies to a specific design revision and scope.

### Problem 8: Described GDSII/OASIS as containing all chip information

Fix:

GDSII and OASIS contain final physical manufacturing geometry. They do not replace RTL, SDC, SPEF, timing libraries, or other logical and analysis files.

### Problem 9: Did not clearly understand layer mapping

Fix:

Layer mapping translates each internal implementation layer into the correct foundry GDSII/OASIS layer number and datatype.

## Connection to VLSI / EDA / 3D IC

Physical-design signoff connects logical design, physical implementation, manufacturing, timing, reliability, and final fabrication release.

For a Physical Design Engineer, signoff knowledge is required to understand why a design that appears routed and timing-clean may still be blocked by:

* DRC
* LVS
* ERC
* Signal integrity
* Antenna
* EM
* IR drop
* Density
* Database inconsistency

For an STA Engineer, signoff involves:

* Final extracted parasitics
* Setup and hold closure
* MMMC analysis
* SI-aware timing
* Constraint validation
* Timing-report review

For an EDA Engineer, signoff concepts are connected to tool development for:

* DRC and LVS
* Parasitic extraction
* Static timing analysis
* Crosstalk analysis
* EM and IR-drop analysis
* Density verification
* Database conversion
* Signoff automation

For 3D IC and advanced packaging, signoff must also consider:

* TSV resistance and capacitance
* Microbump connectivity
* Inter-die power delivery
* Package inductance
* Thermal effects
* Cross-die timing
* Interposer routing
* Die-to-die reliability

Signoff is therefore the final connection between chip design and actual manufacturable hardware.

## One Sentence Summary

Physical Design Signoff verifies that the exact final layout is manufacturable, electrically correct, timing-clean, reliable, power-stable, and consistent with the database submitted for tapeout.

## Next Step

Review the complete RTL-to-GDSII physical-design flow and connect each implementation stage with its corresponding inputs, outputs, optimization goals, and signoff checks.
