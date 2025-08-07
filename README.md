# RV32I Pipelined RISC-V SoC

This repository contains a modular and extensible implementation of a **5-stage pipelined RV32I RISC-V processor**, designed in Verilog. It includes custom instruction extensions and will later integrate SoC-level peripherals.

---

## 📌 Project Highlights

- ✅ 5-stage pipeline: IF, ID, EX, MEM, WB
- ✅ Custom instructions implemented:
  - `btransm` – Bit Transpose with Mask (primary novel instruction)
  - `rotmix` – Rotate and Mix (XOR after rotate, cryptographic-style)
- ✅ Fully modular design
- ✅ Each module is independently verified with testbenches
- ✅ Waveform results captured with QuestaSim
- ✅ Clean folder structure for easy navigation and reuse
- 🔜 Planned peripherals: UART, Timer, GPIO

---

## 🧠 Pipeline Stages and Modules

| Stage | Module(s)                                          |
|-------|----------------------------------------------------|
| IF    | `pc`, `im`                                         |
| ID    | `reg_file`, `control_unit`, `imm_gen`              |
| EX    | `alu`, `alu_control`, `forwarding_unit`            |
| MEM   | 🔜 Data memory (`dmem`), memory interface           |
| WB    | Integrated in control signals & forwarding logic   |

Pipeline registers:
- `if_id_pipeline_reg`
- `id_ex_pipeline_reg`
- `ex_mem_pipeline_reg`
- `mem_wb_pipeline_reg` 🔜

---

## 📁 Folder Structure

Each module folder contains:
- `module.v` – RTL Verilog file
- `module_tb.v` – Verilog testbench
- `waveform.png` – Simulation result waveform

Example:
