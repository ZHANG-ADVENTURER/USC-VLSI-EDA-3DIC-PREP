# Static Timing Analysis Fundamentals

## 1. Overview

Static Timing Analysis, or STA, verifies whether data signals can propagate through a digital design while satisfying timing requirements.

STA does not require a testbench or functional input sequence. Instead, it builds a timing graph from the logical design, timing constraints, cell timing models, and interconnect parasitics.

A typical post-route STA input set is:

> Gate-level netlist + SDC + `.lib` + SPEF
> → Static Timing Analysis

Each input provides a different type of information:

| Input              | Main Role                                                     |
| ------------------ | ------------------------------------------------------------- |
| Gate-level netlist | Cell instances and logical connectivity                       |
| SDC                | Clock definitions, timing requirements, and timing exceptions |
| `.lib`             | Cell delay, transition, setup, hold, and other timing models  |
| SPEF               | Extracted interconnect resistance and capacitance             |

STA uses these inputs to calculate:

* Data arrival time
* Data required time
* Setup slack
* Hold slack
* Critical paths
* Worst Negative Slack
* Total Negative Slack

The central timing relationship is:

> Startpoint
> → Data path
> → Endpoint

The analysis must also include the launch clock path and capture clock path.

---

## 2. Timing Path Structure

A timing path describes how data propagates from a valid startpoint to a valid endpoint.

A typical register-to-register path is:

> Launch register
> → Combinational logic
> → Capture register

At the pin level:

> `FF1/Q`
> → Combinational cells and nets
> → `FF2/D`

The complete timing relationship includes three major parts:

> Launch clock path
>
> * Data path
> * Capture clock path

The launch clock determines when new data begins propagating.

The data path determines how long the data takes to reach the destination.

The capture clock determines when the destination register checks the data.

---

## 3. Startpoint and Endpoint

### Startpoint

A startpoint is where timed data propagation begins.

Common startpoints include:

* Register `Q` pins
* Primary input ports
* Memory output pins
* Macro output pins
* Other sequential-cell output pins

For a register-to-register path:

> `FF1/Q`
> → Logic
> → `FF2/D`

The startpoint is `FF1/Q`.

The launch register clock pin, such as `FF1/CK`, is not the data-path startpoint. It belongs to the launch clock path.

The clock edge reaches `FF1/CK`, triggers the register, and then the data appears at `FF1/Q` after the clock-to-Q delay.

### Endpoint

An endpoint is where a timing requirement is checked.

Common endpoints include:

* Register `D` pins
* Primary output ports
* Memory input pins
* Macro input pins
* Asynchronous control pins
* Clock-gating control pins

For a register-to-register path:

> `FF1/Q`
> → Logic
> → `FF2/D`

The endpoint is `FF2/D`.

The endpoint determines which timing requirement must be checked, such as:

* Setup
* Hold
* Recovery
* Removal
* Clock-gating setup
* Clock-gating hold
* Output timing requirement

---

## 4. Main Timing Path Types

The four main timing path types are:

1. Input-to-Register
2. Register-to-Register
3. Register-to-Output
4. Input-to-Output

### Input-to-Register

> Primary input
> → Combinational logic
> → Register `D`

Startpoint:

* Primary input port

Endpoint:

* Register `D` pin

The launch register is outside the current design boundary.

The external timing consumed before the data reaches the input port is modeled with `set_input_delay`.

> External launch register
> → External logic, package, or board delay
> → Design input port
> → Internal logic
> → Capture register

### Register-to-Register

> Register `Q`
> → Combinational logic
> → Register `D`

Startpoint:

* Launch register `Q`

Endpoint:

* Capture register `D`

This is the most common internal timing path.

The analysis includes:

* Launch clock arrival
* Clock-to-Q delay
* Combinational cell delay
* Net delay
* Capture clock arrival
* Setup or hold requirement
* Clock uncertainty

### Register-to-Output

> Register `Q`
> → Combinational logic
> → Primary output

Startpoint:

* Register `Q`

Endpoint:

* Primary output port

The capture register is outside the current design boundary.

The external timing requirement is modeled with `set_output_delay`.

### Input-to-Output

> Primary input
> → Combinational logic
> → Primary output

