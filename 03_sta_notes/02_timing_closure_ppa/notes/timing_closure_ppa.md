# Timing Closure and PPA Tradeoffs

## 1. Overview

Timing closure is the iterative process of making a design satisfy all required timing constraints across the required operating modes and PVT corners while controlling power, performance, area, congestion, and physical implementation risk.

Timing closure is not equivalent to obtaining one positive WNS value from one setup report.

A design can only be considered timing-clean when:

- Setup timing passes.
- Hold timing passes.
- Timing constraints are correct.
- Relevant paths are properly constrained.
- Required operating modes are analyzed.
- Required PVT corners are analyzed.
- Timing repairs do not introduce unacceptable power, area, congestion, slew, capacitance, or physical verification problems.

The complete objective is:

> Meet timing under valid constraints and analysis scenarios without creating unacceptable PPA or physical side effects.

## 2. Why Positive WNS Is Not Sufficient

WNS represents the worst slack among the paths included in one specific timing analysis.

For example:

> Setup WNS = +0.05 ns

This result only proves that the worst analyzed setup path has positive slack under the current:

- Timing constraints
- Operating mode
- PVT corner
- Path group
- Parasitic model
- Clock definition
- Analysis type

It does not prove that the entire design has achieved timing closure.

A design may still contain:

- Hold violations
- Violations in other corners
- Violations in other modes
- Unconstrained paths
- Missing input or output delays
- Incorrect clock relationships
- Incorrect false-path exceptions
- Incorrect multicycle-path exceptions
- Incorrect clock periods
- Missing generated clocks
- Excessive slew or capacitance
- Unacceptable power or congestion

A clean timing report generated from incorrect constraints is not a valid result.

## 3. Timing Closure Coverage

Timing closure includes three major categories of checks.

### 3.1 Timing Checks

The primary checks include:

- Setup
- Hold
- Recovery
- Removal
- Minimum pulse width
- Clock-gating timing

The main focus of this module is setup and hold timing.

### 3.2 Constraint and Coverage Checks

The analysis must confirm that:

- All sequential elements receive valid clocks.
- Generated clocks are defined correctly.
- Input delays are present where required.
- Output delays are present where required.
- Clock relationships match the architecture.
- False paths are supported by functional intent.
- Multicycle paths reflect the real number of allowed cycles.
- Unconstrained endpoints are reviewed.
- Timing exceptions are not being used to hide real violations.

A false path should only be applied when the path does not require a normal timing relationship because of real architectural behavior.

Examples may include:

- Properly synchronized asynchronous clock-domain crossings
- Test-only paths disabled in functional mode
- Functionally impossible paths
- Configuration paths that only change while normal operation is stopped

A timing violation alone is not a valid reason to declare a path false.

### 3.3 PPA and Physical Checks

A timing-clean design must also remain physically practical.

The closure process must review:

- Dynamic power
- Leakage power
- Clock power
- Standard-cell area
- Utilization
- Placement density
- Congestion
- Routing resources
- Transition time
- Capacitance
- Fanout
- DRC
- Signal integrity
- Clock-tree impact

## 4. The Timing Closure Loop

Timing closure is an iterative engineering loop.

> Run STA  
> → Identify violating paths  
> → Verify constraints and path coverage  
> → Classify the root cause  
> → Select the smallest appropriate repair  
> → Update placement, routing, or logic implementation  
> → Re-extract parasitics  
> → Rerun setup and hold STA  
> → Review PPA and physical side effects  
> → Repeat until all requirements are satisfied

A repair should never be accepted based only on the expected direction of change.

The design must be reanalyzed because timing changes depend on:

- New cell delays
- New loads
- New input slews
- New routing lengths
- New resistance and capacitance
- New clock relationships
- New interactions with other paths

## 5. Root-Cause Classification

A timing violation should first be classified into one or more of the following categories:

1. Data-path problem
2. Clock-path problem
3. Constraint or analysis problem
4. Physical implementation problem

The purpose of classification is to avoid applying a repair that does not match the actual cause.

## 6. Cell-Delay-Dominated Paths

A path is cell-delay dominated when most of its delay is contributed by standard-cell timing arcs.

Example:

| Delay Component | Value |
|---|---:|
| Total cell delay | 2.10 ns |
| Total net delay | 0.30 ns |

This path is primarily limited by cell delay.

Possible causes include:

- Weak drive strength
- Deep combinational logic
- Slow high-Vt cells
- Poor input slew
- Large output load
- Inefficient logic structure

