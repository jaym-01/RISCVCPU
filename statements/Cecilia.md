# Personal Statement: Cecilia(Zequan Li)

## **Overview**

In this project, I was responsiable for the following components:

**Single Cycle**

- Program Counter
   - systemverilog file for pc
   - testbench for pc
   - test results for pc(GTKwave) 

After finishing and debuging the code for program counter I started simulation for the program.   

**Data Cache**

- I seperate the cache design into two parts:
    - Direct mapped cache 
    - Two-way set associative cache

## Single Cycle


The core of program counter is a MUX. I need to integrate all the different instructions into MUX and specify collected signals into different types of instruction implementations. In this part, I need to consider the components from other members' block and understand each logic.Finally I mapped the hardware logic into software logic and done the simulation.

Also,as for personal work at beginning, testing program seems is not mandatory. However, when I realized that we work as a team, it will be very helpful for us to test our own program well before the final integration and verification stage, because we can make sure that the previous progress is correct.This makes our team more efficient and saves a lot of time.
![Block diagram of PC](https://i.postimg.cc/WbnYbcq9/IMG-1709.jpg)

### Program Counter

Signals:
- pc_src:to select three different pc instructions:
  - Regular case
  * Branch
  + Jump
- clock and reset:
  - Asynchronous reset
- Output:
  - PC(external)
  * pc_next(internal)

Outputs from ALU&control unit goes to PC inputs:

**Multiplexer**

This determine pc_next(the internal logic that will tranmitt to output logic PC). There are three possible cases:

| Case      | PCSrc | Meaning                                                                          |
| --------- | ----- | -------------------------------------------------------------------------------- |
| PC + 4    | 2‘b00 | For register(regular) instruction +4 because of byte addressing                                                          |
| PC + Imm  | 2‘b01 | For branch instruction OR JAL instruction|
| Rd1 + Imm | 2’b10 | For jump instruction                                                  |

```verilog
always_comb
        case(pc_src)
            2'b1: pc_next = pc_b;
            2'b10: pc_next = pc_r;
            default: pc_next = pc_4;
        endcase
```
Using default to cover all "don't care conditions"
![Block diagram of mux](https://i.postimg.cc/gjgWhS28/IMG-1711.jpg)

**PC flipflop**

This transmit internal logic pc_next to output PC:
```verilog
always_ff @(posedge clk, posedge rst)
       if(rst) PC <= {ADDRESS_WIDTH{1'b0}};
       else PC <= pc_next;
```
![Block diagram of FF](https://i.postimg.cc/SQ8HcbBB/IMG-1730.jpg)


**Mistakes made in this part:**

At the beginning, I did not consider jump instruction. The mux I wrote had only one bit, either control normal plus4 ins or branch ins that contain pc target (extension block output).
Later in the meeting, my team member told me that the JALR ins need to be taken into account, so I changed pcsrc into two bits to control four inputs, which could cover the entire instruction case.
After that I realized for teamwork I need to think deeply and makesure I understad the whole project and consider all the possible combinations of instructions involved in the project.so that it will be more precise after I have a precise thinking.Getting to know each person’s part is important and know about the relationship between different parts before starting work, rather than just foucus on my individual part. 

**The old code**
```verilog
always_comb begin
    if(PCsrc) next_PC=PC_target
    else next_PC=inc_PC;
 end
```

**The new code**

```verilog
always_comb
    case (pc_src)
     2'b0: PC = pc_4;
     2'b1: PC = pc_b;
     2'b10:PC = pc_r;
    endcase
```


### Testbench

What I have done:
1.Created a testbench for Program counter
1.In the testbench tried different combinations of input and compare the output with expected
1.Created a shell file to run the simulation
**Code For Testbench**
```C++
#include "verilated.h"
#include "verilated_vcd_c.h"
#include"Vpc.h"


int main(int argc, char **argv, char** env){
    int i, clk;

    Verilated::commandArgs(argc, argv);

    // init top instance
    Vpc *top = new Vpc;

    // init trace dump of signals
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("pc.vcd");

    // init inputs and outputs
    //top->clk = 1;
   // top->rst = 1;
    top->pc_4 =0;
    top->pc_b =0;
    top->pc_r =0;
    top->PC =0;
   for(i=0;i<300;i++){
       for(clk = 0; clk < 2; clk++){
            tfp->dump(2*i + clk);
            top->clk = !top->clk;
            top->eval();
        } 
        
        if(i==2){
        //for branch instruction
        top->pc_src = 1;
        top->pc_4 =0x014;
        top->pc_b =0x00C;
        top->pc_r =0x001;
        //pc_next should be 0x00C
     }
     else if(i==3){
     //for register instruction
        top->pc_src = 2;
        top->pc_4 =0x010;
        top->pc_b =0x00C;
        top->pc_r =0x020;
        //pc_next should be 0x020

     }
     else if(i==4){
       //for adding 4 instruction
        top->pc_4 =0xFF4;
        top->pc_b =0xFEC;
        top->pc_r =0x1C;
        //pc_next should be 0xFF4
     }
 }



    if(Verilated::gotFinish()) exit(0);


    tfp->close();
    exit(0);
}
```
In this code I tried different combination of address and compare the output with the expected value

One mistake I made here was assigning the value of pc_src.Because testbench using C++ and I specifeid the value in systemverilog.Another was unmatched bits in assigning memory address value.At first I defined the Data width was 12 bits but here I used 32 bits.After changing it the program works well.

**The old code**
```C++
 if(i==2){
        //for branch instruction
        top->pc_src=2'b1;
        top->pc_4=0x00000004;
        top->pc_b=0x00000018;
        top->pc_r=0x00000024;
        //pc_next should be 0x00000018
     }
```
### Test results

After running the shell script pc.vcd file was generated and displayed in GTKwave
-As shown in the picture when the pc_src=10,corresponding to the output will be same as the input of pc_r.The actual output matched the expected value.

![Wavform generated](https://i.postimg.cc/g2ZC1NGK/Full-Size-Render.jpg)
---

## Data Cache

For adding cache memory of RISCV processor, I was in charge of adding direct mapping cache and two-way set associative cache(without replacement and write policy) for a 4GB main memory which is organized as 4-byte blocks, and a direct-mapped cache/two-way set associative cache of 32 bytes with a block size of 4 bytes.
- For the direct mapped cache implementation used :
  - A total of 8 sets
  - Single cache line per set
  - The LRU (Least Recently Used) replacement policy will be used (if have more time)
  - The Write through method will be used(if have more time)
  - Forms 8 entry x 60 bits RAM(without adding U bit)
- For the two-way set associative cache implementation used :
  - A total of 4 sets
  - Two cache line per set
  - The LRU (Least Recently Used) replacement policy will be used (if have more time)
  - The Write through method will be used(if have more time)
  - Forms 4 entry x 122 bits RAM(without adding U bit)

### Direct-mapped Cache

In a direct-mapped cache structure, the cache is organized into multiple sets with a single cache line per set. Based on the address of the memory block, it can only occupy a single cache line. The cache can be framed as a n × 1 column array.

**Module Memory**

1. Input and Output
   - address: 32-bit input representing the memory address.
   - data_in: 32-bit input representing data to be written into memory.
   - write_enable: Input signal indicating whether a write operation should be performed.
   - data_out: 32-bit output representing data read from memory.

``` verilog
module Memory (
  input logic [31:0] address,
  input logic [31:0] data_in,
  input logic write_enable,
  output logic [31:0] data_out
);

```

2. Main memory parameters&main memory
   - MEM_SIZE: Parameter specifying the size of the main memory (4GB in this case).
   - BLOCK_SIZE: Parameter specifying the size of each memory block (4 bytes).
   - MEM_ADDR_BITS: Parameter indicating the number of bits required to address the memory (32 bits).
   - memory: A memory array storing 32-bit data elements, with the array size calculated based on MEM_SIZE and BLOCK_SIZE.

``` verilog
  // Main memory parameters
  parameter int MEM_SIZE = 32'h100000000; // 4GB
  parameter int BLOCK_SIZE = 4; // 4 bytes per block
  parameter int MEM_ADDR_BITS = 32; // 32-bit address

  // Main memory array
  logic [31:0] memory [0: (MEM_SIZE/BLOCK_SIZE)-1];

```

3. Read and Write operation
   - always_ff: A procedural block sensitive to the positive edge of write_enable.
   - Inside the block, it checks if write_enable is active. If true, it writes data_in to the corresponding block in memory.
   - assign data_out: An assignment statement continuously updates data_out with the content of the memory block addressed by address/BLOCK_SIZE.

``` verilog
  // Read and write operations
  always_ff @(posedge write_enable) begin
    if (write_enable) begin
      // Write data to main memory
      memory[address/BLOCK_SIZE] = data_in;
    end
  end

  // Read data from main memory
  assign data_out = memory[address/BLOCK_SIZE];

```
**Module Direct-mapped cache**
1. Input and Output
  - cpu_address: 32-bit input representing the CPU address.
  - cpu_data_in: 32-bit input representing data to be written into the cache.
  - cpu_write: Input signal indicating whether a write operation should be performed.
  - cpu_read: Input signal indicating whether a read operation should be performed.
  - cpu_data_out: 32-bit output representing data read from the cache.

``` verilog
module DirectMappedCache (
  input logic [31:0] memory_address,
  input logic [31:0] memory_data_in,
  input logic memory_write,
  input logic memory_read,
  output logic [31:0] memory_data_out
);

```
2.Cache parameters&cache memory
  - CACHE_SIZE: Parameter specifying the size of the cache (32 bytes).
  - BLOCK_SIZE: Parameter specifying the size of each cache block (4 bytes).
  - SETS: Parameter calculating the number of sets in the cache.
  - cache_memory: Cache memory array storing 32-bit data elements, with the array size determined by SETS.
  -valid: Array of valid bits, one for each set in the cache.

 ``` verilog
  // Cache parameters
  parameter int CACHE_SIZE = 32; // 32 bytes cache
  parameter int BLOCK_SIZE = 4; // 4 bytes per block
  parameter int SETS = CACHE_SIZE/BLOCK_SIZE; // Number of sets

  // Cache memory
  logic [31:0] cache_memory [0: SETS-1];
  logic valid [0: SETS-1];
```

3.The incoming address to the cache is divided into bits for Offset, Index and Tag.
  - Offset corresponds to the bits used to determine the byte to be accessed from the cache line. Because the cache lines are 4 bytes long, there are 2 offset bits.
  - Index corresponds to bits used to determine the set of the Cache. There are 8 sets in the cache, and because 2^3 = 8, there are 3 index bits.
  - Tag corresponds to the remaining bits. This means there are 32 – (3+2) = 27 bits, which are stored in tag field to match the address on cache request.

| Siganl        | Corresponding address bit                           |                                                                     
| ------------- | ----------------------------------------------------|
| offset        |   memory_address[1:0]                               |
| index         |   memory_address[4:2]                               |
| tag           |   memory_address[31:5]                              |                          
``` verilog
  // Cache control signals
  logic [2:0] index;
  logic [26:0] tag;
  logic hit;
  // Extract index and tag from memory address
  always_comb begin
    offset = memory_adress[1:0];
    index = cpu_address[4:2];
    tag = cpu_address[31:5];
  end
```


4.Hit determination&read.write operations

For direct mapped cache,the tag bits derived from the memory block address are compared with the tag bits associated with the set. If the tag matches, then there is a cache hit and the cache block is returned to the processor. Else there is a cache miss and the memory block is fetched from the lower memory 

``` verilog
 // Hit determination
  always_comb begin
    hit = valid[index] && (tag == cache_memory[index][31:5]);
  end
 // Cache read and write operations
  always_ff @(posedge cpu_read or posedge cpu_write) begin
    if (cpu_read || cpu_write) begin
      hit = 0;
      // Check the cache line for the requested data
      if (valid[index] && (tag == cache_memory[index][31:5])) begin
        hit = 1;
        cpu_data_out = cache_memory[index];
      end
      // Perform write operation if cpu_write is 1
      if (cpu_write) begin 
        // Write data to the cache line
        cache_memory[index] = cpu_data_in;
        // Set the valid bit
        valid[index] = 1;
      end
    end
  end
```

**Top-level file**

``` verilog
module Top_cache;

  // Inputs and outputs
  logic [31:0] memory_address;
  logic [31:0] memory_data_in;
  logic memory_write;
  logic memory_read;
  logic [31:0] memory_data_out;

  // Instantiate Memory module
  Memory mem (
    .address(memory_address),
    .data_in(memory_data_in),
    .write_enable(memory_write),
    .data_out(memory_data_out)
  );

  // Instantiate DirectMappedCache module
  DirectMappedCache cache (
    .cpu_address(memory_address),
    .cpu_data_in(memory_data_in),
    .cpu_write(memory_write),
    .cpu_read(memory_read),
    .cpu_data_out(memory_data_out)
  );

  // Testbench logic - example reads and writes
  initial begin
    // Write data to memory at address 0x100 (assuming byte addressing)
    memory_address = 32'h100;
    memory_data_in = 32'hABCDEFFF;
    memory_write = 1;
    memory_read = 0;
    #10;

    // Read data from memory at address 0x100
    memory_address = 32'h100;
    memory_data_in = 32'h0;
    memory_write = 0;
    memory_read = 1;
    #10;

    // Perform additional tests as needed

    // Finish simulation
    $finish;
  end

endmodule : TopModule

```

**Testbench**

``` C++
#include <verilated.h>
#include "VTop_cache.h"

int main(int argc, char** argv) {
    // Initialize Verilator and the module instance
    Verilated::commandArgs(argc, argv);
    VTop_cache* top = new VTop_cache;

    // Testbench variables
    top->memory_address = 0;
    top->memory_data_in = 0;
    top->memory_write = 0;
    top-memory_read = 0;

    // Simulate for 1000 clock cycles
    for (int i = 0; i < 1000; ++i) {
        top->memory_address = 0x100;  // Example address
        top->memory_data_in = 0xABCDEFFF;  // Example data
        top->memory_write = 1;
        top->memory_read = 0;

        // Evaluate the module
        top->eval();

        // Print or check outputs if needed
        std::cout << "Data Out: " << top->cpu_data_out << std::endl;

        // Advance simulation time
        top->clk = 0;
        top->eval();
        top->clk = 1;
        top->eval();
    }

    // Clean up
    delete top;
    exit(0);
}

```
### Two-way set associative cache
















## **Conclusion**
This group cooperation was very pleasant and smooth. My team members were very kind. They taught me a lot of things during this process and made me make great progress. As for my contribution to this project, I would like to say that my ability is relatively weak among all the four people, so there are not many things that I can help the team to complete. However, everyone has been helping me and encouraging me to do more things that can increase my contribution,so I really aprreciate that. For the operations that I am not familiar with, john and jay always teach me how to do them and leave me notes to facilitate my review later. They also gave me time to research and study when I am struggling my part, and they also answer my questions that I could not solve individually and help me debug. I feel very lucky to finish this project together with everyone and really learned a lot, which also made my coding ability improved a lot. In practice, I also learned how to pull and push to github, how to commit, how to write README, and how to work in a team and be a responsible person. If I have more time, I will continue to study the unfinished LRU replacement policy and write through/back policy to make the logic of this cache unit more rigorous.
