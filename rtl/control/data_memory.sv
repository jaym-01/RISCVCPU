module data_memory #(
    parameter 
    A_WIDTH=20
)
(
    input logic clk,
    input logic [31:0] ALUResult,
    input logic [31:0] WriteData,
    input logic MemWrite,
    output logic [31:0] ReadData,

    // have access to the instruction, to determine LB LW
);
    logic [7:0] data_mem_arr [2**ADDRESS_WIDTH-1:0];
    
    logic [A_WIDTH-1:0] addr;
    logic [7:0] temp;
    
    assign addr = ALUResult[A_WIDTH-1:0];
    assign temp = data_mem_arr[addr];
    assign ReadData = {24{1'b0}, temp}; // LBU operation

    always_ff(@posedge clk) {
        if (MemWrite) data_mem_arr[addr] = WriteData[7:0]; // Store write data [7:0] in data_mem_arr
    }
    
endmodule