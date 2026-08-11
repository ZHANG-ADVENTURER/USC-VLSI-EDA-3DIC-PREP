# Prof. Sung-Kyu Lim Advisor Brief

## 1. Current Technical Direction

My current main direction is Electronic Design Automation, with a particular interest in Physical Design optimization for 2.5D and 3D integrated circuits.

> Main Field: EDA  
> Research Space: 2.5D / 3D IC  
> Primary Interest: Physical Design Optimization  
> Supporting Strengths: Physical Design + STA  
> Practical Evidence: OpenROAD implementation flow  
> Differentiating Background: TSV fabrication and process integration  
> Current Skill Gaps: Algorithms + C++ / programming

My prior fabrication experience and recent Physical Design study have led me to become particularly interested in how advanced-package physical constraints are modeled and optimized in EDA flows.

## 2. Technical Background

### Academic Foundation

Relevant preparation includes:

- VLSI Design
- Microelectronics Fabrication
- Digital Systems
- Analog IC Design

### TSV-Based 3D Packaging Capstone

My undergraduate capstone focused on advanced 3D semiconductor packaging with through-silicon vias.

The process-integration flow included:

> Photolithography  
> → DRIE  
> → Dielectric Liner  
> → Barrier / Seed Metallization  
> → Copper Fill  
> → CMP  
> → RDL  
> → Bump / Flip-Chip Integration

Representative TSV structures included:

- Approximately 46 µm diameter and 200 µm depth, with aspect ratio ≈ 4.35
- Approximately 46 µm diameter and 83 µm depth, with aspect ratio ≈ 1.80

This work helped me understand the physical origin of constraints involving TSV parasitics, keep-out zones, current capacity, process variation, reliability, manufacturability, and yield.

## 3. Summer Technical Preparation

My summer preparation followed this progression:

> RTL / Digital Design Foundation  
> ↓  
> Physical Design  
> ↓  
> Static Timing Analysis  
> ↓  
> OpenROAD Physical Implementation  
> ↓  
> 2.5D / 3D IC and Chiplet Constraints  
> ↓  
> Packaging-Aware EDA Interest

### Digital / RTL Foundation

I built foundational experience with Verilog, combinational and sequential logic, FSMs, FIFOs, handshake protocols, register files, pipelined datapaths, and testbench-based verification.

### Physical Design

I studied synthesis, floorplanning, placement, CTS, routing, congestion, DRC / LVS, PPA tradeoffs, and power delivery.

### Static Timing Analysis

I studied startpoints and endpoints, launch and capture, cell and net delay, setup and hold, slack, WNS / TNS, skew, jitter, constraints, parasitics, and timing closure.

## 4. OpenROAD Practical Evidence

I used OpenROAD to understand how timing, routing, parasitics, and power constraints interact during physical implementation.

### Timing

The final extracted design had positive setup and hold slack under the analyzed constraints:

- Setup WNS: +0.0160 ns
- Hold WNS: +0.1108 ns

### Routing Closure

Detailed-routing violations were reduced iteratively:

> 59  
> → 29  
> → 20  
> → 0

This helped me understand implementation as an iterative closure problem rather than a one-pass flow.

### Static Power Integrity

I performed single-die static IR-drop analysis.

Representative results included:

- Worst VDD drop ≈ 5.93 mV
- Worst VSS bounce ≈ 3.17 mV

These were educational single-die static analyses, not package-aware or signoff-level PI results.

## 5. Extension to 2.5D / 3D IC

I extended familiar single-die concepts into a multi-die context.

| Single-Die Concept | 2.5D / 3D Extension |
| --- | --- |
| Macro / cell placement | Chiplet placement / tier assignment |
| Placement blockage / halo | TSV keep-out zone |
| Metal routing | Interposer / vertical routing |
| Routing congestion | TSV / bump / inter-die congestion |
| Net RC / SPEF | TSV / bump / interposer parasitics |
| On-die PDN / IR drop | Package → interposer → bump / TSV → die PDN |
| Local hotspot | Cross-tier thermal coupling |

This progression made me interested in how EDA algorithms can jointly optimize placement, routing, timing, power, and thermal constraints in advanced integration.

## 6. Why 3D IC EDA

My interest comes from connecting two perspectives.

### Fabrication Perspective

TSV fabrication showed me how diameter, depth, aspect ratio, liner integrity, barrier and seed continuity, copper-fill quality, and wafer thickness can influence parasitics, KOZ, reliability, current capacity, manufacturability, and yield.

### EDA Perspective

Physical Design and STA showed me how these physical effects become placement, routing, timing, power, and reliability constraints.

The research question that interests me is:

> How can advanced-package physical constraints be abstracted, modeled, and optimized effectively in EDA flows?

## 7. Current Research Interest

My current primary interest is:

> Physical Design optimization for 2.5D and 3D ICs.

I am especially interested in problems where:

- TSVs and bumps consume limited physical resources
- KOZ reduces available placement area
- Inter-die routing creates congestion
- Parasitics affect cross-die timing
- Power delivery competes with signal resources
- Thermal coupling constrains die placement
- Multiple objectives must be optimized simultaneously

## 8. Current Skill Gaps

### Algorithms

I understand placement, routing, timing closure, and chiplet planning as optimization problems, but I do not yet have a strong foundation in the algorithms used to solve them.

Priority topics include:

- Graph algorithms
- Search
- Data structures
- Partitioning
- Heuristics
- Optimization methods
- Placement and routing algorithms

### C++ / Programming

I can use EDA tools, but I need stronger software skills to move from tool user to EDA developer or researcher.

The next step is to become able to:

> Read EDA source code  
> → Modify algorithms  
> → Implement new heuristics  
> → Run experiments  
> → Collect metrics  
> → Compare results

## 9. Questions for Prof. Lim

### Question 1 — Skill Prioritization

For someone with my current foundation in Physical Design, STA, OpenROAD, and TSV process integration, which technical gap should I prioritize first to become capable of contributing to 2.5D / 3D EDA research?

### Question 2 — Research Opportunities

Which problems in 2.5D / 3D Physical Design currently have the most room for meaningful EDA research?

### Question 3 — Algorithms vs Modeling

In current 3D IC EDA research, which challenges are primarily algorithmic, and which are limited more by physical modeling or manufacturing uncertainty?

### Question 4 — Industry Transferability

If my long-term goal is an industry role in Physical Design or EDA, what type of 2.5D / 3D research project would provide the most transferable engineering skills?

### Question 5 — USC Course Selection

Which USC courses would you prioritize for someone targeting EDA and advanced Physical Design rather than a purely fabrication-oriented path?

## 10. Short Meeting Introduction

> I am currently building toward EDA, with a particular interest in Physical Design optimization for 2.5D and 3D ICs. My summer preparation has covered Physical Design, STA, and an OpenROAD implementation flow, while my prior TSV fabrication experience gives me a physical understanding of where many advanced-package constraints originate. I am especially interested in how EDA algorithms can model and jointly optimize TSV, routing, timing, power, and thermal constraints.

## 11. Core Technical Identity

> EDA  
> + 2.5D / 3D IC  
> + Physical Design Optimization  
> + STA  
> + OpenROAD  
> + TSV Process Awareness

The long-term transition I want to make is:

> EDA Tool User  
> → EDA Algorithm / Tool Developer  
> → Packaging-Aware Physical Design Engineer or Researcher
