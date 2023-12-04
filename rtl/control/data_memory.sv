module data_memory #(
    parameter 
    A_WIDTH=20
) (
    input logic clk,
    input logic [31:0] A,
    input logic [31:0] WD,
    input logic WE,
    input logic [2:0] MemSrc,
    output logic [31:0] RD
);
    logic [7:0] data_mem_arr [2**A_WIDTH-1:0];
    logic [A_WIDTH-1:0] addr;
    assign addr = A[A_WIDTH-1:0];

    // only for the pdf
    initial $readmemh("reference/triangle.mem", data_mem_arr, 'h10000);

    // load 
    logic sign_bit;
    assign sign_bit = MemSrc[2] == 1 ? 1'b0 : data_mem_arr[addr][7]; // if MemSrc[2] == 1, then unsigned
    always_comb begin 
        if (MemSrc[1:0] == 2'b00)
            RD = {{24{sign_bit}}, data_mem_arr[addr]}; // LBU operation
        else if (MemSrc[1:0] == 2'b01)
            RD = {{16{sign_bit}}, data_mem_arr[addr + 1], data_mem_arr[addr]}; // LBU operation
        else
            RD = {data_mem_arr[addr + 3], data_mem_arr[addr + 2], data_mem_arr[addr + 1], data_mem_arr[addr]}; // LBU operation
    end
    
    // store
    always_ff @(posedge clk)
        if (WE == 1) begin
            data_mem_arr[addr] <= WD[7:0];
            if (MemSrc[1:0] == 2'b01) data_mem_arr[addr + 1] <= WD[15:8]; // half word
            else if (MemSrc[1:0] == 2'b10) begin
                data_mem_arr[addr + 1] <= WD[15:8];
                data_mem_arr[addr + 2] <= WD[23:16];
                data_mem_arr[addr + 3] <= WD[31:24];
            end
        end
    
endmodule
