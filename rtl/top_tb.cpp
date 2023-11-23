#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define MAX_SIM_CYCLE 1000000

int main(int argc, char **argv, char** env){
    int simCycle, clk;

    Verilated::commandArgs(argc, argv);

    Vtop *top = new Vtop();


}