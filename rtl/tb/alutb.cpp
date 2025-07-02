#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Valu.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#define MAX_CYCLES 6
vluint64_t sim_time = 0;

#define CHECK(signal, expected) \
    if ((signal) != (expected)) { \
        std::cerr << "ASSERT FAIL: " #signal " == " << (int)(signal) \
                  << ", expected " << (int)(expected) << std::endl; \
        exit(1); \
    }

void step(Valu* alu, VerilatedVcdC* trace, int cycles = MAX_CYCLES) {
    for (int i = 0; i < cycles; ++i) {
        alu->clk = !alu->clk;
        alu->eval();
        if (trace) trace->dump(sim_time);
        sim_time++;
    }
}

void test_add(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 5 + 10\n";
    alu->enable = 1;
    alu->mode = 16;  // OP_ADD
    alu->in_a = 5;
    alu->in_b = 10;
    step(alu, trace);
    CHECK(alu->out, 15);
    CHECK(alu->flag_zero, 0);
    CHECK(alu->flag_carry, 0);
}

void test_zero(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 5 - 5 (should zero)\n";
    alu->enable = 1;
    alu->mode = 17;  // OP_SUB
    alu->in_a = 5;
    alu->in_b = 5;
    step(alu, trace);
    CHECK(alu->out, 0);
    CHECK(alu->flag_zero, 1);
    CHECK(alu->flag_carry, 0);
}

void test_carry(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 255 + 1 (should carry)\n";
    alu->enable = 1;
    alu->mode = 16;  // OP_ADD
    alu->in_a = 255;
    alu->in_b = 1;
    step(alu, trace);
    CHECK(alu->out, 0);
    CHECK(alu->flag_zero, 1);
    CHECK(alu->flag_carry, 1);
}

void test_and(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 16 & 8 \n";
    alu->enable = 1;
    alu->mode = 18;  // OP_AND
    alu->in_a = 0xAA;
    alu->in_b = 0x55;
    step(alu, trace);
    CHECK(alu->out, 0x00);
    CHECK(alu->flag_zero, 1);
}

void test_or(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 0x0F | 0xF0 \n";
    alu->enable = 1;
    alu->mode = 19;  // OP_OR
    alu->in_a = 0x0F;
    alu->in_b = 0xF0;
    step(alu, trace);
    CHECK(alu->out, 0xFF);
    CHECK(alu->flag_zero, 0);
}

void test_xor(Valu* alu, VerilatedVcdC* trace) {
    std::cout << "Running test: 0x3C ^ 0x0F \n";
    alu->enable = 1;
    alu->mode = 20;  // OP_XOR
    alu->in_a = 0x3C;
    alu->in_b = 0x0F;
    step(alu, trace);
    CHECK(alu->out, 0x33);
    CHECK(alu->flag_zero, 0);
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Valu* alu = new Valu;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    alu->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    test_add(alu, m_trace);
    test_zero(alu, m_trace);
    test_carry(alu, m_trace);
    test_and(alu, m_trace);
    test_or(alu, m_trace);
    test_xor(alu, m_trace);

    std::cout << "All tests passed.\n";

    m_trace->close();
    delete alu;
    delete m_trace;
    return 0;
}
