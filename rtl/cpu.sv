module cpu (
    input logic clk,
    input logic reset,
    output logic [7:0] addr_bus,
    output logic clk_b,

    inout logic [7:0] bus
);

// ============
// Clocks:
//   - clk_b = inverted clock for control unit
// ============
assign clk_b = ~clk;

wire flag_zero;
wire flag_carry;

// ===============
// Control Signals
//  - c_rin = Registers in
//  - c_rou = Registers out
//  - c_aen = Alu enable
//  - c_aou = Alu enable output read onto bus
//  - c_mae = Memory Address Register enable
//  - c_pce = Program counter enable
//  - c_pcd = Program counter decrement
//  - c_pco = Program counter enable output read onto bus
// ===============

logic c_rin, c_rou;
logic c_aen, c_aou;
logic c_mai, c_ien;
logic c_pce, c_pcd, c_pco;


// ============
// Registers
// ============

logic [2:0] sel_in;
logic [2:0] sel_out;
logic [7:0] rega_out;
logic [7:0] regb_out;

gp_registers m_registers (
    .clk(),
    .write_en(c_rin),
    .out_en(c_rou),
    .data_in(bus),
    .sel_in(sel_in),
    .sel_out(sel_out),
    .data_out(bus),
    .rega(rega_out),
    .regb(regb_out)
);

register m_mar (
    .clk(),
    .enable(c_mae),
    .reset(reset),
    .data_in(bus),
    .data_out(addr_bus)
);

logic [7:0] ireg_out;
register m_ireg (
    .clk(),
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
    .clk(),
    .in(bus),
    .sel_in(c_pce),
    .reset(reset),
    .dec(c_pcd),
    .out(pc_out)
)

tristate_buffer m_pc_buff(
    .enable(c_pco),
    .in(pc_out),
    .out(bus)
)

// ============
// ALU
// ============

wire [7:0] alu_out;
wire [2:0] alu_mode;

alu m_alu(
    .clk(),
    .enable(c_aen),
    .mode(alu_mode),
    .in_a(rega_out),
    .in_a(regb_out),
    .out(alu_out),
    .flag_carry(flag_carry),
    .flag_zero(flag_zero)
);

tristate_buffer m_alu_buff(
    .enable(c_aou),
    .in(alu_out),
    .out(bus)
)

endmodule