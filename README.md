# RISC-V Multi-Cycle Processor Design (Verilog)

This repository contains the full hardware implementation of a **32-bit RISC-V compatible processor** using Verilog HDL. The project progresses from designing basic building blocks (ALU, Register File) to implementing a multi-cycle datapath and a Finite State Machine (FSM) controller.

## 📊 Project Overview

### Exercise 1: 32-bit Arithmetic Logic Unit (ALU)
Implementation of a 32-bit ALU with parameterized operation selection via the `alu_op` signal.
* **Operations:** Supports arithmetic (ADD, SUB), logical (AND, OR, XOR), shifts (SLL, SRL, SRA), and comparisons (SLT).
* **Zero Flag:** A 1-bit output indicating if the result is zero (essential for BEQ instructions).
* **Technical Details:** Signed comparison logic and arithmetic right shifts using signed type casting.

### Exercise 2: Digital Hardware Calculator
Integration of the ALU into a calculator circuit with a 16-bit accumulator.
* **Accumulator:** 16-bit register with synchronous reset (`btnu`) and update (`btnd`) triggers.
* **Interface:** Connection of inputs (switches) and the accumulator to the ALU using sign extension logic.
* **Control:** Structural Verilog implementation (`calc_enc.v`) using pure logic gates to generate the `alu_op` signal.


*Figure: Simulation waveform verifying the correct execution of arithmetic operations in the hardware calculator.*

### Exercise 3: Register File
Design of a 32-entry (32-bit wide) Register File for the RISC-V architecture.
* **Ports:** Dual asynchronous read ports and one synchronous write port.
* **Register x0:** Hardwired to constant zero; remains unaffected by write operations.
* **Write-First Logic:** Mechanism ensuring that write data is immediately available at the read ports when addresses match.

### Exercise 4: Datapath Design
Synthesis of individual modules into a unified data processing path based on the RISC-V architecture.
* **Program Counter (PC):** Update logic for PC+4 or Branch Offset calculation.
* **Immediate Generation:** Support for I, S, and B-type instructions with proper sign extension.
* **Memory Interface:** Integration with instruction and data memory modules.



### Exercise 5: Multi-cycle Control (FSM)
Implementation of a 5-stage Finite State Machine controller (Instruction Fetch, Decode, Execute, Memory, Write-Back).
* **Control Signals:** Generation of `PCSrc`, `ALUSrc`, `MemRead`, `MemWrite`, `RegWrite`, and `ALUCtrl`.
* **Technical Note:** During system-level simulation in `top_proc.v`, connectivity issues were identified regarding the `WriteBackData` signal and `RegWrite` activation. These issues currently affect the full completion of LW/SW instructions.



## 🛠️ Instruction Set Support
The processor is designed to support the following instructions:
* **R-Type:** ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA.
* **I-Type:** ADDI, ANDI, ORI, XORI, SLTI, SLLI, SRLI, SRAI, LW.
* **S-Type:** SW.
* **B-Type:** BEQ.



## 📂 Repository Structure

### RTL
Core Verilog source files implementing the hardware logic:
* **alu.v**: 32-bit Arithmetic Logic Unit.
* **calc.v**: Top-level calculator module.
* **calc_enc.v**: Structural logic for ALU operation encoding.
* **regfile.v**: 32x32 Register File.
* **datapath.v**: RISC-V Datapath wiring.
* **top_proc.v**: Multi-cycle Processor Top and FSM.

### Memory
Memory models and machine code data used for simulation:
* **DATA_MEMORY.v**: Data memory module (formerly `ram.v`).
* **INSTRUCTION_MEMORY.v**: Instruction memory module (formerly `rom.v`).
* **rom_bytes.data**: Hexadecimal machine code for processor execution.

### Testbenches
Verification files for simulation:
* **calc_tb.v**: Testbench for the digital calculator (Ex. 2).
* **top_proc_tb.v**: System-level testbench for the full processor (Ex. 5).

### Simulations
Verification assets:
* **calculator_simulation_waveforms.png**: Timing diagram of the calculator's logic.

### Docs
Project documentation and reference material:
* **Assignment_Specifications.pdf**: Original project requirements.
* **Digital_Systems_Design_Report.pdf**: Detailed technical analysis and design report.

## 🛠️ Tech Stack
* **Language:** Verilog HDL
* **Tools:** ModelSim / Vivado / Icarus Verilog
* **Architecture:** RISC-V (RV32I Subset)

---
*Developed as part of the Digital Systems Design course, ECE AUTh, 2026.*