### 6.1 Weak Driver

A small driver may not be strong enough to charge or discharge a heavy load quickly.

Possible repairs include:

- Cell upsizing
- Load isolation
- Buffer insertion

### 6.2 Poor Input Slew

Poor input slew means that the input transition is slow.

A slow transition may cause the receiving cell to spend more time in its switching region, increasing propagation delay.

Poor slew can propagate through multiple logic levels:

> Poor input slew  
> → Larger current-cell delay  
> → Poor output slew  
> → Poor input slew at the next cell  
> → Larger next-cell delay

### 6.3 Large Output Load

Output load may include:

- Downstream pin capacitance
- Wire capacitance
- Coupling capacitance

A large load increases the time required for the driver to charge or discharge the output node.

### 6.4 Deep Combinational Logic

A deep logic path contains many sequential levels of combinational logic.

Example:

> Launch Register  
> → MUX  
> → AND  
> → Adder  
> → Comparator  
> → MUX  
> → Capture Register

Even if each cell has a moderate delay, the accumulated cell delay may exceed the available clock period.

Possible repairs include:

- Logic restructuring
- Boolean optimization
- Parallel computation
- Pipelining

## 7. Net-Delay-Dominated Paths

A path is net-delay dominated when routing and interconnect delay contribute most of the total delay.

Example:

| Delay Component | Value |
|---|---:|
| Total cell delay | 0.50 ns |
| Total net delay | 1.70 ns |

Possible causes include:

- Poor placement
- Long routing
- Routing congestion
- Macro blockage
- Large fanout
- Excessive vias
- Inefficient routing layers

### 7.1 Long Routing

Longer wires usually increase:

- Resistance
- Ground capacitance
- Coupling capacitance
- RC delay

### 7.2 Poor Placement

Logically adjacent cells may be physically far apart.

> Short logical connection does not guarantee short physical routing.

Poor placement may create:

- Long nets
- High capacitance
- Large net delay
- More buffers
- Greater congestion

### 7.3 Routing Congestion

Congestion may force the router to:

- Use indirect routes
- Change metal layers repeatedly
- Add more vias
- Pass through narrow routing channels
- Avoid blocked regions

The result may be larger resistance, capacitance, delay, and coupling.

### 7.4 Large Fanout

Fanout is the number of receiving pins driven by one source.

Large fanout can increase both cell delay and net delay.

> More sink pins  
> → Larger total pin capacitance  
> → Larger driver load  
> → Larger cell delay

At the same time:

> More sinks  
> → Larger routing tree  
> → More wire resistance and capacitance  
> → Larger net delay

Fanout and capacitance are related but not identical. A large number of small loads may be lighter than a small number of large loads.

## 8. Clock-Path Root Causes

### 8.1 Clock Skew

Clock skew is:

> Clock Skew = Capture Clock Arrival − Launch Clock Arrival

For setup:

- Positive skew usually helps setup.
- Negative skew usually hurts setup.

For hold:

- Positive skew usually hurts hold.
- Negative skew usually helps hold.

Negative skew hurts setup because the capture clock arrives earlier relative to the launch clock, reducing the effective time available for data propagation.

Positive skew does not make the data signal faster. It delays the capture boundary.

### 8.2 Clock Period Versus Capture Latency

Increasing the clock period and increasing capture latency are different operations.

Setup required time depends on the next capture edge:

> Setup Required Time = Clock Period + Capture Clock Arrival − Setup Time − Uncertainty

Hold required time normally depends on the current capture edge:

> Hold Required Time = Current Capture Clock Arrival + Hold Time + Hold Uncertainty

Therefore:

| Change | Setup Effect | Hold Effect |
|---|---|---|
| Increase clock period | Usually improves setup | Usually unchanged |
| Increase capture clock latency | Improves setup | Usually worsens hold |
| Increase data-path delay | Worsens setup | Improves hold |

Lowering frequency usually cannot repair an ordinary hold violation because hold compares current-cycle launch and capture edges.

## 9. Constraint and Analysis Root Causes

A violation may be caused by an incorrect timing model rather than a slow or fast physical path.

Possible problems include:

- Incorrect clock period
- Missing generated clock
- Missing `set_input_delay`
- Missing `set_output_delay`
- Incorrect uncertainty
- Incorrect clock relationship
- Incorrect false path
- Incorrect multicycle path
- Wrong operating corner
- Missing library
- Incorrect parasitic annotation

Constraint correction is valid only when the original constraint is incorrect.

Changing a real 2 ns performance requirement to 4 ns only to remove setup violations is not a timing repair. It changes the performance specification.

## 10. Setup Repair Methods

A setup violation means:

> Data arrives too late.

The goal is to reduce maximum data-path delay or increase valid available time without violating the architectural specification.

### 10.1 Cell Upsizing

Cell upsizing replaces a cell with a stronger version.

Example:

> `BUF_X1` → `BUF_X4`

Benefits may include:

- Lower effective output resistance
- Stronger drive capability
- Better output slew
- Lower delay under heavy load

Costs may include:

- Larger area
- Higher dynamic power
- Higher leakage
- Larger input capacitance
- More congestion

For a path:

> Cell A → Cell B → Cell C

Upsizing Cell B may make Cell B faster, but its larger input capacitance increases the load seen by Cell A.

> Cell B becomes faster  
> → Cell A may become slower

Cell upsizing should be applied only after confirming that cell delay, load, or slew is the dominant issue.

### 10.2 Low-Vt Replacement

Replacing a high-Vt or standard-Vt cell with a low-Vt cell usually reduces cell delay.

Benefits:

- Faster switching
- Better setup slack
- Often little area change

Primary cost:

- Higher leakage power

Low-Vt cells are usually applied selectively on critical paths.

### 10.3 Buffer Insertion for Setup

Buffer insertion may reduce total delay on a long RC net.

Before:

> Driver → Long RC Net → Receiver

After:

> Driver → Shorter RC Segment → Buffer → Shorter RC Segment → Receiver

The buffer:

- Isolates downstream capacitance
- Restores slew
- Divides the RC network
- Reduces the effective burden on the original driver

The inserted buffer adds cell delay, but total path delay may still decrease if the RC and slew improvements are larger than the added buffer delay.

### 10.4 Fanout Reduction

A high-fanout signal may be split using a buffer tree or logic duplication.

Before:

> One Driver → 100 Loads

After:

> One Driver  
> → Buffer A → Part of the loads  
> → Buffer B → Remaining loads

This can reduce:

- Direct load on the original driver
- Slew degradation
- Routing complexity per branch
- Cell and net delay

### 10.5 Logic Restructuring

Logic restructuring reduces delay by changing the combinational implementation.

Possible techniques include:

- Reducing logic depth
- Reassociating operations
- Simplifying Boolean expressions
- Parallelizing computations
- Duplicating logic to reduce fanout

The best structure depends on:

- Standard-cell library
- Input arrival times
- Fanout
- Physical placement
- Logic mapping

### 10.6 Placement Improvement

Placement improvement attempts to move related cells closer together.

Potential benefits:

- Shorter wires
- Lower resistance
- Lower capacitance
- Better slew
- Lower net delay

Placement changes must also consider:

- Congestion
- Density
- Macro blockages
- Routing access
- Effects on other timing paths

### 10.7 Routing Improvement

Routing optimization may include:

- Reducing detours
- Reducing unnecessary vias
- Using lower-resistance metal
- Increasing wire width
- Improving spacing
- Moving critical nets away from congested regions

Upper metal layers may provide lower resistance, but those layers are limited resources shared by:

- Clock networks
- Power delivery
- Global signals
- Other critical nets

### 10.8 Pipelining

Pipelining adds a sequential boundary to split one long combinational path into multiple stages.

Before:

> Register A  
> → Long Combinational Logic  
> → Register B

After:

> Register A  
> → Logic Part 1  
> → New Register  
> → Logic Part 2  
> → Register B

Pipelining can:

- Reduce logic delay per stage
- Increase maximum frequency
- Improve throughput

However, it may also:

- Increase latency
- Increase register area
- Increase clock load
- Increase clock power
- Increase control complexity
- Require RTL changes
- Require additional verification

Pipelining is an architectural change, not a normal implementation ECO.

### 10.9 Useful Skew

Useful skew intentionally changes clock arrival relationships.

Delaying the capture clock may improve setup:

> Capture clock arrives later  
> → More setup propagation time  
> → Better setup slack

However:

> Positive skew may worsen hold.

Useful-skew optimization must be checked globally because one register may be the endpoint of some paths and the startpoint of others.

## 11. Hold Repair Methods

A hold violation means:

> New data arrives too early.

The primary goal is:

> Increase minimum data-path delay.

### 11.1 Delay Buffer Insertion

A delay buffer or hold cell may be inserted to slow the minimum path.

Before:

