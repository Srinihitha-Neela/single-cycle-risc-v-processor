`timescale 1ns/1ps

class imm_transaction;

    randc bit [2:0] choice;

    // 6 instruction cases
    
    constraint valid_choice {

        choice inside {[0:5]};

    }

endclass



module immediate_generator_tb;

logic [31:0] instruction;
logic [31:0] imm_out;

imm_transaction tr;

immediate_generator dut(

    .instruction(instruction),
    .imm_out(imm_out)

);


// Self-check task

task check_imm(

    input signed [31:0] expected

);

begin

    if(imm_out == expected)

        $display(
        "PASS: instruction=%h imm_out=%0d",
        instruction,
        imm_out
        );

    else

        $display(
        "FAIL: instruction=%h Expected=%0d Got=%0d",
        instruction,
        expected,
        imm_out
        );

end

endtask



initial begin

    tr = new();

    // Random Verification

    repeat(18) begin

        tr.randomize();

        case(tr.choice)

            // addi x1,x0,5
           
            0: begin

                instruction = 32'h00500093;

                #5;

                check_imm(32'd5);

            end

            // addi x1,x0,-5
            
            1: begin

                instruction = 32'hFFB00093;

                #5;

                check_imm(-32'd5);

            end

            // sw x2,8(x1)
        
            2: begin

                instruction = 32'h0020A423;

                #5;

                check_imm(32'd8);

            end

            // sw x2,-8(x1)
         
            3: begin

                instruction = 32'hFE20AC23;

                #5;

                check_imm(-32'd8);

            end

            // beq x1,x2,16
        
            4: begin

                instruction = 32'h00208863;

                #5;

                check_imm(32'd16);

            end

            // beq x1,x2,-16
       
            5: begin

                instruction = 32'hFE2088E3;

                #5;

                check_imm(-32'd16);

            end

        endcase

        #5;

    end


    $display(
    "Immediate Generator Test Done"
    );

    #10;
    $finish;

end
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end

endmodule
