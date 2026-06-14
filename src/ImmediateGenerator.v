`timescale 1ns/1ps

module immediate_generator(

    input [31:0] instruction,

    output reg [31:0] imm_out
);

wire [6:0] opcode;

assign opcode = instruction[6:0];


always @(*) begin

    imm_out = 32'd0;

    case (opcode)

        // I-Type (addi)
        7'b0010011:
            imm_out = {{20{instruction[31]}},
                       instruction[31:20]};

        // S-Type (sw)
        7'b0100011:
            imm_out = {{20{instruction[31]}},
                       instruction[31:25],
                       instruction[11:7]};

        // B-Type (beq)
        7'b1100011:
            imm_out = {{19{instruction[31]}},
                       instruction[31],
                       instruction[7],
                       instruction[30:25],
                       instruction[11:8],
                       1'b0};

        default:
            imm_out = 32'd0;

    endcase

end
endmodule
