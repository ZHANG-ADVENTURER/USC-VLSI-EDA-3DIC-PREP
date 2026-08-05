# Floorplan and Placement Notes

## 1. Objective

The objective of Day 39 was to inspect how the synthesized Nangate45 GCD design entered physical implementation.

The analysis focused on:

> Synthesized standard cells  
> → Floorplan  
> → Power-distribution network  
> → Global placement  
> → Detailed placement

The main questions were:

1. What physical structures existed before cell placement?
2. How were rows and placement sites used?
3. What changed between global placement and detailed placement?
4. How did instance count, area, utilization, and timing change across stages?
5. Which new cells were inserted by the physical-design flow?

## 2. Floorplan Stage

The floorplan GUI showed the physical framework prepared for placement.

Visible structures included:

- Die boundary
- Core boundary
- Placement rows and sites
- Power-distribution-network straps
- Local power rails
- I/O pin markers
- Routing-layer geometry

At this stage, the design database already contained synthesized logic and physical-only support cells, but the ordinary logic cells had not yet been assigned their final legal placement coordinates.

The floorplan defines:

- The physical size of the design
- The core region available for standard cells
- The legal rows and sites
- The power-distribution structure
- The boundary conditions for later placement and routing

The floorplan does not yet complete:

- Timing-driven cell placement
- Placement legalization
- Clock tree synthesis
- Signal routing
- Post-route parasitic extraction

## 3. Die and Core Boundaries

The die boundary defines the outer physical limit of the layout.

The core boundary defines the primary region in which standard cells are placed and routed.

These boundaries are not identical. The space between them can support:

- I/O access
- Routing margin
- Boundary-related physical structures
- Power connection
- Design-rule spacing

The observed core boundary remained effectively fixed from floorplan through later implementation. Area growth therefore increased utilization rather than expanding the core.

## 4. Placement Rows and Sites

When the Rows display was enabled, the GUI showed a dense legal placement grid.

A standard-cell row contains repeated placement sites. Standard cells must:

- Be placed on legal rows
- Align to the site grid
- Remain within the core boundary
- Avoid overlap
- Use a legal orientation
- Respect placement blockages

A row describes where cells may be placed. It does not mean that cells have already been placed there.

The relationship is:

> Floorplan creates legal placement locations.  
> Placement assigns each instance to one of those locations.

## 5. Power-Distribution Structure

The floorplan view contained wide horizontal and vertical power straps together with thinner local rails.

The observed hierarchy was:

> Upper-metal PDN straps  
> → Local power grid  
> → Standard-cell power rails  
> → Standard-cell VDD/VSS pins

The wide straps were different from ordinary signal routing. They were created to distribute supply current across the core and reduce power-network resistance.

Specific metal-layer identification was not established from object inspection, so the analysis relied on geometry and the GUI layer display rather than assigning every colored shape to a guaranteed layer name.

## 6. Placement View Versus Routing View

The placement GUI showed many detailed blue shapes inside the standard-cell rectangles.

These shapes were not all routed inter-cell signal wires.

They primarily represented:

- Standard-cell internal library geometry
- Standard-cell pins
- Local metal shapes
- Obstructions
- Row power rails

Each standard cell is a predesigned physical layout. When OpenROAD places the cell, the GUI displays the geometry already defined in the library.

At placement stage:

> Cell coordinates have been assigned.  
> Exact inter-cell signal routes have not yet been completed.

Signal routing later determines:

- Routing layer
- Track
- Wire segment
- Via location
- Detour around obstacles
- Final routed parasitics

## 7. Global Placement

Global placement assigns approximate physical locations to the cells.

Its objectives include:

- Reducing estimated wirelength
- Improving timing
- Controlling density
- Reducing congestion risk
- Keeping related cells physically close

Global-placement coordinates may not yet satisfy every discrete site and row requirement.

The global-placement timing report showed:

