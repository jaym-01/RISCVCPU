#include "Vpc.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char** env){
    int i, clk;

    Verilated::commandArgs(argc, argv);

    // init top instance
    Vpc *top = new Vpc();

    // init trace dump of signals
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("pc/pcwaveform.vcd");

    // init inputs and outputs
    top->clk = 1;
    top->rst = 1;
    top->pc_4 =0;
    top->pc_b =0;
    top->pc_r =0;
    top->pc_next =0;
   for(i=0;i<300;i++){
       for(clk = 0; clk < 2; clk++){
            tfp->dump(2*i + clk);
            top->clk = !top->clk;
            top->eval();
        }
 }

     if(i==2){
        //for branch instruction
        top->pc_src=2'b1;
        top->pc_4=0x00000004;
        top->pc_b=0x00000018;
        top->pc_r=0x00000024;
        //pc_next should be 0x00000018
     }
     else if(i==3){
     //for register instruction
        top->pc_src=2'b10;
        top->pc_4=0x00000010;
        top->pc_b=0x0000000C;
        top->pc_r=0x00000020;
        //pc_next should be 0x00000020

     }
     else if(i==4){
       //for adding 4 instruction
        top->pc_src=2'b??;
        top->pc_4=0xFFFFFFF4;
        top->pc_b=0xFFFFFFEC;
        top->pc_r=0x0000001C;
        //pc_next should be 0xFFFFFFF4
     }

    if(Verilated::gotFinish()) exit(0);


    tfp->close();
    exit(0);
    std::cout<<pc_next<<std::endl;
}