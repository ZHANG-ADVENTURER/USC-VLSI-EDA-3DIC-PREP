# 01 Verilog Basics: Basic Gates, Wires, and HDLBits Practice

## Overview

This folder records my early Verilog practice for basic combinational logic.

The work started with a simple 2-input AND gate project, including source code, testbench, simulation output, and waveform generation. After that, I continued practicing basic Verilog syntax and gate-level logic through HDLBits problems.

The main focus of this section is learning how to describe simple digital logic circuits in Verilog and understand how the code maps to real hardware gates.

## Topics Covered

* Basic Verilog module structure
* Input and output port declarations
* `wire` signals
* `assign` statements
* Basic combinational logic
* AND, OR, NOT, XNOR gates
* Internal wire declarations
* Translating logic diagrams into Verilog
* HDLBits online verification
* Simple simulation workflow with Icarus Verilog and GTKWave

## Completed Work

### Local AND Gate Project

I built a basic 2-input AND gate in Verilog.

The circuit has two inputs, `a` and `b`, and one output, `y`. The output becomes high only when both inputs are high.

This part included:

* Verilog source code
* A local testbench
* Icarus Verilog simulation
* VCD waveform generation
* GTKWave waveform viewing
* A saved waveform screenshot

### HDLBits Verilog Basics Practice

I completed several HDLBits exercises in the Verilog Basics section.

The practice included:

* Simple wire connection
* Multiple wire assignments
* Inverter logic
* Basic gates
* Declaring internal wires
* 7458 chip implementation

The 7458 chip problem helped me practice reading a gate-level diagram and translating it into Verilog logic using `assign` statements and intermediate `wire` signals.

## Function

This folder is not only for one AND gate anymore. It now represents my first stage of Verilog basics practice.

The main function of this section is to help me understand how simple digital circuits are described, simulated, and verified using Verilog.

The local AND gate project shows the basic workflow of writing Verilog code, creating a testbench, running a simulation, and checking the waveform.

The HDLBits exercises expand this foundation by practicing more combinational logic patterns and by using HDLBits hidden testbenches to verify correctness online.

## Project Structure

```text
01_basic_gates/
  HDLBits
    Basics.png
    7458.png
  sourcecode/
    and_gate.v
  testbench/
    and_gate_tb.v
  simulation/
    and_gate_tb.vvp
  waveforms/
    and_gate.vcd
    and_gate_waveform.png
  README.md
