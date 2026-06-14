`timescale 1ns/1ps

module reg_file(

    input clk,
    input rst,

    input [4:0] rs1,
    input [4:0] rs2,

    input [4:0] rd,
    input [31:0] write_data,
    input reg_write,

    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] registers [31:0];

integer i;


always @(posedge clk or posedge rst) begin

    if(rst) begin

        for(i=0; i<32; i=i+1)
            registers[i] <= 32'd0;

    end

    else if(reg_write && rd != 5'd0) begin
        registers[rd] <= write_data;
    end

end


assign read_data1 = registers[rs1];
assign read_data2 = registers[rs2];

endmodule
