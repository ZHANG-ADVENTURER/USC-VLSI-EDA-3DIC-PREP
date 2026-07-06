# SystemVerilog Awareness

## Topic

SystemVerilog awareness: `logic`, `always_comb`, `always_ff`, and `always_latch`.

The goal of this note is not to fully switch from Verilog to SystemVerilog. The goal is to understand why modern RTL code often uses SystemVerilog syntax and how it maps to the Verilog concepts already learned.

---

## Why SystemVerilog Matters

Verilog is enough for basic RTL design, but some syntax choices can be confusing for beginners.

The biggest confusion is usually:

- When should I use `wire`?
- When should I use `reg`?
- Does `reg` always mean a real register?
- Does `=` mean combinational logic?
- Does `<=` mean sequential logic?

SystemVerilog improves this by introducing clearer RTL coding styles such as:

- `logic`
- `always_comb`
- `always_ff`
- `always_latch`

These keywords make the design intent clearer.

---

## 1. `logic`

In Verilog, signals are often declared as either `wire` or `reg`.

```verilog
wire y1;
reg  y2;
```

However, `reg` is misleading. A Verilog `reg` does not always mean a physical flip-flop.

For example:

```verilog
always @(*) begin
    y = a & b;
end
```

Here, `y` must be declared as `reg` in Verilog because it is assigned inside an `always` block. But the hardware is still combinational logic, not necessarily a register.

SystemVerilog introduces `logic`:

```systemverilog
logic y;
```

`logic` can replace many beginner-level uses of `wire` and `reg`.

Important rule:

`logic` describes a signal type, not the hardware structure by itself.

The actual hardware is decided by how the signal is assigned:

- `assign` usually describes continuous combinational logic.
- `always_comb` describes combinational logic.
- `always_ff` describes clocked sequential logic.

---

## 2. `always_comb`

In Verilog, combinational logic is often written as:

```verilog
always @(*) begin
    y = a & b;
end
```

In SystemVerilog, the cleaner style is:

```systemverilog
always_comb begin
    y = a & b;
end
```

Meaning:

`always_comb` describes logic that is recalculated immediately whenever its inputs change.

It does not store past values.

Good use cases:

`Mux`

Used when selecting one signal from multiple inputs.

`Decoder`

Used when converting encoded input into one-hot or structured output.

`ALU result`

Used when calculating output from current operands and opcode.

`next_state`

Used in FSM design to calculate the next state from the current state and input.

`status flags`

Used for signals such as `full`, `empty`, `zero`, `valid_write`, and `valid_read`.

Example:

```systemverilog
always_comb begin
    if (sel)
        y = a;
    else
        y = b;
end
```

This is still combinational logic.

There is no clock.

There is no memory.

---

## 3. `always_ff`

In Verilog, clocked sequential logic is often written as:

```verilog
always @(posedge clk) begin
    q <= d;
end
```

In SystemVerilog, the cleaner style is:

```systemverilog
always_ff @(posedge clk) begin
    q <= d;
end
```

Meaning:

`always_ff` describes logic that updates only on a clock edge.

This is used when the circuit needs to remember information across cycles.

Good use cases:

`Register`

Stores a value from one clock cycle to the next.

`Counter`

Stores and updates a count value.

`FSM current_state`

Stores the current state of the FSM.

`FIFO pointers`

Stores `write_ptr` and `read_ptr`.

`FIFO count`

Stores the number of valid elements in the FIFO.

`Registered output`

Stores an output value that should update only on the clock edge.

Example:

```systemverilog
always_ff @(posedge clk) begin
    if (reset)
        q <= 1'b0;
    else
        q <= d;
end
```

This is sequential logic because `q` only changes on the rising edge of `clk`.

---

## 4. `always_latch`

`always_latch` is used when the designer intentionally wants to describe latch behavior.

A latch is level-sensitive, not edge-triggered.

In beginner RTL design, latches are usually not desired unless the design specifically requires them.

Example of latch-like behavior:

```systemverilog
always_latch begin
    if (en)
        q <= d;
end
```

When `en` is inactive, `q` keeps its previous value.

That means the circuit needs memory.

Important beginner rule:

Avoid writing latch behavior accidentally.

Most of the time, use:

- `always_comb` for combinational logic.
- `always_ff` for clocked sequential logic.
- Avoid `always_latch` unless the latch is intentional.

---

## Verilog vs SystemVerilog Comparison

| Design Intent | Verilog Style | SystemVerilog Style |
|---|---|---|
| Continuous combinational connection | `assign` | `assign` |
| Combinational logic block | `always @(*)` | `always_comb` |
| Clocked sequential logic | `always @(posedge clk)` | `always_ff @(posedge clk)` |
| General signal declaration | `wire` / `reg` | `logic` |

---

## Key Rule

The keyword alone does not define the hardware.

The design intent defines the hardware.

`Need to remember past values`

Use clocked logic.

