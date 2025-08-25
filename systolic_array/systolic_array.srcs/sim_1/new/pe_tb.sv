`timescale 1ns / 1ps

module pe_tb;
    // input and accumulator width
    localparam int IW = 8;
    localparam int AW = 20;
    
    // signal declaration
    logic clk = 0;
    logic reset_n;
    logic enable;
    logic clear_acc;
    
    logic signed [IW-1:0] a_in;
    logic signed [IW-1:0] b_in;
    
    logic signed [IW-1:0] a_out;
    logic signed [IW-1:0] b_out;
    
    logic signed [AW-1:0] acc_out;
    
    pe #(.IW(IW), .AW(AW)) dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .clear_acc(clear_acc),
        .a_in(a_in),
        .b_in(b_in),
        .a_out(a_out),
        .b_out(b_out),
        .acc_out(acc_out)
    );
    
    task automatic step(input logic signed [IW-1:0] a, input logic signed[IW-1:0] b);
        begin
            enable = 1;
            a_in = a;
            b_in = b;
            @(posedge clk);
            #1;
        end
    endtask
    
    always #1 clk = ~clk;
    
    initial begin
        // reset signals
        reset_n = 0;
        clear_acc = 0; 
        enable = 0;
        a_in = '0;
        b_in = '0;
        repeat(2) @(posedge clk);
        
        // start 
        reset_n = 1;
        clear_acc = 1;
        enable = 1;
        
        #1;
        @(posedge clk);
        clear_acc = 0;
        
        step(1, 5); // expected output is 5
        assert (acc_out == 5) else $fatal("Expected acc_out = 5. Got %0d instead", acc_out);
        
        step(2, 6); // expected output 5 + 2*6 = 17
        assert (acc_out == 17) else $fatal("Expected acc_out = 17. Got %0d instead", acc_out);
        
        step(3, 7); // expected output 17 + 3*7 = 38
        assert (acc_out == 38) else $fatal("Expected acc_out = 38. Got %0d instead", acc_out);
        
        $finish;
    end
endmodule
