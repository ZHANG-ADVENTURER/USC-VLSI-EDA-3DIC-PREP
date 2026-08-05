# Day 38 Daily Log

## Topic

Inspecting Yosys Synthesis Output and Mapping RTL to Standard Cells

## What I Learned

Today I opened the synthesis stage of the official Nangate45 GCD example and compared the original RTL with the Yosys-generated gate-level netlist.

The original RTL file was:

> `designs/src/gcd/gcd.v`

The synthesized netlist was:

> `/work/results/nangate45/gcd/base/1_2_yosys.v`

The original RTL contained ten modules, including the top-level GCD module, controller, datapath, registers, comparators, muxes, and subtractor. The synthesized netlist contained only one top-level module, `gcd`. This confirmed that Yosys flattened the original hierarchy before or during optimization and technology mapping.

The original design used a control-and-datapath architecture. The controller generated mux-select, register-enable, request-ready, and response-valid signals. The datapath contained the A and B registers, less-than comparator, zero comparator, subtractor, and muxes. After synthesis, these architectural blocks were no longer preserved as separate modules. Their functions were absorbed into one flattened network of standard cells and internal nets.

The synthesis report showed:

- 538 wires
- 584 wire bits
- 8 top-level ports
- 54 top-level port bits
- 513 mapped standard cells
- 626.696 µm² synthesis cell area
- 158.270 µm² sequential-cell area
- 25.25% sequential-area share
- 0 memories
- 0 processes

The 54 port bits matched the original interface exactly, so synthesis preserved the top-level I/O structure.

The 513 mapped cells included 35 DFFs and 478 non-register cells. The 35 DFFs mapped directly to three controller state registers, sixteen A-register bits, and sixteen B-register bits.

The largest logic category was NAND cells. There were 244 NAND cells in total, including 161 `NAND2_X1` instances. The original RTL contained named functions such as mux, subtractor, less-than comparator, and zero comparator, but the synthesized cell list did not preserve those functional module names. Yosys converted those functions into networks of NAND, NOR, inverter, AOI, OAI, XOR, XNOR, AND, OR, and buffer cells.

I also learned how to read a gate-level instance. A mapped cell specifies the library cell type, instance name, and the net connected to each cell pin.

One state flip-flop used:

> `DFF_X1`

with:

> `CK` connected to `clk`  
> `D` connected to `_016_`  
> `Q` connected directly to `req_rdy`  
> `QN` connected to `_493_`

This showed that synthesis optimized one controller state bit so that its Q output directly became the top-level `req_rdy` signal.

A NAND example used:

> `NAND2_X1`

with two input nets and one inverted output net. Unlike RTL, the netlist expressed only cell connectivity and Boolean structure rather than algorithmic intent.

The original controller used three logical states but declared a two-bit state variable. The synthesized netlist contained three state-related DFFs. This provided strong structural evidence that Yosys transformed the original state encoding into a three-bit one-hot-like implementation.

The observed mapping was:

- `state.out[0]` strongly matched IDLE because its Q output directly drove `req_rdy`.
- `state.out[1]` strongly matched DONE because it participated in generating `resp_val` and response-handshake state logic.
- `state.out[2]` strongly matched CALC because it was the remaining state bit and was buffered to drive multiple control loads.

This mapping was not formally proven by an FSM recoding report, so it should be described as strongly supported rather than guaranteed.

I also traced part of the `resp_val` logic. The netlist showed that `resp_val` was generated from `state.out[1]` and another internal control net. A NAND gate also implemented the response-handshake condition involving `resp_val` and `resp_rdy`, which then contributed to the next-state logic.

The synthesis structural check reported:

> `Found and reported 0 problems.`

This confirmed that Yosys found no obvious structural issue within the scope of its `CHECK` pass. It did not prove functional correctness or replace simulation, formal equivalence, STA, CDC, DRC, or LVS.

## What I Built

I did not create new RTL or modify the official design.

I completed a synthesis-analysis workflow that included:

- Comparing original and synthesized module hierarchy
- Inspecting the original top-level controller/datapath structure
- Reading `synth_stat.txt`
- Classifying standard-cell types
- Mapping DFF instances back to controller and datapath registers
- Inspecting real DFF and NAND pin connections
- Tracing selected FSM and handshake nets
- Checking `synth_check.txt`
- Creating `synthesis-output-notes.md`

The completed Notes file is intended for:

> `04_openroad_practice/03_reports/synthesis-output-notes.md`

The selected screenshots are stored in:

> `04_openroad_practice/04_screenshots/day38_synthesis/`

## Key Concepts

### Hierarchy Flattening

Hierarchy flattening removes original module boundaries and combines the design into one optimization scope.

### Technology Mapping

Technology mapping converts Boolean logic into standard cells available in the target library.

### Gate-Level Netlist

A gate-level netlist describes cell instances and pin-to-net connectivity rather than RTL behavior.

### Standard Cell

A standard cell is a pre-characterized logic or sequential cell from the technology library, such as a DFF, NAND, NOR, inverter, AOI, or buffer.

### Drive Strength

Suffixes such as X1, X2, X4, and X8 indicate drive strength, not bit width.

### Escaped Identifier

A Verilog escaped identifier begins with a backslash and allows special characters to appear in an instance or net name.

### Logic Cone

A logic cone is the network of cells and nets that contributes to a selected signal, endpoint, or register input.

## Problems / Fixes

### Problem 1: The Original FSM Encoding Was Misread

The first DFF-count interpretation suggested that the RTL directly used a three-bit state register.

Fix:

The controller source was inspected. It showed a two-bit RTL state variable with three logical states. The three synthesized DFFs therefore indicated an apparent synthesis recoding rather than a direct one-to-one state-register mapping.

### Problem 2: `resp_val` Was Initially Assumed to Be a Direct State Output

It was initially suspected that the DONE state bit might directly drive `resp_val`.

Fix:

The netlist was searched and the driver was inspected. `resp_val` was generated by combinational logic using `state.out[1]` and another internal control signal.

### Problem 3: Automatic Net Names Lost Architectural Meaning

Internal nets such as `_285_` and `_352_` did not reveal their RTL function directly.

Fix:

The driver and fanout of selected nets were traced through buffers and logic gates until the relationship to state and handshake logic became clear enough.

## Connection to VLSI / EDA / 3D IC

This synthesis analysis connects RTL design with downstream physical implementation. Placement, STA, CTS, and routing do not operate on high-level controller and datapath descriptions. They operate on mapped cells, nets, clocks, loads, and constraints.

Understanding the synthesized netlist is therefore essential for:

- Reading timing paths
- Interpreting cell delay and net delay
- Understanding area growth
- Identifying high-fanout control signals
- Explaining why buffers and larger drive-strength cells appear
- Relating RTL structure to physical-design consequences

The same principle applies to chiplets and 3D IC systems. Each die still requires synthesizable logic, technology mapping, timing constraints, physical implementation, and signoff before die-to-die integration.

## One Sentence Summary

I traced how the hierarchical GCD RTL was flattened, optimized, and mapped into 513 Nangate45 standard cells, then connected selected gate-level structures back to the original controller and datapath behavior.

## Next Step

The next task is Day 39: inspect floorplanning and placement outputs, compare pre-placement and post-placement databases, and identify how standard cells were physically organized inside the core.
