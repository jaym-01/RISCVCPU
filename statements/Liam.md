# Personal Statement:Liam

## Overview

This repository contains SystemVerilog code for two modules: ALU (Arithmetic Logic Unit) and Register File. These modules can be integrated into a larger system for various digital processing applications.

### ALU Module

The ALU module performs arithmetic and logical operations based on the control signals provided. It supports operations such as addition, subtraction, and direct passing of one of the operands. The module also features an output indicating whether the result is zero.

### Register File Module

The Register File module serves as a set of registers with read and write functionality. It includes three read ports (RD1, RD2, a0) and one write port (WD3). The module supports asynchronous read access to register 'd10 (a0) and synchronous write access to any register specified by the address (AD3). The initial state of registers 0 and 'd10 is set to zero.

## Files

- `alu.sv`: Contains the ALU module code.
- `regfile.sv`: Contains the Register File module code.

## Usage

### ALU Module

- Connect the `op1`, `op2`, and `ALUctrl` inputs.
- Retrieve results from the `SUM` output and the `zero` output to check if the result is zero.

### Register File Module

- Connect the `clk` input for clock synchronization.
- Specify read addresses (`AD1` and `AD2`) to get data from corresponding registers.
- Specify the write address (`AD3`), data (`WD3`), and write enable (`WE3`) to write data to a specific register.

