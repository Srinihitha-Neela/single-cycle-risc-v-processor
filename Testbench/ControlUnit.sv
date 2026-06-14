`timescale 1ns/1ps

class control_transaction;

    randc bit [3:0] choice;

    // 10 instruction cases
   
    constraint valid_choice {

        choice inside {[0:9]};

    }

endclass



module control_unit_tb;

logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

logic [3:0] alu_sel;
logic reg_write;

control_transaction tr;

control_unit dut(

    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),

    .alu_sel(alu_sel),
    .reg_write(reg_write)

);

// Self-check task

task check_control(

    input [3:0] exp_alu_sel,
    input exp_reg_write

);

begin

    if(
        alu_sel == exp_alu_sel &&
        reg_write == exp_reg_write
    )

        $display(
        "PASS: opcode=%b funct3=%b funct7=%b alu_sel=%0d reg_write=%0d",
        opcode,
        funct3,
        funct7,
        alu_sel,
        reg_write
        );

    else

        $display(
        "FAIL: opcode=%b Expected ALU=%0d Got=%0d",
        opcode,
        exp_alu_sel,
        alu_sel
        );

end

endtask



initial begin

    tr = new();

    // Random verification
 
    repeat(20) begin

        tr.randomize();

        case(tr.choice)

            // ADDI
            
            0: begin

                opcode = 7'b0010011;
                funct3 = 3'b000;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd0,
                    1'b1
                );

            end


            // ADD

            1: begin

                opcode = 7'b0110011;
                funct3 = 3'b000;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd0,
                    1'b1
                );

            end


            // SUB

            2: begin

                opcode = 7'b0110011;
                funct3 = 3'b000;
                funct7 = 7'b0100000;

                #5;

                check_control(
                    4'd1,
                    1'b1
                );

            end

            // AND
   
            3: begin

                opcode = 7'b0110011;
                funct3 = 3'b111;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd2,
                    1'b1
                );

            end

            // OR
    
            4: begin

                opcode = 7'b0110011;
                funct3 = 3'b110;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd3,
                    1'b1
                );

            end

            // XOR
     
            5: begin

                opcode = 7'b0110011;
                funct3 = 3'b100;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd4,
                    1'b1
                );

            end

            // SLT
       
            6: begin

                opcode = 7'b0110011;
                funct3 = 3'b010;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd5,
                    1'b1
                );

            end

            // SLL
     
            7: begin

                opcode = 7'b0110011;
                funct3 = 3'b001;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd6,
                    1'b1
                );

            end

            // SRL
         
            8: begin

                opcode = 7'b0110011;
                funct3 = 3'b101;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd7,
                    1'b1
                );

            end

            // Invalid opcode
   
            9: begin

                opcode = 7'b1111111;
                funct3 = 3'b000;
                funct7 = 7'b0000000;

                #5;

                check_control(
                    4'd0,
                    1'b0
                );

            end

        endcase

        #5;

    end


    $display(
    "Control Unit Test Done"
    );

    #10;
    $finish;

end
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end

endmodule
