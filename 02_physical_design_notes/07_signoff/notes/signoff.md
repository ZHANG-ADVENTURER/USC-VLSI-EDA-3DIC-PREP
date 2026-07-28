# Physical Design Signoff

## 1. Overview

Physical Design Signoff is the final verification stage used to determine whether a completed chip layout satisfies all mandatory requirements before tapeout.

Signoff verifies that the design is:

* Timing-clean
* Physically manufacturable
* Electrically connected as intended
* Reliable under expected current conditions
* Safe across voltage and power domains
* Robust against signal-integrity and power-integrity problems
* Ready for mask preparation and fabrication

Routing completion does not automatically mean that a design is ready for tapeout.

A fully routed design may still fail because of:

* DRC violations
* LVS mismatches
* Setup or hold violations
* Crosstalk
* Antenna violations
* Electromigration
* Static or dynamic IR drop
* Metal-density problems
* ERC violations
* Incorrect GDSII/OASIS generation

The central signoff question is:

> Can the exact final design database be manufactured and operated correctly and reliably?

---

## 2. Implementation Checks versus Signoff Checks

Implementation checks are performed during placement, CTS, routing, and optimization. They help engineers build and modify the design.

Signoff checks are performed on the final or near-final design using more accurate models, qualified rule decks, and complete operating scenarios.

| Implementation Checks          | Signoff Checks                        |
| ------------------------------ | ------------------------------------- |
| Guide optimization             | Determine tapeout readiness           |
| Often fast and incremental     | More accurate and comprehensive       |
| May use estimated parasitics   | Use final extracted parasitics        |
| Temporary violations may exist | Mandatory violations must be resolved |
| Run throughout implementation  | Run on the final design revision      |

Signoff itself is primarily a verification process. If signoff finds a violation, engineers return to implementation or ECO work, modify the design, and rerun the affected signoff analyses.

Therefore:

> Implementation-clean does not automatically mean signoff-clean.

---

## 3. Final Design Rule Checking

Design Rule Checking, or DRC, verifies whether layout geometry satisfies the foundry’s manufacturing rules.

Typical DRC rules include:

* Minimum width
* Minimum spacing
* Minimum area
* Via enclosure
* Via spacing
* End-of-line spacing
* Layer-interaction rules
* Metal-density rules

### Minimum-Width Violation

A wire is narrower than the minimum allowed width.

A narrow wire may have:

* Poor printability
* Excessive resistance
* Greater defect sensitivity
* Increased electromigration risk

### Minimum-Spacing Violation

Two separate shapes are placed closer than the required minimum distance.

This may cause:

* Manufacturing bridges
* Shorts
* Increased coupling

### Minimum-Area Violation

A shape may have legal width but insufficient total area.

This is a minimum-area violation, not a spacing violation.

### Via-Enclosure Violation

The surrounding metal does not extend far enough beyond a via. Misalignment during fabrication may then produce a weak or incomplete connection.

### Routing DRC versus Signoff DRC

Routing tools may use simplified or incremental rule checking. Signoff DRC uses the complete foundry-qualified rule deck on the final layout.

Therefore:

> Routing-tool DRC-clean does not guarantee signoff-DRC-clean.

DRC checks whether geometry is manufacturable. It does not prove correct connectivity, functionality, timing, or reliability.

---

## 4. Layout Versus Schematic

Layout Versus Schematic, or LVS, compares the circuit extracted from the physical layout with the intended netlist.

LVS asks:

> Did the physical layout implement the intended electrical circuit?

LVS commonly compares:

* Cell or device count
* Net connectivity
* Pin mapping
* Power and ground connections
* Device terminals

### Open

One intended net becomes two or more extracted nets.

Possible causes include:

* Missing wire
* Missing via
* Incomplete pin access
* Broken connection

### Short

Two intended nets become one extracted net because they are unintentionally connected.

### Incorrect Connection

A route can use legal geometry but connect the wrong pins.

Example:

* Intended: `U1/Z → U2/A`
* Extracted: `U1/Z → U3/A`

Possible result:

* DRC: PASS
* LVS: FAIL

The core distinction is:

