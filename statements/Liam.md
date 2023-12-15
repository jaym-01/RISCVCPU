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

**Code**
``` verilog
module alu #(
    parameter DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] op1,
    input logic [DATA_WIDTH-1:0] op2,
    input logic [2:0] ALUctrl,
    output logic [DATA_WIDTH-1:0] SUM,
    output logic zero
);
    assign zero = op1 == op2;

    always_comb
        case(ALUctrl)
            3'b001: SUM = op1 - op2;
            3'b010: SUM = op2;
            default: SUM = op1 + op2;
        endcase
endmodule module regfile #(
    parameter ADDRESS_WIDTH = 5,
    DATA_WIDTH = 32
)(
    input logic clk,
    input logic [ADDRESS_WIDTH-1:0] AD1,
    input logic [ADDRESS_WIDTH-1:0] AD2,
    input logic [ADDRESS_WIDTH-1:0] AD3,
    input logic WE3,
    input logic [DATA_WIDTH-1:0] WD3,
    output logic [DATA_WIDTH-1:0] a0,
    output logic [DATA_WIDTH-1:0] RD1,
    output logic [DATA_WIDTH-1:0] RD2
);

    logic [DATA_WIDTH-1:0] regs [2**ADDRESS_WIDTH-1:0];

    initial begin
        regs[0] = {DATA_WIDTH{1'b0}};
        regs['d10] = {DATA_WIDTH{1'b0}};
    end

    assign RD1 = regs[AD1];
    assign RD2 = regs[AD2];
    assign a0 = regs['d10];  // a0 made async **

    always_ff @(posedge clk) begin
        if(WE3 && AD3 != 0) regs[AD3] <= WD3;
    end

endmodule
```

