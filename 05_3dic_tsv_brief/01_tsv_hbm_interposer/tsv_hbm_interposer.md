# TSV, HBM, and Silicon Interposer Fundamentals

## 1. Overview

This note explains the main structures and design constraints in a typical 2.5D HBM system. The system combines a logic die, one or more HBM stacks, a silicon interposer, microbumps, through-silicon vias, package-level bumps, and a package substrate.

The key architectural relationship is:

> Logic die and HBM stacks are usually placed side by side on a silicon interposer rather than directly stacked on top of one another.

The interposer provides dense lateral routing between the logic die and HBM. Vertical connections are provided by TSVs, microbumps, C4 bumps, and other package-level interconnects.

This structure links TSV fabrication knowledge with packaging-aware physical design and EDA. TSV geometry, material integration, placement, and manufacturing quality affect parasitics, routing density, keep-out zones, power delivery, reliability, test, yield, and cost.

## 2. Typical 2.5D HBM Structure

A simplified top-to-bottom structure is:

> Logic Die and HBM Stack
> 
> → Microbumps
> 
> → Silicon Interposer Metal Routing and RDL
> 
> → Interposer TSVs
> 
> → C4 Bumps
> 
> → Package Substrate
> 
> → BGA Balls
> 
> → PCB

The main data path between HBM and the logic die is not a single TSV connection. It crosses multiple physical structures:

> HBM TSV Network
> 
> → HBM Base Die
> 
> → HBM Microbumps
> 
> → Silicon Interposer Metal Routing
> 
> → Logic-Die Microbumps
> 
> → HBM PHY
> 
> → Memory Controller

## 3. Logic Die

The logic die performs the main computation and system-control functions. Depending on the product, it may be a GPU, AI accelerator, CPU, networking ASIC, FPGA, or custom compute die.

A logic die used with HBM may contain:

- Compute cores
- Cache
- Memory controller
- HBM PHY
- On-chip network
- Clock and power distribution
- High-speed I/O circuitry

The logic die does not normally communicate directly with each DRAM die in the HBM stack. Instead, it communicates through the HBM PHY, microbumps, interposer routing, and the HBM base-die interface.

### 3.1 Memory Controller

The memory controller is responsible for logical decisions and scheduling. It determines:

- Whether the operation is a read or write
- Which HBM channel is selected
- Which bank and address are accessed
- When commands are issued
- How multiple requests are ordered
- How refresh and conflicts are handled

A useful summary is:

> The memory controller decides what, where, and when.

### 3.2 HBM PHY

The HBM PHY is the physical and electrical interface. It handles:

- Driving and receiving data, address, command, and clock signals
- Data sampling
- Clock alignment
- Interface training and calibration
- Skew management
- Electrical signaling
- Timing at the physical interface

A useful summary is:

> The HBM PHY determines how bits physically cross the interface.

The PHY is normally placed near the HBM-facing edge of the logic die. This reduces on-die wirelength, parasitic resistance and capacitance, routing congestion, interface skew, power, and timing uncertainty.

## 4. HBM Stack

HBM means High Bandwidth Memory. An HBM stack contains multiple DRAM dies placed vertically on top of one another.

A simplified structure is:

> Upper DRAM Die
> 
> → TSV Network
> 
> → DRAM Die
> 
> → TSV Network
> 
> → Lower DRAM Die
> 
> → Base Die or Interface Die
> 
> → Microbumps
> 
> → Silicon Interposer

Each DRAM die contains structures such as memory cells, sense amplifiers, row and column decoders, banks, and local data paths. The base die or interface die connects the stacked DRAM dies to the external HBM interface.

## 5. Why HBM Provides High Bandwidth

HBM does not depend only on extremely high data rate per individual wire. Its main advantage comes from a wide, short, and highly parallel interface.

A simplified relationship is:

> Total bandwidth ≈ number of parallel data connections × data rate per connection

HBM uses:

- A very wide interface
- Many parallel channels
- Dense microbump connections
- Short interposer routing
- Close placement to the logic die

