#include <stdlib.h>
#include <iostream>
#include <cassert>
#include "Vcontrolunit.h"
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

static inline void tick(Vcontrolunit* ctrl, VerilatedVcdC* trace) {
    ctrl->clk = 0; ctrl->eval(); trace->dump(sim_time++);
    ctrl->clk = 1; ctrl->eval(); trace->dump(sim_time++);
}

void test_NOP(Vcontrolunit* ctrl, VerilatedVcdC* trace)
{
    ctrl->instruction = OP_NOP;

    CHECK(ctrl->cycle, 0);

    for(int i = 0; i < 6; i++)
    {
        tick(ctrl, trace);

        if (ctrl->cycle == 1) {
            CHECK(ctrl->state, STATE_FETCH_PC);
        }
        if (ctrl->cycle == 2) {
            CHECK(ctrl->state, STATE_FETCH_INST);
        }
        if (ctrl->cycle == 3) {
            CHECK(ctrl->state, STATE_NEXT);
        }
    }
}

void test_ALU(Vcontrolunit* ctrl, VerilatedVcdC* trace)
{
    ctrl->instruction = OP_ALU;

    CHECK(ctrl->cycle, 0);

    for(int i = 0; i < 6; i++)
    {
        tick(ctrl, trace);

        if (ctrl->cycle == 1) {
            CHECK(ctrl->state, STATE_FETCH_PC);
        }
        if (ctrl->cycle == 2) {
            CHECK(ctrl->state, STATE_FETCH_INST);
        }
        if (ctrl->cycle == 3) {
            CHECK(ctrl->state, STATE_ALU_EXEC);
        }
        if (ctrl->cycle == 4) {
            CHECK(ctrl->state, STATE_ALU_STORE);
        }
        if (ctrl->cycle == 5) {
            CHECK(ctrl->state, STATE_NEXT);
        }
    }
}

void test_JMP(Vcontrolunit* ctrl, VerilatedVcdC* trace)
{
    ctrl->instruction = OP_JMP;

    CHECK(ctrl->cycle, 0);

    for(int i = 0; i < 6; i++)
    {
        tick(ctrl, trace);

        if (ctrl->cycle == 1) {
            CHECK(ctrl->state, STATE_FETCH_PC);
        }
        if (ctrl->cycle == 2) {
            CHECK(ctrl->state, STATE_FETCH_INST);
        }
        if (ctrl->cycle == 3) {
            CHECK(ctrl->state, STATE_FETCH_PC);
        }
        if (ctrl->cycle == 4) {
            CHECK(ctrl->state, STATE_JUMP);
        }
        if (ctrl->cycle == 5) {
            CHECK(ctrl->state, STATE_NEXT);
        }
    }
}

void test_LDI(Vcontrolunit* ctrl, VerilatedVcdC* trace)
{
    ctrl->instruction = OP_LDI;

    CHECK(ctrl->cycle, 0);

    for(int i = 0; i < 6; i++)
    {
        tick(ctrl, trace);

        if (ctrl->cycle == 1) {
            CHECK(ctrl->state, STATE_FETCH_PC);
        }
        if (ctrl->cycle == 2) {
            CHECK(ctrl->state, STATE_FETCH_INST);
        }
        if (ctrl->cycle == 3) {
            CHECK(ctrl->state, STATE_FETCH_PC);
        }
        if (ctrl->cycle == 4) {
            CHECK(ctrl->state, STATE_SET_REG);
        }
        if (ctrl->cycle == 5) {
            CHECK(ctrl->state, STATE_NEXT);
        }
    }
}

void test_MOV(Vcontrolunit* ctrl, VerilatedVcdC* trace)
{
    ctrl->instruction = OP_MOV;

    CHECK(ctrl->cycle, 0);

    for(int i = 0; i < 6; i++)
    {
        tick(ctrl, trace);

        if (ctrl->cycle == 1) {
            CHECK(ctrl->state, STATE_FETCH_PC);
        }
        if (ctrl->cycle == 2) {
            CHECK(ctrl->state, STATE_FETCH_INST);
        }
        if (ctrl->cycle == 3) {
            CHECK(ctrl->state, STATE_MOV_FETCH);
        }
        if (ctrl->cycle == 4) {
            CHECK(ctrl->state, STATE_MOV_LOAD);
        }
        if (ctrl->cycle == 5) {
            CHECK(ctrl->state, STATE_MOV_STORE);
        }
        if (ctrl->cycle == 6) {
            CHECK(ctrl->state, STATE_NEXT);
        }
    }
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vcontrolunit* ctrl = new Vcontrolunit;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    ctrl->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    ctrl->instruction = 64;

    ctrl->reset = 1;
    tick(ctrl, m_trace);
    tick(ctrl, m_trace);
    ctrl->reset = 0;

    test_NOP(ctrl, m_trace);
    test_ALU(ctrl, m_trace);
    test_JMP(ctrl, m_trace);
    test_LDI(ctrl, m_trace);
    test_MOV(ctrl, m_trace);


    std::cout << "All tests passed.\n";

    m_trace->close();
    delete ctrl;
    delete m_trace;
    return 0;
}