SystemVerilog style:

```systemverilog
always_ff @(posedge clk)
```

`Need to calculate immediately from current inputs`

Use combinational logic.

SystemVerilog style:

```systemverilog
always_comb
```

`Need a simple continuous connection`

Use `assign`.

Example:

```systemverilog
assign empty = (count == 0);
```

---

## Connection to Previous Verilog Projects

### ALU

The ALU result is calculated from current inputs.

Therefore, it is combinational logic.

Verilog style:

```verilog
always @(*) begin
    case (opcode)
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a & b;
        2'b11: result = a | b;
    endcase
end
```

SystemVerilog style:

```systemverilog
always_comb begin
    case (opcode)
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a & b;
        2'b11: result = a | b;
    endcase
end
```

### FSM

The `current_state` remembers the current state.

Therefore, it is sequential logic.

```systemverilog
always_ff @(posedge clk) begin
    if (reset)
        current_state <= S0;
    else
        current_state <= next_state;
end
```

The `next_state` is calculated from `current_state` and inputs.

Therefore, it is combinational logic.

```systemverilog
always_comb begin
    case (current_state)
        S0: next_state = bit_in ? S1 : S0;
        S1: next_state = bit_in ? S1 : S2;
        default: next_state = S0;
    endcase
end
```

### FIFO

The FIFO pointers and count must remember previous values.

Therefore, they belong in clocked sequential logic.

```systemverilog
always_ff @(posedge clk) begin
    if (reset) begin
        write_ptr <= 2'b00;
        read_ptr  <= 2'b00;
        count     <= 3'b000;
    end
    else begin
        if (valid_write)
            write_ptr <= write_ptr + 1;

        if (valid_read)
            read_ptr <= read_ptr + 1;
    end
end
```

The `full`, `empty`, `valid_write`, and `valid_read` signals are calculated from current values.

Therefore, they can remain combinational.

```systemverilog
assign full        = (count == 4);
assign empty       = (count == 0);
assign valid_write = write_en && !full;
assign valid_read  = read_en && !empty;
```

---

## Common Mistakes

### Mistake 1: Thinking `logic` automatically means register

Wrong idea:

`logic` means flip-flop.

Correct idea:

`logic` is just a signal type. The assignment style determines the hardware.

---

### Mistake 2: Thinking complex logic must be sequential

Wrong idea:

A big `case` statement must be sequential.

Correct idea:

A big `case` statement can still be combinational if it only calculates output from current inputs.

Example: ALU `case` logic is usually combinational.

---

### Mistake 3: Thinking repeated same output means memory

Wrong idea:

If `next_state` keeps being `S1`, it must be memory.

Correct idea:

If the inputs are unchanged, combinational logic can keep calculating the same output.

The real memory is `current_state`, not `next_state`.

---

### Mistake 4: Accidentally creating latch behavior

In combinational logic, every output should be assigned in every possible path.

Bad style:

```systemverilog
always_comb begin
    if (sel)
        y = a;
end
```

When `sel = 0`, `y` is not assigned.

That can imply that `y` should keep its old value, which creates latch-like behavior.

Better style:

```systemverilog
always_comb begin
    if (sel)
        y = a;
    else
        y = b;
end
```

Or:

```systemverilog
always_comb begin
    y = b;

    if (sel)
        y = a;
end
```

---

## One-Sentence Summary

SystemVerilog does not change the basic RTL thinking; it makes the designer’s intent clearer by using `logic`, `always_comb`, and `always_ff` to separate signal declaration, combinational logic, and clocked sequential logic.

---

## Next Step

Rewrite one small previous module mentally in SystemVerilog style, but do not start a full SystemVerilog project yet.

Recommended practice target:

- ALU combinational block -> `always_comb`
- FSM state register -> `always_ff`
- FIFO flags -> `assign`
- FIFO pointer/count update -> `always_ff`

---

## Practice: Classifying RTL Logic in SystemVerilog Style

The purpose of this practice is to classify previous Verilog design patterns into SystemVerilog RTL styles.

The key question is:

Does this logic remember past values, or does it only calculate from current values?

---

## Example 1: ALU Result

### Hardware Meaning

The ALU result depends only on current inputs:

- `a`
- `b`
- `opcode`

It does not need to remember the previous result.

Therefore, the ALU result is combinational logic.

### Verilog Style

```verilog
always @(*) begin
    case (opcode)
    
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a & b;
        2'b11: result = a | b;
        default: result = 4'b0000;
    endcase
end
```

### SystemVerilog Style

```systemverilog
always_comb begin
    case (opcode)
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a & b;
        2'b11: result = a | b;
        default: result = 4'b0000;
    endcase
end
```

### Classification

`result`

Combinational output.

Use `always_comb`.

---

## Example 2: Counter

### Hardware Meaning

A counter must remember its previous value.

At each clock edge, it updates from the old count value to the next count value.

