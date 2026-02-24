# RISC-V Multi-Cycle Processor Design (Verilog)

This repository contains the hardware implementation of a **32-bit RISC-V compatible processor** using Verilog HDL. The design evolves from a basic ALU to a fully functional multi-cycle CPU capable of executing R-type, Immediate, Load/Store, and Branch instructions.


## 🚀 Project Overview

The project is structured into five incremental design stages:

### 1. Arithmetic Logic Unit (ALU)
A 32-bit ALU designed to support RISC-V operations:
* **Arithmetic:** ADD, SUB, SLT (Set Less Than).
* **Logical:** AND, OR, XOR.
* **Shifts:** Logical Left, Logical Right, Arithmetic Right.
* **Zero Detection:** Flag for branch operations.

### 2. Digital Calculator (Ex. 2)
Integration of the ALU into a hardware calculator featuring:
* **16-bit Accumulator:** Synchronous reset and update logic.
* **Structural Control:** Operation encoding using pure logic gates (Structural Verilog).
* **Sign Extension:** Handling transitions between 16-bit inputs and 32-bit processing.

### 3. Register File (Ex. 3)
Implementation of a `32 x 32-bit` Register File:
* **Dual Read Ports:** Simultaneous access to `rs1` and `rs2`.
* **Synchronous Write:** Edge-triggered data storage at `rd`.
* **Zero Register:** Hardwired `x0` constant at address zero.

### 4. Datapath & Control Unit (Ex. 4 & 5)
The final stages focus on the complete CPU integration:
* **Datapath:** Wiring the Program Counter (PC), Immediate Generator, Register File, and ALU.
* **5-Stage FSM:** Implementation of the control logic following the states:
  1. **IF (Instruction Fetch):** Retrieve instruction from memory.
  2. **ID (Decode):** Decode fields and read registers.
  3. **EX (Execute):** Perform ALU operations or address calculation.
  4. **MEM (Memory Access):** Data memory read/write (LW, SW).
  5. **WB (Write Back):** Store results back to the Register File.


## 🛠️ Instruction Support
The processor is verified via `top_proc_tb.v` for the following ISA subsets:
* **R-Type:** `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT`, `SLL`, `SRL`, `SRA`.
* **I-Type:** `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLLI`, `SRLI`, `SRAI`, `LW`.
* **S-Type:** `SW`.
* **B-Type:** `BEQ`.

## 📂 Structure
* **`RTL/`**: Core Verilog modules for ALU, RegFile, and Datapath.
* **`Testbenches/`**: Automated simulation scripts for unit and system testing.

---
*Developed as part of the Digital Systems Design course, ECE AUTh, 2026.*
