#include "verilated.h"
#include "Valu.h"
#include "vector"
#include "iostream"

int main(int argc, char **argv, char **env) {
    int i;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Valu* top = new Valu();
    
    // colums: | op1 | op2 | ALUCtrl | SUM | Zero 
    std::vector<std::vector<int>> tests = {
        {6, 13, 0, 19, 0},
        {13, 6, 1, 7, 0},
        {6, 6, 1, 0, 1},
        {0, 100, 2, 100, 0}
    };

    //run simulation for many clock cycles
    for (i=0; i < tests.size(); i++) {

        top->op1 = tests[i][0];
        top->op2 = tests[i][1];
        top->ALUctrl = tests[i][2];

        // evaluate the output 
        top->eval();

        if(top->SUM != tests[i][3]) std::cout << "error on test: " << i << std::endl;
        if(top->zero != tests[i][4]) std::cout << "error on test: " << i << std::endl;
        
        if (Verilated::gotFinish()) exit(0);
    }
    exit(0);
}