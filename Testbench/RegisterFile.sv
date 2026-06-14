`timescale 1ns/1ps

class reg_transaction;

    rand bit [4:0] rd;
    rand bit [31:0] write_data;

    rand bit [4:0] rs1;
    rand bit [4:0] rs2;

    //  x0=0
    constraint valid_reg {
        rd inside {[1:31]};
        rs1 inside {[1:31]};
        rs2 inside {[1:31]};
    }

endclass



module reg_file_tb;

logic clk;
logic rst;

logic [4:0] rs1;
logic [4:0] rs2;

logic [4:0] rd;
logic [31:0] write_data;
logic reg_write;

logic [31:0] read_data1;
logic [31:0] read_data2;


// DUT
reg_file dut(

    .clk(clk),
    .rst(rst),

    .rs1(rs1),
    .rs2(rs2),

    .rd(rd),
    .write_data(write_data),
    .reg_write(reg_write),

    .read_data1(read_data1),
    .read_data2(read_data2)
);


reg_transaction tr;


// Clock
always #5 clk = ~clk;



initial begin

    clk = 0;
    rst = 1;

    rs1 = 0;
    rs2 = 0;
    rd = 0;
    write_data = 0;
    reg_write = 0;

  
    #10;
    rst = 0;

    tr = new();

  // Random writes
  
    repeat(10) begin

        if(!tr.randomize())
            $display("Randomization Failed");

        @(posedge clk);

        rd = tr.rd;
        write_data = tr.write_data;
        reg_write = 1;

      $display("WRITE at x%0d = %0d",rd,write_data);

    end

    // Random Reads

    reg_write = 0;

    repeat(5) begin

        if(!tr.randomize())
            $display("Randomization Failed");

        rs1 = tr.rs1;
        rs2 = tr.rs2;

        #2;

      $display("READ -> x%0d=%0d | x%0d=%0d" ,rs1                               ,read_data1,rs2,read_data2);

        #5;

    end


    //--------------------------------
    // Test x0 protection
    //--------------------------------
    @(posedge clk);

    rd = 0;
    write_data = 999;
    reg_write = 1;

    @(posedge clk);

    reg_write = 0;
    rs1 = 0;

    #2;

    $display("x0 = %0d", read_data1);

    $display("register file random test done");

    #20;
    $finish;

end
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(0, reg_file_tb);
  end

endmodule
