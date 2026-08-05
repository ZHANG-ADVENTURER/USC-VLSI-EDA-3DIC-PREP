# Day 39 Daily Log

## Topic

Inspecting Floorplan, Global Placement, Detailed Placement, and Physical-Design Instance Growth

## What I Learned

Today I examined how the synthesized Nangate45 GCD design entered physical implementation.

The first stage was floorplanning. The floorplan GUI showed the die boundary, core boundary, placement rows, placement sites, power-distribution straps, local power rails, and I/O pin markers. At this stage, the physical framework existed, but the ordinary logic cells had not yet been assigned their final legal locations.

I enabled the Rows display and observed the legal placement grid. A placement row is divided into repeated sites, and standard cells must align to those sites. Cells cannot be placed at arbitrary coordinates. They must remain inside the core, avoid overlap, use legal orientations, and respect blockages.

I then opened the placement database. The placement view contained many blue shapes inside the cell rectangles. These shapes were not all inter-cell signal routes. Most were standard-cell library geometry, such as internal Metal1 shapes, pins, local power connections, and obstructions. This clarified the difference between placement and routing:

> Placement assigns physical coordinates to cells.  
> Routing later creates exact inter-cell metal paths and vias.

Global placement produced approximate optimized locations for the cells. Its objectives included estimated wirelength, timing, density, and congestion risk. Detailed placement then legalized those positions by aligning cells to rows and sites, removing overlap, and applying local refinement.

The global-placement timing report showed a worst setup slack of +0.02 ns, while the detailed-placement report showed +0.01 ns. The small reduction was reasonable because legalization moved cells from idealized positions to discrete legal sites. Setup TNS remained 0.00 ns, and the displayed hold slack remained +0.11 ns.

The reports still used an ideal clock network because CTS had not yet been performed. The interconnect delay was also placement-estimated rather than based on final routed SPEF parasitics.

The detailed-placement database reported:

- Design area: 672 µm²
- Utilization: 62%
- Setup violations: 0
- Hold violations: 0
- Max slew violations: 0
- Max fanout violations: 0
- Max capacitance violations: 0

The placement-density heat map showed that cell distribution was not perfectly uniform. The central region had relatively higher density, while the right side and several local regions retained more whitespace. This did not directly prove routing congestion. Placement density measures local cell occupancy, while routing congestion compares routing demand with available routing capacity.

I also compared instance counts across stages:

- Synthesis: 513 instances
- Floorplan: 559 instances
- Detailed placement: 606 instances

The floorplan-stage increase was exactly 46 instances. The placement master-cell list showed exactly 46 `TAPCELL_X1` instances, confirming that floorplanning added 46 physical-only tap cells.

The placement-stage increase was 47 instances. The synthesis report contained 15 buffer-type instances, while the placement database contained 62 buffer instances. The net buffer increase was therefore 47, exactly matching the floorplan-to-placement instance-count increase.

This established the physical transformation:

> 513 synthesized logic instances  
> → add 46 tap cells  
> → 559 floorplan instances  
> → increase buffer population from 15 to 62  
> → 606 placed instances

The non-buffer logical and sequential cell counts remained unchanged.

## What I Built

I did not create or modify RTL.

I completed a floorplan-and-placement analysis workflow that included:

- Opening the floorplan database
- Identifying die and core boundaries
- Displaying placement rows and sites
- Distinguishing PDN geometry from signal routing
- Opening the placement database
- Inspecting placed standard cells
- Comparing global and detailed placement timing
- Checking placement-area and utilization results
- Viewing the placement-density heat map
- Querying floorplan and placement instance counts
- Counting placement database instances by master-cell type
- Creating `floorplan-placement-notes.md`

The completed Notes file is intended for:

> `04_openroad_practice/03_reports/floorplan-placement-notes.md`

The selected screenshots are stored in:

> `04_openroad_practice/04_screenshots/day39_floorplan_placement/`

## Key Concepts

### Floorplan

A floorplan defines the die, core, placement region, rows, sites, and power-distribution framework.

### Placement Row

A placement row is a legal horizontal region containing repeated placement sites for standard cells.

### Placement Site

A placement site is the smallest legal horizontal grid unit used to align standard cells.

### Global Placement

Global placement finds approximate cell locations while optimizing wirelength, timing, density, and congestion risk.

### Detailed Placement

Detailed placement legalizes cell positions and aligns them to valid rows and sites.

### Tap Cell

A tap cell is a physical-only cell used for well and substrate connection and latch-up prevention.

### Placement Density

Placement density describes local cell-area occupancy inside a placement bin.

### Routing Congestion

Routing congestion occurs when routing demand exceeds available routing-track capacity.

## Problems / Fixes

### Problem 1: Standard-Cell Geometry Was Mistaken for Signal Routing

The placement GUI showed many blue shapes inside each standard cell, which initially looked like completed inter-cell routing.

Fix:

The view was interpreted by stage and connectivity. The blue patterns were primarily library-defined internal metal, pins, obstructions, and local rails. Exact inter-cell signal routing had not yet been performed.

### Problem 2: The Initial Database Query Command Failed

The command using `get_db insts` returned an invalid-command error.

Fix:

The OpenROAD database block was accessed with:

> `set block [ord::get_db_block]`

The instance count was then obtained with:

> `llength [$block getInsts]`

### Problem 3: Instance Growth Could Not Be Explained by Area Alone

The area increased across synthesis, floorplan, and placement, but area values alone did not identify which cells were added.

Fix:

The database instances were grouped by master-cell type. This confirmed that floorplanning added 46 tap cells and that placement increased the buffer population from 15 to 62.

## Connection to VLSI / EDA / 3D IC

This exercise showed how physical design changes the synthesized netlist without changing the intended logic function.

Floorplanning added manufacturing-required physical-only cells. Placement added and reorganized buffers to improve electrical behavior, timing, and physical feasibility. These changes affected area, utilization, and instance count before CTS and routing.

The same concepts apply to larger chips and chiplets. Each die still requires a legal floorplan, power-distribution structure, placement grid, buffer strategy, and congestion-aware cell distribution before package-level integration can be considered.

## One Sentence Summary

I traced how the 513-instance synthesized GCD netlist became a 606-instance legal placement through tap-cell insertion, buffer expansion, and physical placement optimization.

## Next Step

The next task is Day 40: inspect clock tree synthesis and routing, identify actual clock buffers and routed signal geometry, and compare pre-CTS, post-CTS, and post-route timing behavior.
