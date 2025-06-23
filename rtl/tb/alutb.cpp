#include <stdlib.h>
#include <iostream>
#include "obj_dir/Valu.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#define MAX_TIME 20
vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Valu* alu = new Valu;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    alu->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    // Reset signals
    alu->clk = 0;
    alu->enable = 0;
    alu->mode = 0;
    alu->in_a = 0;
    alu->in_b = 0;

    // Test case: 5 + 10
    alu->enable = 1;
    alu->mode = 16;  // OP_ADD
    alu->in_a = 5;
    alu->in_b = 10;

    for (int i = 0; i < MAX_TIME; ++i) {
        alu->clk = !alu->clk;
        alu->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    std::cout << "OUT: " << (int)alu->out << std::endl;
    std::cout << "ZERO: " << alu->flag_zero << std::endl;
    std::cout << "CARRY: " << alu->flag_carry << std::endl;

    m_trace->close();
    delete alu;
    delete m_trace;
    return 0;
}
