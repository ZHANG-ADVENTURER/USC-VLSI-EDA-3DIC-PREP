# Day18 Daily Log

## Topic

Register File Basics

## What I Learned

Today I learned the basic structure and behavior of a register file.

A register file is a group of registers that can be accessed by address. Unlike a FIFO, which reads data in first-in-first-out order, a register file allows the user to choose which register to read or write using address signals.

The register file designed today has four 8-bit registers, one write port, and two read ports.

The most important structure is:

4 registers x 8-bit data width

This means the register file contains:

- regs[0]
- regs[1]
- regs[2]
- regs[3]

Each register stores one 8-bit value.

I also learned that the write operation and read operation can have different timing behavior.

The write operation is sequential because writing data into a register means storing a value. Therefore, it happens on the rising edge of the clock.

The read operation in this design is combinational because read_data1 and read_data2 are directly selected from the register array using read_addr1 and read_addr2. Changing the read address immediately changes the read output after a small simulation delay.

The key design style is:

clocked write + combinational read

## What I Built / Produced

Today I built and verified a basic register file project.

Produced files:

- `01_verilog_basics/12_register_file_basic/src/register_file_basic.v`
- `01_verilog_basics/12_register_file_basic/tb/register_file_basic_tb.v`
- `01_verilog_basics/12_register_file_basic/sim/register_file_basic_tb.vvp`
- `01_verilog_basics/12_register_file_basic/waves/register_file_basic.vcd`
- `01_verilog_basics/12_register_file_basic/waves/register_file_basic_wave.png`
- `01_verilog_basics/12_register_file_basic/waves/register_file_basic_sim.png`
- `01_verilog_basics/12_register_file_basic/README.md`

The RTL module includes:

- clock input
- synchronous reset
- write enable
- write address
- write data
- two read addresses
- two read data outputs
- internal register array

The testbench verifies:

- reset behavior
- writing to regs[0]
- writing to regs[1]
- writing to regs[2]
- writing to regs[3]
- reading two registers at the same time
- reading the same register from both read ports
- overwriting regs[0]
- confirming other registers remain unchanged

The waveform confirms that the register file supports clocked write, combinational read, two read ports, and overwrite behavior.

## Key Concepts

Register File

A register file is a group of registers that can be accessed by address. It is commonly used in datapaths and CPU-like structures to store operands and results.

Address-Based Access

A register file uses address signals to select which register to read or write. This is different from FIFO, which uses order-based access.

Write Port

The write port controls where new data is stored. It includes write_en, write_addr, and write_data.

Read Port

A read port selects and outputs data from a register. This project used two read ports, so two registers can be read at the same time.

Clocked Write

Writing into the register file is sequential logic. The selected register updates on the rising edge of the clock when write_en is high.

Combinational Read

Reading from the register file is combinational in this design. read_data1 and read_data2 update based on read_addr1 and read_addr2 without waiting for a clock edge.

Internal Register Array

The internal register array stores the actual data values. In this design, regs[0] to regs[3] each store one 8-bit value.

Loop Index

The integer i is used as a for-loop index during reset. It allows the reset logic to clear all four registers without manually writing each reset assignment.

Synchronous Reset

The reset signal clears the register file at the rising edge of the clock. It does not clear the registers immediately when reset changes.

## Problems and Fixes

Problem:

I initially wrote the loop update as i += 1.

Fix:

I learned that i += 1 is more SystemVerilog-style and may not be compatible with a traditional Verilog .v file and basic iverilog command. For this Verilog project, I changed it to i = i + 1.

Problem:

I initially used always_ff in the RTL source file.

Fix:

I learned that always_ff is SystemVerilog syntax. Since the project is still using .v files and traditional Verilog style, I changed it to always @(posedge clk).

Problem:

I needed to understand why the loop variable i is declared as integer.

Fix:

I learned that integer i is used as a procedural loop index for the reset for-loop. It helps access regs[0], regs[1], regs[2], and regs[3] during reset. It is not the main data stored in the register file.

Problem:

I was confused about why FIFO read used clocked logic while register file read is combinational.

Fix:

I learned that register file read does not consume data or change internal state. It only selects data by address. FIFO read consumes the oldest data and changes read_ptr and count, so the FIFO read operation is usually clocked in the design I wrote before.

Problem:

The testbench output did not display the full test name.

Fix:

I learned that input [8*40-1:0] test_name only allows up to 40 characters. Longer strings can be truncated. Increasing the width to input [8*80-1:0] allows longer test descriptions to print correctly.

Problem:

I wondered why the testbench used %h even though the data width was only 8-bit.

Fix:

I learned that %h is a display format for hexadecimal output. It does not mean the data is wider than 8 bits. For 8-bit values, hexadecimal display is convenient because 8 bits correspond to two hex digits.

## Connection to VLSI / EDA / 3D IC

Register files are important because they are core datapath structures in digital systems.

In CPU-like datapaths, a register file stores operands and results. ALUs often read operands from a register file and write results back into it.

This connects directly to datapath and control separation. The register array, write_data, and read_data signals are datapath elements. The write enable and address signals are control-related signals because they decide which register is accessed and when data is written.

For VLSI and EDA, register files introduce important implementation concepts such as storage elements, read/write ports, address decoding, mux-based read paths, and timing behavior.

For Physical Design and STA, register files and their surrounding muxes, buses, and ALU connections can affect area, routing, timing delay, and power.

For 3D IC and advanced packaging, register files are still basic on-chip storage structures. Understanding how data is stored, selected, and transferred helps prepare for larger system-level data movement, memory access, and chiplet communication topics.

## One Sentence Summary

Today I built and verified a basic 4 x 8 register file and learned the key difference between clocked write, combinational read, address-based register access, and FIFO order-based access.

## Next Step

Continue Week 3 Digital Architecture Bridge by studying valid/ready handshake basics and how producer-consumer modules communicate using control and status signals.