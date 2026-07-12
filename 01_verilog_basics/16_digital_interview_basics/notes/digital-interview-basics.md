# Digital Interview Basics

## 1. Overview

This note reviews common digital design interview topics based on the Verilog and RTL projects completed so far.

The main topics include:

- Combinational and sequential logic
- Blocking and non-blocking assignments
- Latches and flip-flops
- Finite State Machines
- FIFO design
- Pipeline concepts
- Valid/ready handshake
- Datapath and control
- Memory interfaces
- Reset design
- Synthesizable RTL
- Bit width, carry, and overflow

The goal is not only to remember definitions, but also to explain the corresponding hardware behavior.

---

## 2. Combinational vs Sequential Logic

### Combinational Logic

Combinational logic produces outputs based only on the current input values.

    output = function(current inputs)

It does not independently store previous values.

Common examples include:

- Logic gates
- Multiplexers
- Decoders
- Adders
- Comparators
- Combinational ALUs

Common Verilog styles:

    assign y = a & b;

or:

    always @(*) begin
        y = a & b;
    end

The main rule is that every output must receive a value on every possible execution path.

### Sequential Logic

Sequential logic stores state.

Its behavior depends on both current inputs and previously stored values.

    next state = function(current input, previous state)

Common examples include:

- Flip-flops
- Registers
- Counters
- Shift registers
- FIFO pointers
- FIFO counters
- FSM state registers
- Pipeline registers

Common Verilog style:

    always @(posedge clk) begin
        q <= d;
    end

### Interview Answer

Combinational logic depends only on current inputs and does not store state. It is commonly described using `assign` or `always @(*)`. Sequential logic stores previous values using flip-flops or registers and is usually updated on a clock edge.

---

## 3. State vs Derived Logic

A stored state signal and a signal calculated from that state may belong to different logic categories.

Example:

    assign full = (count == DEPTH);

`count`

Sequential logic because it stores FIFO occupancy across clock cycles.

`full`

Combinational logic because it is calculated directly from the current value of `count`.

A status signal is not automatically combinational. The classification depends on whether the signal independently stores information.

---

## 4. Blocking vs Non-Blocking Assignments

### Blocking Assignment

Symbol:

    =

A blocking assignment updates the left-hand side immediately.

Later statements in the same procedural block can see the updated value.

Example:

    always @(*) begin
        temp = a + b;
        y = temp & mask;
    end

Blocking assignments are normally used in combinational procedural logic.

### Non-Blocking Assignment

Symbol:

    <=

A non-blocking assignment evaluates the right-hand side using the current values and schedules the left-hand-side update for later in the same simulation time step.

Example:

    always @(posedge clk) begin
        q1 <= data_in;
        q2 <= q1;
    end

At the clock edge:

    q1 receives the old data_in value
    q2 receives the old q1 value

The registers then update together.

Non-blocking assignments are normally used in clocked sequential logic.

### Important Rule

The clocked event control creates sequential storage behavior:

    always @(posedge clk)

The `<=` operator does not independently create memory. It provides the correct simulation semantics for parallel register updates.

### Common Mistake

Incorrect clocked shift register:

    always @(posedge clk) begin
        q1 = data_in;
        q2 = q1;
    end

Because blocking assignments update immediately, `q2` may receive the new `q1` during the same clock event.

Correct version:

    always @(posedge clk) begin
        q1 <= data_in;
        q2 <= q1;
    end

### Interview Answer

Blocking assignments update immediately and execute in statement order, so they are normally used in combinational logic. Non-blocking assignments evaluate old values first and update registers afterward, which correctly models parallel flip-flop behavior.

---

## 5. Latch vs Flip-Flop

### Latch

A latch is a level-sensitive storage element.

Example:

    always @(*) begin
        if (en)
            q = d;
    end

When `en = 1`, `q` follows `d`.

When `en = 0`, the code does not assign a new value to `q`, so `q` must hold its previous value.

This may infer a latch.

### Flip-Flop

A flip-flop is an edge-triggered storage element.

Example:

    always @(posedge clk) begin
        q <= d;
    end

The value of `d` is sampled only at the active clock edge.

### Avoiding Unintended Latches

Incomplete combinational code:

    always @(*) begin
        if (en)
            q = d;
    end

Correct using an `else` branch:

    always @(*) begin
        if (en)
            q = d;
        else
            q = 1'b0;
    end