> DRC checks how the geometry is drawn. LVS checks what electrical circuit the geometry creates.

LVS does not prove that the original RTL correctly implements the specification. A buggy RTL design can be synthesized, placed, and routed consistently and still pass LVS.

---

## 5. Electrical Rule Checking

Electrical Rule Checking, or ERC, verifies electrical-safety, biasing, voltage-domain, and device-usage requirements.

Typical ERC checks include:

* Floating nodes
* Missing well or substrate taps
* Incorrect body bias
* Illegal voltage-domain crossings
* Gate-oxide overstress
* Missing level shifters
* Missing isolation cells
* Incorrect power connections

### Well and Substrate Taps

Well and substrate taps connect body regions to defined supply potentials.

Typical connections are:

* N-well → VDD
* P-well or substrate → VSS

They prevent floating body regions and reduce noise and latch-up risk.

### Level Shifters

A level shifter converts the signal representation between voltage domains.

Example:

`0.8 V domain → level shifter → 1.2 V domain`

It helps:

* Produce valid destination logic levels
* Prevent device overstress
* Reduce leakage and reliability risk

### DRC, LVS, and ERC

| Check | Main Purpose                                    |
| ----- | ----------------------------------------------- |
| DRC   | Verify manufacturing geometry                   |
| LVS   | Verify extracted connectivity                   |
| ERC   | Verify electrical safety and legal device usage |

A geometrically legal `1.8 V` connection to a `0.8 V`-rated device may produce:

* DRC: PASS
* LVS: PASS
* ERC: FAIL

---

## 6. Final Parasitic Extraction

Parasitic extraction converts the completed physical layout into an electrical resistance-capacitance model.

Primary extracted parasitics include:

* Wire resistance
* Ground capacitance
* Coupling capacitance
* Via resistance

### Wire Resistance

Wire resistance is approximately:

`R = ρ × L / A`

where:

* `R` is resistance
* `ρ` is resistivity
* `L` is wire length
* `A` is cross-sectional area

Longer wires have greater resistance. Wider or thicker wires generally have lower resistance.

### Ground Capacitance

Ground capacitance represents capacitance from a signal net to structures modeled as a reference or ground node.

More capacitance requires the driver to move more charge and may increase:

* Transition time
* Delay
* Dynamic power

### Coupling Capacitance

Coupling capacitance exists between distinct signal nets.

It increases with:

* Longer parallel routing
* Smaller spacing
* Larger interacting conductor surfaces

Coupling capacitance is the primary physical basis of crosstalk.

### Via Resistance

Vias have nonzero resistance. Additional vias add parasitics, but using more vias may still improve a route if they allow access to a lower-resistance upper metal layer.

The correct goal is to minimize total electrical and physical cost, not simply via count.

### SPEF

SPEF stands for Standard Parasitic Exchange Format. It stores extracted interconnect parasitics.

| File               | Purpose                                           |
| ------------------ | ------------------------------------------------- |
| Gate-level netlist | Cells and logical pin connectivity                |
| `.lib`             | Cell timing, power, and electrical behavior       |
| SDC                | Clocks and timing constraints                     |
| SPEF               | Extracted interconnect resistance and capacitance |

The gate-level netlist contains logical pin connectivity, but it does not contain accurate final wire geometry and interconnect parasitics.

---

## 7. Signoff Static Timing Analysis

Signoff STA uses final timing data to verify that all required paths meet timing requirements.

Typical inputs include:

* Final gate-level netlist
* Signoff timing libraries
* SDC constraints
* Extracted SPEF
* Clock definitions
* PVT corners
* RC corners
* Variation models

### Setup Timing

Setup timing verifies that data reaches the capture register early enough before the capture edge.

`Setup Slack = Required Time - Arrival Time`

* Positive slack: pass
* Zero slack: exactly at the limit
* Negative slack: fail

### Hold Timing

Hold timing verifies that new data does not reach the capture register too early.

A simplified expression is:

`Hold Slack = Arrival Time - Minimum Required Time`

Negative hold slack indicates a hold violation.

### WNS and TNS

Worst Negative Slack, or WNS, is the worst path slack.

