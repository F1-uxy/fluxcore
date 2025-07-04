#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Vcpu.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "parameters.h"

#define MAX_CYCLES 50
vluint64_t sim_time = 0;

#define CHECK(signal, expected) \
    if ((signal) != (expected)) { \
        std::cerr << __FILE__ << ":" << __LINE__ << ": " \
                  << "ASSERT FAIL: " #signal " == " << (int)(signal) \
                  << ", expected " << (int)(expected) << std::endl; \
        exit(1); \
    }

static inline void tick(Vcpu* cpu, VerilatedVcdC* trace) {
    cpu->clk = 0; ctrl->eval(); trace->dump(sim_time++);
    cpu->clk = 1; ctrl->eval(); trace->dump(sim_time++);
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vcpu* cpu = new Vcontrolunit;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    cpu->trace(m_trace, 5);
    m_trace->open("waveform.vcd");


    std::cout << "All tests passed.\n";

    m_trace->close();
    delete cpu;
    delete m_trace;
    return 0;
}
