`timescale 1ns/1ps

class instr_transaction;

    randc bit [31:0] pc;

    constraint valid_pc {

        pc inside {
            32'd0,
            32'd4,
            32'd8,
            32'd12
        };

    }

endclass



module instruction_memory_tb;

logic [31:0] pc;
logic [31:0] instruction;

instr_transaction tr;


instruction_memory dut(.pc(pc),.instruction(instruction));

// Self-check Task

task check_instruction(

    input [31:0] actual,
    input [31:0] expected

);

begin

    if(actual == expected)

        $display(
        "PASS: PC=%0d Instruction=%h",
        pc,
        actual
        );

    else

        $display(
        "FAIL: PC=%0d Expected=%h actual=%h",
        pc,
        expected,
        actual
        );

end

endtask



initial begin

    tr = new();

    // Random Instruction Fetch
    
    repeat(10) begin

        if(!tr.randomize())
            $display("Randomization Failed");

        pc = tr.pc;

        #5;

        // Fetch + Verify
       
        check_instruction(

            instruction,

            dut.memory[pc[31:2]]

        );

        #5;

    end


    $display(
    "Instruction Memory Test Done");

    #10;
    $finish;

end
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end 

endmodule
