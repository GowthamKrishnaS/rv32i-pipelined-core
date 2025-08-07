# RV32I RISC-V 5-Stage Pipelined SoC

This repository contains a modular implementation of an RV32I-based RISC-V 5-stage pipelined System-on-Chip (SoC). Each module is placed in a separate folder with its Verilog code, testbench, and waveform image for easy understanding and testing.

## 📁 Folder Structure

```
RV32I_SoC/
│
├── 01_pc/
│   ├── pc.sv
│   ├── tb_pc.sv
│   └── waveform_pc.png
│
├── 02_instruction_memory/
│   ├── instruction_memory.sv
│   ├── tb_instruction_memory.sv
│   └── waveform_instruction_memory.png
│
├── 03_if_id_pipeline_reg/
│   ├── if_id_pipeline_reg.sv
│   ├── tb_if_id_pipeline_reg.sv
│   └── waveform_if_id_pipeline_reg.png
│
├── 04_control_unit/
│   ├── control_unit.sv
│   ├── tb_control_unit.sv
│   └── waveform_control_unit.png
│
├── 05_register_file/
│   ├── register_file.sv
│   ├── tb_register_file.sv
│   └── waveform_register_file.png
│
├── 06_immediate_generator/
│   ├── immediate_generator.sv
│   ├── tb_immediate_generator.sv
│   └── waveform_immediate_generator.png
│
├── 07_id_ex_pipeline_reg/
│   ├── id_ex_pipeline_reg.sv
│   ├── tb_id_ex_pipeline_reg.sv
│   └── waveform_id_ex_pipeline_reg.png
│
├── 08_alu_control/
│   ├── alu_control.sv
│   ├── tb_alu_control.sv
│   └── waveform_alu_control.png
│
├── 09_alu/
│   ├── alu.sv
│   ├── tb_alu.sv
│   └── waveform_alu.png
│
├── 10_forwarding_unit/
│   ├── forwarding_unit.sv
│   ├── tb_forwarding_unit.sv
│   └── waveform_forwarding_unit.png
│
├── 11_ex_mem_pipeline_reg/
│   ├── ex_mem_pipeline_reg.sv
│   ├── tb_ex_mem_pipeline_reg.sv
│   └── waveform_ex_mem_pipeline_reg.png
│
└── README.md
```

## 🧪 How to Use

1. **Clone the Repository:**
```bash
git clone https://github.com/your_username/RV32I_SoC.git
cd RV32I_SoC
```

2. **Open Any Module Folder:**
Each folder contains:
- The main Verilog module
- Testbench file (`tb_*.sv`)
- Waveform image to visualize the simulation results

3. **Simulate Using Questa or Any Tool:**
Open the testbench in your simulator and run to view waveform and module behavior.

4. **Contributions:**
Feel free to fork and submit pull requests with improvements or additional modules.

## 📌 License
This project is open-source and available under the MIT License.