Startpoint:

* Primary input port

Endpoint:

* Primary output port

This path does not contain an internal launch register or capture register.

It may be constrained using:

* Input delay
* Output delay
* Virtual clocks
* Maximum-delay constraints
* Interface timing requirements

---

## 5. Primary Inputs and Outputs

A primary input or output is defined relative to the current analysis boundary.

At full-chip level, a primary input may correspond to an external chip pin.

At block level, an internal block port may be treated as a primary input for block-level STA.

Therefore, the word primary does not always mean a physical package pin.

It means the signal crosses the boundary of the design currently being analyzed.

---

## 6. Launch Clock and Capture Clock

### Launch Clock

The launch clock is the clock edge that triggers the launch register.

The sequence is:

> Launch clock reaches `FF1/CK`
> → Register is triggered
> → Clock-to-Q delay occurs
> → New data appears at `FF1/Q`

The launch clock determines when the data begins propagating through the data path.

### Capture Clock

The capture clock is the clock edge that triggers the capture register.

The capture register checks whether data at its input satisfies setup and hold requirements.

For setup analysis, the data must arrive before the capture edge by at least the setup time.

For hold analysis, the data must remain stable after the capture edge for at least the hold time.

---

## 7. Setup and Hold Edge Relationships

### Setup Edge Relationship

For a normal single-cycle register-to-register path, setup analysis usually compares:

> Launch edge at the current cycle
> → Capture edge one clock period later

If the clock period is `5 ns`:

> Launch edge = `0 ns`
> Capture edge = `5 ns`

The data has approximately one clock period to propagate, before accounting for setup time, uncertainty, skew, and other margins.

### Hold Edge Relationship

Hold analysis usually compares launch and capture edges near the same cycle.

> Launch edge = `0 ns`
> Capture edge = `0 ns`

Hold analysis checks whether new data propagates too quickly and disturbs the data being captured at the current edge.

The key distinction is:

> Setup checks whether data is too late for the next capture edge.
> Hold checks whether new data is too early for the current capture edge.

---

## 8. Clock Latency and Clock Skew

### Clock Latency

Clock latency is the propagation time from the clock source to one specific clock sink.

Example:

> Clock source
> → Clock buffers and wires
> → `FF1/CK`

If the clock reaches `FF1/CK` at `0.30 ns`, the launch clock latency is `0.30 ns`.

### Clock Skew

Clock skew is the arrival-time difference between two clock sinks.

> Clock Skew = Capture Clock Arrival - Launch Clock Arrival

Example:

> Launch clock arrival = `0.25 ns`
> Capture clock arrival = `0.40 ns`

> Clock Skew = `0.40 - 0.25 = +0.15 ns`

This is positive skew because the capture clock arrives later.

---

## 9. Positive and Negative Skew

### Positive Skew

Positive skew means:

> Capture clock arrival > Launch clock arrival

Typical effect:

* Setup may improve
* Hold may worsen

For setup, the later capture clock gives the data more propagation time.

For hold, the later capture clock moves the earliest safe arrival boundary later, making it easier for new data to arrive too early.

### Negative Skew

Negative skew means:

> Capture clock arrival < Launch clock arrival

Typical effect:

* Setup may worsen
* Hold may improve

The capture edge occurs earlier relative to the launch edge, reducing setup time but relaxing the hold relationship.

These are general timing effects. Actual results depend on the complete clock and data paths.

---

## 10. Clock Period versus Clock Skew

Clock period and clock skew affect timing differently.

### Increasing Clock Period

If the clock period changes from `5 ns` to `8 ns`:

> Setup capture edge: `5 ns` → `8 ns`

The next-cycle capture edge moves later, so setup timing receives more available time.

However, ordinary hold analysis still compares same-cycle edges:

> Hold launch edge ≈ `0 ns`
> Hold capture edge ≈ `0 ns`

Therefore, increasing the clock period usually improves setup but does not fix hold.

### Increasing Positive Skew

Positive skew changes the relative arrival of launch and capture clocks within the same cycle.

> Launch clock arrival = `0.20 ns`
> Capture clock arrival = `0.35 ns`

This affects both setup and hold:

* Setup may improve
* Hold may worsen

