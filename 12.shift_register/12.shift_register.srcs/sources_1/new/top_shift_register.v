`timescale 1ns / 1ps



module top_shift_register(
    input clk,
    input reset, 
    input [1:0] btn,
    output [7:0] led
    );

wire[1:0] w_debounced_btn;

btn_debouncer u_btn_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .debounced_btn(w_debounced_btn)
    );
shift_register u_shift_register(
    .clk(clk),
    .reset(reset),
    .btnU(w_debounced_btn[0]),
    .btnD(w_debounced_btn[1]),
    .led(led)

);


endmodule