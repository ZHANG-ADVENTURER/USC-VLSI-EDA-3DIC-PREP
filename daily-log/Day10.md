# Day10 Daily Log

## Topic

Traffic Light FSM Verilog Implementation

## What I Learned

Today I implemented a traffic light FSM in Verilog using the standard three-block FSM structure.

I learned how to separate an FSM into state register, next-state logic, and output logic. The state register updates `current_state` on the rising edge of `clk`. The next-state logic calculates `next_state` based on `current_state` and `timer_done`. The output logic generates `ns_light` and `ew_light` based on the current state.

I also learned why `timer_done` is used as a control signal instead of using only `posedge clk`. The clock controls when the FSM updates, while `timer_done` controls whether the FSM should move to the next state at that clock edge.

## What I Built / Produced

* Code: `01_verilog_basics/07_fsm_traffic_light/src/traffic_light_fsm.v`
* Testbench: `01_verilog_basics/07_fsm_traffic_light/tb/traffic_light_fsm_tb.v`
* Simulation output: `01_verilog_basics/07_fsm_traffic_light/sim/traffic_light_fsm_tb.vvp`
* Waveform: `01_verilog_basics/07_fsm_traffic_light/waves/traffic_light_fsm.vcd`
* Waveform screenshot: `01_verilog_basics/07_fsm_traffic_light/waves/traffic_light_fsm.png`
* README: `01_verilog_basics/07_fsm_traffic_light/README.md`

## Key Concepts

Three-block FSM
The FSM is divided into state register, next-state logic, and output logic.

State Register
The state register stores `current_state` and updates only on the rising edge of `clk`.

Next-State Logic
The next-state logic calculates `next_state` based on `current_state` and `timer_done`.

Output Logic
The output logic generates `ns_light` and `ew_light` based on `current_state`.

Synchronous Reset
The reset signal is checked inside `always @(posedge clk)`, so the FSM resets on the clock edge.

Self-checking Testbench
The testbench compares actual outputs with expected outputs and prints PASS or FAIL in the terminal.

Timer Done
`timer_done` is an external control signal that represents the completion of the current light phase. In this simplified FSM, the testbench manually controls `timer_done`.

## Problems and Fixes

* Problem: The output logic was accidentally nested inside the next-state logic block.

* Fix: Added the missing `end` after `endcase` to properly close the next-state logic block before starting the output logic block.

* Problem: The testbench used a different `GREEN` encoding from the source module.

* Fix: Changed `GREEN` in the testbench to `2'b10` to match the source module.

* Problem: The task name was inconsistent between definition and calls.

* Fix: Unified the task name as `check_lights`.

* Problem: The terminal output originally showed binary light values only.

* Fix: Kept the binary output because it directly matches the Verilog signal values and waveform.

## Connection to VLSI / EDA / 3D IC

FSMs are important in RTL design because they are widely used for control logic. A real chip often needs FSMs to control datapaths, memory access, communication protocols, FIFOs, and processor control units.

This traffic light FSM also connects to Physical Design and STA because the state register creates timing paths. After synthesis, `current_state` becomes flip-flops, and the next-state/output logic becomes combinational gates. These paths must meet setup and hold timing requirements.

Understanding FSM implementation helps prepare for later RTL-to-GDS, timing analysis, and control-path design topics.

## One Sentence Summary

Today I implemented and verified a traffic light FSM using state register, next-state logic, output logic, and a self-checking testbench.

## Next Step

* Continue to sequence detector FSM.
* Practice converting a pattern detection specification into states, transitions, Verilog code, and waveform verification.
