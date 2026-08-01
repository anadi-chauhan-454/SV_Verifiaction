# Parameterized ALU in SystemVerilog

A parameterized Arithmetic Logic Unit (ALU) written in **SystemVerilog** and a complete **SystemVerilog verification environment**.

This project was created as my first RTL design during learning of ASIC Design Verification. was to design an ALU and to get a better understanding of the complete verification flow, from the RTL implementation to writing a reusable testbench architecture.

---

## Project Goals

- Parameterize ALU design for reusability.
- - Learn RTL coding practices for synthesis.
- Create a modular SystemVerilog testbench
- Understand how to verify transactions
- Verify design against a reference model and scoreboard.

---

## Features

- Parameterized data width
- Arithmetic operations
  - Addition
  - Subtraction
  - Increment
  - Decrement
- Logical operations
  - AND
  - OR
  - XOR
  - XNOR
  - NOT
- Shift operations
  - Logical Left Shift
  - Logical Right Shift
- Comparison operations
- Status Flags
  - Zero Flag
  - Carry Flag
  - Overflow Flag
  - Negative Flag

---

## Directory Structure

```
.
├── rtl/
│   └── alu.sv
│
├── tb/
│   ├── alu_if.sv
│   ├── alu_tr.sv
│   ├── alu_gen.sv
│   ├── alu_drv.sv
│   ├── alu_mon.sv
│   ├── alu_rm.sv
│   ├── alu_scb.sv
│   ├── alu_env.sv
│   ├── alu_test.sv
│   └── top.sv
|
│── alu_pkg.sv
|
└── README.md
```

---

## Verification Architecture

The design is verified using a layered SystemVerilog testbench.

```
               Generator
                    │
                    ▼
               Transaction
                    │
                    ▼
Driver ─────► Interface ─────► DUT
                                   │
                                   ▼
                              Monitor
                                   │
                    ┌──────────────┴──────────────┐
                    ▼                             ▼
             Reference Model               Scoreboard
```

---

## Verification Flow

1. Generator creates randomized transactions.
2. Driver drives transactions to the DUT.
3. Monitor captures DUT inputs and outputs.
4. Reference Model calculates the expected result.
5. Scoreboard compares expected and actual outputs.
6. Test passes only if both results match.

---

## Concepts Practiced

### RTL Design

- Parameterization
- Combinational Logic
- Case Statements
- Synthesizable Coding Style

### Verification

- Interfaces
- Mailboxes
- Virtual Interfaces
- Transaction Class
- Generator
- Driver
- Monitor
- Reference Model
- Scoreboard
- Environment
- Test Class

---

## Future Improvements

This project was intentionally kept simple to build a strong verification foundation.

Future enhancements include:

- Functional Coverage
- SystemVerilog Assertions (SVA)
- Constrained Random Verification
- Multiple Test Scenarios
- UVM Migration

---

## What I Learned

This project taught me much more than writing an ALU.

I learned about the architecture of verification environments, how different verification components interact, and the importance of modularity for reusable verification.

But more importantly, it made me realize that writing RTL is only one part of digital design, and that proving the design works is just as important.

---

## Author Information

**Anadi Chauhan**

Aspiring ASIC Design Verification Engineer

Currently learning:

- Advanced SystemVerilog Assertions (SVA)
- Functional Coverage
- Constrained Random Verification
- UVM
- Python for Verification

Feel free to explore the project, raise issues, or suggest improvements.