> Launch Register → Short Net → Capture Register

After:

> Launch Register → Delay Buffer → Capture Register

The buffer increases:

- Cell propagation delay
- Net delay
- Minimum arrival time

This improves hold slack.

### 11.2 Localized Hold Repair

Assume one launch register drives three capture registers:

> Launch Register  
> → Shared Trunk  
> → Branch Point  
> → Capture A  
> → Capture B  
> → Capture C

The actual timing paths are:

> Launch → Shared Trunk → Branch A → Capture A  
> Launch → Shared Trunk → Branch B → Capture B  
> Launch → Shared Trunk → Branch C → Capture C

If only Capture A has a hold violation, placing a buffer before the branch point delays all three paths.

> Launch → Buffer → Branch Point  
> → Capture A  
> → Capture B  
> → Capture C

This may repair Capture A but unnecessarily reduce setup margin for B and C.

The preferred repair is usually:

> Branch Point → Delay Buffer → Capture A

This localizes the repair to the violating branch.

The hold buffer is often placed near the endpoint because that location is more likely to belong only to the target branch.

The exact placement also depends on:

- Available placement sites
- Congestion
- Routing resources
- Setup margin
- Slew and capacitance limits

### 11.3 Dedicated Hold Cells

A library may include dedicated hold cells or delay cells characterized to provide controlled delay.

They still consume:

- Area
- Dynamic power
- Leakage power
- Routing resources

### 11.4 Cell Downsizing

Cell downsizing replaces a strong cell with a weaker version.

Example:

> `BUF_X4` → `BUF_X1`

Possible effects:

- Higher effective output resistance
- Slower transition
- Larger propagation delay
- Improved hold slack

Risks:

- Reduced setup slack
- Poor output slew
- Transition violations
- Inadequate drive capability

Cell downsizing changes data arrival time. It does not change launch clock arrival.

### 11.5 Higher-Vt Replacement

Replacing a low-Vt cell with a standard-Vt or high-Vt cell may:

- Increase minimum delay
- Improve hold
- Reduce leakage
- Worsen setup

This method is useful only when sufficient setup margin exists.

### 11.6 Routing Detour

A routing detour intentionally increases wire length.

Potential benefits:

- Larger resistance
- Larger capacitance
- Larger net delay
- Improved hold

Potential costs:

- Worse setup
- Higher dynamic power
- More routing congestion
- More coupling
- More routing resources
- Greater extraction sensitivity

### 11.7 Clock-Skew Adjustment

Hold may be improved by making skew more negative, such as by:

- Making capture clock arrive earlier
- Making launch clock arrive later

Clock-skew adjustment can affect many paths and must be verified with full STA.

## 12. Setup and Hold Repair Interaction

Many hold repairs increase both minimum and maximum delay.

Example:

| Metric | Before Repair |
|---|---:|
| Setup slack | +0.05 ns |
| Hold slack | −0.04 ns |

Assume a buffer increases both minimum and maximum delay by approximately 0.06 ns.

New hold slack:

> −0.04 ns + 0.06 ns = +0.02 ns

New setup slack:

> +0.05 ns − 0.06 ns = −0.01 ns

The hold violation is repaired, but a new setup violation is created.

Therefore:

> Every hold repair must be followed by setup analysis.

The same principle applies in the opposite direction. A setup repair may worsen hold.

## 13. PPA Tradeoffs

### 13.1 Performance

Performance may refer to:

- Maximum clock frequency
- Clock period
- Critical-path delay
- Throughput
- Latency
- Setup margin

### 13.2 Dynamic Power

A simplified dynamic-power relationship is:

> Dynamic Power ∝ Activity × Capacitance × Voltage² × Frequency

Dynamic power may increase because of:

- Larger cells
- More buffers
- More registers
- Longer wires
- Higher frequency
- Larger switched capacitance

### 13.3 Leakage Power

Leakage depends on:

- Threshold voltage
- Cell size
- Process
- Voltage
- Temperature

Low-Vt cells generally increase leakage.

High-Vt cells generally reduce leakage but operate more slowly.

### 13.4 Area

Area growth may result from:

- Cell upsizing
- Buffer insertion
- Hold cells
- Pipeline registers
- Logic duplication
- Spare cells

Higher area and utilization can reduce whitespace and increase congestion.

### 13.5 Congestion

Congestion may create a negative optimization loop:

> Timing violation  
> → Insert buffers and upsize cells  
> → Increase utilization and routing demand  
> → Increase congestion  
> → Force longer routes  
> → Increase net delay  
> → Create new timing violations

