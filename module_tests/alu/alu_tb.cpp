#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Valu.h"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Valu* top = new Valu;
    
    //init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("alu.vcd");

    //initialize simulation inputs
    top->SUM = 0;
    top->op1 = 0;
    top->op2 = 0;
    top->ALUctrl = 0;
    

    //run simulation for many clock cycles
    for (i=0; i < 300; i++) {
    
        //dump variables into VCD file and toggle clock
        for (clk=0; clk < 2; clk++) {
            tfp->dump (2*i+clk);        //unit is in ps
            top->eval ();
        }
        if(i == 2) {
            // subtract
            top->ALUctrl = 3'b001; // 1 as in base10
            top->op1 = 5;
            top->op2 = 4;
            // expect SUM = 1 (see waveform)
        } else if(i == 3) {
            // sum
            top->ALUctrl = 3'b011;
            top->op1 = 3;
            top->op2 = 2;
            // expect SUM = 5
        } else if(i == 4) {
            // and
            top->ALUctrl = 3'b010;
            top->op1 = 6;
            top->op2 = 9;
            // expect SUM = 0
        } else if(i == 5) {
            // or
            top->ALUctrl = 3'b000;
            top->op1 = 2;
            top->op2 = 1;
            // expect SUM = 3
        } else if(i == 6) {
            // set less than
            top->ALUctrl = 3'b101;
            top->op1 = 2;
            top->op2 = 3;
            // expect SUM = 1
        }
        if (Verilated::gotFinish()) exit(0);
    }
    tfp->close();
    exit(0);
}