Correct using a default assignment:

    always @(*) begin
        q = 1'b0;

        if (en)
            q = d;
    end

### Important Distinction

A latch is not always incorrect hardware.

Intentional latches may be used in:

- Latch-based designs
- Time-borrowing circuits
- Some low-power structures
- Specialized high-performance datapaths

The problem is an unintended latch caused by incomplete combinational assignments.

### Interview Answer

A latch is level-sensitive, while a flip-flop is edge-triggered. An unintended latch is inferred when a combinational block does not assign an output on every possible path, forcing the hardware to preserve the previous value.

---

## 6. Finite State Machine

An FSM uses a finite number of states to control system behavior.

A standard FSM contains three main parts.

### State Register

Stores the current state.

    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

This is sequential logic.

### Next-State Logic

Calculates the next state from the current state and inputs.

    always @(*) begin
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (start)
                    next_state = RUN;
            end

            RUN: begin
                if (done)
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

This is combinational logic.

### Output Logic

Generates the outputs from the state and possibly the current inputs.

### `current_state` vs `next_state`

`current_state`

Stored state that is updated on a clock edge.

`next_state`

Combinational result calculated from the current state and inputs.

### Default Assignment

    next_state = current_state;

This means the FSM stays in the current state unless a transition condition is satisfied.

It also ensures that `next_state` is assigned on every path and helps avoid latch inference.

### Moore FSM

Output depends only on the current state.

    output = function(current_state)

### Mealy FSM

Output depends on the current state and current inputs.

    output = function(current_state, inputs)

The Moore/Mealy difference is mainly in the output logic, not the state register.

### Illegal States

If a state encoding is unused, the FSM should usually include a safe recovery path:

    default: begin
        next_state = IDLE;
    end

This can help recover from:

- Reset release problems
- Metastability
- Timing violations
- State bit corruption
- RTL bugs
- Unknown state values

### Interview Answer

An FSM normally consists of a state register, combinational next-state logic, and output logic. The state register stores the current state, while the next-state logic calculates the next state from the current state and inputs.

---

## 7. FIFO Basics

FIFO means First In, First Out.

If data is written in this order:

    A, B, C

It must be read in the same order:

    A, B, C

### FIFO vs Register File

FIFO

Order-based access. The internal read pointer selects the oldest data.

Register file

Address-based access. The user supplies a read address.

### Main FIFO Components

- Memory array
- Write pointer
- Read pointer
- Occupancy count
- Full flag
- Empty flag
- Write control
- Read control

### FIFO State

`write_ptr`

Sequential state because its next value depends on its old value.

`read_ptr`

Sequential state because its next value depends on its old value.

`count`

Sequential state because it stores current FIFO occupancy.

### Full and Empty

    assign full = (count == DEPTH);
    assign empty = (count == 0);

`full` and `empty` are normally combinational signals derived from `count`.

### Write Request vs Accepted Write

    valid_write = write_en && !full

`write_en`

A write request from the producer.

`valid_write`

A write operation that is actually accepted.

### Read Request vs Accepted Read

    valid_read = read_en && !empty

`read_en`

A read request.

`valid_read`

A read operation that is actually accepted.

### Count Update

Only successful write:

    count_next = count + 1

Only successful read:

    count_next = count - 1

Successful read and write in the same cycle:

    count_next = count

Neither succeeds:

    count_next = count

During simultaneous successful read and write:

- `write_ptr` advances
- `read_ptr` advances
- `count` remains unchanged

### Overflow

An attempted write when the FIFO is full.

This may overwrite unread data if not blocked.

### Underflow

An attempted read when the FIFO is empty.

This may return stale or invalid data and corrupt the pointer or count if not blocked.

Underflow does not automatically cause a latch. Latch inference is caused by incomplete combinational assignments.

### Pointer Wrap-Around

For a depth-4 FIFO:

    0 → 1 → 2 → 3 → 0

### Pointer Equality

    write_ptr == read_ptr

This may indicate:

- Empty FIFO
- Full FIFO after pointer wrap-around

Therefore pointer equality alone cannot distinguish full from empty.

Possible solutions include:

- Occupancy count
- Extra pointer bit
- Phase bit
- Gray-code pointers in asynchronous FIFOs

### Beginner FIFO Boundary Behavior

Using:

    valid_write = write_en && !full
    valid_read = read_en && !empty

If the FIFO is full and read/write are both requested:

