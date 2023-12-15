# Personal Statement: John

## **Overview**

Throughout this project, I was tasked with implementing the following components:

**Single Cycle**

- [Control unit](#control-unit)
- [Extend](#extend)
- [Instruction memory](#instruction-memory)
- [Data memory](#data-memory)

**Pipeline**

- [Implementing the primary pipelined stages and additional components to support pipelined signals (e.g. D Flip Flops)](#pipeline)

Additionally, for the single cycle processor, I planned and drew out the additional logic and changes on top of the original diagram, as shown below, for the single cycle processor, so that the entire group was synchronised and in agreement on how to implement the RISCV processor. This diagram is shown below:

![Diagram of Single Cycle CPU](../images/SingleCycleDesign.jpg)

## Single Cycle

**Commits:** [Commit fd82548](https://github.com/johnyeocx/iac-project-team02/commit/fd825483846293d3e1b77f112e19411ecfb2fd1e), [Commit abd1157](https://github.com/johnyeocx/iac-project-team02/commit/abd1157f6db489873745e9a641c5fea6437e09b9)

Below, I have detailed how I implemented each component which I worked on for the single cycle processor. In general, the control unit took up the bulk of the work as I had to not only consider each signal and case, but also make decisions based on other members’ components in order to make them work correctly together. Below, I have shown what each control signal means and the values that it can take on, and how this affects the other components in the processor.

Additionally, I have illustrated how I implemented the other 3 components: extend, instruction & data memory. Extend and instruction memory were the easiest, with data memory being slightly complicated due to the cases of byte, half word and word, as well as zero / sign extensions being handled. In general, these weren’t necessary for the reference program to work, but were implemented just to be more robust.

### Control Unit

The control unit takes in 4 signals:

1. op: Type of instruction
2. funct7
3. funct3
4. Zero

It uses these inputs to determine the following control signals:

**PCSrc (2 bits)**

This controls what the next PC instruction is. There are three possible cases:

| Case      | PCSrc | Meaning                                                                          |
| --------- | ----- | -------------------------------------------------------------------------------- |
| PC + 4    | 2‘b00 | This is the regular case                                                         |
| PC + Imm  | 2‘b01 | This is when the branch condition is true (Zero == 1) OR when there is a JAL ins |
| Rd1 + Imm | 2’b10 | When there is a JALR (RET) ins                                                   |

**ImmSrc (3 bits)**

This controls how the Imm value is sign extended in the **extend** component. Each ImmSrc corresponds to a particular type of instruction, determined from **op**:

| ImmSrc | Case       | Relevant Instructions       |
| ------ | ---------- | --------------------------- |
| 3’b000 | Default    | Rest (e.g. JALR, ADD, etc.) |
| 3’b001 | B Type Ins | BNE                         |
| 3’b010 | S Type Ins | SB                          |
| 3’b011 | J Type Ins | JAL                         |
| 3’b100 | U Type Ins | LUI                         |

**ALUControl (3 bits)**

This controls the operation performed by the ALU, and hence the output ALUResult. Although ALUControl is 3 bits, only 3 values were ultimately used, but 3 bits was ultimately used for flexibility, incase extra instructions were to be added later on. The ALUControl values correspond to the following, which was determined from both the **op and funct7** variables:

| ALUControl | ALU Result         |
| ---------- | ------------------ |
| 3’b000     | ADD                |
| 3’b001     | SUB                |
| 3’b010     | SrcB (for LUI ins) |

Although the SUB instruction was technically not needed, we eventually used it in the f1.s program to set register a0 to 0 (SUB a0, a0, a0).

**MemSrc (3 bits) = funct3**

MemSrc is used to indicate the type of load / store byte operation (such as byte, halfword or word). The MemSrc signal has the following meanings:

**MemSrc[2]**: if 1, then load data with zero extension, otherwise signed extension

| MemSrc[1:0] | Meaning             |
| ----------- | ------------------- |
| 2’b00       | Byte operation      |
| 2’b01       | Half Word operation |
| 2’b11       | Word operation      |

Although technically not used by the reference program, since only SB & LBU instructions were written, it was implemented just to make the data memory component more complete.

**RegWSrc (2 bits)**

This controls whether the data to write to the register file comes from the ALU Result, Data mem read data, or PC + 4. The RegWSrc signal values and their meanings are as follows:

| RegWSrc | Meaning                 | Relevant Ins |
| ------- | ----------------------- | ------------ |
| 2’b00   | WriteData = ALUResult   |              |
| 2’b01   | WriteData = Data Mem RD | LBU          |
| 2’b10   | WriteData = PC + 4      | JAL, JALR    |

Initially, this was split into 2 signals, 1 to determine if the value to write comes from Mem or ALU, and the other to determine if write was PC + 4. However, after working on the pipeline, we saw this more succinct implementation, and changed the single cycle processor to just have 1 control signal to switch between 3 cases.

**Old:**

```verilog
assign result = result_src? read_data : alu_result;
assign wd3 = rw_src? {{DATA_WIDTH-INS_ADDRESS_WIDTH{1'b0}}, pc_incr_4} : result;
```

**New**

```verilog
assign wd3 = rw_src == 2'b01 ? read_data
: rw_src == 2'b10 ? {{DATA_WIDTH-INS_ADDRESS_WIDTH{1'b0}}, pc_incr_4}
: alu_result;
```

**Other 1 bit control signals**

The control unit also implements the following 1 bit signals, which control whether to write to memory, the SrcB signal in ALU, as well as whether to write to register file:

| Signal   | Meaning                          | Relevant Ins                   |
| -------- | -------------------------------- | ------------------------------ |
| MemWrite | Write to data mem if 1           | SB                             |
| ALUSrc   | SrcB = Imm if 1, else SrcB = Rd2 | LBU, SB, ADDI, LUI             |
| RegWrite | Write to Rd if 1                 | ADD, ADDI, LBU, JALR, JAL, LUI |

With that, the control unit is complete. For some signals, there could’ve been more values implemented, but as per the project guide, these signals were implemented to cover fully or more than the instructions written in the reference & f1 programs.

---

### Extend

The extend component takes in

- ImmSrc: control signal from control unit,
- Ins[31:7]: this contains all the bits necessary to construct the extended Imm data

and uses that to determine how to construct the 32 bit Imm signal to be passed to the ALU. The most significant bit (**msb**) is always Imm[31]. The ImmSrc signals and corresponding Imm extended is as follows:

| ImmSrc | Case       | ImmExt                                                        |
| ------ | ---------- | ------------------------------------------------------------- |
| 3’b000 | Default    | { 20 \* msb, Imm[31:0] }                                      |
| 3’b001 | B Type Ins | { 19 \* msb, Imm[31], Imm[7], Imm[30:25], Imm[11:8], 1’b0 }   |
| 3’b010 | S Type Ins | { 20 \* msb, Imm[31:25], Imm[11:7] }                          |
| 3’b011 | J Type Ins | { 11 \* msb, Imm[31], Imm[19:12], Imm[20], Imm[30:21], 1’b0 } |
| 3’b100 | U Type Ins | { Imm[31:12], 12 \* 1’b0 }                                    |

---

### Instruction Memory

The instruction memory component is relatively simple, as it simply declares a 2D array representing instruction mem, with size **2 ** A_WIDTH x 7\*\*. The default value for A_WIDTH in this case is 12. Here, there are:

- 2^A_WIDTH memory locations
- Each memory location holds 7 bit data

The reason for the 7 bit data width used is because RISCV is byte addressable, and so each data location should hold 7 bits of data.

However, since instructions are 32 bits each, each read operation will input an address that is a multiple of 4, and the output data will be a 32 bit instruction, with the format as such:

```verilog
assign RD = {instr_arr[A+3], instr_arr[A+2], instr_arr[A+1], instr_arr[A]};
```

---

### Data Memory

The data memory component is slightly more complex that the instruction memory component. It follows a similar format of having size 2 \*\* A_WIDTH x 7. The default value for A_WIDTH in this case is 20.

The data mem takes in 4 inputs:

- A: address to read from / write to
- MemSrc: control signal indicating a unsigned / signed & byte / halfword / word operation
- WE: control signal indicating whether to write to address A
- WD: data to write to address A

An internal logic **sign_bit** will be 0 if MemSrc indicates zero extension or **msb** of data_mem_arr. Based on these, it will either:

1. Write WD to address A:

```verilog
if (WE == 1) begin
    data_mem_arr[addr] <= WD[7:0];
    if (MemSrc[1:0] == 2'b01) data_mem_arr[addr + 1] <= WD[15:8]; // half word
    else if (MemSrc[1:0] == 2'b10) begin
        data_mem_arr[addr + 1] <= WD[15:8];
        data_mem_arr[addr + 2] <= WD[23:16];
        data_mem_arr[addr + 3] <= WD[31:24];
    end
end
```

1. Read from address A and output to **RD:**

```verilog
always_comb begin
    if (MemSrc[1:0] == 2'b00)
        RD = {{24{sign_bit}}, data_mem_arr[addr]}; // LBU operation
    else if (MemSrc[1:0] == 2'b01)
        RD = {{16{sign_bit}}, data_mem_arr[addr + 1], data_mem_arr[addr]}; // LHU operation
    else
        RD = {data_mem_arr[addr + 3], data_mem_arr[addr + 2], data_mem_arr[addr + 1], data_mem_arr[addr]}; // LW operation
end
```

**Note**: To test these components, my group mate Jay ensured that the f1 & reference program worked. In the process of testing, there were some syntaxtual errors which he corrected. However, ultimately, the components functioned correctly and the two programs gave the correct output.

## Pipeline

For the pipelined RISCV processor, I was in charge of implementing the pipeline stages, while Jay was in charge of implementing the hazard unit.

To implement the pipelined processor, I broke it down into each stage:

- Fetch
- Decode
- Exec
- Memory
- Writeback

and considered which signals needed to be passed to which stage. Each signal would then have it’s corresponding pipelined version at each stage appended with a \_{stage}. For instance, the PCPlus4 signal would have a PCPlus4_f signal to represent the version of that signal in the fetch stage, or PCPlus4_w for the version of that signal in the Writeback stage.

### Implementation 1

Commit: [Commit 15f6ce3](https://github.com/johnyeocx/iac-project-team02/commit/15f6ce3500a3a806a00ea21e038a549bc3805bc8)

When I first implemented the pipeline, I did it in a way such that each signal would pass through the stages **within the component** it was in. So I first broke down the pipeline into each stage:

- Fetch
- Decode
- Exec
- Memory
- Writeback

And then for each component, I would consider which signals would need to be used in each stage. For instance, inside of PC, the PCPlus4 signal would need to be passed to the Writeback stage, and so my PC component looked something like the following:

```verilog
logic [A_WIDTH-1:0] PCPlus4_f;
logic [A_WIDTH-1:0] PCPlus4_d;
logic [A_WIDTH-1:0] PCPlus4_e;
logic [A_WIDTH-1:0] PCPlus4_m;

always_ff @(posedge clk, posedge rst) begin
    if (rst) PC_f <= {A_WIDTH{1'b0}};

    else begin
        PC_f <= PCNext;
        PC_d <= PC_f;
        PC_e <= PC_d;

        // pipelining PC + 4 to Writeback stage
        PCPlus4_f <= PCNext + {{A_WIDTH-3{1'b0}}, 3'b100};
        PCPlus4_d <= PCPlus4_f;
        PCPlus4_e <= PCPlus4_d;
        PCPlus4_m <= PCPlus4_e;
        PCPlus4_w <= PCPlus4_m;
    end;
end;
```

After that, the output would be whichever “version” of the signal which would be used. In this case, PCPlus4_w would be used in the writeback stage.

However, the problem of this implementation arose when Jay tried to implement the hazard unit. Because all these pipelined signals were contained inside their components, he wasn’t able to effectively perform stall, flush & forwarding operations inside of them. On my part, I should have worked more closely with him, instead of working on this separately. As a result, we had to switch out design of the pipeline processor to implementation 2.

### Implementation 2

Commits: [Commit e766856](https://github.com/johnyeocx/iac-project-team02/commit/e766856b5e614dac860aafbc517e00098789c11b), [Commit 0764a1c](https://github.com/johnyeocx/iac-project-team02/commit/0764a1c777932dd104b153926d776da254470a55)

For the second implementation, each component would process signals as it would in the single cycle, and there would then be a pipelined component, which simply contains flip flops to pass the signals from one stage to the next.

Using the example of PC above, the PC component looks like the following:

```verilog
logic [ADDRESS_WIDTH-1:0] PCNext;

always_ff @(posedge clk, posedge rst) begin
    if (rst) PC_f <= {ADDRESS_WIDTH{1'b0}};
    else PC_f <= PCNext;
end

assign PCPlus4_f = PC_f + {{ADDRESS_WIDTH-3{1'b0}}, 3'b100};
```

And now the PCPlus4_f signal would be passed to the next stage in a component called pipeline_fd, which passes all the necessary signals from the fetch stage to the decode stage. This file looks like such:

```verilog
always_ff @(posedge clk)
    if(stall == 0) begin
        ins_d <= ins_f;
        PC_d <= PC_f;
        PCPlus4_d <= PCPlus4_f;
        flush2_d <= flush2_f;
    end
```

**Note**: stall was added by Jay for his hazard control implementation

As you can see, each of the fetch stage signals that is needed in the later stages are pipelined into the decode stage through a flip flop. This was then done similarly for both data & control signals for the decode to exec stage, exec to memory stage and memory to writeback stage. Jay implemented part of this stage too (the memory & writeback stages).

Once Jay implemented the hazard controls, the components were tested and the correct outputs were seen when running the f1 & reference programs.

## Adding Data Cache to top and testing (with Jay)

Commits: [Commit 3bfaf78](https://github.com/johnyeocx/iac-project-team02/commit/3bfaf78bb3ef8094b20ca195328c7ca9d1c70540), [Commit 9dfb205](https://github.com/johnyeocx/iac-project-team02/commit/9dfb205d90f9933d7196a07eeba75338ff112cac)

For this section, me and Jay were tasked with integrating the data cache module that Ze Quan & Ying Kai made with the top design file and ensuring that the programs still worked as expected. In general, the data cache module was added asynchronously to the memory stage of the pipeline. It can be seen as an “addition” to the data memory module, so this means that there weren’t any changed that were needed to be made to the pipelining of the processor.

### Editting the data cache module

Ze Quan & Ying Kai initially built a 2 way set associative cache [Commit 7c976e3](https://github.com/johnyeocx/iac-project-team02/commit/7c976e32e3631f4049a3119e7ff486b991fe55d2). In order to make it work with top, I made the following changes:

**Writing to cache**

This was a section which I worked on for the data cache. For writing to the cache, I considered three possibilities:

- Read operation and there was a hit: Update U bit in way 1 cache
- Read operation and no hit: Update cache with new data and tag
- Write operation: Update cache with new data (& tag if it’s new)

This is done synchronously, similar to how data is written to data memory. On the rising edge of the next clock cycle, data will be written.

**Data size**

Initially, when building the cache, I encountered problems with the 32 bit data size, because the LBU and SB instructions were writing & reading bytes, and my strategy was to simply replace the specific byte offset within the word stored in the cache. However, this made the tag invalid for the other bytes in the word, and therefore the program didn’t work.

**Change 1: Make data in cache byte sized**

To fix this, the first thing I did was to simply make the data sizes in the cache byte sized, as can be seen in the following code:

```verilog
logic [TAG_WIDTH + B_WIDTH:0] way_0_cache [3:0];
logic [TAG_WIDTH + B_WIDTH + 1:0] way_1_cache [3:0];
```

However, I realised that while this implementation allowed the f1 & reference program to work, it wasn’t very robust because word & half word store & read operations would completely fail.

### Adding the data cache module to top

To integrate the updated data cache module with top, all that was needed was to add a mux in top to determine whether data should be read from the data cache depending on whether there was a read hit:
```

**riscv_top.sv**

```verilog
assign ReadData_m = hit ? data_from_cache : data_from_memory;
```

Testing this out with the f1 & reference programs showed them working. Moreover, on further inspection into the waveforms, it could be seen that there were several hits, which means that data was being read from the cache.

## **Conclusion**

In conclusion, working on the RISCV processor throughout this project has been fun and instrumental in helping me understand fundamentally how the processor works. In particular, the pipelined implementation was more challenging, but offered great insight into how efficiency can be improved by creating each stage and how to propagate signals throughout the stages to maintain the RISCV’s functionality.

One mistake I made was implementing the pipelined stage without regard for how the hazard control would be done, and this resulted in me having to do a reimplementation, but nevertheless an important lesson on the importance of coordination in a team.
