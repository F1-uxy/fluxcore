#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Vcontrolunit.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#define MAX_CYCLES 50
vluint64_t sim_time = 0;

#define CHECK(signal, expected) \
    if ((signal) != (expected)) { \
        std::cerr << "ASSERT FAIL: " #signal " == " << (int)(signal) \
                  << ", expected " << (int)(expected) << std::endl; \
        exit(1); \
    }


int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vcontrolunit* ctrl = new Vcontrolunit;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    ctrl->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    ctrl->instruction = 64;

    for (int i = 0; i < 50; i++) {
        ctrl->clk = !ctrl->clk;
        ctrl->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    std::cout << "All tests passed.\n";

    m_trace->close();
    delete ctrl;
    delete m_trace;
    return 0;
}
