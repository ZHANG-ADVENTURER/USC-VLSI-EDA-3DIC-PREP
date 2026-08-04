# Synthesis Output Notes

## 1. Objective

The objective of Day 38 was to inspect the synthesis output of the official Nangate45 GCD example and understand how hierarchical RTL was transformed into a flattened gate-level netlist mapped to standard cells.

The analysis compared:

> Original RTL: `designs/src/gcd/gcd.v`

with:

> Synthesized netlist: `/work/results/nangate45/gcd/base/1_2_yosys.v`

The main questions were:

1. How many modules existed before and after synthesis?
2. Which RTL structures became flip-flops and logic cells?
3. How did Yosys represent cell instances and net connections?
4. Which synthesis optimizations changed the visible structure of the design?
5. What did the synthesis reports reveal about cell count and area?

## 2. Original RTL Structure

The original RTL file was approximately 19 KB and contained ten modules:

1. `gcd`
2. `GcdUnitCtrlRTL_0x4d0fc71ead8d3d9e`
3. `RegRst_0x9f365fdf6c8998a`
4. `GcdUnitDpathRTL_0x4d0fc71ead8d3d9e`
5. `RegEn_0x68db79c4ec1d6e5b`
6. `LtComparator_0x422b1f52edd46a85`
7. `ZeroComparator_0x422b1f52edd46a85`
8. `Mux_0x683fa1a418b072c9`
9. `Mux_0xdd6473406d1a99a`
10. `Subtractor_0x422b1f52edd46a85`

The file header stated that the design was originally generated from PyMTL and then modified to make it more compatible with OpenROAD tools.

The top-level `gcd` module mainly connected two major architectural blocks:

> Controller: `GcdUnitCtrlRTL... ctrl`  
> Datapath: `GcdUnitDpathRTL... dpath`

This is a standard control-and-datapath organization.

### 2.1 Top-Level Interface

The top-level ports were:

| Port | Direction | Width | Purpose |
|---|---|---:|---|
| `clk` | Input | 1 | Main clock |
| `reset` | Input | 1 | Reset |
| `req_msg` | Input | 32 | Request message containing two operands |
| `req_val` | Input | 1 | Request-valid signal |
| `req_rdy` | Output | 1 | Request-ready signal |
| `resp_msg` | Output | 16 | GCD result |
| `resp_rdy` | Input | 1 | Response-ready signal |
| `resp_val` | Output | 1 | Response-valid signal |

The 32-bit request was divided into two 16-bit operands:

> `req_msg[31:16]` → operand A  
> `req_msg[15:0]` → operand B

The request and response interfaces used valid/ready handshaking:

> Request transfer occurs when `req_val && req_rdy` is true.  
> Response transfer occurs when `resp_val && resp_rdy` is true.

### 2.2 Controller Responsibilities

The controller received status information from the datapath:

- `is_a_lt_b`
- `is_b_zero`

It generated control signals for the datapath:

- `a_mux_sel`
- `b_mux_sel`
- `a_reg_en`
- `b_reg_en`

It also controlled the handshake outputs:

- `req_rdy`
- `resp_val`

The controller therefore decided which operation should happen next, while the datapath stored and transformed the operands.

### 2.3 Datapath Responsibilities

The datapath contained the structures required to implement the GCD operation:

- A register
- B register
- Less-than comparator
- Zero comparator
- Subtractor
- Multiplexers

The datapath produced:

- `is_a_lt_b`
- `is_b_zero`
- `resp_msg`

The controller and datapath formed a feedback loop:

> Controller control signals  
> → Datapath operation  
> → Datapath status signals  
> → Controller next-state decision

## 3. Hierarchy Flattening

The synthesized netlist contained only one module:

> `module gcd(...)`

The original ten-module hierarchy had therefore been flattened into one top-level gate-level module.

The transformation was:

> Hierarchical RTL  
> → Flattened Boolean network  
> → Nangate45 standard-cell instances

Flattening removed module boundaries so that Yosys could optimize logic across the original controller, datapath, register, comparator, mux, and subtractor boundaries.

Possible benefits of flattening include:

- Constant propagation
- Dead-logic removal
- Shared-logic optimization
- Cross-module Boolean simplification
- More flexible technology mapping

The original functions were not deleted. Their implementation was absorbed into one gate-level network.

## 4. Synthesis Statistics

The synthesis report contained the following overall statistics:

| Metric | Result |
|---|---:|
| Wires | 538 |
| Wire bits | 584 |
| Public wires | 42 |
| Public wire bits | 88 |
| Ports | 8 |
| Port bits | 54 |
| Memories | 0 |
| Memory bits | 0 |
| Processes | 0 |
| Standard cells | 513 |
| Synthesis cell area | 626.696 µm² |
| Sequential-cell area | 158.270 µm² |
| Sequential-area share | 25.25% |

The 54 top-level port bits matched the original interface:

> 1 + 32 + 1 + 1 + 1 + 16 + 1 + 1 = 54 bits

This confirmed that synthesis preserved the top-level interface.

### 4.1 Why Processes Became Zero