The distinction is:

> Longer period moves the next capture edge.
> Positive skew moves the capture clock relative to the launch clock.

---

## 11. Data Path Delay

A register-to-register data path commonly includes:

> Clock-to-Q delay
>
> * Combinational cell delays
> * Net delays

Example:

> `FF1/Q`
> → Net
> → NAND gate
> → Net
> → Inverter
> → Net
> → `FF2/D`

The total propagation time is the sum of all relevant delays along the path.

---

## 12. Clock-to-Q Delay

Clock-to-Q delay is the time between the active clock edge reaching a launch register and the new data appearing at its output.

> Clock edge reaches `FF1/CK`
> → Internal register response
> → New data appears at `FF1/Q`

Clock-to-Q delay is part of the data arrival calculation.

It is modeled in the sequential cell’s `.lib` timing data.

---

## 13. Cell Delay

Cell delay is the propagation time through a library cell.

Example:

> Signal reaches inverter input at `1.00 ns`
> Signal changes at inverter output at `1.08 ns`

> Cell delay = `0.08 ns`

Cell delay is not a fixed value.

Within one PVT corner, the two main lookup variables are:

* Input slew
* Output load capacitance

> Input slew + Output load
> → `.lib` timing table
> → Cell delay and output transition

### Input Slew

Input slew is the transition time of the signal arriving at a cell input.

A slow input transition usually increases cell delay because the internal transistors take longer to cross their switching region.

### Output Load

Output load is the capacitance driven by the output pin.

It may include:

* Downstream cell input capacitance
* Wire capacitance
* Coupling capacitance
* Output-port load

A larger output capacitance requires more charge to change voltage.

> Larger capacitance
> → More charge required
> → Slower output transition
> → Larger cell delay

---

## 14. Timing Arcs

A timing arc represents a timing relationship between cell pins.

For a combinational cell:

> Input pin
> → Output pin

A NAND gate may contain separate timing arcs for:

* `A` to `Y`
* `B` to `Y`

The delay may also differ by transition direction:

* Input rise to output rise
* Input rise to output fall
* Input fall to output rise
* Input fall to output fall

For a sequential cell, timing arcs and timing checks may include:

* Clock-to-Q
* Setup
* Hold
* Recovery
* Removal
* Minimum pulse width

A timing arc is a timing-model relationship, not a physical wire.

---

## 15. Net Delay

Net delay is the propagation time between a driver pin and a load pin through interconnect.

> Driver output
> → Wire and vias
> → Load input

Net delay is influenced by:

* Wire resistance
* Wire capacitance
* Coupling capacitance
* Metal layer
* Wire length
* Wire width
* Wire spacing
* Via count
* Routing topology
* Neighboring nets

Wire resistance can be described approximately as:

> R = ρ × L / A

Where:

* `ρ` is material resistivity
* `L` is wire length
* `A` is wire cross-sectional area

A longer or narrower wire generally has greater resistance.

More vias may also add resistance.

---

## 16. Net Delay at Different Design Stages

### Before Placement

The physical route is unknown.

Net delay may be estimated using:

* Fanout
* Statistical wire-load models
* Early interconnect estimates

### After Placement

Cell coordinates are known.

The tool can use:

* Estimated wire length
* Cell distance
* Global-routing estimates

### After Routing

Actual routing geometry is available.

Extraction tools calculate parasitic resistance and capacitance and write them into SPEF.

> Routed geometry
> → Parasitic extraction
> → SPEF
> → Post-route STA

Post-route net delay is generally more accurate than pre-layout estimates.

---

## 17. Cell Delay and Net Delay Propagation

STA propagates timing stage by stage.

> Previous arrival time
>
> * Cell or net delay
>   = New arrival time

Example:

| Timing Point |            Increment | Arrival Time |
| ------------ | -------------------: | -----------: |
| `FF1/Q`      |                    — |    `0.30 ns` |
| `NAND/A`     |  Net delay `0.05 ns` |    `0.35 ns` |
| `NAND/Y`     | Cell delay `0.20 ns` |    `0.55 ns` |
| `INV/A`      |  Net delay `0.08 ns` |    `0.63 ns` |
| `INV/Y`      | Cell delay `0.12 ns` |    `0.75 ns` |
| `FF2/D`      |  Net delay `0.05 ns` |    `0.80 ns` |

