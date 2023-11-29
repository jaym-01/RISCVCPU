module pc_top #(
    paeameter DATA_WIDTH =32
)(
    input logic clk,
    input logic rst,
    input logic [DATA_WIDTH-1:0] PC,
    input logic [12:0] ImmOp,
    input logic PCsrc,
    output logic [DATA_WIDTH-1:0] PC,
);
    logic [DATA_WIDTH-1:0] next_PC;
    logic PC_target;
    logic inc_PC;

    pc_regfile pcRegFile(
        .clk(clk),
        .rst(rst),
        .next_PC(PC),

    );
    assign next_PC =PCsrc? branch_PC:inc_PC;
endmodule