The original RTL contained behavioral processes such as `always @(*)`.

After synthesis, the report showed:

> Processes = 0

This is expected because an RTL process is not a physical hardware primitive. Yosys converted the behavioral processes into:

- Flip-flops
- Combinational logic cells
- Explicit nets

### 4.2 Why Memories Became Zero

The design contained no inferred RAM, ROM, register file, or memory macro.

The A and B storage elements were ordinary registers, so they were implemented as individual flip-flops rather than as memory blocks.

## 5. Standard-Cell Mapping

The 513 mapped cells included:

| Cell group | Count |
|---|---:|
| DFF | 35 |
| BUF | 12 |
| CLKBUF | 3 |
| INV | 86 |
| NAND | 244 |
| NOR | 59 |
| AOI / OAI | 52 |
| AND / OR | 10 |
| XOR / XNOR | 12 |
| Total | 513 |

The most common individual cell was:

> `NAND2_X1`: 161 instances

The original RTL contained named mux, comparator, and subtractor modules, but the synthesized cell list did not contain dedicated cells with those original module names.

Instead, those functions were mapped into networks of:

- NAND
- NOR
- INV
- AOI
- OAI
- XOR
- XNOR
- AND
- OR

This is technology mapping:

> RTL operation  
> → Boolean logic  
> → Available standard cells

The absence of a cell named `Subtractor` does not mean the subtraction function disappeared. It means that the subtraction logic was implemented using library cells.

## 6. Drive Strength

The standard-cell names included suffixes such as:

- `X1`
- `X2`
- `X4`
- `X8`

These suffixes represent drive strength, not bit width.

In general:

- Smaller drive-strength cells use less area and usually less power.
- Larger drive-strength cells can drive more load or improve timing.
- Larger cells usually have greater input capacitance and area.

Yosys selected different drive strengths according to the technology-mapping and optimization results.

## 7. Sequential Structure Mapping

The netlist contained 35 `DFF_X1` instances.

The instance names showed the following organization:

| RTL structure | Mapped flip-flops |
|---|---:|
| Controller state | 3 |
| Datapath A register | 16 |
| Datapath B register | 16 |
| Total | 35 |

This was confirmed by instance names such as:

- `ctrl.state.out[0]`
- `ctrl.state.out[1]`
- `ctrl.state.out[2]`
- `dpath.a_reg.out[...]`
- `dpath.b_reg.out[...]`

The original module hierarchy was flattened, but Yosys preserved partial origin information in the instance names. This traceability later appeared in the timing reports, where timing paths referenced names such as `dpath.a_reg.out[15]`.

## 8. Gate-Level Instance Syntax

A gate-level instance follows this general structure:

> `Cell_Type Instance_Name ( .Pin(Connected_Net), ... );`

### 8.1 DFF Example

One mapped state flip-flop had the following connections:

> Cell type: `DFF_X1`  
> Clock pin `CK` → `clk`  
> Data pin `D` → `_016_`  
> Normal output `Q` → `req_rdy`  
> Inverted output `QN` → `_493_`

This showed that one controller state flip-flop directly drove the top-level output `req_rdy`.

The direct connection is evidence of synthesis optimization. The original RTL expressed `req_rdy` as controller output logic, but synthesis recognized that the signal could be represented directly by a state-register output.

### 8.2 NAND Example

One NAND cell had:

> Cell type: `NAND2_X1`  
> Input `A1` → `_051_`  
> Input `A2` → `_052_`  
> Output `ZN` → `_053_`

Its Boolean function was:

> `_053_ = NOT(_051_ AND _052_)`

The automatic names such as `_051_`, `_052_`, and `_053_` represent internal nets generated by synthesis.

## 9. Escaped Identifiers

Some instance names started with a backslash, for example:

> `\ctrl.state.out[0]$_DFF_P_`

This is a Verilog escaped identifier.

The backslash allows the identifier to contain characters such as:

- `.`
- `[ ]`
- `$`

The backslash is not a hierarchy operator. It tells the Verilog parser to treat the following character sequence as one identifier until whitespace terminates it.

## 10. FSM Transformation

The original controller used three logical states:

- `STATE_IDLE`
- `STATE_CALC`
- `STATE_DONE`

The original RTL state variable was two bits wide.

The synthesized implementation contained three state-related flip-flops:

- `state.out[0]`
- `state.out[1]`
- `state.out[2]`

This provides strong structural evidence that Yosys recoded the original two-bit FSM into a three-bit one-hot-like implementation.

The likely mapping was:

| Synthesized bit | Likely state | Evidence |
|---|---|---|
| `state.out[0]` | IDLE | Its Q output directly drove `req_rdy` |
| `state.out[1]` | DONE | It participated in `resp_val` generation and response-handshake logic |
| `state.out[2]` | CALC | It was the remaining state bit and was buffered to drive multiple control loads |

This mapping is strongly supported by the observed netlist structure, but no explicit Yosys FSM recoding log or formal state-mapping report was inspected. It should therefore be described as an apparent or strongly supported mapping rather than as a formally proven encoding report.

