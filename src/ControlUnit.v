`timescale 1ns/1ps

module control_unit(

    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg [3:0] alu_sel,
    output reg reg_write
);

always @(*) begin

    // Default values
  
    alu_sel = 4'd0;
    reg_write = 1'b0;


     // Decode Logic
case (opcode)

    7'b0110011: begin
        reg_write = 1'b1;

        case ({funct7, funct3})

            {7'b0000000,3'b000}: alu_sel = 4'd0; // ADD
            {7'b0100000,3'b000}: alu_sel = 4'd1; // SUB
            {7'b0000000,3'b111}: alu_sel = 4'd2; // AND
            {7'b0000000,3'b110}: alu_sel = 4'd3; // OR
            {7'b0000000,3'b100}: alu_sel = 4'd4; // XOR
            {7'b0000000,3'b010}: alu_sel = 4'd5; // SLT
            {7'b0000000,3'b001}: alu_sel = 4'd6; // SLL
            {7'b0000000,3'b101}: alu_sel = 4'd7; // SRL
            default:             alu_sel = 4'd0;

        endcase
    end

    7'b0010011: begin
        reg_write = 1'b1;
        alu_sel   = 4'd0;
    end

    default: begin
        alu_sel   = 4'd0;
        reg_write = 1'b0;
    end

endcase
    end

endmodule