| Metric | Result |
|---|---:|
| Setup TNS | 0.00 ns |
| WNS summary | 0.00 ns |
| Worst setup slack | +0.02 ns |
| Minimum reported period | 0.43 ns |
| Estimated Fmax | 2316.10 MHz |
| Displayed hold slack | +0.11 ns |

The clock network was still reported as ideal because CTS had not yet been performed.

## 8. Detailed Placement

Detailed placement converts approximate positions into legal standard-cell locations.

Its responsibilities include:

- Row alignment
- Site alignment
- Overlap removal
- Legal orientation
- Boundary compliance
- Local placement refinement

The command:

> `check_placement -verbose`

did not print any placement-legality problem in the loaded detailed-placement database.

The detailed-placement timing report showed:

| Metric | Result |
|---|---:|
| Setup TNS | 0.00 ns |
| WNS summary | 0.00 ns |
| Worst setup slack | +0.01 ns |
| Minimum reported period | 0.44 ns |
| Estimated Fmax | 2293.71 MHz |
| Displayed hold slack | +0.11 ns |
| Max slew violations | 0 |
| Max fanout violations | 0 |
| Max capacitance violations | 0 |
| Setup violations | 0 |
| Hold violations | 0 |

Detailed placement slightly reduced setup margin:

> Global placement worst slack: +0.02 ns  
> Detailed placement worst slack: +0.01 ns

This small degradation was consistent with legalization. Cells were moved from approximate optimized positions to legal rows and sites, which slightly changed estimated wirelength and capacitance.

## 9. Pre-CTS Timing Limitation

Both global-placement and detailed-placement reports showed:

> `clock network delay (ideal)`

This means the placement-stage timing analysis did not yet include the final physical clock tree.

Before CTS, the flow did not yet have:

- Final clock-buffer topology
- Real clock latency
- Real clock skew
- Routed clock parasitics

Placement timing therefore used an ideal or modeled clock network.

The interconnect delay was also placement-estimated rather than based on final routed SPEF parasitics.

## 10. Placement Density Heat Map

The placement-density heat map showed a nonuniform distribution.

The central region contained relatively high-density bins, while the right side and several local areas retained more whitespace.

The heat map was interpreted only qualitatively because the screenshot did not include a numerical legend.

The correct distinction is:

### Placement Density

Placement density describes how much cell area occupies a local bin.

### Routing Congestion

Routing congestion compares routing demand with available routing capacity.

High placement density can increase congestion risk, but the two quantities are not identical.

A region with lower cell density can still experience congestion if many nets pass through it.

## 11. Area and Utilization Across Stages

The observed area results were:

| Stage | Design area | Utilization |
|---|---:|---:|
| Synthesis | 626.696 µm² | Not reported as final physical utilization |
| Floorplan | 639 µm² | 59% |
| Detailed placement | 672 µm² | 62% |
| Final implementation | 683 µm² | 63% |

### Synthesis to Floorplan

> Area increase = 639 − 626.696  
> Area increase = 12.304 µm²  
> Relative increase ≈ 1.96%

### Floorplan to Placement

> Area increase = 672 − 639  
> Area increase = 33 µm²  
> Relative increase ≈ 5.16%

### Placement to Final

> Area increase = 683 − 672  
> Area increase = 11 µm²  
> Relative increase ≈ 1.64%

### Synthesis to Final

> Total area increase = 683 − 626.696  
> Total area increase = 56.304 µm²  
> Relative increase ≈ 8.98%

Because the core boundary remained effectively fixed, the increase in cell area caused utilization to rise from 59% at floorplan to 62% after detailed placement and 63% in the final design.

## 12. Instance Count Across Stages

The observed database instance counts were:

| Stage | Instance count |
|---|---:|
| Synthesis | 513 |
| Floorplan | 559 |
| Detailed placement | 606 |

The OpenROAD database was queried with:

> `set block [ord::get_db_block]`