Timing optimization must therefore be physically aware.

## 14. Repair Method Tradeoff Summary

| Repair Method | Primary Timing Purpose | Power Impact | Area and Physical Impact |
|---|---|---|---|
| Cell upsizing | Improve setup and slew | Dynamic and leakage usually increase | Area, load, and congestion increase |
| Low-Vt replacement | Reduce cell delay | Leakage increases | Area usually changes little |
| Setup buffer insertion | Reduce long-net or fanout delay | Dynamic and leakage increase | Area and routing demand increase |
| Hold buffer insertion | Increase minimum delay | Dynamic and leakage increase | Area increases and setup margin decreases |
| Cell downsizing | Increase hold delay | Power may decrease | Area decreases, but slew may worsen |
| Higher-Vt replacement | Improve hold | Leakage decreases | Setup may worsen |
| Placement improvement | Reduce net delay | May reduce switched capacitance | May improve or relocate congestion |
| Routing optimization | Reduce net delay | May reduce wire power | Uses limited routing resources |
| Routing detour | Increase hold delay | Dynamic power may increase | Routing resources and congestion increase |
| Logic restructuring | Reduce logic depth | Depends on implementation | Area and fanout may increase or decrease |
| Pipelining | Increase frequency and throughput | Clock and register power increase | Area, latency, and complexity increase |

## 15. Throughput Versus Latency in Pipelining

Pipelining allows multiple transactions to occupy different stages simultaneously.

Before pipelining:

> One operation passes through the entire combinational path before the next operation can use the same path.

After pipelining:

> Operation 1 enters Stage 2 while Operation 2 enters Stage 1.

This may improve throughput because results can be produced more frequently after the pipeline is filled.

However, one operation must pass through more register stages, so latency may increase.

> Throughput = How frequently results can be produced  
> Latency = How long one transaction takes from input to output

## 16. Clock Power and Pipelining

Pipeline registers add clock pins to the clock network.

> More registers  
> → Larger clock capacitance  
> → More clock-tree buffers  
> → More clock switching activity  
> → Higher clock dynamic power

Clock power is important because the clock network:

- Has high activity
- Drives large fanout
- Spans much of the chip
- Contains many buffers
- Switches every active cycle

## 17. Engineering Change Order

ECO stands for Engineering Change Order.

An ECO is a controlled, incremental change made to an existing design, usually late in the implementation flow.

The objective is to repair a local issue without rerunning or destabilizing the entire design.

Common ECO examples include:

- Cell upsizing
- Cell downsizing
- Vt swapping
- Buffer insertion
- Hold-cell insertion
- Local routing changes
- Local placement changes
- Small logic modifications
- DRC repairs
- Antenna repairs

### 17.1 Timing ECO

A timing ECO may repair:

- Setup violations
- Hold violations
- Slew violations
- Capacitance violations
- Fanout violations

### 17.2 Functional ECO

A functional ECO modifies logical behavior.

Examples include:

- Correcting control logic
- Modifying an enable condition
- Changing a state transition
- Adding a logic gate

Functional ECOs require appropriate functional and equivalence verification.

### 17.3 Physical ECO

A physical ECO may repair:

- DRC
- Antenna
- Placement legality
- Routing congestion
- Via reliability
- Signal integrity

### 17.4 Metal-Only ECO

A metal-only ECO changes only selected metal and via layers.

This approach may use preplaced spare cells.

> Spare cell already exists physically  
> → Metal routing is changed  
> → Spare cell is connected into the required logic path

Metal-only ECOs may reduce cost and schedule impact because transistor-level base layers do not need to change.

## 18. Case Study

Assume a setup report contains:

| Item | Value |
|---|---:|
| Check type | Setup |
| Slack | −0.18 ns |
| Total cell delay | 0.55 ns |
| Total net delay | 1.70 ns |
| Launch clock arrival | 0.25 ns |
| Capture clock arrival | 0.20 ns |
| Physical observation | Long route through congestion |
| Local utilization | 88% |

### 18.1 Violation Type

This is a setup violation.

> Maximum data arrival is too late.

### 18.2 Delay Dominance

Net delay is much larger than cell delay.

> Net delay = 1.70 ns  
> Cell delay = 0.55 ns

The path is net-delay dominated.

### 18.3 Clock Skew

> Clock Skew = 0.20 ns − 0.25 ns = −0.05 ns

The negative skew hurts setup because it reduces effective propagation time.

### 18.4 Appropriate Repair Direction

The first repair direction should be physical optimization:

- Improve placement
- Reduce routing detour
- Relieve local congestion
- Use a lower-resistance routing layer where appropriate
- Reduce unnecessary vias
- Consider one localized buffer only if a long RC segment requires it

### 18.5 Why Massive Upsizing Is Inappropriate

Massive cell upsizing does not match the main root cause.

It may:

- Increase cell area
- Increase input capacitance
- Increase utilization
- Reduce whitespace
- Worsen congestion
- Force longer routing
- Increase net delay

In this case, aggressive upsizing may make timing worse.

### 18.6 Required Verification

After the repair:

> Update placement and routing  
> → Re-extract parasitics  
> → Update SPEF  
> → Rerun setup STA  
> → Rerun hold STA  
> → Check all required modes and corners  
> → Review slew and capacitance  
> → Review power, area, utilization, and congestion  
> → Run required physical verification

## 19. Common Misunderstandings

### 19.1 Positive Setup WNS Means Timing Closure

Incorrect.

Hold, constraints, corners, modes, and coverage must also be checked.

### 19.2 Increasing Clock Period Makes Hold Worse

Usually incorrect.

Increasing period moves the next setup capture edge but normally does not change the current-cycle hold relationship.

Increasing capture clock latency may worsen hold.

### 19.3 Positive Skew Makes Data Arrive Faster

Incorrect.

Positive skew delays the capture clock boundary. It does not accelerate the data path.

### 19.4 Cell Downsizing Makes the Launch Clock Arrive Later

Incorrect.

Downsizing increases data-path delay. It does not change launch clock arrival.

### 19.5 Buffer Insertion Always Adds Delay

Incorrect.

A buffer adds cell delay, but it may reduce total path delay by dividing a long RC network and restoring slew.

### 19.6 A False Path Is Acceptable After Detailed Review

Incomplete.

A false path is valid only when architectural behavior proves that a normal timing relationship is not required.

### 19.7 Changing the Clock Requirement Is a Timing Repair

Incorrect when the original requirement is valid.

Relaxing a correct specification hides the violation rather than repairing it.

### 19.8 High-Vt Cells Increase Leakage

Incorrect.

High-Vt cells are usually slower but have lower leakage than low-Vt cells.

### 19.9 A Timing Repair Only Affects One Path

Usually incorrect.

One cell, net, or clock node may participate in many timing paths.

## 20. Timing Closure Decision Checklist

### Step 1: Validate the Analysis

- Is the path properly constrained?
- Are the clocks correct?
- Is the correct mode active?
- Is the correct corner active?
- Are parasitics annotated?
- Is the path a real functional timing path?

### Step 2: Identify the Violation Type

- Setup
- Hold
- Slew
- Capacitance
- Fanout
- Clock-related

### Step 3: Classify the Root Cause

- Cell-delay dominated
- Net-delay dominated
- Poor slew
- Heavy load
- Large fanout
- Deep logic
- Poor placement
- Congestion
- Unfavorable skew
- Excessive uncertainty
- Incorrect constraints

### Step 4: Select a Targeted Repair

- Cell sizing
- Vt replacement
- Buffer insertion
- Logic restructuring
- Placement improvement
- Routing improvement
- Hold cell
- Cell downsizing
- Routing detour
- Useful skew
- Pipelining
- Constraint correction when justified

### Step 5: Predict Side Effects

- Setup impact
- Hold impact
- Slew
- Capacitance
- Power
- Area
- Utilization
- Congestion
- Routing resources
- Clock power
- DRC

### Step 6: Reimplement and Reanalyze

- Update netlist or physical implementation
- Legalize placement
- Incrementally route
- Re-extract parasitics
- Update SPEF
- Rerun setup and hold STA
- Review all required MCMM scenarios
- Review PPA and physical checks

## 21. Final Engineering Principle

Timing closure is not the act of forcing one slack value to become positive.

It is a controlled optimization process that connects STA, constraints, standard-cell behavior, clocking, placement, routing, parasitic extraction, ECO implementation, and PPA analysis.

The complete closure flow is:

> Validate constraints and timing coverage  
> → Identify the real violation  
> → Classify the root cause  
> → Apply the smallest appropriate repair  
> → Update physical implementation  
> → Re-extract parasitics  
> → Rerun setup and hold analysis across all required scenarios  
> → Verify PPA and physical side effects  
> → Iterate until every requirement is satisfied
