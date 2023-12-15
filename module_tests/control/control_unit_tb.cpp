#include "Vcontrol_unit.h"
#include "verilated.h"
#include "vector"
#include "iostream"
#include "string"

void testResult(int signal, int ans, int ins, std::string signal_name){
    if(ans == -1) return;
    else if(signal == ans) return;
    else std::cout << "failed on instruction: " << ins << " | on signal: " << signal_name << " | expected: " << ans << " | got: " << signal <<  std::endl;
}

int main(int argc, char **argv, char **env)
{
    int simCycle, clk;

    Verilated::commandArgs(argc, argv);

    // create pointer to VControlUnit_top to interface signals
    Vcontrol_unit *top = new Vcontrol_unit();

    //          |      inputs                 |            outputs                                                            |
    // columns: | op | funct3 | funct7 | Zero | ImmSrc | PCSrc | ALUControl | ALUSrc | MemWrite | MemSrc | RegWrite | RegWSrc |
    // rows:
    // JAL
    // JALR
    // SB
    // LBU
    // ADD
    // ADDI
    // LUI
    // BNE, don't branch (Zero = 1)
    // BNE, branch (Zero = 0)
    // SUB

    // don't cares have been represented as -1 on the outputs and 0 on the inputs
    std::vector<std::vector<int>> test = {
        {111, 0, 0, 0, 3, 1, -1, -1, 0, -1, 1, 2},
        {103, 0, 0, 0, 3, 2, 0, 1, 0, -1, 1, 2},
        {35, 0, 0, 0, 2, 0, 0, 1, 1, 0, 0, -1},
        {3, 4, 0, 0, 0, 0, 0, 1, 0, 4, 1, 1},
        {51, 0, 0, 0, -1, 0, 0, 0, 0, -1, 1, 0},
        {19, 0, 0, 0, 0, 0, 0, 1, 0, -1, 1, 0},
        {55, 0, 0, 0, 4, 0, 2, 1, 0, -1, 1, 0},
        {99, 1, 0, 1, 1, 0, -1, -1, 0, -1, 0, -1},
        {99, 1, 0, 0, 1, 1, -1, -1, 0, -1, 0, -1},
        {51, 0, 32, 0, -1, 0, 1, 0, 0, -1, 1, 0}
    };

    for (simCycle = 0; simCycle < test.size(); simCycle++)
    {
        // set the values of the inputs
        top->op = test[simCycle][0];
        top->funct3 = test[simCycle][1];
        top->funct7 = test[simCycle][2];
        top->Zero = test[simCycle][3];

        // process the signals
        top->eval();
        
        // check all of the outputs
        testResult(top->ImmSrc, test[simCycle][4], simCycle, "ImmSrc");
        testResult(top->PCSrc, test[simCycle][5], simCycle, "PCSrc");
        testResult(top->ALUControl, test[simCycle][6], simCycle, "ALUControl");
        testResult(top->ALUSrc, test[simCycle][7], simCycle, "ALUSrc");
        testResult(top->MemWrite, test[simCycle][8], simCycle, "MemWrite");
        testResult(top->MemSrc, test[simCycle][9], simCycle, "MemSrc");
        testResult(top->RegWrite, test[simCycle][10], simCycle, "RegWrite");
        testResult(top->RegWSrc, test[simCycle][11], simCycle, "RegWSrc");

        if (Verilated::gotFinish())
            exit(0);
    }

    exit(0);
}