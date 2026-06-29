# Day11 Daily Log

## Topic

Sequence Detector FSM

Today's topic was designing and verifying a `1011` sequence detector using a Moore FSM.

## What I Learned

- I learned how to design an FSM based on a target input sequence.
- I learned that each FSM state can represent how much of the target sequence has already been matched.
- I learned the difference between normal detection and overlapping detection.
- I learned how to translate a state transition table into Verilog `case` logic.
- I learned how to use a self-checking testbench to send one input bit per clock cycle and compare the actual output with the expected output.

## What I Built / Produced

- Code: `src/sequence_detector.v`
- Testbench: `tb/sequence_detector_tb.v`
- Simulation output: `sim/sequence_detector_tb.vvp`
- Waveform: `waves/sequence_detector.vcd`
- Waveform screenshot: `waves/sequence_detector.png`
- Notes: `notes/sequence-detector-notes.md`
- README: `README.md`

## Key Concepts

Sequence Detector  
A sequence detector is an FSM that watches a serial input stream and checks whether a specific bit pattern appears.

Target Sequence  
The target sequence in this project is `1011`. The FSM should assert `detected = 1` when this sequence is found.

Overlapping Detection  
Overlapping detection means the last bit of one detected sequence can also be used as the first bit of the next possible sequence. For example, the input `1011011` contains two overlapping `1011` sequences.

State Meaning  
Each state represents how much of the target sequence has already been matched. For example, `S_10` means the FSM has already matched `10`.

Moore FSM  
This project uses a Moore FSM because the output `detected` depends only on `current_state`, not directly on `bit_in`.

Next-State Logic  
The next-state logic uses `current_state` and `bit_in` to decide the next state of the FSM.

Self-Checking Testbench  
The testbench sends one bit per clock cycle, waits for the FSM to update, and compares `detected` with `expected_detected`.

## Problems and Fixes

- Problem: I needed to understand why `@(posedge clk)` was placed inside the testbench task.
- Fix: I learned that every task call waits for one clock edge, so each input bit is sent to the FSM one cycle at a time.

- Problem: I questioned whether `#1` after `@(posedge clk)` was necessary.
- Fix: I learned that `#1` gives the FSM output time to update after the state register changes on the clock edge.

- Problem: I needed to distinguish between the input being stable before the clock edge and the output becoming stable after the clock edge.
- Fix: I learned that `bit_in` is prepared before the clock edge, while `detected` is checked after the FSM updates `current_state`.

## Connection to VLSI / EDA / 3D IC

Sequence detector FSMs are examples of control logic in RTL design. In real VLSI systems, FSMs are used to control datapaths, communication protocols, memory interfaces, and hardware modules.

After synthesis, the FSM state registers become flip-flops, and the next-state/output logic becomes combinational gates. This connects directly to Physical Design and STA because the paths from state registers through combinational logic to the next state must meet timing constraints.

This project also strengthens the RTL-to-hardware thinking needed for ASIC implementation, EDA flows, and later OpenROAD practice.

## One Sentence Summary

Today I implemented and verified an overlapping `1011` sequence detector FSM, learning how to turn a state transition table into Verilog RTL and validate it with a self-checking testbench.

## Next Step

- Continue to Day11: FIFO concept.
- Learn what a single-clock FIFO is and draw its basic structure, including memory array, write pointer, read pointer, full flag, and empty flag.