- Read is accepted
- Write is rejected
- Count decreases

If the FIFO is empty and read/write are both requested:

- Write is accepted
- Read is rejected
- Count increases

A higher-performance FIFO may use more advanced logic to support simultaneous boundary operations.

---

## 8. Pipeline Basics

Pipelining divides a long combinational operation into shorter stages separated by registers.

Non-pipelined path:

    Register → Logic A → Logic B → Logic C → Register

Pipelined path:

    Register → Logic A → Register
    Register → Logic B → Register
    Register → Logic C → Register

### Pipeline Stage

A section of combinational logic between two register boundaries.

### Throughput

The rate at which results are completed.

A filled single-lane pipeline may produce:

    1 result per cycle

A four-stage pipeline does not normally produce four results per cycle. It may contain four transactions in flight, but only one transaction completes from the final stage each cycle.

### Latency

The number of cycles or amount of time required for one transaction to travel from input to output.

A four-stage pipeline normally has a base latency of approximately four cycles.

### Critical Stage

The pipeline stage with the largest delay.

Example:

    Stage 1 = 2 ns
    Stage 2 = 5 ns
    Stage 3 = 3 ns

Stage 2 is the critical stage.

Ignoring register overhead:

    Tclk >= 5 ns

### Pipeline Balancing

The process of distributing logic so that stage delays are reasonably similar.

The goal is not simply to add registers, but to reduce the maximum register-to-register delay.

### Setup Timing Connection

A simplified setup timing condition is:

    Tclk >= Tcq + Tlogic + Tsetup + Tuncertainty

Pipeline registers reduce the combinational delay that must fit inside one clock period.

---

## 9. Stall and Bubble

### Stall

A stall occurs when a stage contains valid data but the downstream stage cannot accept it.

    valid = 1
    ready = 0

During a stall:

- Data must remain stable
- Valid must remain asserted
- Associated control signals must remain stable
- The transaction must not be overwritten

A stall may propagate upstream as backpressure.

### Bubble

A bubble is an invalid or empty pipeline entry.

    valid = 0

The data bits may still contain an old value, but that value must be ignored.

A bubble normally moves through the pipeline and may cause a cycle with no valid output.

### Difference

Stall

Valid data exists but cannot move.

Bubble

No valid transaction exists in that pipeline entry.

### Data-Control Alignment

A pipeline transaction may contain:

- Payload data
- Operation
- Address
- Destination
- Control flags
- Valid

All related fields must pass through the same number of pipeline stages.

If data and control information are delayed by different numbers of cycles, they may belong to different transactions.

---

## 10. Valid/Ready Handshake

A common interface contains:

- `data`
- `valid`
- `ready`

Directions:

    data, valid → producer to consumer
    ready       → consumer to producer

### Valid

Controlled by the producer.

    valid = 1

Means the current data is meaningful.

### Ready

Controlled by the consumer.

    ready = 1

Means the consumer can accept data.

### Transfer

A transfer occurs when:

    transfer = valid && ready

In a synchronous interface, both signals are normally checked at the active clock edge.

### Backpressure

    valid = 1
    ready = 0

The producer has data, but the consumer cannot accept it.

The producer must keep:

- `valid` asserted
- `data` stable
- Related control information stable

### No Valid Transaction

    valid = 0
    ready = 1

The consumer is available, but the producer has no valid data.

### Deadlock Risk

The producer should normally assert `valid` when data is available instead of waiting for `ready`.

If the producer waits for `ready` and the consumer waits for `valid`, both sides may wait forever.

### Interview Answer

A transfer occurs when valid and ready are both asserted. If valid is high and ready is low, the producer must hold valid, data, and associated control signals stable until the transaction is accepted.

---

## 11. Datapath, Control, and Status

### Datapath

Carries, stores, selects, or processes payload data.

Examples:

- ALU operands
- ALU result
- FIFO data input
- FIFO memory array
- Register-file data
- Memory read/write data buses
- Pipeline payload data

### Control

Decides what operation happens, when it happens, or which location is selected.

Examples:

- `write_en`
- `read_en`
- `opcode`
- `mux_sel`
- Address signals
- Reset
- Pipeline enable
- FSM state

### Status/Control

Reports the current condition of a module and affects control decisions.

Examples:

- `full`
- `empty`
- `busy`
- `done`
- `valid`
- `ready`
- `overflow`

### Important Distinction

