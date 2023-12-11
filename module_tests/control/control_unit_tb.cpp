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

    // columns: | op | funct3 | funct7 | ImmSrc | PCSrc | ALUControl | ALUSrc | MemWrite | MemSrc | RegWrite | RegWSrc | Branch
    // rows:
    // JAL
    // JALR
    // SB
    // LBU
    // ADD
    // ADDI
    // LUI
    // BNE
    // SUB

    // don't cares have been represented as -1 on the outputs and 0 on the inputs
    std::vector<std::vector<int>> test = {
        {111, 0, 0, 3, 1, -1, -1, 0, -1, 1, 2, 0},
        {103, 0, 0, 3, 2, 0, 1, 0, -1, 1, 2, 0},
        {35, 0, 0, 2, 0, 0, 1, 1, 0, 0, -1, 0},
        {3, 4, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0},
        {51, 0, 0, -1, 0, 0, 0, 0, -1, 1, 0, 0},
        {19, 0, 0, 0, 0, 0, 1, 0, -1, 1, 0, 0},
        {55, 0, 0, 4, 0, 2, 1, 0, -1, 1, 0, 0},
        {99, 1, 0, 1, 1, -1, -1, 0, -1, 0, -1, 1},
        {51, 0, 32, -1, 0, 1, 0, 0, -1, 1, 0, 0}
    };

    for (simCycle = 0; simCycle < test.size(); simCycle++)
    {
        // set the values of the inputs
        top->op = test[simCycle][0];
        top->funct3 = test[simCycle][1];
        top->funct7 = test[simCycle][2];

        // process the signals
        top->eval();
        
        // check all of the outputs
        testResult(top->ImmSrc, test[simCycle][3], simCycle, "ImmSrc");
        testResult(top->PCSrc, test[simCycle][4], simCycle, "PCSrc");
        testResult(top->ALUControl, test[simCycle][5], simCycle, "ALUControl");
        testResult(top->ALUSrc, test[simCycle][6], simCycle, "ALUSrc");
        testResult(top->MemWrite, test[simCycle][7], simCycle, "MemWrite");
        testResult(top->MemSrc, test[simCycle][8], simCycle, "MemSrc");
        testResult(top->RegWrite, test[simCycle][9], simCycle, "RegWrite");
        testResult(top->RegWSrc, test[simCycle][10], simCycle, "RegWSrc");
        testResult(top->Branch, test[simCycle][11], simCycle, "Branch");

        if (Verilated::gotFinish())
            exit(0);
    }

    exit(0);
}