Compared with external DDR connected through a package and PCB, HBM can reduce interconnect length, parasitic loading, I/O energy, and signal-integrity difficulty while increasing total bandwidth.

## 6. Through-Silicon Vias

A through-silicon via is a vertical conductor that passes through a silicon substrate. TSVs are not ideal wires. They introduce resistance, capacitance, possible inductance, substrate coupling, neighboring-TSV coupling, and mechanical stress.

### 6.1 HBM TSVs

TSVs inside an HBM stack connect vertically stacked DRAM dies. Different TSVs may carry:

- Data
- Address
- Command
- Clock
- Power
- Ground
- Test signals
- Redundant connections

HBM requires a TSV network rather than a single TSV.

### 6.2 Interposer TSVs

TSVs inside a silicon interposer connect top-side interposer routing to the lower package substrate.

Their main responsibility is vertical escape toward the package substrate. They do not provide the primary lateral connection between HBM and the logic die.

### 6.3 HBM TSVs Versus Interposer TSVs

| TSV Location | Main Responsibility |
|---|---|
| Inside HBM stack | Connect vertically stacked DRAM dies |
| Inside silicon interposer | Connect interposer top-side routing to the package substrate |

## 7. Vertical and Lateral Interconnects

A 2.5D HBM system combines vertical and lateral connections.

### 7.1 Vertical Connections

Examples include:

- HBM TSVs
- Interposer TSVs
- Microbumps
- C4 bumps
- BGA balls

### 7.2 Lateral Connections

Examples include:

- DRAM-die metal routing
- Logic-die metal routing
- HBM base-die routing
- Silicon interposer metal routing
- Redistribution layers
- Package-substrate routing
- PCB traces

A complete signal path may alternate between directions:

> Lateral → Vertical → Lateral → Vertical → Lateral

## 8. Microbumps, C4 Bumps, and RDL

### 8.1 Microbumps

Microbumps connect two separate fine-pitch surfaces, such as:

- Logic die to interposer
- HBM stack to interposer
- Die to die in stacked integration

A microbump is located at an interface. It does not pass through the full silicon substrate.

A useful distinction is:

> A bump connects surfaces; a TSV passes through silicon.

### 8.2 C4 Bumps

C4 bumps are generally larger and coarser than microbumps. They are commonly used for package-level connections such as:

- Interposer to package substrate
- Die to package substrate

They carry signals, power, and ground while also contributing mechanical support.

### 8.3 Redistribution Layer

RDL means Redistribution Layer. It redistributes pad or bump locations through lateral metal routing.

RDL may connect:

- TSV terminals to bumps
- Fine-pitch die pads to a different bump pitch
- Internal package connections to external interfaces

RDL does not normally pass through silicon. Its main function is surface-level redistribution and lateral routing.

## 9. Silicon Interposer

A silicon interposer is a high-density interconnect platform between dies and the package substrate.

In a typical passive interposer, the main structures are:

- Fine-pitch metal routing
- Dielectric layers
- RDL
- Vias
- TSVs
- Power and ground distribution structures

The silicon interposer provides dense lateral routing between side-by-side dies. It supports a much finer routing pitch and higher interconnect density than a typical organic package substrate.

The interposer should not be treated as a single connection point. The actual signal path uses specific structures such as metal routing, RDL, TSVs, and bumps.

## 10. Package Substrate

The package substrate is located between the interposer and the PCB. It provides:

- Signal fan-out
- Power and ground distribution
- Mechanical support
- Connection to BGA balls
- Connection from the package to the PCB

Compared with a silicon interposer, the package substrate normally has larger pitch, lower routing density, longer interconnects, and lower cost per unit area.

## 11. TSV Diameter, Depth, and Aspect Ratio

TSV geometry creates tradeoffs between electrical performance, manufacturability, density, and mechanical reliability.

### 11.1 TSV Diameter

A larger TSV diameter may provide:

- Lower resistance
- Higher current capability
- Lower aspect ratio when depth is unchanged
- Easier etching, deposition, and filling

