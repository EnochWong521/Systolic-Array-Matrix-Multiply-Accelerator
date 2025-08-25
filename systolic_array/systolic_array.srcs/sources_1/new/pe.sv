`timescale 1ns / 1ps

module pe #(
    parameter IW = 8, // input width
    parameter AW = 20 // accumulator width
)(
    input logic clk,
    input logic reset_n,
    input logic enable,
    input logic clear_acc,
    
    input logic signed [IW-1:0] a_in,
    input logic signed [IW-1:0] b_in,
    
    output logic signed [IW-1:0] a_out,
    output logic signed [IW-1:0] b_out,
    
    output logic signed [AW-1:0] acc_out
);
    
    logic signed [2*IW-1:0] prod;
    
    always_comb 
        prod = a_in * b_in;
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            a_out <= '0;
            b_out <= '0;
            acc_out <= '0;
        end
        else if (enable) begin
            a_out <= a_in;
            b_out <= b_in;
            if (clear_acc)
                acc_out <= '0;
            else 
                acc_out <= acc_out + $signed(prod);
        end
    end
endmodule
