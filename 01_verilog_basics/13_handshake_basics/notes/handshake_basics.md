# Handshake Basics Notes

## Topic

Valid / Ready Handshake Basics

## Overview

This note explains the basic valid / ready handshake protocol used for communication between digital modules.

In previous projects, I built individual modules such as ALU, FSM, FIFO, and register file. The next step is to understand how modules communicate with each other.

A valid / ready handshake is used when one module sends data and another module receives data.

The key rule is:

transfer happens when valid and ready are both 1.

In synchronous RTL, this usually means that at the clock edge, if valid = 1 and ready = 1, the data is successfully accepted by the consumer.

---

## 1. Why Handshake Is Needed

In a digital system, one module often sends data to another module.

Example:

Producer -> FIFO -> Consumer

However, the producer and consumer may not always be ready at the same time.

The producer may have data, but the consumer may not be ready.

The consumer may be ready, but the producer may not have valid data.

Therefore, the system needs a protocol to answer three questions:

Is the data valid?

Is the receiver ready?

When does the transfer actually happen?

This is the purpose of the valid / ready handshake.

---

## 2. Producer

The producer is the module that generates or sends data.

Examples:

- data generator
- ALU output stage
- memory read unit
- upstream module
- FIFO output side

The producer controls valid.

valid means:

The current data from the producer is meaningful and can be accepted.

If valid = 1, the producer has valid data.

If valid = 0, the producer does not currently provide useful data.

---

## 3. Consumer

The consumer is the module that receives data.

Examples:

- FIFO input side
- register write stage
- memory write unit
- downstream module
- processing unit

The consumer controls ready.

ready means:

The consumer can accept data now.

If ready = 1, the consumer is able to receive data.

If ready = 0, the consumer is not able to receive data at this moment.

---

## 4. Signal Directions

The signal directions are important.

data

Direction: Producer -> Consumer

Meaning: the actual data being transferred

valid

Direction: Producer -> Consumer

Meaning: the producer says the data is valid

ready

Direction: Consumer -> Producer

Meaning: the consumer says it can accept data

Simple diagram:

    Producer                         Consumer
    +----------+       data       +----------+
    |          | ----------------> |          |
    |          |       valid      |          |
    |          | ----------------> |          |
    |          |       ready      |          |
    |          | <---------------- |          |
    +----------+                  +----------+

---

## 5. Transfer Rule

The core rule is:

transfer = valid && ready

This means data is transferred only when both conditions are true:

- producer has valid data
- consumer is ready to accept data

In a synchronous design, the transfer usually happens at the clock edge when valid and ready are both high.

---

## 6. Four Valid / Ready Cases

| valid | ready | Meaning | Transfer? |
|---:|---:|---|---|
| 0 | 0 | Producer has no valid data and consumer is not ready | No |
| 0 | 1 | Consumer is ready, but producer has no valid data | No |
| 1 | 0 | Producer has valid data, but consumer is not ready | No |
| 1 | 1 | Producer has valid data and consumer is ready | Yes |

The most important case is valid = 1 and ready = 0.

This means the producer has data, but the consumer cannot accept it yet.

In this case, the producer usually needs to keep the data stable until the transfer happens.

---

## 7. Connection to FIFO Write

FIFO write behavior is closely related to valid / ready handshake.

For FIFO input side:

write_en is similar to valid.

It means the producer wants to send data into the FIFO.

!full is similar to ready.

It means the FIFO has space to accept new data.

Therefore:

valid_write = write_en && !full

Meaning:

A write is valid only when the producer wants to write and the FIFO is not full.

Classification:

write_en

Producer-side request or valid-like signal.

!full

FIFO ready-like signal.

valid_write

Actual accepted write condition.

---

## 8. Connection to FIFO Read

FIFO read behavior can also be explained using handshake thinking.

For FIFO output side:

!empty is similar to valid.

It means the FIFO has valid data available.

read_en is similar to ready or request.

It means the consumer wants to take data.

Therefore:

valid_read = read_en && !empty

Meaning:

A read is valid only when the consumer wants to read and the FIFO has valid data.

Classification:

!empty

FIFO valid-like signal.

read_en

Consumer-side ready or request signal.

valid_read

Actual accepted read condition.

---

## 9. Important Difference Between Data and Control

In a valid / ready interface, data is the payload.

valid and ready are control/status signals.

Example:

data

The actual value being transferred.

valid

A control/status signal from producer to consumer.

ready

A control/status signal from consumer to producer.

This connects directly to datapath vs control:

data belongs to the datapath.

valid and ready belong to control/status logic.

---

## 10. Relation to Previous Projects

ALU

The ALU result is datapath data.

If another module receives the ALU result, valid can indicate whether the ALU result is meaningful.

Register File

write_data is datapath.

write_en is control.

A handshake can be used before writing data into the register file.

FIFO

FIFO is the closest previous example to handshake behavior.

The FIFO input side uses write_en and !full.

The FIFO output side uses read_en and !empty.

FSM

FSMs are often used to generate control signals such as valid, ready, write_en, read_en, mux_sel, and alu_op.

---

## 11. Common Mistakes

### Mistake 1: Thinking valid is generated by the consumer

Correct idea:

valid is generated by the producer.

The producer uses valid to say that the current data is meaningful.

---

### Mistake 2: Thinking ready is generated by the producer

Correct idea:

ready is generated by the consumer.

The consumer uses ready to say that it can accept data.

---

### Mistake 3: Thinking valid = 1 means transfer is complete

Correct idea:

valid = 1 only means the producer has valid data.

Transfer happens only when valid = 1 and ready = 1.

---

### Mistake 4: Ignoring data stability when ready = 0

