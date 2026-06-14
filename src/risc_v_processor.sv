
`timescale 1ns/1ps

// ALU

module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0]  alu_sel,
    output reg [31:0] result,
    output zero
);

    always @(*) begin
        case (alu_sel)
          
            4'b0000: result = a + b; //ADD
            4'b0001: result = a - b;  //SUB
            4'b0010: result = a & b; //AND
            4'b0011: result = a | b; //OR
            4'b0100: result = a ^ b;  //XOR
          4'b0101: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  //SLT
          4'b0110: result = a << b[4:0]; //SLL
          4'b0111: result = a >> b[4:0]; //SRL
            default: result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule



// Register File

module reg_file (
    input         clk,
    input         rst,
  
    input  [4:0]  rs1,
    input  [4:0]  rs2,
  
    input  [4:0]  rd,
    input  [31:0] write_data,
    input reg_write,
  
    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] registers [31:0];
    integer i;

always @(posedge clk or posedge rst) begin

    if (rst) begin

        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'd0;

    end

    else begin

        if (reg_write && rd != 5'd0)
            registers[rd] <= write_data;

        // x0 is always zero in RISC-V
        registers[0] <= 32'd0;

    end

end

    assign read_data1 = registers[rs1];
    assign read_data2 = registers[rs2];

endmodule


// Program Counter

module program_counter (
    input         clk,
    input         rst,
    input  [31:0] pc_next,
    output reg [31:0] pc_current
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_current <= 32'd0;
        else
            pc_current <= pc_next;
    end

endmodule


// Instruction Memory

module instruction_memory (
    input  [31:0] pc,
    output [31:0] instruction
);
  
 // 32 x 32-bit instruction memory
    reg [31:0] memory [31:0];
  
// Preload instructions
initial begin

    memory[0] = 32'h00500093; // addi x1,x0,5
    memory[1] = 32'h00700113; // addi x2,x0,7
    memory[2] = 32'h002081B3; // add x3,x1,x2
    memory[3] = 32'h40218233; // sub x4,x3,x2

end

    assign instruction =
    (pc[31:2] < 4) ?
    memory[pc[31:2]] :
    32'h00000013;
  
endmodule



// Instruction Decoder
module instruction_decoder (
    input  [31:0] instruction,
    output [6:0]  opcode,
    output [4:0]  rd,
    output [2:0]  funct3,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [6:0]  funct7
);

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

endmodule


// Control Unit

module control_unit (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
  
    output reg [3:0] alu_sel,
    output reg reg_write
);

    always @(*) begin
       // Default values
        alu_sel   = 4'd0;
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

// Immediate Generator

module immediate_generator (
    input  [31:0] instruction,
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


module datapath(

    input clk,
    input rst

);

    
    // PC signals
    
    wire [31:0] pc_current;
    wire [31:0] pc_next;


    
    // Instruction Fetch
    
    wire [31:0] instruction;


    
    // Decoder
    
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;


    // Control Signals
    
    wire [3:0] alu_sel;
    wire reg_write;


    // Register File
    
    wire [31:0] rd1;
    wire [31:0] rd2;


    // Immediate Generator
    
    wire [31:0] imm_out;


    // ALU
    
    wire [31:0] alu_result;
    wire zero;


    // ALU mux
    
    wire [31:0] alu_b;

    assign alu_b =
        (opcode == 7'b0010011) ?
        imm_out :
        rd2;


    
    // PC + 4
    
    assign pc_next = pc_current + 32'd4;


    
    // Program Counter
    
    program_counter pc(

        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc_current(pc_current)

    );


    
    // Instruction Memory
    
    instruction_memory imem(

        .pc(pc_current),
        .instruction(instruction)

    );


    
    // Decoder
    
    instruction_decoder decoder(

        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)

    );


    // Control Unit
    
    control_unit control(

        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .alu_sel(alu_sel),
        .reg_write(reg_write)

    );


    // Immediate Generator
    
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


    // ALU
    
    alu alu_inst(

        .a(rd1),
        .b(alu_b),

        .alu_sel(alu_sel),

        .result(alu_result),
        .zero(zero)

    );

endmodule