Total Negative Slack, or TNS, is the sum of the negative slack values of all violating paths.

* WNS describes the worst individual path.
* TNS describes the accumulated violation across all failing paths.

### MMMC

Multi-Mode Multi-Corner analysis verifies timing across different operating modes and physical corners.

Modes may include:

* Functional mode
* Scan shift
* Scan capture
* Test mode
* Low-power mode

Corners may vary:

* Process
* Voltage
* Temperature
* Resistance
* Capacitance
* On-chip variation

A design is not timing-clean if any mandatory scenario has negative slack.

A basic timing-clean condition is:

* Setup WNS ≥ 0
* Setup TNS = 0
* Hold WNS ≥ 0
* Hold TNS = 0

These requirements must hold across all required scenarios.

---

## 8. Signal-Integrity Signoff

Signal-integrity signoff verifies that coupling between interconnects does not create unsafe noise or timing changes.

### Aggressor and Victim

* Aggressor: the switching net that creates a coupled disturbance
* Victim: the net affected by the disturbance

### Crosstalk Noise

An aggressor transition can inject charge into a quiet victim and create a voltage glitch.

Severe noise may:

* Cross a receiving threshold
* Create a false transition
* Trigger reset or clock circuitry incorrectly
* Cause functional failure

### Crosstalk Delay

Opposite-direction switching usually increases the victim’s effective load:

* Victim becomes slower
* Setup timing becomes more vulnerable

Same-direction switching may reduce effective coupling load:

* Victim becomes faster
* Hold timing may become more vulnerable

### Switching Windows

Strong dynamic crosstalk requires the aggressor and victim switching windows to overlap.

If their switching windows do not overlap, the aggressor cannot create the same worst-case dynamic timing effect.

SI-aware STA calculates:

`Base delay + crosstalk delta delay = SI-aware delay`

A path may pass ordinary STA but fail SI-aware STA.

---

## 9. Antenna Signoff

The antenna effect is a fabrication-stage reliability problem.

During plasma processing, exposed metal can collect charge. If connected to a MOS gate, that charge may discharge through the thin gate oxide and damage it.

The vulnerable structure is:

> The thin gate oxide

A simplified antenna ratio is:

`Antenna Ratio ≈ Exposed Metal Area / Gate Area`

Common antenna fixes include:

* Antenna-diode insertion
* Layer jumping
* Routing segmentation
* Shortening lower-metal segments near the gate

An antenna diode provides a discharge path, but it adds capacitance and may affect:

* Delay
* Slew
* Placement
* Congestion
* DRC
* LVS

Therefore, timing and affected physical checks must be rerun after antenna repair.

---

## 10. Electromigration Signoff

Electromigration, or EM, is the gradual movement of metal atoms caused by excessive current density during long-term operation.

Current density is:

`J = I / A`

where:

* `J` is current density
* `I` is current
* `A` is conductor cross-sectional area

If the area is reduced by half while current remains constant, current density doubles.

### Void

A region loses metal atoms.

Possible consequences:

* Reduced cross-sectional area
* Increased resistance
* Open circuit

### Hillock

A region accumulates metal atoms.

Possible consequences:

* Metal deformation
* Short circuit

### EM Fixes

* Increase wire width
* Use thicker upper metal
* Add parallel paths
* Add redundant vias
* Use multi-cut via arrays
* Improve power-grid current distribution

Redundant vias distribute current among multiple conductive paths. They reduce current per via and local current density; they do not “share atoms.”

---

## 11. Static IR-Drop Signoff

IR drop is the voltage loss caused by current flowing through power-network resistance.

`V_drop = I × R`

The voltage reaching a cell is approximately:

`V_cell = V_supply - V_drop`

Static IR-drop analysis uses average or steady-state current.

Excessive IR drop causes:

* Lower local VDD
* Weaker transistor drive
* Increased cell delay
* Reduced noise margin
* Possible setup or functional failure

High-density regions are vulnerable because many cells create concentrated local current demand.

Common fixes include:

* Wider power stripes
* Additional stripes
* More via arrays
* Additional power bumps
* Stronger local rails
* Cell spreading
* Moving high-power cells

