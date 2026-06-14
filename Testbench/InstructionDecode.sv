`timescale 1ns/1ps

class decode_transaction;

    randc bit [3:0] choice;

  
    // 10 instructions
    constraint valid_choice {
        choice inside {[0:9]};
    }

endclass



module instruction_decoder_tb;

logic [31:0] instruction;

logic [6:0] opcode;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;

decode_transaction tr;

instruction_decoder dut(

    .instruction(instruction),

    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)

);


// Self-check Task

task check_decode(

    input [6:0] exp_opcode,
    input [4:0] exp_rd,
    input [2:0] exp_funct3,
    input [4:0] exp_rs1,
    input [4:0] exp_rs2,
    input [6:0] exp_funct7

);

begin

    if(
        opcode == exp_opcode &&
        rd == exp_rd &&
        funct3 == exp_funct3 &&
        rs1 == exp_rs1 &&
        rs2 == exp_rs2 &&
        funct7 == exp_funct7
    )

        $display(
        "PASS: instruction=%h opcode=%b rd=%0d rs1=%0d rs2=%0d",
        instruction,
        opcode,
        rd,
        rs1,
        rs2
        );

    else

        $display(
        "FAIL: instruction=%h",
        instruction
        );

end

endtask



initial begin

    tr = new();

    // Random Decode Verification

    repeat(20) begin

        tr.randomize();

        case(tr.choice)

            // addi x1,x0,1
            
            0: begin

                instruction = 32'h00100093;

                #5;

                check_decode(
                    7'b0010011,
                    5'd1,
                    3'b000,
                    5'd0,
                    5'd1,
                    7'b0000000
                );

            end

            // addi x2,x0,2
           
            1: begin

                instruction = 32'h00200113;

                #5;

                check_decode(
                    7'b0010011,
                    5'd2,
                    3'b000,
                    5'd0,
                    5'd2,
                    7'b0000000
                );

            end


            // add x3,x1,x2
         
            2: begin

                instruction = 32'h002081B3;

                #5;

                check_decode(
                    7'b0110011,
                    5'd4,   // error : incorrect value
                    3'b000,
                    5'd1,
                    5'd2,
                    7'b0000000
                );

            end


            // sub x4,x3,x2
            
            3: begin

                instruction = 32'h40218233;

                #5;

                check_decode(
                    7'b0110011,
                    5'd4,
                    3'b000,
                    5'd3,
                    5'd2,
                    7'b0100000
                );

            end


            // and x5,x3,x2
           
            4: begin

                instruction = 32'h0021F2B3;

                #5;

                check_decode(
                    7'b0110011,
                    5'd5,
                    3'b111,
                    5'd3,
                    5'd2,
                    7'b0000000
                );

            end


            // or x6,x3,x2
          
            5: begin

                instruction = 32'h0021E333;

                #5;

                check_decode(
                    7'b0110011,
                    5'd6,
                    3'b110,
                    5'd3,
                    5'd2,
                    7'b0000000
                );

            end


            // xor x7,x3,x2
        
            6: begin

                instruction = 32'h0021C3B3;

                #5;

                check_decode(
                    7'b0110011,
                    5'd7,
                    3'b100,
                    5'd3,
                    5'd2,
                    7'b0000000
                );

            end


            // sll x8,x1,x2
       
            7: begin

                instruction = 32'h00209433;

                #5;

                check_decode(
                    7'b0110011,
                    5'd8,
                    3'b001,
                    5'd1,
                    5'd2,
                    7'b0000000
                );

            end


            // srl x9,x1,x2

            8: begin

                instruction = 32'h0020D4B3;

                #5;

                check_decode(
                    7'b0110011,
                    5'd9,
                    3'b101,
                    5'd1,
                    5'd2,
                    7'b0000000
                );

            end


            // slt x10,x1,x2
      
            9: begin

                instruction = 32'h0020A533;

                #5;

                check_decode(
                    7'b0110011,
                    5'd10,
                    3'b010,
                    5'd1,
                    5'd2,
                    7'b0000000
                );

            end

        endcase

        #5;

    end


    $display(
    "Instruction Decoder Test Done"
    );

    #10;
    $finish;

end
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars;

    
  end 

endmodule
