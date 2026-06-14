`timescale 1ns/1ps

class alu_transaction;

    rand bit [31:0] a;
    rand bit [31:0] b;

    randc bit [3:0] alu_sel;

    constraint valid_opcode {
        alu_sel inside {[0:7]};
    }

    function string op_name(input bit [3:0] op);
        case(op)
            0: return "ADD";
            1: return "SUB";
            2: return "AND";
            3: return "OR";
            4: return "XOR";
            5: return "SLT";
            6: return "SLL";
            7: return "SRL";
            default: return "UNKNOWN";
        endcase
    endfunction

endclass


module alu_tb;

logic [31:0] a;
logic [31:0] b;
logic [3:0] alu_sel;
logic [31:0] result;
logic zero;

alu dut(
    .a(a),
    .b(b),
    .alu_sel(alu_sel),
    .result(result),
    .zero(zero)
);

alu_transaction tr;


initial begin

    tr = new();

    repeat(20) begin

        if(!tr.randomize())
            $display("Randomization failed");

        a = tr.a;
        b = tr.b;
        alu_sel = tr.alu_sel;

        #10;

        $display(
            "A=%0d B=%0d OP=%s RESULT=%0d",
            a,
            b,
            tr.op_name(alu_sel),
            result
        );

    end

    $finish;

end

initial begin
    $dumpfile("alu_wave.vcd");
    $dumpvars(0, alu_tb);
end


endmodule