---

## 12. Dynamic IR-Drop Signoff

Dynamic IR drop is a transient voltage droop caused by rapid changes in current demand.

A block may pass static IR-drop analysis but fail dynamic analysis because:

* Average current is acceptable
* Simultaneous switching creates a large short-duration current spike

Dynamic power is approximately:

`P_dynamic = α × C × V² × f`

Package and PDN inductance also contribute transient voltage disturbance:

`V_L = L × (dI/dt)`

This equation depends on the rate of change of current, not voltage.

### Decoupling Capacitors

A decap stores electrical charge near the load.

During a current spike:

* The decap releases stored charge.
* It temporarily supplies nearby cells.
* Local voltage droop is reduced.
* The power grid recharges the decap afterward.

A large clock-gated block may create a hotspot when enabled because many gates and registers begin switching within the same short time window.

---

## 13. Power-Integrity Signoff

Power integrity is broader than IR drop.

It includes:

* Static IR drop
* Dynamic IR drop
* VDD droop
* Ground bounce
* Supply noise
* Electromigration
* Decap behavior
* Bump and package effects
* PDN robustness

The effective voltage across a cell is:

`V_effective = local VDD - local VSS`

A local VDD of `0.74 V` and local VSS of `0.04 V` provide an effective supply of:

`0.74 V - 0.04 V = 0.70 V`

Poor power integrity can change both data-path and clock-path delay.

A wider power stripe improves power integrity by lowering resistance and increasing current capacity, but it consumes routing tracks and may worsen signal congestion.

---

## 14. Metal Density and Fill Verification

Metal density is the percentage of a checking region occupied by metal.

`Metal Density = (Metal Area / Window Area) × 100%`

Density is checked using local sliding windows because a legal whole-chip average can hide local sparse or dense regions.

Foundries usually specify:

* Minimum-density limits
* Maximum-density limits

The primary purpose of metal fill is to improve manufacturing uniformity, especially during CMP.

Metal fill helps reduce:

* Dishing
* Erosion
* Layer-thickness variation
* Planarity problems

However, metal fill adds conductive geometry and changes ground and coupling capacitance.

Therefore, after fill insertion, engineers must rerun:

* Density verification
* DRC
* Parasitic extraction
* STA
* Signal-integrity analysis
* Other affected signoff checks

Metal fill is not equivalent to a decap cell. Fill primarily serves manufacturability; decaps intentionally store charge for power integrity.

---

## 15. GDSII and OASIS Generation

GDSII and OASIS store the complete final physical layout geometry delivered for mask preparation and fabrication.

They include:

* Standard-cell geometry
* Macro geometry
* Signal and clock routing
* Power grid
* Vias and contacts
* Metal fill
* Physical-only cells
* Layer and datatype information

They do not replace RTL, SDC, SPEF, or timing libraries.

### LEF versus Full Layout

LEF is an implementation abstraction containing information such as:

* Cell boundary
* Pin shapes
* Routing blockages
* Placement dimensions

LEF does not necessarily contain every transistor-level manufacturing polygon. Final fabrication requires complete standard-cell and macro layout geometry.

### Layer Mapping

The layer-map file translates internal implementation layers into the correct GDSII/OASIS layer numbers and datatypes required by the foundry.

An incorrect layer map may cause:

* Missing metal
* Incorrect vias
* Geometry on the wrong mask
* Missing labels
* Invalid manufacturing output

### Stream-Out Verification

Final verification should be performed on the streamed and merged database because export problems may introduce:

* Missing macro geometry
* Broken hierarchy
* Missing fill
* Incorrect layer mapping
* Omitted library cells

The signoff principle is:

> Sign off the exact database that will be submitted.

---

## 16. Tapeout Package

Tapeout is the formal release of final chip-design data for mask preparation and fabrication.

A tapeout package commonly includes:

* Final GDSII/OASIS
* Final netlist
* Layer map
* DRC report
* LVS report
* ERC report
* Antenna report
* Density report
* Timing reports
* SI reports
* EM and IR-drop reports
* Waiver documentation
* Release forms
* Version and checksum information