### 10.1 State Bit Driving `req_rdy`

The first state flip-flop had:

> `.Q(req_rdy)`

This means the IDLE state indicator was optimized into the request-ready output directly.

The likely structural simplification was:

> State register  
> → state decoder  
> → `req_rdy`

became:

> State-register Q  
> → `req_rdy`

### 10.2 `resp_val` Logic

The netlist showed:

> `resp_val = state.out[1] AND _352_`

The net `_352_` was generated by:

> `_352_ = NOT(_293_ OR _285_)`

The net `_285_` was a buffered version of `state.out[2]`.

Therefore, the observed local relationship was:

> `resp_val = state.out[1] AND NOT(_293_ OR state.out[2])`

The exact meaning of `_293_` was not established, so the full expression was not reduced to a named RTL condition.

### 10.3 Response Handshake Logic

The netlist also contained:

> `_454_ = NOT(resp_val AND resp_rdy)`

This NAND output participated in the next-state Boolean network.

This directly corresponds to the RTL response handshake condition:

> `resp_val && resp_rdy`

which controls the transition from DONE back to IDLE.

## 11. Buffering of a State Signal

The netlist contained a `CLKBUF_X2` cell driven by `state.out[2]`.

Its output was `_285_`, and `_285_` drove several downstream logic cells.

Although the cell name contains `CLKBUF`, the input was not a clock. In this mapped netlist, the cell functioned as a non-inverting buffer for a high-load control signal.

This illustrates that:

- Library cell names describe the available cell type.
- Actual use is determined by connectivity.
- A clock-buffer cell can appear on a non-clock control signal if the mapping flow allows it and its electrical characteristics are useful.

## 12. Logic-Cone Tracing

The analysis demonstrated how gate-level netlist tracing differs from RTL reading.

At RTL level, an engineer reads:

> State comparison  
> → control decision  
> → output assignment

At gate level, the same behavior appears as:

> State DFF  
> → buffer or inverter  
> → generated internal net  
> → NAND/NOR/AOI/OAI network  
> → output or next-state D input

Tracing the fanout of `_285_` and the driver of `_352_` showed that a meaningful RTL signal may be renamed after buffering and then reused in several places.

This is the basis of logic-cone tracing:

1. Identify a source or endpoint.
2. Find the cell that drives the net.
3. Inspect the cell inputs.
4. Follow predecessor or successor nets.
5. Stop when the original architectural meaning is sufficiently clear.

## 13. Synthesis Area Versus Final Area

The synthesis report showed:

> Synthesis cell area = 626.696 µm²

The final implementation reported:

> Final design area = 683 µm²

The increase was:

> 683 − 626.696 = 56.304 µm²

This was approximately a 9% increase relative to the synthesis cell area.

Likely contributors included:

- Cell resizing
- Additional buffering
- Clock-tree insertion
- Timing repair
- Electrical-rule repair

This confirms that synthesis area is not the final post-implementation area.

## 14. Sequential Area Versus Sequential Power

The synthesis report showed:

> Sequential-area share = 25.25%

The final power report showed:

> Sequential-power share = 24.8%

These percentages were close, but they represented different quantities:

- Sequential-area share describes physical cell area.
- Sequential-power share describes estimated power consumption.

Their similarity in this example should not be treated as a general rule.

## 15. Synthesis Structural Check

The synthesis check report stated:

> `Executing CHECK pass (checking for obvious problems).`  
> `Checking module gcd...`  
> `Found and reported 0 problems.`

This means Yosys found no obvious structural problems within the scope of its `CHECK` pass.

This result does not replace:

- Functional simulation
- RTL-to-gate formal equivalence
- CDC/RDC analysis
- Static timing analysis
- Physical DRC/LVS
- Signoff verification

The accurate conclusion is:

> The synthesized `gcd` netlist passed the Yosys structural CHECK pass with zero reported problems.

## 16. Main Conclusions

The Day 38 analysis established the following synthesis transformation:

> PyMTL-generated hierarchical RTL  
> → Yosys elaboration and hierarchy flattening  
> → Boolean optimization  
> → FSM restructuring or recoding  
> → Nangate45 technology mapping  
> → 513 explicit standard-cell instances  
> → Pin-to-net gate-level connectivity

The most important observed results were:

- Ten original modules were flattened into one `gcd` module.
- The top-level interface remained unchanged.
- The design mapped to 513 standard cells.
- Thirty-five DFFs implemented controller and datapath state.
- Original mux, comparator, and subtractor functions became logic-gate networks.
- One state DFF directly drove `req_rdy`.
- `resp_val` was generated through state-dependent combinational logic.
- The synthesized cell area was 626.696 µm².
- The Yosys structural check reported zero problems.

## 17. Repository Evidence

Recommended screenshot directory:

> `04_openroad_practice/04_screenshots/day38_synthesis/`

Recommended files:

- `module-hierarchy-comparison.png`
- `synthesis-statistics-overview.png`
- `synthesis-cell-area-summary.png`
- `synthesized-instance-list.png`
- `synthesis-check.png`
