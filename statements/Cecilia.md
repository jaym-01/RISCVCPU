# Personal Statement: Cecilia(Zequan Li)

## **Overview**

In this project, I was responsiable for the following components:

**Single Cycle**

- Program Counter
  -systemverilog file for pc
   -testbench for pc
    -test results for pc(GTKwave) 

After finishing and debuging the code for program counter I started simulation for the program.   

**Data Cache**

- I seperate the cache design into two parts:
  -Simple direct mapped cahce
  -2-way set associative cache

## Single Cycle

**Commits:** 

The core of program counter is a MUX. I need to integrate all the different instructions into MUX and specify collected signals into different types of instruction implementations. In this part, I need to consider the components from other members' block and understand each logic.Finally I mapped the hardware logic into software logic and done the simulation.

Also,as for personal work at beginning, testing program seems is not mandatory. However, when I realized that we work as a team, it will be very helpful for us to test our own program well before the final integration and verification stage, because we can make sure that the previous progress is correct.This makes our team more efficient and saves a lot of time.
![Block diagram of PC](https://postimg.cc/QHFJ0Pb5)

### Program Counter

Signals:
-pc_src:
 -to select three different pc instructions:
  -Regular case
  -Branch
  -Jump
-clock and reset:
 -Asynchronous reset
-Output:
 -PC(external)
 -pc_next(internal)

Outputs from ALU&control unit goes to PC inputs:

**Multiplexer**

This determine pc_next(the internal logic that will tranmitt to output logic PC). There are three possible cases:

| Case      | PCSrc | Meaning                                                                          |
| --------- | ----- | -------------------------------------------------------------------------------- |
| PC + 4    | 2‘b00 | This is the regular case +4 because of byte addressing                                                          |
| PC + Imm  | 2‘b01 | This is when the branch condition is true (Zero == 1) OR when there is a JAL ins |
| Rd1 + Imm | 2’b10 | When there is a JALR (RET) ins                                                   |

```verilog
always_comb
        case(pc_src)
            2'b1: pc_next = pc_b;
            2'b10: pc_next = pc_r;
            default: pc_next = pc_4;
        endcase
```
Using default to cover all "don't care conditions"
![Block diagram of mux](https://postimg.cc/YLLZKxgC)

**PC flipflop**

This transmit internal logic pc_next to output PC:
```verilog
always_ff @(posedge clk, posedge rst)
       if(rst) PC <= {ADDRESS_WIDTH{1'b0}};
       else PC <= pc_next;
```
![Block diagram of FF](https://postimg.cc/ZvktqgJd)


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
2.In the testbench tried different combinations of input and compare the output with expected
3.Created a shell file to run the simulation
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


![Wavform generated](<a href='https://postimg.cc/21C9Zdbq' target='_blank'><img src='https://i.postimg.cc/21C9Zdbq/Full-Size-Render.jpg' border='0' alt='Full-Size-Render'/></a>)
---

## Data Cache

For adding cache memory of RISCV processor, I was in charge of the direct mapped cache and associated 2-way cache



## **Conclusion**
