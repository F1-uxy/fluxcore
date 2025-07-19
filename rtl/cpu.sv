`include "rtl/parameters.sv"
`include "rtl/library/counter.sv"
`include "rtl/library/register.sv"
`include "rtl/library/tristate_buffer.sv"


module cpu (
    input logic clk,
    input logic reset,
    output logic [7:0] addr_bus,
    output logic mem_clk,

    inout logic [7:0] bus
);

// ============
// Clocks:
//   - clk_b = inverted clock for control unit
// ============
logic cycle_clk     = 0;
logic internal_clk  = 0;
logic [2:0] cnt     = 3'b100;
logic halted        = 0;

always_ff @(posedge clk) begin
  if (!halted) begin
    {cycle_clk, mem_clk, internal_clk} <= cnt;

    case (cnt)
      3'b100: cnt <= 3'b010;
      3'b010: cnt <= 3'b001;
      3'b001: cnt <= 3'b100;
      default: cnt <= 3'b100; // safety fallback
    endcase
  end
end

logic flag_zero;
logic flag_carry;

// ===============
// Control Signals
//  - c_rin = Registers in
//  - c_rou = Registers out

//  - c_aen = Alu enable
//  - c_aou = Alu enable output read onto bus

//  - c_mae = Memory Address Register enable
//  - c_ien = Instruction Regierster enable

//  - c_pce = Program counter enable
//  - c_pcw = Program counter write
//  - c_pcd = Program counter decrement
//  - c_pco = Program counter enable output read onto bus

//  - c_spe = Stack pointer enable
//  - c_spw = Stack pointer write
//  - c_spd = Stack pointer decrement
//  - c_spo = Stack pointer enable output read onto bus
// ===============

logic c_rin, c_rou;
logic c_aen, c_aou;
logic c_mae, c_ien;
logic c_pce, c_pcd, c_pco;
logic c_spe, c_spd, c_spo;



// ============
// Registers
// ============

logic [2:0] sel_in;
logic [7:0] rega_out;
logic [7:0] regb_out;

gp_registers m_registers (
    .clk(internal_clk),
    .write_en(c_rin),
    .out_en(c_rou),
    .data_in(bus),
    .sel_in(sel_in),
    .data_out(bus),
    .rega(rega_out),
    .regb(regb_out)
);

// Memory Address Register
register m_mar (
    .clk(internal_clk),
    .enable(c_mae),
    .reset(reset),
    .data_in(bus),
    .data_out(addr_bus)
);

// Instruction Register
logic [7:0] ireg_out;
register m_ireg (
    .clk(internal_clk),
    .enable(c_ien),
    .reset(reset),
    .data_in(bus),
    .data_out(ireg_out)
);

// ===============
// Program Counter
// ===============

logic [7:0] pc_out;

counter m_pc(
    .clk(c_pce & internal_clk),
    .in(bus),
    .sel_in(c_pcw),
    .reset(reset),
    .dec(c_pcd),
    .out(pc_out)
);

tristate_buffer m_pc_buff(
    .enable(c_pco),
    .in(pc_out),
    .out(bus)
);

// ===============
// Stack Pointer
// ===============

logic [7:0] sp_out;

counter m_sp(
    .clk(c_spe & internal_clk),
    .in(bus),
    .sel_in(c_spw),
    .reset(reset),
    .dec(c_spd),
    .out(sp_out)
);

tristate_buffer m_sp_buff(
    .enable(c_spo),
    .in(sp_out),
    .out(bus)
);

// ============
// ALU
// ============

logic [7:0] alu_out;
logic [2:0] alu_mode;

alu m_alu(
    .clk(internal_clk),
    .enable(c_aen),
    .mode(alu_mode),
    .in_a(rega_out),
    .in_b(regb_out),
    .out(alu_out),
    .flag_carry(flag_carry),
    .flag_zero(flag_zero)
);

tristate_buffer m_alu_buff(
    .enable(c_aou),
    .in(alu_out),
    .out(bus)
);

// =============
// Control Logic
// =============

logic next_state;

logic [7:0] instruction;
logic [7:0] state;
logic [3:0] cycle;
logic [3:0] opcode;

logic [2:0] operand1;
logic [2:0] operand2;

assign next_state = (state == `STATE_NEXT) | reset;
assign instruction = ireg_out;

assign operand1 = instruction[5:3];
assign operand2 = instruction[2:0];

assign c_rin = (state == `STATE_ALU_STORE) | 
               (state == `STATE_SET_REG);

assign c_rou = 0;

assign c_aen = (state == `STATE_ALU_EXEC);

assign c_aou = (state == `STATE_ALU_STORE);

assign c_mae = (state == `STATE_FETCH_PC);

assign c_ien = (state == `STATE_FETCH_PC);

assign c_pce = (state == `STATE_FETCH_INST);

assign c_pcd = 0;

assign c_pco = (state == `STATE_FETCH_PC);


controlunit m_controlunit(
    .clk(cycle_clk),
    .reset(next_state),
    .instruction(instruction),
    .state(state),
    .cycle(cycle),
    .opcode(opcode)
);

endmodule
