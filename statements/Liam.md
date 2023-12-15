# Personal Statement:Liam

## Overview

This repository contains SystemVerilog code for two modules: ALU (Arithmetic Logic Unit), Register File and data cache. These modules can be integrated into a larger system for various digital processing applications.<img width="1138" alt="截屏2023-12-15 20 10 52" src="https://github.com/johnyeocx/iac-project-team02/assets/151572498/f0b1c6f4-697b-446c-bbf0-a8951b793ff8">


### ALU Module

The ALU module performs arithmetic and logical operations based on the control signals provided. It supports operations such as addition, subtraction, direct passing of one of the operands, and , or and SLT. However, we finally choose 3 of them because only three of them are used in the project. The module also features an output indicating whether the result is zero.



### Register File Module

The Register File module serves as a set of registers with read and write functionality. It includes three read ports (RD1, RD2, a0) and one write port (WD3). The module supports asynchronous read access to register 'd10 (a0) and synchronous write access to any register specified by the address (AD3). The initial state of registers 0 and 'd10 is set to zero.

### Data Cache



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

### single cycle cache
This repository contains code for updating a RAM array based on certain conditions. The provided code snippet focuses on the scenario when a cache miss (`Hit == 1'b0`) occurs, and data needs to be fetched from the main memory.

**Code Logic**

The code snippet is designed to update a RAM array based on different conditions. Here is a brief explanation of the logic:

1. **Address Fetching**:
   - If there is a cache miss (`Hit == 1'b0`), the `DATA_Fetch_Addr_o` is set to `Address_in`.

2. **Cache Line Check**:
   - Check if the cache line corresponding to `Address_in[3:2]` is empty (`ram_array[Address_in[3:2]][60] == 1'b0`).

3. **Cache Line Empty**:
   - If the cache line is empty, update it with the fetched data and address information.
   - Set the validity bit (`ram_array[Address_in[3:2]][60]`) to indicate the presence of valid data.

4. **Cache Line Occupied (Condition 1)**:
   - If the cache line is already occupied and marked as a certain type (`ram_array[Address_in[3:2]][122] == 1'b1`), update it with the fetched data and address information.
   - The code snippet shows the update for a specific condition (`ram_array[Address_in[3:2]][92:61]`).

5. **Cache Line Occupied (Condition 2)**:
   - If the cache line is occupied but doesn't match the condition above, check further conditions.
   - The code snippet showcases nested conditions and updates based on certain criteria.

**Files**

- `ram_array_update_logic.sv`: Contains the code snippet for updating the RAM array.

**Usage**

- Integrate this logic into your main system where RAM updates are required.
- Customize the conditions and data handling based on your specific requirements.

**code**
``` verilog
if (Hit == 1'b0)  begin
    DATA_Fetch_Addr_o = Address_in

    if (ram_array[Address_in[3:2]][60] ==1'b0) begin
    ram_array[Address_in[3:2]][31:0] = Data_fetch_in;
    ram_array[Address_in[3:2]][59:32] = Address_in;
    ram_array[Address_in[3:2]][60] = 1'b1
   end

   else if (ram_array[Address_in[3:2]][122] == 1'b1) begin
    ram_array[Address_in[3:2]][92:61] = Data_fetch_in;
    ram_array[Address_in[3:2]][120:93] = Address_in[31:4];
    ram_array[Address_in[3:2]][122] = 1'b1;
   end
         
   else begin 
   if(ram_array[Address_in[3:2]][121] == 1'b0) begin
   ram_array[Address_in[3:2]][31:0] = Data_fetch_in;
   ram_array[Address_in[3:2]][59:32] = Address_in[31:4];
   end

   if (ram_array[Address_in[3:2]][121] == 1'b1) begin
   ram_array[Address_in[3:2]][92:61] = Data_fetch_in;
   ram_array[Address_in[3:2]][120:93] = Address_in [31:4]
   end
 end
```
code].

## Conclusion and Reflection

This project provided a solution for efficiently updating a RAM array in the context of cache misses. The logic is designed to handle various scenarios, ensuring accurate and timely data retrieval.

### Reflection

- **Challenges**: cache part with handdling dirty bits
  
- **Learning**: how to coorporate in a team

- **Improvements**: adding piplining by myself and LRU replacement policy and write-back policy.