However, it may also cause:

- Larger silicon-area consumption
- Lower TSV density
- Larger routing obstruction
- Increased keep-out-zone impact
- Reduced placement and routing flexibility

### 11.2 TSV Depth

A deeper TSV with fixed diameter produces a higher aspect ratio. This may lead to:

- More difficult DRIE
- Harder sidewall control
- More difficult liner coverage
- Barrier and seed discontinuity risk
- Copper-fill void or seam risk
- Higher conductor resistance

### 11.3 Aspect Ratio

Aspect ratio is defined as:

> Aspect ratio = TSV depth / TSV diameter

If TSV depth remains constant and TSV diameter increases, aspect ratio decreases. This normally improves manufacturability but increases area cost.

## 12. TSV Pitch and Keep-Out Zone

### 12.1 TSV Pitch

TSV pitch is the center-to-center distance between adjacent TSVs.

A smaller pitch can increase vertical interconnect density, but it may also increase:

- Fabrication difficulty
- Electrical coupling
- Crosstalk
- Mechanical interaction
- Routing-access difficulty

### 12.2 Keep-Out Zone

A keep-out zone is a restricted region around a TSV where sensitive devices may not be placed normally.

The main reasons include:

- Mechanical stress caused by different coefficients of thermal expansion
- Electrical coupling
- Reliability constraints
- Manufacturing rules

Copper and silicon expand differently with temperature. This creates mechanical stress around a TSV and can affect nearby transistor mobility, leakage, threshold behavior, timing, and reliability.

The physical cost of a TSV is therefore larger than its cross-sectional area:

> Effective TSV cost = TSV footprint + keep-out-zone area + routing-access cost

## 13. Power and Ground TSVs

A TSV array cannot contain only signal TSVs. Switching circuits require supply current and a ground return path.

Insufficient power and ground TSV resources can cause:

- IR drop
- Ground bounce
- Simultaneous switching noise
- Local voltage instability
- Timing degradation
- Interface errors
- Reliability problems

TSV and bump planning must therefore balance:

> Signal bandwidth vs power integrity vs area

## 14. System-Level Tradeoffs

### 14.1 Routing Congestion

A wide HBM interface requires many data, address, command, clock, power, ground, test, and redundant connections.

This creates high routing demand around:

- Logic-die edge
- HBM edge
- Microbump arrays
- Interposer routing channels

Placing HBM closer to the logic die reduces wirelength but may increase bump-escape congestion, local routing density, power-delivery conflicts, and thermal coupling.

### 14.2 Power Delivery

The power path spans multiple levels:

> PCB
> 
> → BGA
> 
> → Package Substrate
> 
> → C4 Bumps
> 
> → Interposer Power Network
> 
> → Microbumps
> 
> → Logic Die and HBM Stack

Each level contributes resistance and possible voltage drop. Power integrity in 2.5D systems is therefore a chip-package-interposer co-design problem.

### 14.3 Thermal Constraints

The logic die may generate substantial heat, while the HBM stack contains multiple vertically stacked dies.

Thermal concerns include:

- Thermal gradients across HBM layers
- Logic-die-to-HBM thermal coupling
- Leakage increase
- Slower transistor delay
- DRAM retention degradation
- Higher refresh demand
- Reliability reduction

Placing HBM close to the logic die improves routing and bandwidth but may worsen HBM temperature.

### 14.4 Signal Integrity

Many parallel signals can create:

- Crosstalk
- Clock and data skew
- Jitter
- Ground bounce
- Simultaneous switching noise
- Delay variation

Mitigation may require spacing, shielding, ground connections, length matching, careful layer assignment, PHY training, and calibration.

### 14.5 Yield and Test

Smaller dies may improve individual die yield, but the complete package also depends on:

- Logic-die yield
- HBM-stack yield
- Interposer yield
- TSV yield
- Microbump yield
- Bonding yield
- Assembly yield
- Package test coverage

A failure in any critical component or interconnect can cause the full package to fail.