The output slew of one cell becomes the input slew of the next cell.

Therefore, STA does not simply add fixed delay values. It continuously updates:

* Arrival time
* Input slew
* Output slew
* Output load
* Cell delay
* Net delay

---

## 18. Cell Upsizing

Cell upsizing replaces a cell with a stronger drive-strength version.

Example:

> `INV_X1` → `INV_X4`

Possible benefits:

* Stronger drive current
* Lower output resistance
* Faster transition under large load
* Reduced delay at the current stage

Possible disadvantages:

* Larger input capacitance
* Greater load on the previous stage
* Increased area
* Increased power
* Possible congestion impact

Therefore, upsizing one cell does not guarantee improvement for the complete path.

Timing optimization must evaluate the full path.

---

## 19. Buffer Insertion

A long interconnect may be divided using buffers.

Before buffering:

> Driver
> → Long RC wire
> → Load

After buffering:

> Driver
> → Shorter RC segment
> → Buffer
> → Shorter RC segment
> → Load

Buffer insertion adds cell delay, but it may still reduce total delay by:

* Dividing one large RC network
* Improving slew
* Isolating downstream capacitance
* Increasing drive strength
* Reducing the effective delay of a long net

Buffer insertion is also commonly used for hold repair by increasing minimum data-path delay.

After hold repair, setup timing must be rechecked because added buffers also increase maximum delay.

---

## 20. Arrival Time

Arrival time is the cumulative time at which a signal reaches a timing point.

It is different from delay.

### Delay

Delay is the incremental time added by one cell or net.

### Arrival Time

Arrival time is the accumulated time at a specific pin.

> Arrival Time = Previous Arrival Time + Current Incremental Delay

For a register-to-register path:

> Data Arrival Time
> = Launch Clock Arrival
>
> * Clock-to-Q Delay
> * Total Cell Delay
> * Total Net Delay

Example:

> Launch clock arrival = `0.20 ns`
> Clock-to-Q delay = `0.10 ns`
> Total cell delay = `0.65 ns`
> Total net delay = `0.15 ns`

> Data Arrival Time = `0.20 + 0.10 + 0.65 + 0.15`
> Data Arrival Time = `1.10 ns`

The arrival time alone does not determine whether timing passes. It must be compared with required time.

---

## 21. Arrival Time for Different Path Types

### Register-to-Register

> Arrival Time
> = Launch Clock Arrival
>
> * Clock-to-Q Delay
> * Internal Cell and Net Delay

### Input-to-Register

The initial arrival time comes from `set_input_delay`.

> Arrival Time
> = Input Delay
>
> * Internal Cell and Net Delay

The input delay represents time already consumed outside the current design before the data reaches the input port.

It is not an input-port startup time.

### Register-to-Output

> Arrival Time
> = Launch Clock Arrival
>
> * Clock-to-Q Delay
> * Internal Cell and Net Delay

The output delay is normally used on the required-time side, not added to the internal arrival time.

---

## 22. Maximum and Minimum Arrival

### Maximum Arrival

Maximum or late arrival uses larger propagation delays.

It is primarily used for setup analysis.

> Setup concern
> → Data may arrive too late
> → Analyze maximum arrival

### Minimum Arrival

Minimum or early arrival uses smaller propagation delays.

It is primarily used for hold analysis.

> Hold concern
> → Data may arrive too early
> → Analyze minimum arrival

The same logical path can have both a late arrival time and an early arrival time under different timing conditions.

---

## 23. Required Time

Required time is the timing boundary imposed at an endpoint.

Arrival time answers:

> When does the data actually arrive?

Required time answers:

> When is the data allowed or required to arrive?

Arrival time is mainly determined by the launch side and data path.

Required time is mainly determined by the capture side and timing requirement.

---

## 24. Setup Required Time

Setup required time is the latest permitted data arrival time.

For a normal register-to-register setup path:

> Setup Required Time
> = Next Capture Edge
>
> * Capture Clock Arrival
>
> - Setup Time
> - Clock Uncertainty

Example:

> Clock period = `5.00 ns`
> Capture clock arrival = `0.30 ns`
> Setup time = `0.20 ns`
> Clock uncertainty = `0.10 ns`

> Setup Required Time
> = `5.00 + 0.30 - 0.20 - 0.10`
> = `5.00 ns`

The data must arrive no later than `5.00 ns`.

### Why Setup Time Is Subtracted

Setup time is a requirement of the capture register.

The data must become stable before the capture edge.

> Data must be stable
> → Setup window
> → Capture edge

If the capture edge is at `5.00 ns` and setup time is `0.20 ns`:

> Latest allowed arrival = `5.00 - 0.20`
> Latest allowed arrival = `4.80 ns`

Setup time is not external path delay. It is a sequential timing requirement of the destination register.

### Why Uncertainty Is Subtracted

Clock uncertainty reserves timing margin for effects such as:

* Jitter
* Skew variation
* Modeling uncertainty
* Timing margin

Larger uncertainty reduces the available setup time.

---

## 25. Hold Required Time

Hold required time is the earliest permitted arrival time for new data.

For a normal register-to-register hold path:

> Hold Required Time
> = Current Capture Clock Arrival
>
> * Hold Time
> * Hold Uncertainty

Example:

> Capture clock arrival = `0.25 ns`
> Hold time = `0.08 ns`
> Hold uncertainty = `0.02 ns`

> Hold Required Time
> = `0.25 + 0.08 + 0.02`
> = `0.35 ns`

New data must not arrive before `0.35 ns`.

### Why Hold Time Is Added

Hold time is a requirement of the capture register.

The old data must remain stable after the capture edge.

> Capture edge
> → Hold window
> → New data may safely change

If the capture edge is at `0.25 ns` and hold time is `0.08 ns`:

> Earliest safe new-data arrival = `0.25 + 0.08`
> Earliest safe new-data arrival = `0.33 ns`

Hold time is not an extra propagation delay. It is a sequential timing requirement of the destination register.

---

## 26. Setup and Hold Required-Time Comparison

| Check | Required-Time Meaning             | Basic Relationship          |
| ----- | --------------------------------- | --------------------------- |
| Setup | Latest allowed data arrival       | Capture edge - setup margin |
| Hold  | Earliest allowed new-data arrival | Capture edge + hold margin  |

The required conditions are:

> Setup: Arrival Time ≤ Required Time

> Hold: Arrival Time ≥ Required Time

A useful distinction is:

> Setup required time is a deadline.
> Hold required time is an earliest-safe boundary.

---

## 27. Slack

Slack measures the timing margin between arrival time and required time.

Positive slack means the timing requirement is satisfied.

Negative slack means a violation exists.

### Setup Slack

> Setup Slack = Required Time - Arrival Time

Example:

> Setup arrival time = `4.60 ns`
> Setup required time = `5.00 ns`

> Setup Slack = `5.00 - 4.60`
> Setup Slack = `+0.40 ns`

The path passes setup timing.

### Hold Slack

> Hold Slack = Arrival Time - Required Time

Example:

> Hold arrival time = `0.28 ns`
> Hold required time = `0.35 ns`

> Hold Slack = `0.28 - 0.35`
> Hold Slack = `-0.07 ns`

The path has a hold violation of `0.07 ns`.

---

## 28. Slack Interpretation

| Slack    | Meaning                           |
| -------- | --------------------------------- |
| Positive | Timing requirement is met         |
| Zero     | Requirement is met with no margin |
| Negative | Timing requirement is violated    |

For both setup and hold:

> Slack ≥ 0
> → Timing met

> Slack < 0
> → Timing violated

The formulas differ because setup and hold check opposite timing risks.

> Setup fears late data.
> Hold fears early data.

---

## 29. Setup Violation

A setup violation means the data arrives too late.

Common causes include:

* Clock period too short
* Deep combinational logic
* Weak drive strength
* Large output load
* Long routing
* High capacitance
* Too many vias
* Poor placement
* Negative skew
* Large clock uncertainty
* Slow PVT corner

Possible setup fixes include:

* Cell upsizing
* Buffer insertion
* Logic restructuring
* Fanout reduction
* Placement improvement
* Routing improvement
* Faster cell selection
* Pipeline insertion
* Appropriate useful skew
* Correction of invalid constraints

Timing exceptions must reflect real functional behavior. False paths and multicycle paths must not be added merely to hide violations.

---

## 30. Hold Violation

A hold violation means new data arrives too early.

Common causes include:

* Very short data path
* Fast cells
* Small net delay
* Positive skew
* Fast PVT corner
* Minimum RC corner
* Small clock-to-Q delay

Possible hold fixes include:

* Insert delay buffers
* Insert dedicated hold cells
* Use smaller or slower cells
* Add routing detour
* Adjust clock skew
* Perform hold optimization

The goal is:

> Increase minimum data-path delay
> → New data arrives later
> → Hold slack improves

After hold repair, setup timing must be rechecked.

---

## 31. Why Lower Frequency Does Not Fix Hold

Lowering the clock frequency increases the clock period.

For setup:

> Current launch edge
> → Next capture edge

A longer period moves the next capture edge later and increases setup required time.

For hold:

> Current launch edge
> → Current capture edge

The same-cycle edge relationship remains approximately unchanged.

Therefore:

> Lower frequency
> → May improve setup
> → Normally does not repair hold

Hold repair requires changing the minimum data delay or the same-cycle clock relationship.

---

## 32. Timing Report Structure

A timing report commonly includes:

* Startpoint
* Endpoint
* Path group
* Path type
* Timing points
* Incremental delay
* Cumulative path time
* Data arrival time
* Data required time
* Slack

A simplified report structure is:

> Startpoint: `FF1/Q`
> Endpoint: `FF2/D`
> Path Group: `clk`
> Path Type: `max`
>
> Point | Incr | Path
> Clock source | `0.00` | `0.00`
> `FF1/CK` | `0.20` | `0.20`
> `FF1/Q` | `0.10` | `0.30`
> `U1/A` | `0.05` | `0.35`
> `U1/Y` | `0.25` | `0.60`
> `U2/A` | `0.08` | `0.68`
> `U2/Y` | `0.40` | `1.08`
> `FF2/D` | `0.12` | `1.20`
>
> Data arrival time = `1.20 ns`
>
> Capture clock edge = `5.00 ns`
> Capture clock latency = `0.30 ns`
> Clock uncertainty = `-0.10 ns`
> Setup time = `-0.15 ns`
>
> Data required time = `5.05 ns`
>
> Slack = `5.05 - 1.20 = +3.85 ns`

---

## 33. Incremental Delay and Path Time

Timing reports often contain `Incr` and `Path` columns.

### Incr

`Incr` is the delay added by the current timing segment.

This may represent:

* Clock buffer delay
* Clock-to-Q delay
* Cell delay
* Net delay
* Timing-check adjustment

### Path

`Path` is the cumulative timing value at the current point.

> Current Path Time
> = Previous Path Time
>
> * Current Increment

Example:

> Previous path time = `0.35 ns`
> Current cell delay = `0.25 ns`
> New path time = `0.60 ns`

---

## 34. Path Type in Timing Reports

### Max Path

A `max` timing path generally corresponds to setup analysis.

> Max delay
> → Late data
> → Setup analysis

### Min Path

A `min` timing path generally corresponds to hold analysis.

> Min delay
> → Early data
> → Hold analysis

The path type indicates whether the tool is evaluating the latest or earliest possible data arrival.

---

## 35. Path Groups

STA tools group timing paths to organize analysis.

Paths may be grouped by:

* Capture clock
* Clock domain
* Input path category
* Output path category
* User-defined path group

Example groups may include:

* `clk_cpu`
* `clk_mem`
* `clk_bus`
* Input-to-register paths
* Register-to-output paths

Path groups allow engineers to compare:

* Worst slack
* Violation count
* Critical paths
* Timing closure status by domain

---

## 36. Critical Path

A critical path is usually the path with the worst slack or the smallest remaining margin.

It is not necessarily:

* The path with the most logic levels
* The path with the longest wire
* The path with the most cells

It is the path with the worst timing result under the current:

* Mode
* Corner
* Constraints
* Clock relationships
* Parasitic conditions

If all paths pass, the critical path may have a small positive slack.

