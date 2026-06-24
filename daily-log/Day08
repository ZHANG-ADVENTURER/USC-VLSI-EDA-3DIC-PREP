# Day08 Daily Log

## Topic

Blocking vs Non-blocking Assignment in Verilog

## What I Learned

Today I learned the difference between blocking assignment (`=`) and non-blocking assignment (`<=`) in clocked sequential logic.

For detailed explanation, see:

`06_shift_register/notes/blocking-vs-nonblocking.md`

## What I Built / Produced

- Code:
  - `06_shift_register/src/shift_blocking.v`
  - `06_shift_register/src/shift_nonblocking.v`

- Testbench:
  - `06_shift_register/tb/shift_compare_tb.v`

- Waveform:
  - `06_shift_register/waves/shift_compare.vcd`
  - `06_shift_register/waves/shift_compare.png`

- Notes:
  - `06_shift_register/notes/blocking-vs-nonblocking.md`

- README:
  - `06_shift_register/README.md`

## Key Concepts

Blocking assignment  
See `06_shift_register/notes/blocking-vs-nonblocking.md`.

Non-blocking assignment  
See `06_shift_register/notes/blocking-vs-nonblocking.md`.

Shift register behavior  
See `06_shift_register/notes/blocking-vs-nonblocking.md`.

## Problems and Fixes

- Problem:
  I initially needed to distinguish why `=` and `<=` produce different waveform behavior in clocked logic.

- Fix:
  I compared two shift register modules using the same testbench and observed their waveform differences.

## Connection to VLSI / EDA / 3D IC

Correct use of blocking and non-blocking assignment is important for RTL coding because sequential logic is later synthesized into flip-flops and timing paths. This connects directly to register-to-register timing, STA, and RTL-to-GDS flow.

## One Sentence Summary

Today I learned why sequential Verilog logic should usually use non-blocking assignment to model registers that update together at the clock edge.

## Next Step

- Continue to FSM basics.
- Learn state register, next-state logic, and output logic.