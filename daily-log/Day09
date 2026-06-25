# Day09 Daily Log

## Topic

Traffic Light FSM Concept

## What I Learned

Today I learned the basic concept of a finite state machine (FSM). An FSM is a sequential circuit that stores its current state and uses combinational logic to calculate the next state and output behavior.

I learned that a traffic light controller can be modeled as an FSM because it moves through a limited number of meaningful states, such as `S_NS_GREEN`, `S_NS_YELLOW`, `S_EW_GREEN`, and `S_EW_YELLOW`.

I also learned the difference between `current_state` and `next_state`. The `current_state` represents the state that the FSM is currently in, while the `next_state` is calculated by next-state logic and only becomes the current state at the next clock edge.

## What I Built / Produced

* Code: Not implemented today
* Testbench: Not implemented today
* Waveform: Not generated today
* Notes: `01_verilog_basics/07_fsm_traffic_light/notes/fsm-notes.md`
* README: `01_verilog_basics/07_fsm_traffic_light/README.md`
* Diagram: `01_verilog_basics/07_fsm_traffic_light/screenshots/state_diagram.png`

## Key Concepts

FSM
A finite state machine is a sequential circuit with a limited number of states. It remembers its current state and uses that state to decide future behavior.

State
A state represents the current stage of the system. In the traffic light FSM, examples include `S_NS_GREEN`, `S_NS_YELLOW`, `S_EW_GREEN`, and `S_EW_YELLOW`.

Current State
The current state tells what stage the FSM is in right now.

Next State
The next state is the state that the FSM is preparing to enter. It is calculated by combinational logic but only becomes the current state at the next clock edge.

State Register
The state register stores the current state. It is sequential logic because it uses flip-flops and updates on the clock edge.

Next-State Logic
Next-state logic calculates the next state based on the current state and input conditions such as `timer_done`.

Output Logic
Output logic generates the output signals based on the current state.

Moore FSM
A Moore FSM generates outputs based only on the current state. The traffic light controller is a Moore FSM because the light outputs are determined by the traffic light phase.

Mealy FSM
A Mealy FSM generates outputs based on both the current state and inputs.

## Problems and Fixes

* Problem: I initially needed to clarify the difference between the project folder number and the actual day number.

* Fix: I confirmed that Day 8 is the FSM traffic light concept task, and the work should be placed inside `01_verilog_basics/07_fsm_traffic_light/`.

* Problem: Some note content was split too much, making the explanation less continuous.

* Fix: I reorganized the FSM explanation so that related concepts such as FSM, state, current state, next state, and naming convention stay together in one coherent section.

## Connection to VLSI / EDA / 3D IC

FSMs are important in VLSI and digital design because real chips need control logic. Many hardware blocks use FSMs to control datapaths, memory access, communication protocols, counters, FIFOs, and processor control units.

In RTL design, FSMs are written using registers and combinational logic. After synthesis, the state register becomes flip-flops, and the next-state/output logic becomes gates.

This connects to Physical Design and STA because FSM state registers create timing paths. The path from the current state register, through next-state logic, and back into the state register must meet setup and hold timing requirements.

Understanding FSMs helps build the foundation for later topics such as RTL design, timing analysis, control logic, FIFO control, and RTL-to-GDS flow.

## One Sentence Summary

Today I learned that an FSM is a sequential control circuit that stores its current state and uses combinational logic to decide the next state and outputs.

## Next Step

* Implement the traffic light FSM in Verilog using state register, next-state logic, and output logic.
* Write a testbench to simulate state transitions.
* Generate a waveform to verify that the FSM changes states correctly when `timer_done` is asserted.
