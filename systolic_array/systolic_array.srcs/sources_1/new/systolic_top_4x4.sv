`timescale 1ns / 1ps

module systolic_top_4x4 #(
    parameter int N = 4,
    parameter int IW = 8,
    parameter int AW = 20
)(
    input logic clk,
    input logic reset_n,
    input logic start,
    input logic signed [IW-1:0] A [N][N],
    input logic signed [IW-1:0] B [N][N],
    output logic done,
    output logic signed [AW-1:0] C [N][N]
);

    // states for three-state FSM 
    typedef enum logic [1:0] {IDLE, RUN, HOLD} state_e;
    state_e states;
    
    // enable for all PEs
    logic en;
    
    // edge injection buses
    // left
    logic signed [IW-1:0] a_in_row [N];
    // top 
    logic signed [IW-1:0] b_in_row [N];
    

endmodule