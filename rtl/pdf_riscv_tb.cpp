#include "vbuddy.cpp"
#include "Vriscv_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define MAX_SIM_CYCLE 1000000

int main(int argc, char **argv, char** env){
    int simCycle, clk;

    Verilated::commandArgs(argc, argv);

    // create pointer to Vriscv_top to interface signals
    Vriscv_top *top = new Vriscv_top();

    // init vcd file for trace of signals
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("test/PDFWaveform.vcd");

    // init vbuddy
    if(vbdOpen() != 1) return(-1);
    vbdHeader("RISC V: PDF");

    // flag on vbuddy set to one-shot
    vbdSetMode(1);

    bool show_signal = false;

    // init input
    top->clk = 1;
    top->rst = 1;

    for(simCycle = 0; simCycle < MAX_SIM_CYCLE; simCycle++){
        // run 1 clock cycle
        for(clk = 0; clk < 2; clk++){
            tfp->dump(2*simCycle + clk);
            top->clk = !top->clk;
            top->eval();
        }

        // dipslay output graph on the vbuddy
        // only after the 'display' subroutine
        if(show_signal || top->a0 != 0){
            vbdPlot(top->a0, 0, 255);
            vbdCycle(simCycle+1);
            show_signal = true;
        }
        

        top->rst = (simCycle < 2);

        // display clock cycle on the vbuddy
        if(Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}