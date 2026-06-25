# FSM Notes

## Topic

Traffic light finite state machine concept.

## What Is an FSM?

FSM stands for Finite State Machine.

An FSM is a sequential digital circuit that has a limited number of states. It remembers its current state and uses that state, together with input conditions, to decide the next state and output behavior.

For a traffic light controller, the FSM does not randomly change lights. Instead, it moves through a fixed set of meaningful states, such as North-South green, North-South yellow, East-West green, and East-West yellow.

## State, Current State, and Next State

A state represents the current stage of the system.

In a traffic light controller, each light phase can be represented as one FSM state. For example, if the North-South direction is green and the East-West direction is red, the FSM can be in the state `S_NS_GREEN`.

Here, `S` means state. `NS` means North-South, and `EW` means East-West. Therefore, `S_NS_GREEN` means the state where the North-South direction has a green light.

Example states:

* `S_NS_GREEN`: North-South green, East-West red
* `S_NS_YELLOW`: North-South yellow, East-West red
* `S_EW_GREEN`: East-West green, North-South red
* `S_EW_YELLOW`: East-West yellow, North-South red

The current state tells what stage the FSM is in right now. For example, if `current_state = S_NS_GREEN`, it means the FSM is currently in the North-South green phase.

The next state is the state that the FSM is preparing to enter. For example, if the current state is `S_NS_GREEN` and the timer is done, the next state should be `S_NS_YELLOW`.

The next state is calculated by combinational logic, but it only becomes the current state at the next clock edge.

## State Transition

A state transition describes how the FSM moves from one state to another.

For the traffic light controller, the states should follow this order:

* `S_NS_GREEN` goes to `S_NS_YELLOW`
* `S_NS_YELLOW` goes to `S_EW_GREEN`
* `S_EW_GREEN` goes to `S_EW_YELLOW`
* `S_EW_YELLOW` goes back to `S_NS_GREEN`

The transition is controlled by a signal called `timer_done`.

If `timer_done = 0`, the FSM should stay in the current state.

If `timer_done = 1`, the FSM should move to the next state.

For example, when the current state is `S_NS_GREEN`, the FSM stays in `S_NS_GREEN` if `timer_done = 0`. When `timer_done = 1`, the next state becomes `S_NS_YELLOW`.

This means the FSM does not change states randomly. It follows a controlled transition order based on the current state and the timer condition.

## State Diagram

The state diagram shows how the FSM moves between states.

For this traffic light FSM, the transition order is:

`S_NS_GREEN` -> `S_NS_YELLOW` -> `S_EW_GREEN` -> `S_EW_YELLOW` -> `S_NS_GREEN`

Each transition happens when `timer_done = 1`.

Simple state diagram:

`S_NS_GREEN`
-> `S_NS_YELLOW`
-> `S_EW_GREEN`
-> `S_EW_YELLOW`
-> `S_NS_GREEN`

This diagram means the FSM starts with the North-South green light, then moves to North-South yellow, then East-West green, then East-West yellow, and finally returns to North-South green.

## Three Main Parts of an FSM

A standard FSM can be divided into three main parts: state register, next-state logic, and output logic.

The state register stores the current state. It is sequential logic because it uses flip-flops to remember the FSM state. The current state only changes at the clock edge. For example, the FSM may currently store `S_NS_GREEN`, which means the North-South direction is green and the East-West direction is red.

The next-state logic calculates the next state. It is combinational logic because it does not store information. It uses the current state and input conditions to decide where the FSM should go next. For example, if the current state is `S_NS_GREEN` and `timer_done = 1`, the next state should be `S_NS_YELLOW`. If `timer_done = 0`, the FSM should stay in `S_NS_GREEN`.

The output logic generates the output signals. It is usually combinational logic. For this traffic light FSM, the output logic decides the North-South and East-West lights based on the current state. For example, when the current state is `S_NS_GREEN`, the North-South light should be green and the East-West light should be red.

In short, the state register remembers where the FSM is, the next-state logic decides where the FSM should go, and the output logic decides what the FSM should output.

## Moore FSM and Mealy FSM

There are two common types of FSMs: Moore FSM and Mealy FSM.

In a Moore FSM, the outputs depend only on the current state.

This can be written conceptually as:

`output = function(current_state)`

For the traffic light controller, this means the light outputs are determined by the current state. For example, when the FSM is in `S_NS_GREEN`, the North-South light is green and the East-West light is red. When the FSM is in `S_EW_GREEN`, the East-West light is green and the North-South light is red.

In a Mealy FSM, the outputs depend on both the current state and the inputs.

This can be written conceptually as:

`output = function(current_state, input)`

For this traffic light controller, a Moore FSM is more suitable because the light outputs should be stable and directly tied to the current traffic light phase. The signal `timer_done` should control the next state transition, but it should not directly change the light outputs in the same moment.

Therefore, this traffic light controller will be designed as a Moore FSM.

## Traffic Light FSM State Table

The traffic light FSM can be summarized using a state table.

The table shows the relationship between the current state, the next state, and the output lights.

| Current State | If `timer_done = 0` | If `timer_done = 1` | NS Light | EW Light |
| ------------- | ------------------- | ------------------- | -------- | -------- |
| `S_NS_GREEN`  | `S_NS_GREEN`        | `S_NS_YELLOW`       | Green    | Red      |
| `S_NS_YELLOW` | `S_NS_YELLOW`       | `S_EW_GREEN`        | Yellow   | Red      |
| `S_EW_GREEN`  | `S_EW_GREEN`        | `S_EW_YELLOW`       | Red      | Green    |
| `S_EW_YELLOW` | `S_EW_YELLOW`       | `S_NS_GREEN`        | Red      | Yellow   |

This table connects the FSM concept to the future Verilog implementation.

The `timer_done` signal controls when the FSM moves to the next state. When `timer_done = 0`, the FSM stays in the current state. When `timer_done = 1`, the FSM moves to the next state in the traffic light cycle.

The light outputs are determined by the current state. This is why the traffic light controller is a Moore FSM.
