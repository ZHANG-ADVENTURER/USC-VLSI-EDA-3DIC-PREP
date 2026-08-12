# RTL / Digital Foundation

## Project Scope

This feature presents the implemented RTL work that supports later study of synthesis, STA, and Physical Design. It intentionally emphasizes structured sequential designs rather than early gate and mux exercises.

## Featured Implementations

### Simple FIFO

A single-clock, 8-bit-wide, depth-4 FIFO using a memory array, read/write pointers, occupancy count, full/empty flags, and overflow/underflow protection.

- [Project overview](../../01_verilog_basics/09_simple_fifo/README.md)
- [RTL source](../../01_verilog_basics/09_simple_fifo/src/simple_fifo.v)
- [Self-checking testbench](../../01_verilog_basics/09_simple_fifo/tb/simple_fifo_tb.v)
- [Waveform data](../../01_verilog_basics/09_simple_fifo/waves/simple_fifo.vcd)

### Sequence Detector FSM

A Moore FSM that detects the overlapping `1011` sequence, with explicit state-transition reasoning and a self-checking testbench.

- [Project overview](../../01_verilog_basics/08_sequence_detector/README.md)
- [RTL source](../../01_verilog_basics/08_sequence_detector/src/sequence_detector.v)
- [Self-checking testbench](../../01_verilog_basics/08_sequence_detector/tb/sequence_detector_tb.v)
- [Waveform image](../../01_verilog_basics/08_sequence_detector/waves/sequence_detector_wave.png)

### Register File

A 4-entry, 8-bit register file with one clocked write port, two combinational read ports, reset behavior, and a self-checking testbench.

- [Project overview](../../01_verilog_basics/12_register_file_basic/README.md)
- [RTL source](../../01_verilog_basics/12_register_file_basic/src/register_file_basic.v)
- [Self-checking testbench](../../01_verilog_basics/12_register_file_basic/tb/register_file_basic_tb.v)
- [Waveform image](../../01_verilog_basics/12_register_file_basic/waves/register_file_basic_wave.png)

## Additional Implemented Work

- [Traffic-light Moore FSM](../../01_verilog_basics/07_fsm_traffic_light/README.md)
- [Traffic-light RTL](../../01_verilog_basics/07_fsm_traffic_light/src/traffic_light_fsm.v)
- [Traffic-light self-checking testbench](../../01_verilog_basics/07_fsm_traffic_light/tb/traffic_light_fsm_tb.v)

## Capability Boundary

Ready/valid handshakes, datapath/control separation, memory interfaces, and pipelines are currently documented as conceptual study topics. They are not presented here as implemented RTL projects. Basic gates, combinational modules, counters, waveform drills, and HDLBits screenshots remain available in the [complete RTL learning tree](../../01_verilog_basics/README.md).