Port direction does not determine datapath or control classification.

For example:

    FIFO data_in

is an input port, but it is still datapath because it carries payload data.

---

## 12. Memory Interface

A basic memory interface contains:

    address + data + control

### Address Bus

Selects a memory location.

An `n-bit` address can select:

    2^n locations

Example:

    4-bit address → 16 locations

Address signals are normally classified as control or indexing signals.

### Data Bus

Carries payload data.

Examples:

- `write_data`
- `read_data`

These belong to the datapath.

### Control Signals

Examples:

- `read_en`
- `write_en`
- `chip_en`
- `valid`
- `ready`

### Combinational Read

    assign read_data = mem[addr];

The output changes after the address changes and combinational propagation delay passes.

It does not require a clock edge.

### Synchronous Read

    always @(posedge clk) begin
        if (read_en)
            read_data <= mem[addr];
    end

The memory samples the request at a clock edge and updates the output afterward.

The request and response may occur in different cycles.

### `read_valid`

A memory data bus always contains some binary value, but the value may be:

- Old data
- Stale data
- Unrelated to the current request
- Not ready yet

`read_valid = 1` indicates that `read_data` is a valid response.

    read_en    → request
    read_valid → response

### Register File vs Memory vs FIFO

Register file

- Address-based
- Often combinational read
- Read does not consume data

Memory

- Address-based
- Often synchronous
- Read does not normally consume data
- May have latency

FIFO

- Order-based
- Uses an internal read pointer
- Successful read changes internal state

---

## 13. Reset Basics

### Synchronous Reset

Reset is checked only at the clock edge.

    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

A reset change between clock edges does not immediately update `q`.

### Asynchronous Reset

Reset can affect the register without waiting for a clock edge.

Active-high example:

    always @(posedge clk or posedge reset)

Active-low example:

    always @(posedge clk or negedge reset_n)

### Active-Low Naming

The suffix `_n` normally means:

    active low

For example:

    reset_n = 0 → reset active
    reset_n = 1 → reset inactive

`_n` does not mean falling edge.

`negedge reset_n` means the signal changes from `1` to `0`.

### Assertion and Deassertion

Assertion

Reset moves from inactive to active.

Deassertion

Reset moves from active to inactive.

For active-high reset:

    assertion:   0 → 1
    deassertion: 1 → 0

For active-low reset:

    assertion:   1 → 0
    deassertion: 0 → 1

### Asynchronous Reset Release

Asynchronous reset can be asserted immediately, but deassertion near a clock edge may cause:

- Recovery/removal timing violations
- Metastability
- Inconsistent reset release
- Illegal FSM states
- Registers leaving reset in different cycles

A common strategy is:

    asynchronous assertion
    synchronous deassertion

---

## 14. Synthesizable RTL vs Testbench Code

### Synthesizable RTL

Synthesizable RTL must map to fixed hardware such as:

- Gates
- Multiplexers
- Registers
- Memories
- Arithmetic circuits

Common synthesizable structures:

- `assign`
- `always @(*)`
- `always @(posedge clk)`
- Fixed-bound `for` loops

### Testbench Code

Testbench code runs only in the simulator.

It is not implemented in the physical chip.

Common testbench constructs include:

- `initial`
- `#delay`
- `$display`
- `$monitor`
- `$finish`
- Testbench clock generation
- File I/O
- Random stimulus

### Delay Control

    #10 a = 1'b1;

`#10` describes simulator time, not a fixed hardware structure.

Real hardware delays are normally implemented using:

- Clock cycles
- Counters
- FSM states
- Handshakes

### System Tasks

    $display
    $monitor
    $finish

These control or report simulation behavior and do not generate chip hardware.

### Testbench Clock

    forever #5 clk = ~clk;

This creates a simulated clock. It is not a physical oscillator, PLL, or clock tree.

### Fixed-Bound `for` Loop

    for (i = 0; i < 4; i = i + 1)
        regs[i] <= 0;

This can normally be synthesized because the tool knows the iteration count and unrolls the loop into fixed repeated hardware.

The loop does not execute over four clock cycles like software.

### `initial` in ASIC RTL

An ASIC register should not normally depend on an `initial` block for reset behavior.

A real reset structure should be used.

Some FPGA tools support initialization through `initial`, but that behavior should not automatically be assumed for ASIC RTL.

---

## 15. Bit Width and Truncation

### Addition Width

