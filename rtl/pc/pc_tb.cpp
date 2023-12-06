#include "Vpc.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char** env){
    int i, clk;

    Verilated::commandArgs(argc, argv);

    // init top instance
    Vpc_top *top = new Vpc_top();

    // init trace dump of signals
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("pc/pcwaveform.vcd");

    // init inputs
    top->clk = 1;
    top->rst = 1;

    for(clk = 0; clk < 2; clk++){
             tfp->dump(2*i + clk);
            top->clk = !top->clk;
            top->eval();
        }

     top->rst = (i < 2);

    if(Verilated::gotFinish()) exit(0);

    tfp->close();
    exit(0);
}