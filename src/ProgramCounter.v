`timescale 1ns/1ps

module program_counter(

    input clk,
    input rst,

    input [31:0] pc_next,

    output reg [31:0] pc_current
);

always @(posedge clk or posedge rst) begin

    if(rst)
        pc_current <= 32'd0;

    else
        pc_current <= pc_next;

end

endmodule
