# Traffic Light FSM

## Overview

This project introduces and implements a traffic light finite state machine (FSM).

The concept notes explain the basic FSM structure, including state, current state, next state, state register, next-state logic, output logic, and the difference between Moore FSM and Mealy FSM.

The Verilog implementation uses a three-block FSM structure:

1. State register
2. Next-state logic
3. Output logic

The traffic light controller has four states:

* `S_NS_GREEN`
* `S_NS_YELLOW`
* `S_EW_GREEN`
* `S_EW_YELLOW`

The FSM is designed as a Moore FSM because the light outputs depend only on the current state.

## Files

```text
07_fsm_traffic_light/
  notes/
    fsm-notes.md
  src/
    traffic_light_fsm.v
  tb/
    traffic_light_fsm_tb.v
  sim/
    traffic_light_fsm_tb.vvp
  waves/
    traffic_light_fsm_sim.png
    traffic_light_fsm_wave.png
    traffic_light_fsm.vcd
  README.md
```

## Module Description

Main module: `traffic_light_fsm`

| Signal       | Direction | Width | Description                                                                 |
| ------------ | --------- | ----: | --------------------------------------------------------------------------- |
| `clk`        | input     |     1 | Clock signal. The FSM updates its current state on the rising edge.         |
| `reset`      | input     |     1 | Synchronous reset. When high, the FSM returns to `S_NS_GREEN`.              |
| `timer_done` | input     |     1 | Control signal that tells the FSM when the current light phase is finished. |
| `ns_light`   | output    |     2 | North-South traffic light output.                                           |
| `ew_light`   | output    |     2 | East-West traffic light output.                                             |

Light encoding:

| Code    | Meaning |
| ------- | ------- |
| `2'b00` | Red     |
| `2'b01` | Yellow  |
| `2'b10` | Green   |

FSM state transition order:

| Current State | Next State when `timer_done = 1` | NS Light | EW Light |
| ------------- | -------------------------------- | -------- | -------- |
| `S_NS_GREEN`  | `S_NS_YELLOW`                    | Green    | Red      |
| `S_NS_YELLOW` | `S_EW_GREEN`                     | Yellow   | Red      |
| `S_EW_GREEN`  | `S_EW_YELLOW`                    | Red      | Green    |
| `S_EW_YELLOW` | `S_NS_GREEN`                     | Red      | Yellow   |

When `timer_done = 0`, the FSM stays in the current state.

## Testbench

Testbench file: `tb/traffic_light_fsm_tb.v`

The testbench verifies the FSM using a self-checking format. It applies reset, generates clock cycles, controls `timer_done`, and checks whether `ns_light` and `ew_light` match the expected values.

Test cases:

* Reset to `S_NS_GREEN`
* Hold `S_NS_GREEN`
* Transition from `S_NS_GREEN` to `S_NS_YELLOW`
* Hold `S_NS_YELLOW`
* Transition from `S_NS_YELLOW` to `S_EW_GREEN`
* Hold `S_EW_GREEN`
* Transition from `S_EW_GREEN` to `S_EW_YELLOW`
* Hold `S_EW_YELLOW`
* Transition from `S_EW_YELLOW` back to `S_NS_GREEN`
* Hold `S_NS_GREEN` again

All test cases passed in the terminal.

## Waveform

Waveform file: `waves/traffic_light_fsm.vcd`

Waveform screenshot: `waves/traffic_light_fsm.png`

The waveform shows that the FSM starts from the North-South green state after reset. Each time `timer_done` is asserted, the FSM moves to the next traffic light state on the next rising edge of `clk`.

Observed output sequence:

```text
NS_GREEN   : ns_light = 10, ew_light = 00
NS_YELLOW  : ns_light = 01, ew_light = 00
EW_GREEN   : ns_light = 00, ew_light = 10
EW_YELLOW  : ns_light = 00, ew_light = 01
NS_GREEN   : ns_light = 10, ew_light = 00
```

This confirms that the traffic light FSM follows the expected state transition order.
