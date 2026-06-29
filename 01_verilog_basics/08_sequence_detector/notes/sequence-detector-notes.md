# Sequence Detector FSM Notes

## Topic

Day10 focuses on designing a 1011 sequence detector using a Moore FSM.

## Detection Goal

The detector watches a serial input signal called `bit_in`.

When the input sequence contains `1011`, the output signal `detected` becomes 1.

This design uses overlapping detection. This means the last bit of one detected sequence can also become the first bit of the next sequence.

Example:

Input sequence:

1011011

This contains two overlapping 1011 patterns:

- bits 1-4: 1011
- bits 4-7: 1011

## State Meaning

S_IDLE  
No useful part of the target sequence has been matched yet.

S_1  
The FSM has seen `1`.

S_10  
The FSM has seen `10`.

S_101  
The FSM has seen `101`.

S_1011  
The FSM has seen the complete target sequence `1011`. In this state, `detected = 1`.

## State Transition Table

| Current State | bit_in = 0 | bit_in = 1 | detected |
|---|---|---|---|
| S_IDLE | S_IDLE | S_1 | 0 |
| S_1 | S_10 | S_1 | 0 |
| S_10 | S_IDLE | S_101 | 0 |
| S_101 | S_10 | S_1011 | 0 |
| S_1011 | S_10 | S_1 | 1 |

## Key Idea

The FSM state represents how much of the target sequence `1011` has already been matched.

Overlapping detection means the FSM should not always return to S_IDLE after detecting a sequence. It should keep any suffix that can still be the prefix of a new `1011` sequence.