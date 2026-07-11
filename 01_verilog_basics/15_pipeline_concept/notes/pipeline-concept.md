# Pipeline Concept

## 1. Overview

A pipeline divides a long operation into multiple stages separated by registers.

Instead of allowing data to pass through all combinational logic in one clock cycle, each pipeline stage completes part of the operation. The intermediate result is stored in a pipeline register before moving to the next stage.

The main purpose of pipelining is to improve throughput and reduce the combinational delay between adjacent registers.

---

## 2. Non-Pipelined Design

Consider a design with three combinational logic blocks:

    Input Register
          |
          v
      Logic A
          |
          v
      Logic B
          |
          v
      Logic C
          |
          v
    Output Register

Assume:

    Logic A delay = 2 ns
    Logic B delay = 2 ns
    Logic C delay = 2 ns

The complete combinational path delay is:

    2 ns + 2 ns + 2 ns = 6 ns

Ignoring register and clock overhead, the clock period must satisfy:

    Tclk >= 6 ns

The next data item cannot complete until the full combinational path has been evaluated.

---

## 3. Pipelined Design

Pipeline registers can be inserted between the logic blocks:

    Input Register
          |
          v
      Logic A
          |
    Pipeline Register 1
          |
          v
      Logic B
          |
    Pipeline Register 2
          |
          v
      Logic C
          |
          v
    Output Register

The original long path is divided into three shorter register-to-register paths:

    Stage 1: Logic A = 2 ns
    Stage 2: Logic B = 2 ns
    Stage 3: Logic C = 2 ns

Ignoring register overhead, the clock period can now approach:

    Tclk >= 2 ns

Pipelining does not reduce the total amount of logic. It changes how the logic is divided across clock cycles.

---

## 4. Pipeline Stage

A pipeline stage is the combinational logic between two register boundaries.

Example:

    Register
       |
       v
    Combinational Logic
       |
       v
    Register

Each stage must complete its operation before the next active clock edge.

The slowest pipeline stage limits the maximum clock frequency of the entire pipeline.

---

## 5. Register Boundary

A register boundary separates two pipeline stages.

At each active clock edge:

- The current stage result is stored in a pipeline register.
- The stored value becomes the input of the next stage.
- Data normally advances by one stage per clock cycle.

A single data item cannot pass through several registered stages during one clock cycle.

Pipeline registers help shorten combinational paths, but they also introduce:

- Clock-to-Q delay
- Setup-time requirements
- Additional area
- Additional clock power
- Additional latency in cycles

---

## 6. Throughput

Throughput describes how many results can be completed per unit of time.

After a pipeline has been filled, a well-designed pipeline may accept one new input and produce one result every clock cycle.

Example:

    Throughput = 1 result per cycle

Pipeline design mainly improves throughput.

This assumes:

- No stalls
- No bubbles
- A continuous input supply
- The output can continuously accept data
- Every pipeline stage finishes within one clock period

---

## 7. Latency

Latency describes how long one specific transaction takes to travel from the pipeline input to the pipeline output.

For a three-stage pipeline:

    Latency = 3 cycles

Example:

    Cycle 1: Data A is in Stage 1
    Cycle 2: Data A is in Stage 2
    Cycle 3: Data A is in Stage 3

Although the pipeline may eventually produce one result per cycle, each individual transaction still requires several cycles to pass through all stages.

Pipeline design usually increases latency measured in cycles while improving throughput.

Latency measured in actual time also depends on the clock period:

    Latency time = Pipeline cycles × Clock period

---

## 8. Pipeline Filling and Draining

At the beginning, the pipeline stages are not all occupied.

This startup period is called pipeline filling.

Example for a three-stage pipeline:

| Cycle | Stage 1 | Stage 2 | Stage 3 | Output |
|---:|---|---|---|---|
| 1 | A | Empty | Empty | None |
| 2 | B | A | Empty | None |
| 3 | C | B | A | A |
| 4 | D | C | B | B |

After all stages contain valid transactions, the pipeline is full.

When no new inputs are provided, the remaining transactions continue moving toward the output. This process is called pipeline draining.

---

## 9. Critical Stage

The critical stage is the pipeline stage with the largest combinational delay.