Therefore, the counter is sequential logic.

### Verilog Style

```verilog
always @(posedge clk) begin
    if (reset)
        count <= 4'b0000;
    else
        count <= count + 1;
end
```

### SystemVerilog Style

```systemverilog
always_ff @(posedge clk) begin
    if (reset)
        count <= 4'b0000;
    else
        count <= count + 1;
end
```

### Classification

`count`

Stored register value.

Use `always_ff`.

---

## Example 3: FSM current_state

### Hardware Meaning

`current_state` stores where the FSM currently is.

It must remember the previous clock cycle.

Therefore, it is sequential logic.

### SystemVerilog Style

```systemverilog
always_ff @(posedge clk) begin
    if (reset)
        current_state <= S0;
    else
        current_state <= next_state;
end
```

### Classification

`current_state`

Stored state register.

Use `always_ff`.

---

## Example 4: FSM next_state

### Hardware Meaning

`next_state` is calculated from:

- `current_state`
- input signals such as `bit_in`

It does not store anything by itself.

Therefore, it is combinational logic.

### SystemVerilog Style

```systemverilog
always_comb begin
    case (current_state)
        S0: begin
            if (bit_in)
                next_state = S1;
            else
                next_state = S0;
        end

        S1: begin
            if (bit_in)
                next_state = S1;
            else
                next_state = S2;
        end

        default: begin
            next_state = S0;
        end
    endcase
end
```

### Classification

`next_state`

Combinational calculation.

Use `always_comb`.

---

## Example 5: FIFO Flags

### Hardware Meaning

FIFO flags are calculated from the current value of `count`.

For example:

- if `count == 0`, FIFO is empty
- if `count == 4`, FIFO is full

The flags do not need to remember old values.

Therefore, they are combinational signals.

### SystemVerilog Style

```systemverilog
assign empty = (count == 0);
assign full  = (count == 4);
```

### Classification

`empty`

Combinational status flag.

Use `assign`.

`full`

Combinational status flag.

Use `assign`.

---

## Example 6: FIFO valid_write and valid_read

### Hardware Meaning

`valid_write` is true only when:

- write is requested
- FIFO is not full

`valid_read` is true only when:

- read is requested
- FIFO is not empty

They are calculated immediately from current input and flag values.

Therefore, they are combinational signals.

### SystemVerilog Style

```systemverilog
assign valid_write = write_en && !full;
assign valid_read  = read_en && !empty;
```

### Classification

`valid_write`

Combinational control signal.

Use `assign`.

`valid_read`

Combinational control signal.

Use `assign`.

---

## Example 7: FIFO Pointers and Count

### Hardware Meaning

The FIFO write pointer, read pointer, and count must remember previous values.

- `write_ptr` remembers where the next write should go.
- `read_ptr` remembers where the next read should come from.
- `count` remembers how many valid items are inside the FIFO.

Therefore, they are sequential logic.

### SystemVerilog Style

```systemverilog
always_ff @(posedge clk) begin
    if (reset) begin
        write_ptr <= 2'b00;
        read_ptr  <= 2'b00;
        count     <= 3'b000;
    end
    else begin
        if (valid_write)
            write_ptr <= write_ptr + 1;

        if (valid_read)
            read_ptr <= read_ptr + 1;

        case ({valid_write, valid_read})
            2'b10: count <= count + 1;
            2'b01: count <= count - 1;
            2'b11: count <= count;
            2'b00: count <= count;
        endcase
    end
end
```

### Classification

`write_ptr`

Stored pointer.

Use `always_ff`.

`read_ptr`

Stored pointer.

Use `always_ff`.

`count`

Stored occupancy counter.

Use `always_ff`.

---

## Quick Classification Table

| Signal / Logic | Hardware Meaning | SystemVerilog Style |
|---|---|---|
| ALU `result` | Current-input calculation | `always_comb` |
| Counter `count` | Stored register | `always_ff` |
| FSM `current_state` | Stored state | `always_ff` |
| FSM `next_state` | Current-state calculation | `always_comb` |
| FIFO `full` | Current count flag | `assign` |
| FIFO `empty` | Current count flag | `assign` |
| FIFO `valid_write` | Current control condition | `assign` |
| FIFO `valid_read` | Current control condition | `assign` |
| FIFO `write_ptr` | Stored pointer | `always_ff` |
| FIFO `read_ptr` | Stored pointer | `always_ff` |
| FIFO `count` | Stored occupancy value | `always_ff` |

---

## Main Lesson

SystemVerilog does not remove the need to understand hardware.

It makes the code style more explicit:

- `assign` means simple continuous combinational connection.
- `always_comb` means combinational calculation block.
- `always_ff` means clocked storage logic.
- `logic` is a general signal type, not a guarantee of flip-flop hardware.

The real question is always:

Does this signal need to remember previous cycles?

If yes, use `always_ff`.

If no, use `assign` or `always_comb`.