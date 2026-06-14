`timescale 1ns/1ps

module datapath(

    input clk,
    input rst

);

    //--------------------------------
    // PC signals
    //--------------------------------
    wire [31:0] pc_current;
    wire [31:0] pc_next;


    //--------------------------------
    // Instruction Fetch
    //--------------------------------
    wire [31:0] instruction;


    //--------------------------------
    // Decoder
    //--------------------------------
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;


    //--------------------------------
    // Control Signals
    //--------------------------------
    wire [3:0] alu_sel;
    wire reg_write;


    //--------------------------------
    // Register File
    //--------------------------------
    wire [31:0] rd1;
    wire [31:0] rd2;


    //--------------------------------
    // Immediate Generator
    //--------------------------------
    wire [31:0] imm_out;


    //--------------------------------
    // ALU
    //--------------------------------
    wire [31:0] alu_result;
    wire zero;


    //--------------------------------
    // ALU mux
    //--------------------------------
    wire [31:0] alu_b;

    assign alu_b =
        (opcode == 7'b0010011) ?
        imm_out :
        rd2;


    //--------------------------------
    // PC + 4
    //--------------------------------
    assign pc_next = pc_current + 32'd4;


    //--------------------------------
    // Program Counter
    //--------------------------------
    program_counter pc(

        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc_current(pc_current)

    );


    //--------------------------------
    // Instruction Memory
    //--------------------------------
    instruction_memory imem(

        .pc(pc_current),
        .instruction(instruction)

    );


    //--------------------------------
    // Decoder
    //--------------------------------
    instruction_decoder decoder(

        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)

    );


    //--------------------------------
    // Control Unit
    //--------------------------------
    control_unit control(

        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .alu_sel(alu_sel),
        .reg_write(reg_write)

    );


    //--------------------------------
    // Immediate Generator
    //--------------------------------
    immediate_generator imm_gen(

        .instruction(instruction),
        .imm_out(imm_out)

    );


    //--------------------------------
    // Register File
    //--------------------------------
    reg_file rf(

        .clk(clk),
        .rst(rst),

        .rs1(rs1),
        .rs2(rs2),

        .rd(rd),

        .write_data(alu_result),
        .reg_write(reg_write),

        .read_data1(rd1),
        .read_data2(rd2)

    );


    //--------------------------------
    // ALU
    //--------------------------------
    alu alu_inst(

        .a(rd1),
        .b(alu_b),

        .alu_sel(alu_sel),

        .result(alu_result),
        .zero(zero)

    );

endmodule
