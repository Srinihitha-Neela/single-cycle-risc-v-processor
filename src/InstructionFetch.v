`timescale 1ns/1ps

module instruction_memory(

    input [31:0] pc,

    output [31:0] instruction
);

    // 32 x 32-bit instruction memory
    
    reg [31:0] memory [31:0];

    // Preload instructions
    
initial begin

    memory[0] = 32'h00500093;   // addi x1,x0,5
    memory[1] = 32'h00700113;   // addi x2,x0,7
    memory[2] = 32'h002081B3;  // add x3,x1,x2
    memory[3] = 32'h40218233;    // sub x4,x3,x2

end
// Instruction Fetch

    assign instruction =
    (pc[31:2] < 4) ?
    memory[pc[31:2]] :
32'h00000013;

endmodule
