# Memory Interface Basics Notes

## Topic

Memory Interface Awareness

## Overview

This note explains the basic concept of a memory interface in a digital system.

A memory interface is the group of signals used by a module to access memory.

The main questions are:

Which memory location should be accessed?

Is the module reading or writing?

If writing, what data should be written?

If reading, what data comes back?

Does the memory return data immediately or after some latency?

This topic connects previous work on register files, FIFO, datapath/control separation, and valid/ready handshake.

---

## 1. What Is a Bus?

A bus is a group of signals used together.

A bus is not just one wire.

For example:

`input [7:0] data_in`

This means `data_in` is an 8-bit bus.

It contains 8 parallel signal lines:

- data_in[7]
- data_in[6]
- data_in[5]
- data_in[4]
- data_in[3]
- data_in[2]
- data_in[1]
- data_in[0]

A 1-bit wire carries one bit.

An 8-bit bus carries eight bits in parallel.

A 32-bit bus carries thirty-two bits in parallel.

The bus width tells how many bits can be transferred at the same time.

---

## 2. Data Bus

A data bus carries actual data values.

Examples:

- write_data[7:0]
- read_data[7:0]
- data_in[31:0]
- data_out[31:0]

A data bus belongs to the datapath because it carries real payload data.

Important distinction:

A data bus carries data.

A register or memory stores data.

For example, `write_data[7:0]` carries an 8-bit value into memory.

The memory array stores that value.

---

## 3. Address Bus

An address bus selects which memory location should be accessed.

Example:

`addr[3:0]`

This is a 4-bit address bus.

A 4-bit address bus can represent 16 locations because 2^4 = 16.

The address values range from:

- 0
- 1
- 2
- ...
- 15

The address bus does not carry the main payload data.

It selects the location where data should be read or written.

Therefore, an address bus is usually considered a control or indexing signal, even though physically it is also a group of wires.

---

## 4. Control Signals

Control signals decide what operation happens.

Common memory control signals include:

- read_en
- write_en
- valid
- ready
- byte_enable
- write_mask

Examples:

`write_en`

Decides whether the memory should perform a write operation.

`read_en`

Decides whether the memory should perform a read operation.

`valid`

Can indicate that a memory request is meaningful.

`ready`

Can indicate that the memory or receiver can accept the request.

Control signals do not carry the main payload data.

They control when and how data moves.

---

## 5. Basic Memory Model

A simple memory can be understood as a table.

| Address | Data |
|---:|---|
| 0 | data0 |
| 1 | data1 |
| 2 | data2 |
| 3 | data3 |

A 16 x 8 memory means:

- 16 memory locations
- each location stores 8-bit data

In Verilog, this kind of memory can be represented as:

`reg [7:0] mem [0:15];`

This means:

- mem[0] stores 8-bit data
- mem[1] stores 8-bit data
- ...
- mem[15] stores 8-bit data

---

## 6. Basic Memory Interface Signals

A simple memory interface may contain:

- clk
- reset
- addr
- write_en
- write_data
- read_en
- read_data

Signal meaning:

`clk`

Controls synchronous memory operations.

`reset`

Initializes or clears control state if needed.

`addr`

Selects which memory location to access.

`write_en`

Enables a write operation.

`write_data`

The data value to write into memory.

`read_en`

Enables a read operation.

`read_data`

The data returned from memory.

---

## 7. Write Operation

A write operation stores data into memory.

Example:

addr = 4'd3

write_data = 8'hA5

write_en = 1

At the active clock edge, the memory stores:

mem[3] = 8'hA5

Writing is usually sequential because the memory contents are updated and stored.

This means write operation usually depends on the clock edge.

---

## 8. Read Operation

A read operation returns data from memory.

There are two common styles:

Combinational read

The read data changes when the address changes.

Example idea:

read_data = mem[addr]

This is similar to the register file project.

Synchronous read

The module gives an address and read request in one cycle.

The read data becomes valid in a later cycle, often the next clock cycle.

This creates read latency.

Many real memories, SRAMs, and FPGA block RAMs use synchronous read behavior.

---

## 9. Read Latency

Read latency means the read data is not available immediately after the address is provided.

A common example is 1-cycle latency:

Cycle N:

The module provides addr and read_en.

Cycle N+1:

The memory returns valid read_data.

This is different from combinational read, where changing the address can quickly change the output.

Important rule:

Register file read can be designed as combinational.

Larger memory read is often synchronous and may have latency.

---

## 10. Register File vs Memory

Register file and memory are similar because both use address-based access.

Both can select a location using an address.

