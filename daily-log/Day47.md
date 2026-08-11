# Day 47 Daily Log

## Topic

Preparing a Technical Advisor Brief for Prof. Sung-Kyu Lim

## What I Learned

Today I clarified how to present my technical direction to a professor working in 2.5D / 3D IC and EDA.

The most important decision was to define EDA as my main field rather than describing myself broadly as interested in VLSI or packaging. I identified 2.5D / 3D IC as the research space I want to explore, with Physical Design optimization as my primary technical interest. Physical Design and STA are supporting strengths, while my TSV fabrication experience provides a differentiating process-aware perspective.

I learned that my technical history should not be presented as a chronological list of summer study days. Instead, it should be organized as a progression from digital foundations to Physical Design, STA, OpenROAD implementation, advanced packaging constraints, and finally packaging-aware EDA.

I also clarified how to use OpenROAD results as evidence. Rather than saying that I learned a tool, I should explain which engineering interactions I studied with it. The three most representative categories are timing, routing closure, and static Power Integrity. Positive setup and hold slack represent STA understanding, iterative reduction of detailed-routing violations represents implementation closure, and static IR-drop analysis represents power-delivery awareness.

Another important lesson was to distinguish a technical field from a specialization and from supporting skills. My current hierarchy is:

> Main Field: EDA  
> Research Space: 2.5D / 3D IC  
> Primary Interest: Physical Design Optimization  
> Supporting Strengths: Physical Design + STA  
> Differentiator: TSV Fabrication / Process Integration

I also identified Algorithms and C++ / programming as my two largest current gaps. These are important because I want to move beyond using EDA tools and toward understanding, modifying, and eventually developing EDA algorithms.

## What I Built

I created a technical advisor brief for a future discussion with Prof. Sung-Kyu Lim.

The brief includes:

- Current technical direction
- Relevant academic background
- TSV-based 3D packaging capstone
- Summer technical preparation
- OpenROAD evidence
- 2.5D / 3D Physical Design mapping
- Motivation for 3D IC EDA
- Current research interest
- Current skill gaps
- Five technical questions for Prof. Lim
- A short meeting introduction
- A concise technical identity statement

The main artifact is:

> lim_advisor_brief.md

## Key Concepts

### Technical Identity

A concise definition of the field, specialization, strengths, and differentiating experience that explains where I am technically and where I want to go.

### Research Space

The application domain in which I want to apply EDA methods. For my current direction, this is 2.5D / 3D IC.

### Physical Design Optimization

The use of algorithms and design tools to optimize placement, routing, timing, power, thermal behavior, and related physical constraints.

### Evidence-Based Technical Framing

Describing what engineering problem was analyzed or implemented rather than only naming a tool or course.

### EDA Tool User

A person who understands how to operate an EDA flow and interpret its reports.

### EDA Developer / Researcher

A person who can understand, modify, implement, and evaluate the algorithms and software underlying EDA tools.

## Problems / Fixes

### Problem 1: Using Redundant OpenROAD Metrics

I initially selected setup / hold time, congestion, and slack as the three most representative OpenROAD results.

Fix:

Setup and hold slack already belong to the timing category, so using slack again is redundant. A stronger set of evidence is timing, routing closure, and static IR drop because these represent three different physical implementation dimensions.

### Problem 2: Treating Tool Names as Evidence

I initially focused on showing that I had learned OpenROAD.

Fix:

A stronger technical statement explains what the tool was used to understand. I should describe how OpenROAD exposed the interaction among timing, routing, parasitic extraction, and power analysis during physical implementation.

### Problem 3: Using Multiple Main Labels

I initially considered both EDA and 2.5D / 3D IC as equal main labels.

Fix:

EDA is the main field. 2.5D / 3D IC is the research space. Physical Design optimization is the primary technical focus. This hierarchy makes the technical direction more precise.

### Problem 4: Underestimating Algorithm and Programming Gaps

My prior preparation has focused heavily on semiconductor and VLSI domain knowledge.

Fix:

I identified Algorithms and C++ / programming as the two highest-priority gaps because EDA research requires translating optimization ideas into executable software rather than only understanding design concepts or operating existing tools.

## Connection to VLSI / EDA / 3D IC

Today's work connected the entire summer study sequence into one coherent technical direction.

RTL and digital design provide the logical foundation. Physical Design explains physical implementation. STA explains how implementation affects timing. OpenROAD provides practical implementation evidence. 2.5D / 3D IC extends placement, routing, parasitic, power, and thermal constraints across multiple dies. TSV fabrication explains the physical origin of many of those constraints.

The resulting research direction is packaging-aware EDA for Physical Design optimization.

This positioning allows my fabrication background to support rather than compete with my EDA career direction.

## One Sentence Summary

My current technical direction is EDA for 2.5D / 3D Physical Design optimization, supported by Physical Design, STA, OpenROAD, and TSV process-integration experience, with Algorithms and C++ as the next major skills to develop.

## Next Step

Consolidate the Week 7 3D IC material and prepare a final summary of TSV, HBM, interposers, 2.5D versus 3D integration, chiplets, thermal, Signal Integrity, Power Integrity, and packaging-aware EDA.
