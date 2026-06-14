`timescale 1ns/1ps

module pc_tb;

logic clk;
logic rst;

logic [31:0] pc_next;
logic [31:0] pc_current;


program_counter dut(

    .clk(clk),
    .rst(rst),

    .pc_next(pc_next),
    .pc_current(pc_current)
);


always #5 clk = ~clk;


task check_pc(
    input [31:0] actual,
    input [31:0] expected
);

begin

    if(actual == expected)
        $display("PASS: PC = %0d", actual);

    else
      $display("FAIL: Expected=%0d actual=%0d",
                 expected,
                 actual);

end

endtask


initial begin
  
    clk = 0;
    rst = 1;
    pc_next = 0;

    #10;
    rst = 0;

    
    // PC = 4
  
    @(posedge clk);

    pc_next = 32'd4;

    @(posedge clk);
    #1;

    check_pc(pc_current,4);

    
    // PC = 8
  
    pc_next = 32'd8;

    @(posedge clk);
    #1;

    check_pc(pc_current,8);

  
    // PC = 15
   
    pc_next = 32'd15;

    @(posedge clk);
    #1;

    check_pc(pc_current,16);

    $display("Program Counter Test Done");

    #10;
    $finish;

end
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
  end


endmodule
