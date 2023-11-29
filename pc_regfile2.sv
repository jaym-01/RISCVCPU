module pc_regfile#(
    parameter DATA_WIDTH=32
)
(
    input logic clk;
    input logic rst;
    input logic [DATA_WIDTH-1:0] next_PC;
    output logic [DATA_WIDTH-1:0] PC;
);
    always_ff @(posedge clk,posegde rst)
       if(rst) PC<={WIDTH{1'b0}};
       else    PC<=next_PC;
 endmodule