If valid = 1 and ready = 0, the producer has data but the consumer cannot accept it yet.

In many valid / ready protocols, the producer should keep data stable until ready becomes 1 and the transfer occurs.

---

## 12. Main Rules

Rule 1

valid is controlled by the producer.

Rule 2

ready is controlled by the consumer.

Rule 3

data transfers only when valid and ready are both high.

Rule 4

data usually moves from producer to consumer.

Rule 5

valid usually moves from producer to consumer.

Rule 6

ready usually moves from consumer to producer.

Rule 7

valid and ready are control/status signals, not the main payload data.

---

## 13. Connection to VLSI / EDA / Physical Design / STA

Valid / ready handshake is important because it describes how modules communicate in a digital system.

In RTL design, handshake signals control data movement between modules.

In Physical Design and STA, these signals create real timing paths.

The data path may include buses, muxes, FIFOs, registers, and processing logic.

The control path may include valid, ready, enable, FSM outputs, and status flags.

Both datapath and control path timing need to meet setup and hold requirements.

Handshake design also helps prevent data loss when one module is faster than another module.

This connects to larger topics such as:

- streaming interfaces
- FIFO-based buffering
- producer-consumer systems
- bus protocols
- pipeline backpressure
- NoC communication
- chiplet data movement

---

## 14. Connection to USC Courses

EE457

Handshake concepts help explain datapath/control coordination and module-level communication.

EE560L

Valid / ready is useful for RTL design, testbench writing, and understanding producer-consumer data transfer.

EE577B

Handshake concepts are important for larger digital design projects, streaming datapaths, pipelines, and implementation-aware RTL.

---

## 15. Producer-Consumer Handshake Diagram

A valid / ready interface connects a producer and a consumer.

The producer provides data and valid.

The consumer provides ready.

    Producer                          Consumer
    +-------------+                   +-------------+
    |             |       data        |             |
    |             | ----------------> |             |
    |             |       valid       |             |
    |             | ----------------> |             |
    |             |       ready       |             |
    |             | <---------------- |             |
    +-------------+                   +-------------+

Signal directions:

| Signal | Direction | Meaning |
|---|---|---|
| data | Producer -> Consumer | The actual payload data |
| valid | Producer -> Consumer | Producer has valid data |
| ready | Consumer -> Producer | Consumer can accept data |

The transfer condition is:

transfer = valid and ready

In a synchronous RTL design, the data is accepted at the clock edge when valid and ready are both high.

---

## 16. Handshake Timing Example

The following table shows several clock cycles of valid / ready behavior.

| Cycle | valid | ready | Data Transfer? | Meaning |
|---:|---:|---:|---|---|
| 1 | 0 | 0 | No | No valid data and consumer is not ready |
| 2 | 1 | 0 | No | Producer has data, but consumer cannot accept it |
| 3 | 1 | 1 | Yes | Producer has data and consumer accepts it |
| 4 | 0 | 1 | No | Consumer is ready, but producer has no valid data |
| 5 | 1 | 1 | Yes | Another successful transfer |

The most important case is cycle 2.

When valid = 1 and ready = 0, the producer has valid data, but the consumer cannot accept it yet.

In many valid / ready protocols, the producer should keep the data stable until ready becomes 1 and the transfer happens.

---

## 17. FIFO Input Side as Handshake

The FIFO input side can be understood as a producer sending data into a FIFO.

    Producer                          FIFO
    +-------------+                   +-------------+
    |             |      data_in      |             |
    |             | ----------------> |             |
    |             |      write_en     |             |
    |             | ----------------> |             |
    |             |      !full        |             |
    |             | <---------------- |             |
    +-------------+                   +-------------+

Mapping:

| Handshake Concept | FIFO Input Side |
|---|---|
| data | data_in |
| valid | write_en |
| ready | !full |
| transfer | write_en && !full |

This means:

A FIFO write happens only when the producer wants to write and the FIFO has space.

The accepted write condition is:

valid_write = write_en && !full

If write_en = 1 and full = 1, the FIFO cannot accept the data.

That is similar to valid = 1 and ready = 0.

---

## 18. FIFO Output Side as Handshake

The FIFO output side can be understood as a FIFO sending data to a consumer.

    FIFO                              Consumer
    +-------------+                   +-------------+
    |             |      data_out     |             |
    |             | ----------------> |             |
    |             |      !empty       |             |
    |             | ----------------> |             |
    |             |      read_en      |             |
    |             | <---------------- |             |
    +-------------+                   +-------------+

Mapping:

| Handshake Concept | FIFO Output Side |
|---|---|
| data | data_out |
| valid | !empty |
| ready | read_en |
| transfer | read_en && !empty |

This means:

A FIFO read happens only when the FIFO has valid data and the consumer wants to read.

The accepted read condition is:

valid_read = read_en && !empty

If empty = 1, the FIFO has no valid data to provide.

If read_en = 0, the consumer is not requesting data.

---

## 19. Why FIFO Is a Good Handshake Example

FIFO is a good example because it sits between a producer and a consumer.

It prevents data loss when the producer and consumer do not operate at exactly the same speed.

Input side:

The producer may want to send data, but the FIFO may be full.

Output side:

The consumer may want data, but the FIFO may be empty.

The full and empty flags are status signals that help control whether data movement is allowed.

This connects directly to the valid / ready idea.

---

## 20. Final Rule

For any producer-consumer interface, ask three questions:

Who produces the data?

That side controls valid.

Who consumes the data?

That side controls ready.

When does data transfer?

Only when valid and ready are both high.

The simplified formula is:

transfer = valid && ready

---

## One Sentence Summary

Valid / ready handshake is a communication rule where the producer asserts valid, the consumer asserts ready, and data transfers only when both signals are high.