Example:

    Stage 1 delay = 3 ns
    Stage 2 delay = 7 ns
    Stage 3 delay = 4 ns

Stage 2 is the critical stage because it has the largest delay.

Ignoring register overhead:

    Tclk >= max(3 ns, 7 ns, 4 ns)
    Tclk >= 7 ns

The clock period is determined by the slowest stage, not by the average stage delay.

---

## 10. Pipeline Balancing

Pipeline balancing means dividing the combinational logic so that the delays of different stages are as close as possible.

Unbalanced pipeline:

    Stage 1 = 2 ns
    Stage 2 = 6 ns
    Stage 3 = 2 ns

The clock period is limited by Stage 2:

    Tclk >= 6 ns

A better-balanced design may be:

    Stage 1 = 3.5 ns
    Stage 2 = 3.5 ns
    Stage 3 = 3.0 ns

The maximum stage delay is reduced:

    Tclk >= 3.5 ns

The goal is not simply to add more registers. The goal is to divide the logic into reasonably balanced timing paths.

---

## 11. Register-to-Register Timing

A simplified setup timing requirement is:

    Tclk >= Tcq + Tlogic + Tsetup + Tuncertainty

Where:

Tcq

The clock-to-Q delay of the launch register.

Tlogic

The combinational logic and interconnect delay between registers.

Tsetup

The setup-time requirement of the capture register.

Tuncertainty

Timing margin for clock skew, jitter, and other clock variations.

Therefore, the clock period is not determined only by combinational logic delay.

Pipeline registers reduce Tlogic, but each additional register also introduces timing, power, and area overhead.

---

## 12. Stall

A stall occurs when a pipeline stage temporarily cannot move its valid transaction to the next stage.

Example:

    valid = 1
    ready = 0

The stage contains valid data, but the downstream stage cannot accept it.

During a stall:

- Data must remain unchanged.
- Valid must remain asserted.
- Associated control signals must remain unchanged.
- The occupied stage cannot be overwritten.
- Backpressure may propagate toward upstream stages.

Example:

    Stage 1: C
    Stage 2: B
    Stage 3: A
    Output ready = 0

If Stage 3 cannot transfer A, it must hold A. Stage 2 must then hold B, and Stage 1 must hold C.

A stall is a control action that prevents one or more pipeline registers from updating.

---

## 13. Bubble

A bubble is an empty or invalid entry moving through the pipeline.

A bubble is normally represented by:

    valid = 0

The data field may still contain an old binary value, but that value must be ignored because the valid signal indicates that the stage does not contain a real transaction.

Example:

| Cycle | Stage 1 | Stage 2 | Stage 3 |
|---:|---|---|---|
| 1 | A | Bubble | Bubble |
| 2 | B | A | Bubble |
| 3 | Bubble | B | A |
| 4 | C | Bubble | B |
| 5 | Bubble | C | Bubble |

The bubble moves through the pipeline and eventually causes a cycle with no valid output.

---

## 14. Stall vs Bubble

Stall

The pipeline stage contains valid data but cannot move forward. The data and valid signals must be held.

Bubble

The pipeline stage contains no valid transaction. The pipeline may continue moving, but that stage performs no useful work.

| Concept | Valid Data Present | Stage Moves Normally | Main Meaning |
|---|---:|---:|---|
| Stall | Yes | No | Valid data is blocked |
| Bubble | No | Usually yes | Empty pipeline entry |

A stall does not automatically mean that every stage contains a bubble.

A bubble does not automatically mean that the pipeline is stalled.

---

## 15. Valid and Ready

Pipeline flow can use the same valid/ready handshake learned previously.

    transfer = valid && ready

Valid

Indicates that the producer or upstream stage contains meaningful data.

Ready

Indicates that the consumer or downstream stage can accept data.

Typical conditions:

| Valid | Ready | Meaning |
|---:|---:|---|
| 0 | 0 | No valid data and downstream unavailable |
| 0 | 1 | Downstream can accept, but upstream has no data |
| 1 | 0 | Valid data is blocked; stall |
| 1 | 1 | Successful transfer |

Data and valid move downstream.

Ready and backpressure propagate upstream.

---

## 16. Ready Logic for a Pipeline Stage

