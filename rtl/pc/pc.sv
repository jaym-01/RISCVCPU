module pc#(
    parameter ADDRESS_WIDTH = 12
)(
    input logic clk,
    input logic rst,
    input logic [ADDRESS_WIDTH-1:0] pc_4,
    input logic [ADDRESS_WIDTH-1:0] pc_b,
    input logic [ADDRESS_WIDTH-1:0] pc_r,
    input logic [1:0] pc_src,
    output logic [ADDRESS_WIDTH-1:0] PC
);
    logic [ADDRESS_WIDTH-1:0] pc_next;

    // PC FF
    always_ff @(posedge clk, posedge rst)
       if(rst) PC <= {ADDRESS_WIDTH{1'b0}};
       else PC <= pc_next;

    // multiplexer
    always_comb
        case(pc_src)
            2'b1: pc_next = pc_b;
            2'b10: pc_next = pc_r;
            default: pc_next = pc_4;
        endcase

 endmodule