However, they are not always the same.

| Feature | Register File | Memory |
|---|---|---|
| Access style | Address-based | Address-based |
| Typical size | Small | Larger |
| Common use | CPU operands and results | Larger data storage |
| Read ports | Often multiple | Usually fewer |
| Read behavior | Often combinational or fast | Often synchronous with latency |
| Implementation | Registers or small arrays | SRAM, block RAM, or memory array |

The key correction is:

Register file and memory are both address-based.

But memory is not always instantaneous.

---

## 11. FIFO vs Memory

FIFO and memory both store data, but their access rules are different.

Memory

Accesses data by address.

The user selects which location to read or write.

FIFO

Accesses data by order.

The first data written must be the first data read.

Main difference:

Memory = address-based access

FIFO = order-based access

Example:

In memory, the user can read mem[5] directly by setting addr = 5.

In FIFO, the user cannot directly choose the fifth stored item. The FIFO returns the oldest valid data according to read order.

---

## 12. Bus Classification in Memory Interface

| Signal | Type | Classification |
|---|---|---|
| addr[3:0] | Address bus | Control / indexing |
| write_data[7:0] | Data bus | Datapath |
| read_data[7:0] | Data bus | Datapath |
| write_en | Control signal | Control |
| read_en | Control signal | Control |
| valid | Control/status signal | Control/status |
| ready | Control/status signal | Control/status |

Main idea:

Data bus carries data.

Address bus selects location.

Control signals decide the operation.

---

## 13. Connection to Previous Projects

Register File

The register file project used address-based access.

read_addr1 and read_addr2 selected which registers to read.

write_addr selected which register to write.

This is similar to a small memory interface.

FIFO

FIFO used memory-like storage internally, but the outside interface did not allow random address access.

The user could only write to the next write location and read from the next read location.

Handshake

A memory interface can also use valid and ready.

valid can indicate that a memory request is active.

ready can indicate that the memory can accept the request or return data.

Datapath vs Control

write_data and read_data are datapath.

addr, write_en, read_en, valid, and ready are control or status signals.

---

## 14. Common Mistakes

### Mistake 1: Thinking a bus is one wire

Correct idea:

A bus is a group of wires used together.

An 8-bit bus has 8 parallel signal lines.

---

### Mistake 2: Thinking data bus stores data

Correct idea:

A data bus carries data.

Registers and memory arrays store data.

---

### Mistake 3: Thinking 4-bit address means 4 locations

Correct idea:

A 4-bit address can select 16 locations because 2^4 = 16.

---

### Mistake 4: Thinking all address-based reads are instantaneous

Correct idea:

Register file read can be combinational.

Memory read is often synchronous and may have latency.

---

### Mistake 5: Confusing memory and FIFO

Correct idea:

Memory is address-based.

FIFO is order-based.

---

## 15. Connection to VLSI / EDA / Physical Design / STA

Memory interfaces are important in VLSI and EDA because data movement often depends on memory access.

In RTL design, memory interfaces define how modules read and write stored data.

In Physical Design, memory blocks, address buses, data buses, and control signals affect placement, routing, wirelength, congestion, power, and timing.

Data buses can be wide and may create routing pressure.

Address decoding can create timing delay.

Control signals such as read_en, write_en, valid, and ready create control timing paths.

In STA, memory-related paths may include:

- register to memory address path
- register to memory write data path
- memory read data to register path
- control signal paths such as read_en and write_en

Understanding memory interface basics prepares me for later topics such as register-to-register timing paths, memory latency, bus protocols, pipeline stalls, and RTL-to-GDS implementation.

---

## 16. Connection to USC Courses

EE457

Memory interface concepts support digital system design, datapath organization, CPU-like structures, and address-based data storage.

EE560L

Memory access, read/write control, and latency awareness are useful for structured RTL design and testbench verification.

EE577B

Memory interfaces connect RTL coding to synthesis, implementation constraints, and timing-aware digital design.

---

## 17. Simple Memory Interface Diagram

The following diagram shows a simple memory interface.

A module sends address, write data, and control signals to memory.

The memory returns read data.

    Requesting Module                         Memory
    +------------------+                      +------------------+
    |                  |        addr          |                  |
    |                  | -------------------> |                  |
    |                  |      write_data      |                  |
    |                  | -------------------> |                  |
    |                  |       write_en       |                  |
    |                  | -------------------> |                  |
    |                  |        read_en       |                  |
    |                  | -------------------> |                  |
    |                  |      read_data       |                  |
    |                  | <------------------- |                  |
    +------------------+                      +------------------+

Signal directions:

| Signal | Direction | Meaning |
|---|---|---|
| addr | Module -> Memory | Selects the memory location |
| write_data | Module -> Memory | Data to be written into memory |
| write_en | Module -> Memory | Enables a write operation |
| read_en | Module -> Memory | Enables a read operation |
| read_data | Memory -> Module | Data returned from memory |

---

## 18. Memory Interface Signal Classification

A memory interface contains datapath signals and control signals.

Datapath signals carry actual data.

Control signals decide what operation happens.

| Signal | Type | Classification | Reason |
|---|---|---|---|
| addr | Address bus | Control / indexing | Selects which memory location is accessed |
| write_data | Data bus | Datapath | Carries the data value to be stored |
| read_data | Data bus | Datapath | Carries the data value returned by memory |
| write_en | Control signal | Control | Decides whether memory should be written |
| read_en | Control signal | Control | Decides whether memory should be read |
| clk | Clock signal | Timing control | Controls synchronous memory operations |
| valid | Control/status signal | Control/status | Indicates that the request is meaningful |
| ready | Control/status signal | Control/status | Indicates that memory can accept or complete the request |

Important rule:

The data bus carries data.

The address bus selects location.

The control signals decide the operation.

---

## 19. Example: Write Operation

A write operation stores data into memory.

Example values:

addr = 4'd3

write_data = 8'hA5

write_en = 1

Meaning:

The module wants to write the value A5 into memory location 3.

At the active clock edge, the memory updates:

mem[3] becomes 8'hA5.

The write operation is usually sequential because memory contents are being updated and stored.

Signal roles:

addr

Selects location 3.

write_data

Carries the data A5.

write_en

Allows the write operation.

clk

Defines when the write is committed.

---

## 20. Example: Read Operation

A read operation returns data from memory.

Example values:

addr = 4'd3

read_en = 1

mem[3] = 8'hA5

Meaning:

The module wants to read memory location 3.

The memory returns A5 through read_data.

There are two common read styles.

Combinational read

The read output changes when the address changes.

This is similar to the register file project.

Synchronous read

The module provides addr and read_en in one cycle.

The memory returns read_data in a later cycle, often the next clock cycle.

This creates read latency.

---

## 21. Combinational Read vs Synchronous Read

| Feature | Combinational Read | Synchronous Read |
|---|---|---|
| Output timing | Changes after address changes | Updates after a clock edge |
| Read latency | Almost immediate, except combinational delay | Often 1 cycle or more |
| Common use | Small register files or simple arrays | Larger memories, SRAMs, block RAMs |
| Clock needed for read output | No | Usually yes |
| Easier for beginner RTL | Yes | More realistic for memory systems |

Important distinction:

A register file can use combinational read.

A larger memory often uses synchronous read.

This is why memory interface design must consider latency.

---

## 22. 4-bit Address Example

A 4-bit address bus can access 16 locations.

Reason:

4 bits can represent 2^4 combinations.

The address values are:

0, 1, 2, 3, 4, 5, 6, 7,

8, 9, 10, 11, 12, 13, 14, 15

So a 4-bit address can select locations 0 through 15.

Example memory size:

16 x 8 memory

Meaning:

16 memory locations.

Each location stores 8-bit data.

---

## 23. Bus Width Example

write_data[7:0] is an 8-bit data bus.

This means it contains 8 parallel signal lines.

The signal lines are:

write_data[7]

write_data[6]

write_data[5]

write_data[4]

write_data[3]

write_data[2]

write_data[1]

write_data[0]

If write_data = 8'hA5, then the bus is carrying an 8-bit value.

Important distinction:

The bus carries the value.

The memory stores the value.

---

## 24. Memory Interface and Handshake

A more advanced memory interface may use valid and ready.

Example:

request_valid

The module has a valid memory request.

memory_ready

The memory can accept the request.

A request is accepted only when both are high:

request accepted = request_valid && memory_ready

This is the same valid / ready idea from the handshake topic.

The difference is that the payload now includes memory access information:

- addr
- write_data
- read/write control

So a memory request is not just data. It is a package of address, data, and control information.

---

## 25. Final Memory Interface Rule

For any memory interface, identify three groups of signals:

Address signals

These select the memory location.

Data signals

These carry data into or out of memory.

Control signals

These decide whether the operation is read, write, valid, or ready.

The simplified structure is:

address + data + control = memory interface

The key idea is:

Memory stores data by address, and the memory interface defines how another module reads or writes that data.

---

## One Sentence Summary

A memory interface is a group of address, data, and control signals that allows a digital module to read from or write to memory.