### Checksums

The submitted database checksum must match the verified database checksum.

This confirms that:

* The submitted file is the verified file.
* The file was not corrupted.
* No unapproved changes occurred after signoff.

### Waivers

An approved waiver is a formally reviewed and documented exception.

It should identify:

* The exact violation
* Its location
* Supporting justification
* Responsible approver
* Applicable design revision
* Scope of acceptance

A waiver is not the same as ignoring a violation.

### ECO and Re-Signoff

A late ECO may change:

* Netlist
* Placement
* Routing
* Parasitics
* Timing
* DRC
* LVS
* Antenna
* EM
* IR drop

Therefore, affected signoff checks must be rerun after every late modification.

---

## 17. Final Signoff Checklist

A simplified release checklist includes:

| Category           | Requirement                                |
| ------------------ | ------------------------------------------ |
| Connectivity       | Zero unresolved opens and shorts           |
| DRC                | Zero unresolved violations                 |
| LVS                | Clean netlist match                        |
| ERC                | Zero unresolved electrical-rule violations |
| Antenna            | Zero unresolved violations                 |
| Density            | All required windows pass                  |
| Setup timing       | WNS ≥ 0 and TNS = 0                        |
| Hold timing        | WNS ≥ 0 and TNS = 0                        |
| MMMC               | Every required scenario passes             |
| Signal integrity   | Noise and SI-aware timing pass             |
| Electromigration   | Current-density limits pass                |
| Static IR drop     | Within project limits                      |
| Dynamic IR drop    | Within project limits                      |
| Database integrity | Final streamed database verified           |
| Documentation      | Reports and waivers approved               |
| File integrity     | Verified and submitted checksums match     |

One unresolved mandatory violation blocks tapeout.

---

## 18. Final Signoff Closure Loop

The final closure loop is:

1. Run final signoff.
2. Identify unresolved violations.
3. Analyze the root cause.
4. Implement an ECO.
5. Legalize and reroute the change.
6. Regenerate parasitics.
7. Rerun affected signoff checks.
8. Rebuild the final stream database.
9. Verify reports, versions, waivers, and checksums.
10. Approve and release the tapeout package.

The core principle is:

> Tapeout is allowed only when the exact final design revision passes every mandatory signoff category, every accepted exception is formally approved, and the verified database is identical to the submitted database.

---

## 19. Key Distinctions

### DRC versus LVS versus ERC

* DRC: Is the geometry manufacturable?
* LVS: Does the layout implement the intended netlist?
* ERC: Is the electrical usage safe and legal?

### Antenna versus Electromigration

* Antenna: fabrication-stage gate-oxide damage from plasma charge
* EM: long-term metal-atom movement caused by operating current density

### IR Drop versus EM

* IR drop: voltage-delivery problem governed by `V = I × R`
* EM: reliability problem governed by `J = I / A`

### Static versus Dynamic IR Drop

* Static: average or steady-state current
* Dynamic: short-term current spikes and simultaneous switching

### Metal Fill versus Decap

* Metal fill: manufacturing-density and CMP uniformity
* Decap: intentional local charge storage for power integrity

### Netlist versus SPEF versus GDSII/OASIS

* Netlist: cells and logical pin connectivity
* SPEF: extracted interconnect parasitics
* GDSII/OASIS: final manufacturing geometry

---

## 20. Connection to VLSI and EDA Work

Signoff connects implementation, analysis, manufacturing, and reliability.

A Physical Design Engineer must understand how a local ECO can affect:

* Timing
* Routing
* Congestion
* DRC and LVS
* Signal integrity
* Power integrity
* Reliability
* Final database consistency

An STA Engineer focuses heavily on:

* MMMC setup and hold analysis
* Extracted parasitics
* Clock behavior
* SI-aware timing
* Timing closure

An EDA Engineer may develop or improve algorithms for:

* Extraction
* Timing analysis
* DRC/LVS
* Routing
* SI analysis
* EM/IR-drop analysis
* Signoff automation

A process-aware engineer can connect foundry rules, CMP density, antenna effects, metal reliability, and final layout manufacturability with physical-design decisions.
