// Datapath and risc-v-processor testbench

`timescale 1ns/1ps

module datapath_tb;

    reg clk;
    reg rst;

    
    // DUT
    
    datapath dut(
        .clk(clk),
        .rst(rst)
    );


    
    // Clock generation
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    // Register check task
    
    task check_register;

        input [4:0] reg_num;
        input [31:0] expected;

        begin

            if(dut.rf.registers[reg_num] == expected)

                $display(
                "PASS: x%0d = %0d",
                reg_num,
                dut.rf.registers[reg_num]
                );

            else

                $display(
                "FAIL: x%0d Expected=%0d Got=%0d",
                reg_num,
                expected,
                dut.rf.registers[reg_num]
                );

        end

    endtask


    // Test sequence
    
    initial begin


        $dumpfile("dump.vcd");
        $dumpvars(0, datapath_tb);
      
        // Reset
        
        rst = 1;

        @(posedge clk);

        rst = 0;


        
        // CPU execute instructions
        
        repeat(5)
            @(posedge clk);

        #1;


        // Register checks
        
        check_register(5'd1, 32'd5);
        check_register(5'd2, 32'd7);
        check_register(5'd3, 32'd12);
        check_register(5'd4, 32'd5);


        // Register dump
        
        begin : dump_block

            integer i;

            $display("\n----- Register Contents -----");

            for(i = 0; i < 8; i = i + 1)

                $display(
                "x%0d = %0d",
                i,
                dut.rf.registers[i]
                );

            $display("-----------------------------");

        end


        $display(
        "\nDatapath Integration Test Completed"
        );

        #20;
        $finish;

    end

endmodule
