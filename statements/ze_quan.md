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

- Direct-mapped cache which contains:
  - Memory module
  - Cache module
  - Top-level file
  - Testbench
- Two-way set associative cache

## Single Cycle

The core of program counter is a MUX. I need to integrate all the different instructions into MUX and specify collected signals into different types of instruction implementations. In this part, I need to consider the components from other members' block and understand each logic.Finally I mapped the hardware logic into software logic and done the simulation.

![Block diagram of PC](https://i.postimg.cc/WbnYbcq9/IMG-1709.jpg)

### Program Counter

Signals:

- pc_src:to select three different pc instructions:
  - Regular case
  * Branch
  - Jump
- clock and reset:
  - Asynchronous reset
- Output:
  - PC(external)
  * pc_next(internal)

Outputs from ALU&control unit goes to PC inputs:

**Multiplexer**

This determine pc_next(the internal logic that will transmitt to output logic PC). There are three possible cases:

| Case      | PCSrc | Meaning                                                         |
| --------- | ----- | --------------------------------------------------------------- |
| PC + 4    | 2‘b00 | For register(regular) instruction +4 because of byte addressing |
| PC + Imm  | 2‘b01 | For branch instruction OR JAL instruction                       |
| Rd1 + Imm | 2’b10 | For jump instruction                                            |

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
1. Created a testbench for Program counter
2. In the testbench tried different combinations of input and compare the output with expected
3. Created a shell file to run the simulation

In this code I tried different combination of address and compare the output with the expected value

One mistake I made here was assigning the value of pc_src.Because testbench using C++ and I specifeid the value in systemverilog.
Another was unmatched bits in assigning memory address value.At first I defined the Data width was 12 bits but here I used 32 bits.
After changing it the program works well.

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
-which comfirmed that the test results are same as the expected value.Thus the actual output matched the expected value.

## Data Cache

For adding cache memory of RISCV processor, I was in charge of adding single-cycle direct mapping cache and tried to do two-way set associative cache for a 4GB main memory which is organized as 4-byte blocks, and a direct-mapped cache/two-way set associative cache of 32 bytes with a block size of 4 bytes.Finally our team choose to use pipelined 2-way set associative cache by correcting me and liam's code and adding pipelining.Below are all my basic workings:

- For the direct mapped cache implementation used :
  - A total of 8 sets
  - Single cache line per set
  - No need of any replacement policy
  - The Write-back method will be used(if have more time)
  - Forms 8 entry x 60 bits RAM(without adding U bit)
- For the two-way set associative cache implementation used :
  - A total of 4 sets
  - Two cache line per set
  - The LRU (Least Recently Used) replacement policy will be used (if have more time)
  - The Write-through/write-back method will be used(if have more time)
  - Forms 4 entry x 122 bits RAM(without adding U bit)

### Direct-mapped Cache

In a direct-mapped cache structure, the cache is organized into multiple sets with a single cache line per set. Based on the address of the memory block, it can only occupy a single cache line. The cache can be framed as a n × 1 column array.

**Module Memory**

1. Input and Output
   - address: 32-bit input representing the memory address.
     - **Note**:Previous design our team choose address width to be 20 bits,here I use 32 bits for convenience(easier to map with example in lecture)the width problem already fixed by group member in the final version of file(data_cache.sv)
   - data_in: 32-bit input representing data to be written into memory.
   - write_enable: Input signal indicating whether a write operation should be performed.
   - data_out: 32-bit output representing data read from memory.

```verilog
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

```verilog
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

```verilog
  // Read and write operations
  always_ff @(posedge write_enable) begin
    if (write_enable) begin
      // Write data to main memoy
      memory[address/BLOCK_SIZE] = data_in;
    end
  end

  // Read data from main memory
  assign data_out = memory[address/BLOCK_SIZE];//no need of read_enable because always read

```

**Module Direct-mapped cache**

1. Input and Output

- cpu_address: 32-bit input representing the CPU address.
- cpu_data_in: 32-bit input representing data to be written into the cache.
- cpu_write: Input signal indicating whether a write operation should be performed.
- cpu_read: Input signal indicating whether a read operation should be performed.
- cpu_data_out: 32-bit output representing data read from the cache.

```verilog
module DirectMappedCache (
  input logic [31:0] cpu_address,
  input logic [31:0] cpu_data_in,
  input logic cpu_write,
  input logic cpu_read,
  output logic [31:0] cpu_data_out
);

```

2.Cache parameters&cache memory

- CACHE_SIZE: Parameter specifying the size of the cache (32 bytes).
- BLOCK_SIZE: Parameter specifying the size of each cache block (4 bytes).
- SETS: Parameter calculating the number of sets in the cache.
- cache_memory: Cache memory array storing 32-bit data elements, with the array size determined by SETS.
  -valid: Array of valid bits, one for each set in the cache.

```verilog
 // Cache parameters
 parameter int CACHE_SIZE = 32; // 32 bytes cache
 parameter int BLOCK_SIZE = 4; // 4 bytes per block
 parameter int SETS = 8; // Number of sets

 // define arrays
 logic [31:0] cache_memory [0: SETS-1];
 logic valid [0: SETS-1];
```

3.The incoming address to the cache is divided into bits for Offset, Index and Tag.

- Offset corresponds to the bits used to determine the byte to be accessed from the cache line. Because the cache lines are 4 bytes long, there are 2 offset bits.
- Index corresponds to bits used to determine the set of the Cache. There are 8 sets in the cache, and because 2^3 = 8, there are 3 index bits.
- Tag corresponds to the remaining bits. This means there are 32 – (3+2) = 27 bits, which are stored in tag field to match the address on cache request.

| Siganl | Corresponding address bit |
| ------ | ------------------------- |
| offset | cpu_address[1:0]       |
| index  | cpu_address[4:2]       |
| tag    | cpu_address[31:5]      |

```verilog
  // Cache control signals
  logic [1:0] offset;
  logic [2:0] index;
  logic [26:0] tag;
  logic hit;
  // Extract index and tag from memory address
  always_comb begin
    offset = cpu_adress[1:0];
    index = cpu_address[4:2];
    tag = cpu_address[31:5];
  end
```

4.Hit determination&read.write operations

For direct mapped cache,the tag bits derived from the memory block address are compared with the tag bits associated with the set. If the tag matches, then there is a cache hit and the cache block is returned to the processor. Else there is a cache miss and the memory block is fetched from the lower memory

```verilog
 // Hit determination
  always_comb begin
    hit = valid[index] && (tag == cache_memory[index][31:5]);
  end
 // Cache read and write operations
  always_ff @(posedge cpu_read or posedge cpu_write) begin
    if (cpu_read || cpu_write) begin
      hit = 0;
      if (valid[index] && (tag == cache_memory[index][31:5])) begin
        hit = 1;
        cpu_data_out = cache_memory[index];
      end
      if (cpu_write) begin
        cache_memory[index] = cpu_data_in;
        valid[index] = 1;
      end
    end
  end
```

**Top-level file**

```verilog
module Top_cache;

  // Inputs and outputs
  logic [31:0] cpu_address;
  logic [31:0] cpu_data_in;
  logic cpu_write;
  logic cpu_read;
  logic [31:0] cpu_data_out;

  Memory mem (
    .address(cpu_address),
    .data_in(cpu_data_in),
    .write_enable(cpu_write),
    .data_out(cpu_data_out)
  );

  DirectMappedCache cache (
    .cpu_address(cpu_address),
    .cpu_data_in(cpu_data_in),
    .cpu_write(cpu_write),
    .cpu_read(cpu_read),
    .cpu_data_out(cpu_data_out),
  );

    //try different combinations of inputs for write operation
  initial begin
    // Write data to memory at address 0x100
    cpu_address = 32'h100;
    cpu_data_in = 32'hABCDEFFF;
    cpu_write = 1;
    cpu_read = 0;
    #10;

    //try different combinations of inputs for read operation 
    cpu_address = 32'h100;
    cpu_data_in = 32'h0;
    cpu_write = 0;
    cpu_read = 1;
    #10;

    $finish;
  end

endmodule : Top_cache

```

**Testbench**

```C++
#include <verilated.h>
#include "VTop_cache.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VTop_cache* top = new VTop_cache;

    top->cpu_address = 0;
    top->cpu_data_in = 0;
    top->cpu_write = 0;
    top-cpu_read = 0;

    // Simulate for 1000 clock cycles
    for (int i = 0; i < 1000; ++i) {
        top->cpu_address = 0x100;  // try an address and verify
        top->cpu_data_in = 0xABCDEFFF;  // try an data and verify
        top->cpu_write = 1;
        top->cpu_read = 0;

        top->eval();

        // check outputs
        std::cout << "Data Out: " << top->cpu_data_out << std::endl;

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

A set-associative cache can be imagined as a n × m matrix. The cache is divided into ‘n’ sets and each set contains ‘m’ cache lines.For two-way set associative cache m=2. A memory block is first mapped onto a set and then placed into any cache line of the set.
This part wrote by me is not completed yet so finally we didn't choose this as final version, just leave it as practice.Jay and John further modify this part with correct and complete code and adding pipelining to the cache memory.Below I will attach all my thinking process and progress.

**Module TwoWaySetAssociativeCache**

1. Input and Output
   - cpu_address: 32-bit input representing the CPU address.
   - cpu_data_in: 32-bit input representing data to be written into the cache.
   - cpu_write: Input signal indicating whether a write operation should be performed.
   - cpu_read: Input signal indicating whether a read operation should be performed.
   - cpu_data_out: 32-bit output representing data read from the cache.

```systemverilog
module TwoWaySetAssociativeCache (
  input logic [31:0] cpu_address,
  input logic [31:0] cpu_data_in,
  input logic cpu_write,
  input logic cpu_read,
  output logic [31:0] cpu_data_out
);
```

2. Cache parameters & memory arrays
  - CACHE_SIZE: Parameter specifying the size of the cache (32 bytes).
  - BLOCK_SIZE: Parameter specifying the size of each cache block (8 bytes).
  - SETS: Parameter indicating the number of sets in the cache (4 sets).
  - WAYS: Parameter indicating the number of cache lines per set (2 ways).
  - cache_memory: Two-dimensional array storing 32-bit data elements for each set and way.
  - valid: Two-dimensional array of valid bits, one for each set and way.

``` verilog
  // Cache parameters
  parameter int CACHE_SIZE = 32; // 32 bytes cache
  parameter int BLOCK_SIZE = 4; // 4 bytes per block
  parameter int SETS = 8; // Number of sets
  parameter int WAYS = 2; // Number of cache lines per set

  // Cache memory arrays
  logic [31:0] cache_memory [0: SETS-1][0: WAYS-1];
  logic valid [0: SETS-1][0: WAYS-1];
```

3. Adress bits extraction
``` verilog
  // Cache control signals
  logic [1:0] offset; 2bits
  logic [1:0] index; 2 bits
  logic [27:0] tag;//28 bits
  logic hit;

  // Extract index and tag from memory address
  always_comb begin
    offset = cpu_address[1:0];
    index = cpu_address[3:2];
    tag = cpu_address[31:4];
  end

```

4. Hit determination&read.write operations

The module calculates a hit signal based on whether there is a valid match in either of the two ways within the set.
During a read operation, it checks if there is a cache hit. If yes, it provides the data from the cache. If no, it initiates a miss.
During a write operation, it updates the cache with the new data. If there is a cache hit, it can follow a write-through policy, updating both the cache and main memory. 

``` verilog
 // Hit determination
  always_comb begin
    hit = valid[index][0] && (tag == cache_memory[index][0][31:4]) ||
          valid[index][1] && (tag == cache_memory[index][1][31:4]);
  end
  // Cache read and write operations
  always_ff @(posedge cpu_read or posedge cpu_write) begin
    if (cpu_read || cpu_write) begin
      hit = 0;
      for (int i = 0; i < WAYS; i++) begin
        if (valid[index][i] && (tag == cache_memory[index][i][31:4])) begin
          hit = 1;
          cpu_data_out = cache_memory[index][i];
        end
      end
      
      if (cpu_write) begin
        if (hit) begin
          memory[index * WAYS][31:0] = cpu_data_in;
        end
      end
    end
  end

```
## **Conclusion**

In the collaborative endeavor within our group, we fostered a highly pleasant and seamless working environment. Throughout the project, my team members consistently exhibited kindness and friendliness, providing not only valuable guidance but also significantly contributing to my learning journey. Recognizing that my individual skills may be comparatively weaker, I acknowledge limitations in directly contributing to team tasks. However, the unwavering support and encouragement from the team have been instrumental in inspiring me to broaden my contributions, for which I am sincerely appreciative.

In the face of unfamiliar operations, John and Jay consistently extended their guidance, explaining procedures, and offering detailed notes for future reference. Their willingness to allocate time for research and study during challenging moments, coupled with their prompt assistance in answering questions and aiding in debugging, has been invaluable. Collaborating with the entire team has proven to be an immensely fortunate experience, resulting in substantial learning and a noteworthy enhancement of my coding abilities.

Practically, I acquired proficiency in GitHub operations, encompassing pulling, pushing, committing, and crafting README files. Additionally, the experience enriched my teamwork skills and instilled a heightened sense of responsibility. Given additional time, my intention is to delve deeper into the study of the unfinished LRU replacement policy and the write-through/write-back policy, aiming to refine the logic of our cache unit.
