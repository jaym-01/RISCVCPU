#include "verilated.h"
#include "Vpc.h"
#include "vector"
#include "iostream"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance
    Vpc* top = new Vpc();
    
    // colums: | rst | pc_4 | pc_b | pc_r | pc_src | PC 
    std::vector<std::vector<int>> tests = {
        {0, 1, 2, 3, 0, 1},
        {0, 1, 2, 3, 1, 2},
        {0, 1, 2, 3, 2, 3},
        {1, 1, 2, 3, 0, 0},
    };

    top->clk = 1;

    //run simulation for many clock cycles
    for (i=0; i < tests.size(); i++) {

        top->rst = tests[i][0];
        top->pc_4 = tests[i][1];
        top->pc_b = tests[i][2];
        top->pc_r = tests[i][3];
        top->pc_src = tests[i][4];

        // evaluate the output 
        for(clk = 0; clk < 2; clk++) {
            top->clk = !top->clk;
            top->eval();
        }

        if(top->PC != tests[i][5]) std::cout << "error on test: " << i << std::endl;

        if (Verilated::gotFinish()) exit(0);
    }
    exit(0);
}