Known Good Die testing, redundancy, repair, built-in self-test, and die-to-die link testing are therefore important.

### 14.6 Cost

Cost sources include:

- Silicon interposer processing
- TSV fabrication
- Fine-pitch RDL
- Microbump formation
- Wafer thinning
- Precision bonding and alignment
- HBM stacks
- Advanced testing
- Lower assembly yield
- Complex package substrates

The relevant engineering metric is not only manufacturing cost, but cost per working package.

## 15. Connection to Physical Design and EDA

Single-die Physical Design concepts extend naturally into multi-die integration.

| Single-Die Concept | 2.5D or 3D IC Extension |
|---|---|
| Pin placement | Bump and TSV assignment |
| Standard-cell placement | Die and PHY macro placement |
| Macro halo | TSV keep-out zone |
| Placement blockage | Restricted device placement near TSVs |
| Routing obstruction | TSV, bump, and interposer routing blockage |
| Routing congestion | Interposer and bump-escape congestion |
| SPEF extraction | TSV, bump, and interposer parasitic extraction |
| On-chip PDN | Chip-interposer-package power delivery |
| IR-drop analysis | Multi-level power-integrity analysis |
| Timing closure | Cross-die interface timing closure |

Packaging-aware EDA must consider:

- Die placement
- Bump assignment
- TSV planning
- Interposer routing
- Parasitic extraction
- Power delivery
- Thermal analysis
- Signal integrity
- Timing
- Reliability
- Test
- Yield
- Cost

## 16. Connection to TSV Fabrication Experience

TSV fabrication knowledge becomes valuable when it is translated into design constraints.

| Fabrication Parameter or Process | Design and EDA Relevance |
|---|---|
| Diameter | Resistance, current capability, density, footprint, KOZ |
| Depth | Aspect ratio, resistance, delay, manufacturability |
| DRIE profile | Geometry control, liner coverage, reliability |
| Oxide liner | Isolation, capacitance, leakage |
| Barrier layer | Copper diffusion control and long-term reliability |
| Seed layer | Electroplating continuity and open-defect risk |
| Copper electroplating | Resistance, voids, seams, yield |
| CMP | Planarity, TSV exposure, bump and bonding quality |
| TSV pitch | Interconnect density, coupling, routing access |
| TSV placement | Stress, KOZ, congestion, power delivery |

A concise technical statement is:

> My TSV fabrication background gives me a physical understanding of how interconnect geometry and process integration affect parasitics, routing density, keep-out zones, power delivery, reliability, manufacturability, and yield in 2.5D and 3D IC systems.

## 17. Key Distinctions

| Item | Correct Interpretation |
|---|---|
| Logic die and HBM stack | Usually side by side on a silicon interposer in a typical 2.5D system |
| HBM TSV | Connects vertically stacked DRAM dies |
| Interposer TSV | Connects interposer routing to the package substrate |
| Microbump | Connects two separate fine-pitch surfaces |
| Interposer metal routing | Provides lateral die-to-die communication |
| RDL | Redistributes pad and bump locations laterally |
| Memory controller | Decides what, where, and when |
| HBM PHY | Handles physical and electrical signal transmission |
| TSV pitch | Center-to-center TSV spacing |
| Keep-out zone | Restricted device-placement region around a TSV |

## 18. Final Summary

A typical 2.5D HBM architecture places a logic die and HBM stacks side by side on a silicon interposer. HBM TSVs provide vertical connectivity inside the memory stack, while microbumps and interposer metal routing connect HBM to the logic die. Interposer TSVs, C4 bumps, and the package substrate connect the system to lower packaging levels and the PCB.

The performance advantage comes from wide, short, dense parallel interconnects. The same structure introduces routing congestion, power-delivery complexity, thermal coupling, signal-integrity requirements, test difficulty, yield risk, and cost. TSV geometry and fabrication quality directly affect the parasitic, mechanical, physical-design, reliability, and manufacturability constraints that packaging-aware EDA tools must model and optimize.
