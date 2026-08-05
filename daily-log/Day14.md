# Day 14 Daily Log

## Topic

Today's topic: Verilog src/tb re-practice, testbench checking, module hierarchy, adder structures, and HDLBits exercises.

## What I Learned

- Rewrote and reviewed several Verilog source modules and testbenches from earlier projects.
- Practiced distinguishing combinational logic, sequential logic, and FSM-based designs.
- Reviewed how to write testbenches that not only generate waveforms, but also check expected results.
- Learned that `full` and `empty` in a FIFO are status output ports, not internal-only signals, because external modules need them to decide whether to read or write.
- Reviewed shift register types: SISO, SIPO, PISO, and PIPO.
- Practiced HDLBits module hierarchy problems using provided modules such as `add16`.
- Learned how to build a 32-bit adder from two 16-bit adders.
- Learned why module instantiation must be written structurally, not inside an `always` block.
- Learned the idea of a carry-select adder: calculate both possible upper-half results in parallel, then use a mux to select the correct one.
- Reviewed two's complement subtraction: `a - b = a + (~b) + 1`.
- Reviewed how XOR can work as a controlled inverter: `x ^ 0 = x`, but `x ^ 1 = ~x`.

## What I Built / Produced

- Code:
  - Re-practiced src modules for basic gates, combinational circuits, sequential circuits, FSMs, and FIFO-related logic.
  - Reviewed modules such as `and_gate`, `decoder2to4`, `full_adder`, `mux2to1`, `alu_4bit`, `counter`, `shift_register`, `traffic_light`, `sequence_detector`, and `simple_fifo`.

- Testbench:
  - Rewrote and checked testbenches for earlier modules.
  - Practiced using task-based checking in testbenches.

- Waveform:
  - Reviewed the relationship between source code, testbench, `.vvp`, `.vcd`, and waveform output.
  - Confirmed that `$dumpfile` and `$dumpvars` are needed when waveform output is required.

- Notes:
  - Added understanding of module hierarchy, carry propagation, carry-select logic, XOR-controlled inversion, and two's complement subtraction.
  - Reviewed why Verilog `reg` does not always mean a physical register; it depends on whether the logic is driven by clocked sequential logic.

- README:
  - No major README rewrite today. The main focus was src/tb re-practice and HDLBits concept reinforcement.

## Key Concepts

Combinational logic  
Output depends only on current inputs. Examples include AND gate, mux, decoder, full adder, and basic ALU operations. These usually use `assign` or `always @(*)`.

Sequential logic  
Output depends on current inputs and previously stored state. Examples include counter and shift register. These require `clk`, usually use `always @(posedge clk)`, and should use non-blocking assignment `<=`.

FSM  
A finite state machine uses states to remember where the system currently is. Traffic light and sequence detector are FSM-style designs. They are usually divided into state register, next-state logic, and output logic.

Testbench task  
A task can make repeated test cases cleaner. The correct order is: assign input values, wait for the DUT output to settle, then compare the actual output with the expected output.

`timescale`  
The directive must use the backtick symbol: `` `timescale 1ns/1ps ``. Writing `.timescale` is incorrect.

Module instantiation  
Instantiating a module means creating hardware structure. It must be written directly inside a module body, not inside `always`, `if`, or `case`.

Provided module  
In HDLBits, a module such as `add16` may be provided by the platform. I can instantiate it even if I do not see its internal code.

Missing lower-level module  
Some HDLBits problems provide a higher-level module that internally depends on a lower-level module, such as `add1`. In that case, I must write the missing lower-level module.

Carry propagation  
In a ripple-carry adder, the carry from the lower bit or lower block must propagate to the next bit or block. This makes the design simple but slower.

Carry-select adder  
A carry-select adder improves speed by calculating both possible upper-half results in advance: one assuming carry-in is 0 and one assuming carry-in is 1. After the real lower carry is known, a mux selects the correct upper result.

Area-delay tradeoff  
Carry-select adders are faster than ripple-carry adders, but they use more hardware because part of the adder is duplicated.

Two's complement subtraction  
Subtraction can be implemented using an adder because `a - b = a + (~b) + 1`.

XOR as controlled inverter  
For one bit, `x ^ 0 = x` and `x ^ 1 = ~x`. Therefore, XOR with a control signal can either keep `b` unchanged or invert `b`.

FIFO status flags  
`full` and `empty` are output ports because outside modules need to know whether the FIFO can accept writes or provide valid reads.

## Problems and Fixes

- Problem:
  The AND gate testbench passed expected values into a task, but did not assign those values to the actual DUT inputs.

  Fix:
  Inside the task, assign `a = a_exp` and `b = b_exp` before waiting and checking `y`.

- Problem:
  Wrote `.timescale` instead of `` `timescale ``.

  Fix:
  Use the Verilog compiler directive with a backtick: `` `timescale 1ns/1ps ``.

- Problem:
  The testbench task had multiple statements but was not clearly wrapped in `begin ... end`.

  Fix:
  Put the task body inside `begin ... end` after the input declarations.

- Problem:
  VSCode showed `unknown module 'and_gate'`.

  Fix:
  This is usually because the language server did not include the source file. During real compilation, include both the source file and the testbench file in the `iverilog` command.

- Problem:
  Initially treated `full` and `empty` as optional internal FIFO details.

  Fix:
  Understood that they are status output ports, because external modules need them to avoid overflow and underflow.

- Problem:
  Confused why `a - b` can be implemented as `a + (~b) + 1`.

  Fix:
  Reviewed two's complement representation. In fixed-width binary, `-b` is represented as `~b + 1`, so subtraction can be performed by an adder.

- Problem:
  Confused why XOR can conditionally invert `b`.

  Fix:
  Reviewed XOR truth table. XOR with `0` keeps the bit unchanged; XOR with `1` flips the bit.

- Problem:
  Tried to instantiate `add16` inside an `always` / `case` block for the carry-select adder.

  Fix:
  Understood that module instantiation describes hardware structure and must be placed directly inside the module body. Both upper adders should exist in parallel, and a mux selects the correct output.

## Connection to VLSI / EDA / 3D IC

Today's work connects directly to RTL design and digital hardware implementation. Basic gates, muxes, adders, counters, shift registers, FSMs, and FIFOs are common building blocks in real chip design. Understanding which signals are ports, which signals are internal, and which logic should be combinational or sequential is essential for writing synthesizable RTL.

The HDLBits hierarchy exercises are especially relevant to VLSI design because real chips are built hierarchically: small modules are composed into larger functional blocks. The adder exercises also introduced an important physical design tradeoff: carry-select adders reduce timing delay by using more hardware area. This connects directly to PPA analysis, where designers must balance performance, power, and area.

FIFO status signals such as `full` and `empty` also connect to system-level RTL design, where modules communicate through valid data transfer rules. These ideas are important for bus protocols, streaming interfaces, NoC design, and later CDC FIFO concepts.

## One Sentence Summary

Today I strengthened my Verilog foundation by rewriting src/tb files, debugging testbench structure, and practicing HDLBits hierarchy problems involving adders, carry propagation, XOR-controlled subtraction, and hardware tradeoffs.

## Next Step

- Begin working on SystemVerilog Awareness
- Continue HDLBits exercises in the `Procedures` and `More Verilog Features` sections.