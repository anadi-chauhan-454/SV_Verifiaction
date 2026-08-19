# RISC-V 5-Stage Pipelined CPU

A **5-stage pipelined RISC-V processor** designed and implemented in **SystemVerilog** and verified using **SystemVerilog/UVM**.

The main goal of this project was to understand how a pipelined CPU works at the RTL level, including instruction flow through different pipeline stages, data/control hazards, forwarding, stalling, and pipeline control.

---

## Overview

This project implements a RISC-V CPU using a classic **5-stage pipeline**:

```text
        ┌───────┐
        │  IF   │  Instruction Fetch
        └───┬───┘
            │
        ┌───▼───┐
        │  ID   │  Instruction Decode / Register Read
        └───┬───┘
            │
        ┌───▼───┐
        │  EX   │  Execute / ALU
        └───┬───┘
            │
        ┌───▼───┐
        │  MEM  │  Memory Access
        └───┬───┘
            │
        ┌───▼───┐
        │  WB   │  Write Back
        └───────┘
```

Instead of executing one instruction completely before starting the next one, instructions are overlapped across the five stages.

---

## Pipeline Stages

### 1. Instruction Fetch (IF)

* Generates the program counter.
* Fetches the instruction from instruction memory.
* Calculates the next PC.
* Passes the instruction and PC information to the ID stage.

### 2. Instruction Decode (ID)

* Decodes the instruction.
* Reads source registers from the register file.
* Generates control signals.
* Generates immediate values.
* Detects conditions required for pipeline control.

### 3. Execute (EX)

* Performs ALU operations.
* Calculates branch targets.
* Performs comparisons for branch instructions.
* Handles forwarding from later pipeline stages when required.

### 4. Memory Access (MEM)

* Handles load/store memory operations.
* Passes ALU results and control information toward the WB stage.

### 5. Write Back (WB)

* Selects the value that should be written back to the register file.
* Updates the destination register when required.

---

## Pipeline Hazards

One of the main parts of this project was handling hazards created by pipelining.

### Data Hazards

For example:

```text
ADD x5, x1, x2
SUB x6, x5, x3
```

The `SUB` instruction needs the result of the previous `ADD` instruction before that value has reached the register file.

The design handles these dependencies using **data forwarding** where possible.

---

### Load-Use Hazard

For cases where forwarding alone cannot provide the required value in time, the pipeline needs to stall.

Example:

```text
LW  x5, 0(x1)
ADD x6, x5, x2
```

The dependent instruction is delayed until the loaded data becomes available.

---


# Verification

The processor was verified using **UVM**.

The verification environment was developed to check the processor's behavior rather than only testing individual RTL blocks.

## UVM Environment

The verification environment contains the typical UVM components required to drive, monitor, and check processor activity.

```text
                    ┌───────────────┐
                    │   Test        │
                    └───────┬───────┘
                            │
                    ┌───────▼───────┐
                    │   Environment │
                    └───────┬───────┘
                            │
              ┌─────────────┴─────────────┐
              │                           │
        ┌─────▼─────┐               ┌─────▼─────┐
        │  Sequencer │               │  Monitor  │
        └─────┬─────┘               └─────┬─────┘
              │                           │
        ┌─────▼─────┐                     │
        │   Driver  │                     │
        └─────┬─────┘                     │
              │                           │
              └──────────► DUT ◄──────────┘
                              │
                        ┌─────▼─────┐
                        │ Scoreboard│
                        └───────────┘
```

### Verification Focus

The verification focused on:

* Instruction execution
* ALU operations
* Register updates
* Load/store operations
* Branch instructions
* Pipeline behavior
* Data dependencies
* Forwarding conditions
* Pipeline stalls
* Reset behavior
* Different instruction sequences
* Expected vs actual processor results

The **scoreboard/reference model** is used to compare the expected processor behavior against the DUT output.

---

## Example Instruction Flow

For a sequence such as:

```text
ADD x5, x1, x2
SUB x6, x5, x3
AND x7, x6, x4
```

multiple instructions can be active in different pipeline stages at the same time:

```text
Cycle    IF    ID    EX    MEM   WB
-------------------------------------
1        ADD
2        SUB   ADD
3        AND   SUB   ADD
4              AND   SUB   ADD
5                    AND   SUB   ADD
6                          AND   SUB
7                                AND
```

The forwarding and hazard-control logic ensures that dependent instructions receive the correct values.

---



## What I Learned

This project helped me understand the difference between designing individual RTL blocks and building a complete processor where all the blocks have to work together cycle by cycle.

The main areas I worked on were:

* Converting CPU architecture into synthesizable RTL
* Designing pipeline registers
* Understanding instruction timing
* Handling data dependencies
* Designing forwarding logic
* Designing hazard detection and stalls
* Building a UVM verification environment
* Writing sequences and checking DUT behavior
* Using a scoreboard to detect functional mismatches

---

## Future Improvements

Some possible improvements for this project are:

* Expand instruction-set coverage
* Add more comprehensive constrained-random testing
* Improve functional coverage
* Add assertions for pipeline properties
* Add performance counters
* Improve branch handling
* Add cache interfaces
* Add CSR support
* Extend the processor toward a more complete RISC-V implementation

---

## Author

**Anadi Chauhan**
This project was built as part of my learning and practice in **RTL Design, SystemVerilog, CPU Architecture, and UVM Verification**.