If violations exist, the critical path usually has the most negative slack.

---

## 37. Worst Negative Slack

Worst Negative Slack, or WNS, is the most negative slack among all violating paths.

Example:

> Path A slack = `-0.10 ns`
> Path B slack = `-0.25 ns`
> Path C slack = `-0.05 ns`

> WNS = `-0.25 ns`

WNS shows the severity of the single worst violation.

---

## 38. Total Negative Slack

Total Negative Slack, or TNS, is the sum of all negative slacks.

Using the same paths:

> TNS = `-0.10 - 0.25 - 0.05`
> TNS = `-0.40 ns`

TNS shows the total amount of timing violation across all failing paths.

WNS and TNS answer different questions:

| Metric               | Meaning                                                    |
| -------------------- | ---------------------------------------------------------- |
| WNS                  | How severe is the worst violation?                         |
| TNS                  | How large is the total violation across all failing paths? |
| Violating Path Count | How many paths fail?                                       |

A design may have one severe failure or many small failures. Both conditions require different optimization strategies.

---

## 39. Timing Closure

Timing closure means satisfying all required timing checks across all required analysis scenarios.

It includes more than obtaining positive setup slack in one report.

A complete timing-closure process may include:

* Setup analysis
* Hold analysis
* Recovery and removal checks
* Clock-gating checks
* Multiple timing modes
* Multiple PVT corners
* Multiple RC corners
* Signal-integrity effects
* Timing derates
* Variation analysis
* Constraint validation
* Unconstrained-path review

The design must be timing-clean under all required signoff conditions.

---

## 40. Core Relationships

### Timing Path

> Startpoint
> → Cell and net timing arcs
> → Endpoint

### Register-to-Register Arrival Time

> Data Arrival Time
> = Launch Clock Arrival
>
> * Clock-to-Q Delay
> * Cell Delays
> * Net Delays

### Setup Required Time

> Setup Required Time
> = Next Capture Edge
>
> * Capture Clock Arrival
>
> - Setup Time
> - Clock Uncertainty

### Hold Required Time

> Hold Required Time
> = Current Capture Clock Arrival
>
> * Hold Time
> * Hold Uncertainty

### Setup Slack

> Setup Slack = Required Time - Arrival Time

### Hold Slack

> Hold Slack = Arrival Time - Required Time

### Timing Result

> Slack ≥ 0
> → Timing met

> Slack < 0
> → Timing violated

---

## 41. Key Distinctions

| Concept A            | Concept B          | Main Difference                                                                |
| -------------------- | ------------------ | ------------------------------------------------------------------------------ |
| Delay                | Arrival Time       | Delay is incremental; arrival time is cumulative                               |
| Arrival Time         | Required Time      | Arrival is actual timing; required time is the timing boundary                 |
| Setup                | Hold               | Setup checks late data; hold checks early data                                 |
| Setup Required Time  | Hold Required Time | Setup is the latest allowed arrival; hold is the earliest allowed arrival      |
| Clock Latency        | Clock Skew         | Latency is source-to-one-sink delay; skew is the difference between two sinks  |
| Clock Period         | Clock Skew         | Period separates cycles; skew changes relative clock arrival                   |
| Cell Delay           | Net Delay          | Cell delay occurs inside a library cell; net delay occurs through interconnect |
| Max Path             | Min Path           | Max is generally setup; min is generally hold                                  |
| WNS                  | TNS                | WNS is the worst violation; TNS is the sum of all violations                   |
| Testbench Simulation | STA                | Simulation checks activated behavior; STA analyzes constrained timing paths    |

---

## 42. Final Principle

Static Timing Analysis determines whether data can propagate from valid startpoints to valid endpoints while satisfying setup, hold, and other timing requirements.

It combines:

* Logical connectivity from the gate-level netlist
* Timing intent from SDC
* Cell timing behavior from `.lib`
* Interconnect parasitics from SPEF
* Launch and capture clock timing
* Data-path cell and net delays
* Sequential timing requirements

The central engineering rule is:

> Arrival time describes when data actually reaches an endpoint.
> Required time describes when the data is allowed to reach that endpoint.
> Slack measures the remaining timing margin.
