# Blocking vs Non-blocking Assignment

## Topic

This note compares blocking assignment (`=`) and non-blocking assignment (`<=`) in Verilog sequential logic.

The goal is to understand why sequential logic usually uses non-blocking assignment and how the two assignment types create different simulation results in a shift register.

## Core Difference

Blocking assignment uses `=`.

It executes immediately and in order inside a procedural block. The next statement can see the updated value from the previous statement.

Non-blocking assignment uses `<=`.

It evaluates the right-hand side first and schedules the left-hand side update to happen later in the same simulation time step. Multiple non-blocking assignments in the same clock edge update together.

## Blocking Assignment

Example:

```verilog
always @(posedge clk) begin
    q1 = d;
    q2 = q1;
    q3 = q2;
end
```

In this code, the statements execute sequentially.

At one clock edge:

```text
q1 gets d
q2 gets the new q1
q3 gets the new q2
```

As a result, the input `d` can pass through all three registers in one clock edge during simulation.

This is not the intended behavior of a three-stage shift register.

## Non-blocking Assignment

Example:

```verilog
always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;
    q3 <= q2;
end
```

In this code, all right-hand side values are read first.

At one clock edge:

```text
q1 gets old d
q2 gets old q1
q3 gets old q2
```

Then all register outputs update together.

This matches the behavior of real flip-flops triggered by the same clock edge.

## Shift Register Comparison

The intended shift register behavior is:

```text
d -> q1 -> q2 -> q3
```

If `d = 1` for one clock cycle, the non-blocking version shifts the value like this:

```text
Clock 1: q1 = 1, q2 = 0, q3 = 0
Clock 2: q1 = 0, q2 = 1, q3 = 0
Clock 3: q1 = 0, q2 = 0, q3 = 1
```

The blocking version may produce:

```text
Clock 1: q1 = 1, q2 = 1, q3 = 1
```

because each assignment immediately affects the next line.

## Waveform Observation

In the waveform comparison:

```text
q1_b, q2_b, q3_b
```

come from the blocking version.

```text
q1_nb, q2_nb, q3_nb
```

come from the non-blocking version.

The blocking version allows the input value to propagate through multiple stages in the same clock edge.

The non-blocking version shifts the input value one stage per clock cycle, which is the expected behavior of a real shift register.

## Rule of Thumb

Use blocking assignment `=` for combinational logic.

Example:

```verilog
always @(*) begin
    y = a & b;
end
```

Use non-blocking assignment `<=` for sequential logic.

Example:

```verilog
always @(posedge clk) begin
    q <= d;
end
```

## Why This Matters

Sequential logic is built from flip-flops and registers.

In real hardware, registers triggered by the same clock edge update together. Non-blocking assignment helps the Verilog simulation match this hardware behavior.

Using blocking assignment inside clocked logic can create simulation results that do not match the intended register-transfer behavior.

## Connection to VLSI / EDA / STA

Blocking and non-blocking assignment affect how RTL describes register behavior.

In VLSI and EDA flows, RTL is later synthesized into flip-flops, gates, and timing paths. Correct sequential coding style is important because STA checks register-to-register timing paths.

A typical timing path is:

```text
launch register -> combinational logic -> capture register
```

If the RTL does not correctly describe register behavior, the design can become harder to verify, synthesize, and analyze.

## One Sentence Summary

Blocking assignment updates values immediately and sequentially, while non-blocking assignment schedules register updates to happen together at the clock edge.
