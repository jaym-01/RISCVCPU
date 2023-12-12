# **Team 02: IAC RISC-V Project (Pipelined)**

## Table of Contents

## Quick Start

\*\*Sec

Configure the vbuddy.cfg file

## Overview

Versions:

- [Single Cycle](https://github.com/johnyeocx/iac-project-team02/tree/main)
- [Pipeline](https://github.com/johnyeocx/iac-project-team02/tree/adding_pipeline)
- [Data Cache](https://github.com/johnyeocx/iac-project-team02/tree/adding-data-cache)

Videos of working processor:

### Individual Statements

[John Yeo](./statements/john_yeo.md)

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

| Component       | File                              | John | Jay | Cecilia | Liam |
| --------------- | --------------------------------- | ---- | --- | ------- | ---- |
| Single Cycle    | Branch: main                      |      |     |         |      |
| ALU             | alu/alu.sv                        |      |     |         | x    |
| Register File   | alu/regfile.sv                    |      |     |         | x    |
| Control Unit    | control/control_unit.sv           | x    |     |         |      |
| Extend          | control/extend.sv                 | x    |     |         |      |
| Data Mem        | control/data_memory.sv            | x    |     |         |      |
| Instruction Mem | control/instruction_memory.sv     | x    |     |         |      |
| PC              | pc/pc.sv                          |      |     | x       |      |
| Top             | riscv_top.sv                      |      | x   |         |      |
| Testing         | f1_riscv_tb.cpp, pdf_riscv_tb.cpp |      | x   |         |      |
| Pipeline        | Branch: adding_pipeline           |      |     |         |      |
| Pipeline stages | pipelines/                        | x    | x   |         |      |
| Pipeline top    | riscv_top.sv                      | x    | x   |         |      |
| Testing         | f1_riscv_tb.cpp, pdf_riscv_tb.cpp |      | x   |         |      |
| Data cache      | Branch: adding-data-cache         |      |     |         |      |

## **Detailed explanation implementations & testing**

**Single Cycle**

- Control unit
- Extend
- Instruction memory
- Data memory

**Pipeline**

- Pipeline stages
- Hazard control

## **Project Directory**

**Directories**

| Directory                           | Contains                                        |
| ----------------------------------- | ----------------------------------------------- |
| rtl                                 | - all .sv design files for RISCV processor      |
| - f1 / pdf program .cpp testbenches |
| test                                | - assembly .s files for f1 & reference programs |

- compiled .hex files
- data .mem files for pdf program |
  | module_tests | - extra tests for specific modules that required extra debugging |

**Notable Files**

| File             | Meaning                                               |
| ---------------- | ----------------------------------------------------- |
| README.md        | overall readme document                               |
| run_f1.sh        | shell script to compile & run f1 program              |
| run_pdf.sh       | shell script to compile & run reference (pdf) program |
| rtl/riscv_top.sv | top level file                                        |
