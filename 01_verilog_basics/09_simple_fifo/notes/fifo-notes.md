# FIFO Notes

## Topic

Simple FIFO concept.

## Basic Idea

FIFO means First In, First Out.

The first data written into the FIFO should be the first data read out from the FIFO.

A FIFO is used as a data buffer between two hardware modules.

## Main Components

### Memory Array

The memory array stores the actual data values.

Example:

reg [7:0] mem [0:3];

This means the FIFO has 4 storage locations, and each location stores 8 bits.

### Write Pointer

The write pointer points to the next memory location where new data will be written.

### Read Pointer

The read pointer points to the next memory location where data will be read.

### Full Flag

The full flag tells us that the FIFO has no free space.

When full = 1, the FIFO should not accept new write operations.

### Empty Flag

The empty flag tells us that the FIFO has no valid data.

When empty = 1, the FIFO should not allow read operations.

## Why FIFO Matters

FIFO is important because real hardware modules often produce and consume data at different times.

A FIFO allows one module to temporarily store data before another module is ready to read it.

This makes FIFO a basic building block for RTL design, digital systems, verification, and ASIC implementation.

## Circular Buffer Behavior

A FIFO uses fixed-size memory.

For example, a depth-4 FIFO has four memory locations:

mem[0]
mem[1]
mem[2]
mem[3]

The write pointer and read pointer move through these locations.

After a pointer reaches the last location, it wraps around to the first location.

For a depth-4 FIFO, the pointer movement is:

0 -> 1 -> 2 -> 3 -> 0

This is called circular buffer behavior.

Although the memory array looks linear, the pointer movement behaves like a circle.

## Write Example

If the FIFO is empty at the beginning:

write_ptr = 0
read_ptr = 0
empty = 1
full = 0

After writing A:

mem[0] = A
write_ptr moves from 0 to 1

After writing B:

mem[1] = B
write_ptr moves from 1 to 2

After writing C:

mem[2] = C
write_ptr moves from 2 to 3

After writing D:

mem[3] = D
write_ptr moves from 3 back to 0

At this point, the FIFO is full.

## Read Example

If the FIFO stores A, B, C, and D:

mem[0] = A
mem[1] = B
mem[2] = C
mem[3] = D

The first read returns A.

The second read returns B.

The third read returns C.

The fourth read returns D.

After all four values are read, the FIFO becomes empty again.

## Write Operation

A write operation stores data into the FIFO.

A valid write happens only when:

write_en = 1
full = 0

This can be written as:

valid_write = write_en && !full

When a valid write happens, data_in is stored into mem[write_ptr], and the write pointer moves to the next location.

If write_en = 1 but full = 1, the FIFO should not accept the write.

This situation is called overflow.

## Read Operation

A read operation takes data out of the FIFO.

A valid read happens only when:

read_en = 1
empty = 0

This can be written as:

valid_read = read_en && !empty

When a valid read happens, data_out gets the value from mem[read_ptr], and the read pointer moves to the next location.

If read_en = 1 but empty = 1, the FIFO should not allow the read.

This situation is called underflow.

## Important Rules

The FIFO should write only when it is not full.

The FIFO should read only when it is not empty.

The two most important conditions are:

valid_write = write_en && !full

valid_read = read_en && !empty

## Full and Empty Detection

A FIFO needs to know whether it is full or empty.

Only comparing write_ptr and read_ptr is not enough.

After reset:

write_ptr = 0
read_ptr = 0

This means the FIFO is empty.

However, after writing four values into a depth-4 FIFO, the write pointer also wraps around back to 0.

At that time:

write_ptr = 0
read_ptr = 0

This can mean the FIFO is full.

Therefore, write_ptr == read_ptr can mean either empty or full.

To make the design easier, we can use a count register.

The count register stores how many valid data values are currently inside the FIFO.

For a depth-4 FIFO:

count = 0 means empty
count = 4 means full

So the flags can be defined as:

empty = (count == 0)

full = (count == 4)

## Count Update Rule

If there is a valid write and no valid read, count increases by 1.

If there is a valid read and no valid write, count decreases by 1.

If valid write and valid read happen at the same time, count stays the same.

If neither write nor read happens, count also stays the same.

The basic rules are:

valid_write = write_en && !full

valid_read = read_en && !empty

## FIFO Module Signals

A simple FIFO can be viewed as a hardware module with input and output signals.

### Input Signals

clk

The clock signal controls when the FIFO updates its internal state.

reset

The reset signal clears the FIFO and returns it to the empty state.

data_in

The input data that may be written into the FIFO.

write_en

The write enable signal. It requests a write operation.

A write only happens when write_en = 1 and full = 0.

read_en

The read enable signal. It requests a read operation.

A read only happens when read_en = 1 and empty = 0.

### Output Signals

data_out

The output data read from the FIFO.

full

The full flag indicates that the FIFO has no free space.

empty

The empty flag indicates that the FIFO has no valid data.

## FIFO Internal Structure

A simple FIFO contains:

memory array

write pointer

read pointer

count register

full flag

empty flag

The write pointer decides where the next data value will be stored.

The read pointer decides where the next data value will be read from.

The count register tracks how many valid data values are currently inside the FIFO.

The full and empty flags are generated based on count.

## FIFO Data Flow Example

Assume the FIFO has depth 4 and data width 8-bit.

Initial state:

write_ptr = 0
read_ptr = 0
count = 0
empty = 1
full = 0

Assume three data values:

A = 8'hA1
B = 8'hB2
C = 8'hC3

Operation sequence:

write A
write B
read
write C
read
read

Step 1: Write A

A is written into mem[0].

write_ptr moves from 0 to 1.

count increases from 0 to 1.

Step 2: Write B

B is written into mem[1].

write_ptr moves from 1 to 2.

count increases from 1 to 2.

Step 3: Read

The FIFO reads from mem[0].

data_out becomes A.

read_ptr moves from 0 to 1.

count decreases from 2 to 1.

Step 4: Write C

C is written into mem[2].

write_ptr moves from 2 to 3.

count increases from 1 to 2.

Step 5: Read

The FIFO reads from mem[1].

data_out becomes B.

read_ptr moves from 1 to 2.

count decreases from 2 to 1.

Step 6: Read

The FIFO reads from mem[2].

data_out becomes C.

read_ptr moves from 2 to 3.

count decreases from 1 to 0.

At the end, the FIFO becomes empty again.

The read order is:

A -> B -> C

This proves the First In, First Out behavior.