# **Team 02: IAC RISC-V Project**

## Quick Start

- Ensure the device dev path in vbuddy.cfg file is configured correctly.

- The program executes with the sudo command, as we found it is required to use the port.

- All shell scripts display the ouput on the VBuddy.

- All shell scripts generate a .vcd file with the waveform in the test folder.

For MacOs:

| Command                        | Function                                             |
| ------------------------------ | ---------------------------------------------------- |
| `source ./mac_f1.sh`           | run the f1 program                                   |
| `source ./mac_pdf.sh`          | run the reference program with the gaussian data set |
| `source ./mac_pdf.sh sine`     | run the reference with the sine data set             |
| `source ./mac_pdf.sh triangle` | run the reference with the triangle data set         |
| `source ./mac_pdf.sh noisy`    | run the reference with the noisy data set            |

For Ubuntu:
| Command | Function |
| ---------------------------- | ---------------------------------------------------- |
| `source ./ubuntu_f1.sh` | run the f1 program |
| `source ./ubuntu_pdf.sh` | run the reference program with the gaussian data set |
| `source ./ubuntu_pdf.sh sine` | run the reference with the sine data set |
| `source ./ubuntu_pdf.sh triangle` | run the reference with the triangle data set |
| `source ./ubuntu_pdf.sh noisy` | run the reference with the noisy data set |

## Overview

Versions:

- [**Single Cycle**](https://github.com/johnyeocx/iac-project-team02/tree/main): stored on main branch
- [**Pipelined**](https://github.com/johnyeocx/iac-project-team02/tree/pipeline): stored on branch pipeline
- [**Pipelined Data Cache**](https://github.com/johnyeocx/iac-project-team02/tree/pipeline_data_cache): stored on branch pipeline_data_cache

## Videos of working processor:

[**F1 Starting Light Sequence**](https://www.youtube.com/watch?v=ZEgYNSm-2rE)

[**Reference Program Gaussian Data Set**](https://www.youtube.com/watch?v=L19uE8GNIMg)

[**Reference Program Sine Data Set**](https://www.youtube.com/watch?v=gi-OaK2o7cQ)

[**Reference Program Triangle Data Set**](https://www.youtube.com/watch?v=-6ea5gQGjow)

[**Reference Program Noisy Data Set**](https://www.youtube.com/watch?v=wLEnNPWv9hE)

## Individual Statements

[Personal Statement: John](./statements/john_yeo.md)

[Personal Statement: Jay](./statements/Jay.md)

[Personal Statement: Ze Quan](./statements/ze_quan.md)

[Personal Statement: Yingkai Xu](./statements/ying_kai.md)

## Contribution Table

Overall, the tasks were split into the following categories:

**Single Cycle**

- **John:** Control unit, Extend & Memory
- **Ze Quan:** PC
- **Ying Kai:** ALU & Register File
- **Jay:** Top, Testbench & Testing

**Pipeline:**

- **John**: Pipeline stages
- **Jay**: Hazard unit & testing

**Data Cache:**

- **Ze Quan & Ying Kai**: 2 way set associative cache
- **John & Jay**: Top & testing

However, throughout the project duration, we helped one another out with each component, and as such, the detailed contributions are shown in the following table:

| Component           | File                                               | John | Jay | Ze Quan | Ying Kai |
| ------------------- | -------------------------------------------------- | ---- | --- | ------- | -------- |
| Single Cycle        | Branch: main                                       |      |     |         |          |
| ALU                 | alu/alu.sv                                         |      |     |         | x        |
| Register File       | alu/regfile.sv                                     |      |     |         | x        |
| Control Unit        | control/control_unit.sv                            | x    |     |         |          |
| Extend              | control/extend.sv                                  | x    |     |         |          |
| Data Mem            | control/data_memory.sv                             | x    |     |         |          |
| Instruction Mem     | control/instruction_memory.sv                      | x    |     |         |          |
| PC                  | pc/pc.sv                                           |      |     | x       |          |
| Top                 | riscv_top.sv                                       |      | x   |         |          |
| Testing             | f1_riscv_tb.cpp, pdf_riscv_tb.cpp                  |      | x   |         |          |
| Shell Files         | mac_f1.sh, mac_pdf.sh, ubuntu_f1.sh, ubuntu_pdf.sh |      | x   |         |          |
| Pipeline            | Branch: adding_pipeline                            |      |     |         |          |
| Pipeline stages     | pipelines/                                         | x    | x   |         |          |
| Pipeline top        | riscv_top.sv                                       | x    | x   |         |          |
| Hazard Unit         | hazard_unit/hazard_unit.sv                         |      | x   |         |          |
| Data cache          | Branch: pipelined_data_cache                       |      |     |         |          |
| Building data cache | data_cache/data_cache.sv                           |      |     | x       | x        |
| Data cache top      | riscv_top.sv                                       | x    | x   |         |          |

## **Project Directory**

**Directories**

| Directory    | Contains                                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------------------------- |
| rtl          | all .sv design files for RISCV processor & f1 / pdf program .cpp testbenches                                        |
| test         | assembly .s files for f1 & reference programs, compiled .hex files & data .mem files for pdf program and f1 program |
| module_tests | extra tests for specific modules that required extra debugging                                                      |

**Notable Files**

| File             | Meaning                                               |
| ---------------- | ----------------------------------------------------- |
| README.md        | overall readme document                               |
| run_f1.sh        | shell script to compile & run f1 program              |
| run_pdf.sh       | shell script to compile & run reference (pdf) program |
| rtl/riscv_top.sv | top level file                                        |