and:

> `llength [$block getInsts]`

The original `get_db insts` command failed because that command was not supported by the loaded OpenROAD Tcl environment.

## 13. Floorplan Instance Growth

The count increased from:

> 513 synthesis instances  
> → 559 floorplan instances

The difference was:

> 46 instances

The placement database contained exactly:

> `TAPCELL_X1 46`

Together with the known flow order, this showed that the floorplan-stage growth was accounted for by 46 tap cells.

Tap cells are physical-only cells. They do not perform GCD logic.

Their purposes include:

- Well and substrate connection
- Body-potential control
- Latch-up prevention
- Compliance with process tap-spacing rules

The relationship was:

> 513 synthesized logic instances  
> + 46 tap cells  
> = 559 floorplan instances

## 14. Placement Instance Growth

The count increased from:

> 559 floorplan instances  
> → 606 placement instances

The difference was:

> 47 instances

The synthesis report contained 15 buffer-type instances:

| Buffer type | Count |
|---|---:|
| `BUF_X1` | 5 |
| `BUF_X2` | 3 |
| `BUF_X4` | 3 |
| `BUF_X8` | 1 |
| `CLKBUF_X1` | 2 |
| `CLKBUF_X2` | 1 |
| Total | 15 |

The placement database contained:

| Buffer type | Count |
|---|---:|
| `BUF_X1` | 60 |
| `BUF_X4` | 2 |
| Total | 62 |

The net buffer increase was:

> 62 − 15 = 47

This exactly matched the floorplan-to-placement instance-count increase.

Therefore, the placement-stage instance growth was accounted for by the net increase in buffer population.

The flow may have:

- Inserted new buffers
- Removed or replaced earlier buffers
- Changed drive strengths
- Reorganized buffer trees

The correct conclusion is not that the original 15 buffers were all preserved unchanged. The correct conclusion is:

> Final buffer population increased from 15 to 62.

## 15. Why Placement Inserted Buffers

The additional buffers can support:

- High-fanout repair
- Load splitting
- Slew improvement
- Capacitance reduction at a driver
- Long-distance signal driving
- Estimated setup-timing repair
- Electrical-rule compliance

A high-fanout net can be transformed from:

> One driver  
> → Many sinks

into:

> Original driver  
> → Buffer branches  
> → Smaller sink groups

This reduces the effective load seen by each driving stage.

These were pre-CTS buffers. They should not be confused with the clock-tree buffers inserted during CTS.

## 16. Cell Count Versus Area

Instance count and area did not increase by the same percentage.

Reasons include:

- Tap cells are small physical-only cells.
- Buffers have different sizes.
- X1, X2, X4, and X8 variants have different areas.
- Resizing can increase area without increasing instance count.
- Buffer insertion increases both area and instance count.

Therefore:

> Instance-count growth does not directly equal area growth.

## 17. Main Conclusions

The Day 39 analysis established the following physical transformation:

> 513 synthesized logic instances  
> → floorplan, rows, sites, and PDN  
> → 46 tap cells inserted  
> → 559 floorplan instances  
> → global placement  
> → buffer population increased from 15 to 62  
> → detailed placement and legalization  
> → 606 placed instances

The main observed results were:

- Floorplan created the die, core, placement grid, and PDN.
- Placement assigned physical coordinates to the standard cells.
- Detailed placement produced a legal-looking placement with no printed legality problem.
- Setup timing remained positive after legalization.
- Placement area reached 672 µm².
- Placement utilization reached 62%.
- The buffer network was substantially expanded during placement optimization.
- The design was still pre-CTS and pre-routing.

## 18. Repository Evidence

Recommended screenshot directory:

> `04_openroad_practice/04_screenshots/day39_floorplan_placement/`

Recommended files:

- `floorplan-pdn.png`
- `floorplan-rows-sites.png`
- `placement-cells-only.png`
- `placement-density-heatmap.png`