Two `n-bit` unsigned numbers may require an `n+1-bit` result.

Example:

    4'b1111 + 4'b0001 = 5'b10000

If stored in only 4 bits:

    result = 4'b0000

The most significant bit is lost.

### Truncation

Truncation means that bits outside the destination width are discarded.

### Preserving Carry

    assign {carry_out, result} = a + b;

Or explicitly extend operands:

    assign full_sum = {1'b0, a} + {1'b0, b};

### Zero Extension

Used for unsigned values.

    4'b0110
    → 8'b00000110

### Sign Extension

Used for signed two’s-complement values.

    4'b1010
    → 8'b11111010

The sign bit is copied into the new upper bits.

---

## 16. Signed and Unsigned Values

For `n` bits:

Unsigned range:

    0 to 2^n - 1

Signed two’s-complement range:

    -2^(n-1) to 2^(n-1) - 1

For 4 bits:

    unsigned: 0 to 15
    signed:   -8 to 7

The bit pattern:

    4'b1111

means:

    unsigned: 15
    signed:   -1

The meaning depends on the signal type.

---

## 17. Carry-Out and Overflow

### Carry-Out

Carry-out is the extra bit generated beyond the most significant bit during addition.

Example:

    1111 + 0001 = 1_0000

    carry_out = 1
    result = 0000

Carry-out is mainly associated with unsigned arithmetic.

### Unsigned Overflow

Occurs when an unsigned mathematical result exceeds the maximum value that the destination width can represent.

### Signed Overflow

Occurs when a signed mathematical result exceeds the signed representable range.

For signed addition:

> Overflow occurs when two operands have the same sign but the result has the opposite sign.

Examples:

Positive plus positive produces negative:

    0111 + 0001 = 1000

Negative plus negative produces positive:

    1000 + 1111 = 0111

### Carry-Out Is Not Signed Overflow

Example with signed overflow but no carry-out:

    0111 + 0001 = 1000

    carry_out = 0
    signed overflow = 1

Example with carry-out but no signed overflow:

    1111 + 0001 = 1_0000

Interpreted as signed:

    -1 + 1 = 0

    carry_out = 1
    signed overflow = 0

### Signed Subtraction Overflow

For:

    a - b

Overflow occurs when:

- `a` and `b` have different signs
- The result sign differs from `a`

---

## 18. Common Interview Mistakes

### Mistake 1

Saying that every `reg` becomes a physical register.

Correction:

`reg` is a Verilog procedural variable type. The procedural context determines the inferred hardware.

### Mistake 2

Saying that `<=` creates memory.

Correction:

The clocked block creates sequential storage behavior. Non-blocking assignment models parallel register updates.

### Mistake 3

Saying that every latch is incorrect.

Correction:

Intentional latches are valid hardware. Unintended latches are normally the problem.

### Mistake 4

Calling FIFO underflow a latch problem.

Correction:

Underflow is an invalid FIFO operation. Latch inference results from incomplete combinational assignments.

### Mistake 5

Assuming a four-stage pipeline produces four outputs per cycle.

Correction:

A single-lane filled pipeline normally produces one result per cycle while several transactions remain in flight.

### Mistake 6

Treating `write_en` as a successful write.

Correction:

`write_en` is a request. The accepted operation is determined by `write_en && !full`.

### Mistake 7

Using data without checking valid.

Correction:

Data buses may contain old values. The corresponding valid signal determines whether the transaction is meaningful.

### Mistake 8

Saying `_n` means falling edge.

Correction:

`_n` means active-low. `negedge` describes a falling-edge event.

---

## 19. Quick Interview Rules

Combinational logic

    Current inputs only
    assign or always @(*)
    blocking assignment
    complete assignments

Sequential logic

    Stores state
    clock-edge update
    non-blocking assignment

FSM

    state register
    next-state logic
    output logic

FIFO

    order-based access
    valid_write = write_en && !full
    valid_read = read_en && !empty

Pipeline

    improves throughput
    adds register boundaries
    one result per cycle after filling in a single-lane design

Handshake

    transfer = valid && ready

Stall

    valid data cannot move
    hold data and valid

Bubble

    valid = 0

Memory response

    use read_data only when read_valid = 1

Reset

    `_n` means active-low
    asynchronous reset release requires care

RTL

    must map to hardware

Testbench

    simulation only

Carry-out

    unsigned arithmetic indicator