A stage can accept new data when:

- The stage is currently empty, or
- Its current transaction will leave during the same clock cycle.

A simplified ready expression is:

    stage_ready = !stage_valid || downstream_ready

If the stage is empty:

    stage_valid = 0

It can accept new data even if the downstream stage is not ready.

If the stage is full and the downstream stage is not ready:

    stage_valid = 1
    downstream_ready = 0
    stage_ready = 0

The stage must stall.

---

## 17. Pipeline Register Update Behavior

A pipeline stage commonly has three possible clock-edge behaviors.

### Receive Valid Data

Conditions:

    upstream_valid = 1
    stage_ready = 1

Behavior:

    stage_data receives upstream_data
    stage_valid becomes 1

### Receive a Bubble

Conditions:

    upstream_valid = 0
    stage_ready = 1

Behavior:

    stage_valid becomes 0

The data field may remain unchanged but must be ignored.

### Stall

Condition:

    stage_ready = 0

Behavior:

    stage_data holds its value
    stage_valid holds its value

The stage must not overwrite an unconsumed transaction.

---

## 18. Backpressure

Backpressure occurs when a downstream stage cannot accept data and communicates this condition toward the upstream stages.

Example:

    Output ready = 0
        |
        v
    Stage 3 cannot move
        |
        v
    Stage 2 cannot move
        |
        v
    Stage 1 cannot move
        |
        v
    Input ready = 0

If an intermediate stage contains a bubble, upstream data may temporarily move into that empty stage.

Therefore, backpressure does not always freeze the entire pipeline immediately. It propagates completely only after the available empty stages have been filled.

---

## 19. Data and Control Alignment

A pipeline transaction usually contains more than payload data.

Example:

    Transaction
    ├── data
    ├── operation
    ├── address
    ├── destination
    ├── control flags
    └── valid

All signals associated with the same transaction must pass through the same number of pipeline registers.

Incorrect alignment:

    data from Transaction A
    operation from Transaction B

This causes the wrong operation to be applied to the data.

During a stall, all associated signals must be held together.

During a bubble, valid must be cleared so that the remaining fields are ignored.

Core rule:

Data and its associated control information must remain aligned throughout the pipeline.

---

## 20. Connection to STA

Static Timing Analysis commonly examines register-to-register timing paths:

    Launch Register
          |
          v
    Combinational Logic
          |
          v
    Capture Register

Pipeline registers divide one long combinational path into several shorter timing paths.

This can:

- Reduce critical-path delay
- Allow a shorter clock period
- Increase maximum clock frequency
- Improve setup slack
- Simplify timing closure

However, adding pipeline registers also affects:

- Area
- Dynamic clock power
- Latency
- Clock-tree load
- Hold timing
- Physical placement and routing

Pipeline design is therefore a timing, architecture, power, and area tradeoff.

---

## 21. Connection to VLSI and Physical Design

Pipeline architecture affects the physical implementation of a chip.

More pipeline registers mean:

- More sequential cells
- Greater clock-tree load
- More clock power
- Additional placement requirements
- More register-to-register timing paths
- Potentially shorter combinational paths
- More hold-time paths that must be checked

Physical Design and STA engineers must ensure that each pipeline stage satisfies timing after placement, clock-tree synthesis, and routing.

---

## 22. Key Takeaways

Pipeline Stage

A section of combinational logic between register boundaries.

Register Boundary

A storage point that separates two pipeline stages.

Throughput

The rate at which completed results are produced.

Latency

The time or number of cycles required for one transaction to pass through the full pipeline.

Critical Stage

The stage with the largest delay, which limits the clock period.

Pipeline Balancing

Dividing logic so that stage delays are reasonably similar.

Stall

A valid transaction cannot move forward, so the stage must hold its data and control signals.

Bubble

An invalid pipeline entry identified by valid = 0.

Backpressure

A downstream inability to accept data that propagates toward the upstream stages.

Data-Control Alignment

Payload data and all related control information must remain synchronized through every pipeline stage.

---

## 23. One-Sentence Summary

Pipelining improves throughput and timing by dividing long combinational paths into shorter register-to-register stages, while requiring careful control of latency, stalls, bubbles, valid/ready flow, and data-control alignment.