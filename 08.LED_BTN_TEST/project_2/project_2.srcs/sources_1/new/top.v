`timescale 1ns / 1ps



module top(
    input clk,
    input reset,
    input [2:0] btn,
    output [15:0] led

    );
    wire[2:0] w_debounced_btn;
    wire[13:0] w_seg_data;
    wire w_tick;

    btn_debouncer u_btn_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .debounced_btn(w_debounced_btn)
    );

    control_tower u_control_tower(
        .clk(clk),
        .reset(reset),
        .btn(w_debounced_btn),
        .tick(w_tick),
        .led(led)

    );
    tick_generator u_tick_generator(
        .clk(clk), .reset(reset),
        .tick(w_tick)
    );


endmodule
