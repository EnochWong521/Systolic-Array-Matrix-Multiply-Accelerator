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
    output logic done, // becomes high when all C are finalized 
    output logic signed [AW-1:0] C [N][N] // expose PE accumulators
);

    // states for three-state FSM 
    typedef enum logic [1:0] {IDLE, RUN, HOLD} state_e;
    state_e state;
    
    // enable for all PEs
    logic en;
    
    logic clear_acc;
    
    int unsigned t;
    localparam int T_DONE = 3*N - 3;
    
    // edge injection buses
    // left
    logic signed [IW-1:0] a_in_row [N];
    // top 
    logic signed [IW-1:0] b_in_row [N];
    
    // FSM logic 
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            done <= 1'b0;
            en <= 1'b0;
            clear_acc <= 1'b0;
            t <= '0;
            state <= IDLE;
        end
        else begin
            clear_acc <= 1'b0;
            unique case (state)
                IDLE: begin
                    en <= 1'b0;
                    t <= '0;
                    done <= 1'b0;
                    if (start) begin
                        state <= RUN;
                        en <= 1'b1;
                        clear_acc <= 1'b1;
                    end
                end
                RUN: begin
                    en <= 1'b1;
                    done <= 1'b0;
                    if (t == T_DONE) begin
                        state <= HOLD;
                    end
                    else begin
                        t <= t + 1;
                    end
                end
                HOLD: begin
                    en <= 1'b0;
                    done <= 1'b1;
                    if (start) begin
                        state <= RUN;
                        clear_acc <= 1'b1;
                        done <= 1'b0;
                        t <= '0;
                    end 
                end
            endcase 
        end
    end

endmodule