Signed overflow

    same-sign addition produces opposite-sign result

---

## 20. Comprehensive Mock Interview Answers

### 1. What is the difference between combinational logic and sequential logic?

Combinational logic produces outputs based only on the current inputs and does not store state. Sequential logic stores information using flip-flops or registers, so its behavior depends on both current inputs and previously stored values.

---

### 2. Why do we normally use blocking assignments in combinational logic and non-blocking assignments in clocked sequential logic?

Blocking assignments update variables immediately and allow later statements to use the new values, which matches the evaluation of combinational logic.

Non-blocking assignments evaluate right-hand-side expressions using the old values and update the registers afterward, which correctly models multiple flip-flops sampling data in parallel at a clock edge.

---

### 3. How can an unintended latch be inferred, and how can you avoid it?

An unintended latch can be inferred when a combinational `always` block does not assign an output on every possible execution path. The hardware must then preserve the previous output value.

It can be avoided by using complete `if/else` or `case/default` branches, or by assigning a default value at the beginning of the combinational block.

---

### 4. What are the three main parts of a finite state machine?

An FSM normally contains a state register, next-state combinational logic, and output logic.

The state register stores the current state, the next-state logic calculates the next state from the current state and inputs, and the output logic generates the FSM outputs.

---

### 5. What is the difference between `write_en` and `valid_write` in a FIFO?

`write_en` is a write request from the producer. It does not guarantee that the write operation will be accepted.

`valid_write` indicates that the request is actually accepted and is commonly defined as:

    valid_write = write_en && !full

---

### 6. If a FIFO successfully reads and writes in the same cycle, what happens to `count`, `read_ptr`, and `write_ptr`?

The occupancy count remains unchanged because one item enters and one item leaves.

Both the read pointer and write pointer advance to their next locations.

---

### 7. What is the difference between throughput and latency in a pipeline?

Throughput is the rate at which completed results are produced. A filled single-lane pipeline may produce one result per clock cycle.

Latency is the number of cycles or amount of time required for one specific transaction to travel from the pipeline input to the output.

---

### 8. What is the difference between a pipeline stall and a bubble?

A stall occurs when a pipeline stage contains valid data but cannot move it forward because the downstream stage is not ready. The stage must hold its data, valid bit, and associated control signals.

A bubble is an invalid pipeline entry, normally represented by `valid = 0`. It moves through the pipeline but does not represent useful work.

---

### 9. When does a valid/ready transfer occur, and what must the producer do when `valid = 1` and `ready = 0`?

A transfer occurs when both `valid` and `ready` are asserted at the active clock edge.

When `valid = 1` and `ready = 0`, the producer must keep `valid` asserted and hold the data and all associated control signals stable until the transaction is accepted.

---

### 10. Why is `read_valid` needed in a memory interface with read latency?

The `read_data` bus always contains some binary value, but that value may be old, stale, or unrelated to the current request.

`read_valid` indicates when `read_data` contains the valid response to a completed memory read request.

---

### 11. Why are `#10` and `$display` normally not synthesizable?

`#10` is a simulator time delay and does not describe a fixed gate, register, or other hardware structure.

`$display` is a simulation system task used to print information to the terminal. Neither construct is intended to become part of the physical chip.

---

### 12. What is the difference between synchronous reset and asynchronous reset?

A synchronous reset is checked only at the active clock edge, so the register does not reset until the next clock edge.

An asynchronous reset can affect the register immediately without waiting for a clock edge. However, its deassertion must be handled carefully because it may cause recovery/removal violations or inconsistent reset release.

---

### 13. What is the difference between carry-out and signed overflow?

Carry-out is an extra bit produced beyond the most significant bit and is mainly used in unsigned arithmetic.

Signed overflow occurs when a signed mathematical result exceeds the representable range. For signed addition, it occurs when two operands have the same sign but the result has the opposite sign.

---

### 14. Why may the sum of two `n-bit` unsigned numbers require `n+1` bits?

The maximum value of an `n-bit` unsigned number is `2^n - 1`.

Adding two maximum values produces:

    (2^n - 1) + (2^n - 1)
    = 2^(n+1) - 2

This result may require one additional carry bit, so the complete sum may need `n+1` bits.

---

## 21. One-Sentence Summary

Digital design interview questions test whether an engineer can connect RTL syntax to real combinational logic, sequential state, interfaces, timing behavior, and synthesizable hardware.