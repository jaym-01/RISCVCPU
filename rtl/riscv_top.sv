module top#(
    parameter INS_ADDRESS_WIDTH = 12,
    DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    output logic [DATA_WIDTH-1:0] a0
);
    // pc wires
    logic [INS_ADDRESS_WIDTH-1:0] pc_val;  // **WILL NOT WORK**
    logic [INS_ADDRESS_WIDTH-1:0] pc_incr_4;
    logic [INS_ADDRESS_WIDTH-1:0] pc_target;

    // instruction wires
    logic [DATA_WIDTH-1: 0] instr;

    // control signal wires
    logic [1:0] pc_src;
    logic result_src;
    logic mem_write;
    logic [2:0] mem_src;
    logic [2:0] alu_control;
    logic alu_src;
    logic [2:0] imm_src;
    logic reg_write;
    logic rw_src;

    // register file wires
    logic [DATA_WIDTH-1:0] rd1;
    logic [DATA_WIDTH-1:0] rd2;
    logic [DATA_WIDTH-1:0] wd3;

    // ALU wires
    logic zero;
    logic [DATA_WIDTH-1:0] imm_ext;
    logic [DATA_WIDTH-1:0] alu_result;
    logic [DATA_WIDTH-1:0] srcB;

    // data memory wires
    logic [DATA_WIDTH-1:0] read_data;
    logic [DATA_WIDTH-1:0] result;

    // MUXes for pc values 
    assign pc_incr_4 = pc_val + 0'b100;
    assign pc_target = pc_val + imm_ext[INS_ADDRESS_WIDTH-1:0];

    // MUX for ALU
    assign srcB = alu_src? imm_ext : rd2;

    // data memory MUX
    assign result = result_src? read_data : alu_result;

    // register file mux
    assign wd3 = rw_src? {{DATA_WIDTH-INS_ADDRESS_WIDTH{1'b0}}, pc_incr_4} : result;

    pc rv_pc(
        .clk(clk),
        .rst(rst),
        .pc_4(pc_incr_4),
        .pc_b(pc_target),
        .pc_r(alu_result[INS_ADDRESS_WIDTH-1:0]),
        .pc_src(pc_src),
        .PC(pc_val)
    );

    instruction_memory rv_ins_mem(
        .A(pc_val),
        .RD(instr)
    );

    control_unit rv_cu(
        .op(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .Zero(zero),
        .PCSrc(pc_src),
        .ResultSrc(result_src),
        .MemWrite(mem_write),
        .MemSrc(mem_src),
        .ALUControl(alu_control),
        .ALUSrc(alu_src),
        .ImmSrc(imm_src),
        .RegWrite(reg_write),
        .RWSrc(rw_src)
    );

    extend rv_sign_ext(
        .Imm(instr[31:7]),
        .ImmSrc(imm_src),
        .ImmExt(imm_ext)
    );

    regfile rv_regfile(
        .clk(clk),
        .AD1(instr[19:15]),
        .AD2(instr[24:20]),
        .AD3(instr[11:7]),
        .WE3(reg_write),
        .WD3(wd3),
        .a0(a0),
        .RD1(rd1),
        .RD2(rd2)
    );

    alu rv_alu(
        .op1(rd1),
        .op2(srcB),
        .ALUctrl(alu_control),
        .SUM(alu_result),
        .zero(zero)
    );

    data_memory rv_data_mem(
        .clk(clk),
        .A(alu_result),
        .WD(rd2),
        .WE(mem_write),
        .MemSrc(mem_src),
        .RD(read_data)
    );

endmodule
