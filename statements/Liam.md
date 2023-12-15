# Personal Statement:Liam

## Overview

This repository contains SystemVerilog code for two modules: ALU (Arithmetic Logic Unit), Register File and data cache. These modules can be integrated into a larger system for various digital processing applications.


### ALU Module

The ALU module performs arithmetic and logical operations based on the control signals provided. It supports operations such as addition, subtraction, direct passing of one of the operands, and , or and SLT. However, we finally choose 3 of them because only three of them are used in the project. The module also features an output indicating whether the result is zero. Also, I created the testbench for ALU model. The inputs are SrcA, SrcB and ALU.Controlcode and the output is SUM. 

This is the waveform I created for five functions initially.

![PHOTO-2023-11-30-09-24-03](https://github.com/johnyeocx/iac-project-team02/assets/151572498/509fd50c-572f-4ef8-a0a5-6739d284fa72)
<img width="1138" alt="截屏2023-12-15 20 10 52" src="https://github.com/johnyeocx/iac-project-team02/assets/151572498/ccb4246c-e71a-40d0-a3a6-8c63b9edfd53">

**Code**
```verilog
always_comb begin
    case (ALUctrl)
        3'b001: SUM = op1 - op2;
        3'b000: SUM = op1 + op2;
        3'b010: SUM = op1 & op2;
        3'b011: SUM = op1 | op2;
        3'b101: if(op1<op2) SUM = {[DATA_WIDTH-1]{1‘b0}+{1‘b1}};
                else SUM = {[DATA_WIDTH]{1'b0}};
        default: SUM = op1 + op2;
    endcase
end
```


Because there are only three functions used here, we simplified the code to :the number for ALUctrl is only 1 and 2 and default is made in case of an error occurred. (and then the function is addition)

**Code**
```verilog
case(ALUctrl)
	3'b001: SUM = op1 - op2;
	3'b010: SUM = op2;
	default: SUM = op1 + op2;
endcase
```
The three functions are :<img width="198" alt="截屏2023-12-15 22 00 59" src="https://github.com/johnyeocx/iac-project-team02/assets/151572498/0207ca6c-15f4-4397-9d6f-6342d887fd2d">


### Register File Module

The Register File module serves as a set of registers with read and write functionality. It includes three read ports (RD1, RD2, a0) and one write port (WD3). The module supports asynchronous read access to register 'd10 (a0) and synchronous write access to any register specified by the address (AD3). The initial state of registers 0 and 'd10 is set to zero. The inputs are AD1, AD2, AD3, WE3 and the outputs are a0, RD1 and RD2. 


![IMG_0577](https://github.com/johnyeocx/iac-project-team02/assets/151572498/9e421407-aea3-4b89-98b2-3e5f105436e0)
The instruction from the instrution memory is the inputs of regfile. It has been splited into different inputs of the Regfile. (according to which field the bits locate)


![IMG_0576](https://github.com/johnyeocx/iac-project-team02/assets/151572498/8a0f446f-80d9-49bf-a6e2-86c2476db841)



initial set:
```verilog
initial begin
        regs[0]= {ADDRESS_WIDTH{1'b0}};
    end
```

Also, the number of width for A1, A2 and A3 are 5 and WE3 is the enable signal. When WE3=1 and AD3 is not equal to 0, the data of WD3 will be stored in address with AD3.

**Code**
```verilog
@always_ff @(posedge clk) begin
        if(WE3 && AD3 != 0) regs[AD3] <= WD3;
    end
```
### Data Cache

###two way set 

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

### two way set associative cache
I wrote the entire first draft and Jay and John wrote the write part and add to top based on this draft. This repository contains code for updating a RAM array based on certain conditions. The provided code snippet focuses on the scenario when a cache miss (`Hit == 1'b0`) occurs, and data needs to be fetched from the main memory.The 2-way set-associative cache demonstrated a significant reduction in cache conflicts compared to a 1-way set-associative cache. This was particularly evident in scenarios with high memory contention.
Implementing a two-way set-associative cache involves creating modules and data structures to represent the cache and its operations

**Code Logic**

The code snippet is designed to update a RAM array based on different conditions. Here is a brief explanation of the logic:![IMG_0581](https://github.com/johnyeocx/iac-project-team02/assets/151572498/6cceae09-3156-4596-aadd-3aacd1cf30e3)


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
  
when both 

**Files**

- `ram_array_update_logic.sv`: Contains the code snippet for updating the RAM array.

**Usage**

- Integrate this logic into your main system where RAM updates are required.
- Customize the conditions and data handling based on your specific requirements.

- Initially I wrote the entire first  code based on this arrangement.
- Each line has 123 bits(64 (32+32）bits for data in way 0 and way 1, 56(28+28) bits for tags 0 and 1, and 3 bits for v0, v1 and u)(yes !I use the least recently used method)
![IMG_0580](https://github.com/johnyeocx/iac-project-team02/assets/151572498/277612c4-acd0-4def-987c-b6f47adbfe48)

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
Designing regfile and ALU helps me understanding parts of CPU and cooperating with my teammates helps me understanding that individual work needs to be adjusted to work together.
While this project successfully demonstrated the advantages of a 2-way set-associative cache, there are avenues for further exploration. Future research could delve into making of CPU and related components, addressing specific challenges or optimizing the cache design for certain application scenarios.


