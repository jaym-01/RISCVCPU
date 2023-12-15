# IAC README

# **Team 02: IAC RISC-V Project**

## Table of Contents

## Quick Start

- Ensure the device dev path in vbuddy.cfg file is configured correctly.

- All shell scripts display the ouput on the VBuddy

- All shell scripts generate a .vcd file with the waveform in the test folder

| Command                      | Function                                             |
| ---------------------------- | ---------------------------------------------------- |
| source ./run_f1.sh           | run the f1 program                                   |
| source ./run_pdf.sh          | run the reference program with the gaussian data set |
| source ./run_pdf.sh sine     | run the reference with the sine data set             |
| source ./run_pdf.sh triangle | run the reference with the triangle data set         |
| source ./run_pdf.sh noisy    | run the reference with the noisy data set            |

## Overview

Versions:

- [Single Cycle](https://github.com/johnyeocx/iac-project-team02/tree/main)
- [Pipelined](https://github.com/johnyeocx/iac-project-team02/tree/pipeline)
- [Pipelined Data Cache](https://github.com/johnyeocx/iac-project-team02/tree/pipelined_data_cache)

## Videos of working processor:

[**F1 Starting Light Sequence:**](https://www.youtube.com/watch?v=ZEgYNSm-2rE)

[**Reference Program Gaussian Data Set**](https://www.youtube.com/watch?v=L19uE8GNIMg)

[**Reference Program Sine Data Set:**](https://www.youtube.com/watch?v=gi-OaK2o7cQ)

[**Reference Program Triangle Data Set:**](https://www.youtube.com/watch?v=-6ea5gQGjow)

[**Reference Program Noisy Data Set:**](https://www.youtube.com/watch?v=wLEnNPWv9hE)

## Individual Statements

[Personal Statement: John](./statements/john_yeo.md)

[Personal Statement: Jay](./statements/Jay.md)

[Personal Statement: Cecilia](./statements/Cecilia.md)

## Contribution Table

Overall, the tasks were split into the following categories:

**Single Cycle**

- **John:** Control unit, Extend & Memory
- **Cecilia:** PC
- **Liam:** ALU & Register File
- **Jay:** Top, Testbench & Testing

**Pipeline:**

- **John**: Pipeline stages
- **Jay**: Hazard unit & testing

**Data Cache:** Cecilia & Liam

However, throughout the project duration, we helped one another out with each component, and as such, the detailed contributions are shown in the following table:

| Component           | File                              | John | Jay | Cecilia | Liam |
| ------------------- | --------------------------------- | ---- | --- | ------- | ---- |
| Single Cycle        | Branch: main                      |      |     |         |      |
| ALU                 | alu/alu.sv                        |      |     |         | x    |
| Register File       | alu/regfile.sv                    |      |     |         | x    |
| Control Unit        | control/control_unit.sv           | x    |     |         |      |
| Extend              | control/extend.sv                 | x    |     |         |      |
| Data Mem            | control/data_memory.sv            | x    |     |         |      |
| Instruction Mem     | control/instruction_memory.sv     | x    |     |         |      |
| PC                  | pc/pc.sv                          |      |     | x       |      |
| Top                 | riscv_top.sv                      |      | x   |         |      |
| Testing             | f1_riscv_tb.cpp, pdf_riscv_tb.cpp |      | x   |         |      |
| Shell Files         | run_f1.sh, run_pdf.sh             |      | x   |         |      |
| Pipeline            | Branch: adding_pipeline           |      |     |         |      |
| Pipeline stages     | pipelines/                        | x    | x   |         |      |
| Pipeline top        | riscv_top.sv                      | x    | x   |         |      |
| Hazard Unit         | hazard_unit/hazard_unit.sv        |      | x   |         |      |
| Data cache          | Branch: pipelined_data_cache      |      |     |         |      |
| Building data cache | data_cache/data_cache.sv          |      |     | x       | x    |
| Data cache top      | riscv_top.sv                      | x    | x   |         |      |

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
