module pc#(
    parameter DATA_WIDTH=32
)
(
    input logic clk;
    input logic rst;
    input logic [DATA_WIDTH-1:0] pc_4;
    input logic [DATA_WIDTH-1:0] pc_b;
    input logic [DATA_WIDTH-1:0] pc_r;
    input logic [1:0] pc_src;
    output logic [DATA_WIDTH-1:0] PC;
);
    always_ff @(posedge clk,posegde rst)
       if(rst) PC<={WIDTH{1'b0}};
       else    PC<=next_PC;
    always_comb
    case (pc_src)
     2'b0: PC = pc_4;
     2'b1: PC = pc_b;
     2'b10:PC = pc_r;

    endcase

 endmodule
