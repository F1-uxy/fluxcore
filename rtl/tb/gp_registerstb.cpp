#include <stdlib.h>
#include <iostream>
#include "Vgp_registers.h"
#include <verilated.h>
#include <verilated_vcd_c.h>

#include <stdint.h>

#define MAX_TIME 20
vluint64_t sim_time = 0;


int write_to_reg(Vgp_registers* reg, VerilatedVcdC* m_trace, uint8_t value, uint8_t reg_count)
{
    if(reg == NULL)
    {
        fprintf(stderr, "Register pointer NULL\n");
        return -1;
    }

    reg->write_en = 1;
    reg->out_en = 0;
    reg->sel_in = reg_count;
    reg->data_in = value;

    for (int i = 0; i < 2; i++) {
        reg->clk = !reg->clk;
        reg->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    return 0;
}

uint8_t read_from_reg(Vgp_registers* reg, VerilatedVcdC* m_trace, uint8_t reg_count)
{
    if(reg == NULL)
    {
        fprintf(stderr, "Register pointer NULL\n");
        return -1;
    }

    reg->write_en = 0;
    reg->data_in = 0;
    reg->out_en = 1;
    reg->sel_in = reg_count;

    for (int i = 0; i < 2; i++) {
        reg->clk = !reg->clk;
        reg->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    return reg->data_out;
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vgp_registers* reg = new Vgp_registers;

    Verilated::traceEverOn(true);  // Enable VCD tracing
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    reg->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    int cycles = 0;

    // Reset signals
    reg->clk = 0;

    for (int i = 0; i < 2; i++) {
        reg->clk = !reg->clk;
        reg->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }


    // Write 0xFF to reg A (0)
    write_to_reg(reg, m_trace, 0x69, 2);
    write_to_reg(reg, m_trace, 0x96, 1);

    uint8_t val = read_from_reg(reg, m_trace, 2);

    std::cout << "Reg A Value: " << reg->regb << std::endl;
    std::cout << "Reg A Value: " << val << std::endl;
    std::cout << "Data Out Value: " << val << std::endl;



    m_trace->close();
    delete reg;
    delete m_trace;
    return 0;
}
