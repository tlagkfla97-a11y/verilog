`timescale 1ns / 1ps



module adder4(
    input[3:0] a,
    input [3:0] b,
    input cin, // 1bit
    output [3:0] sum,
    output carry_out


    );
    wire w_carry0,w_carry1,w_carry2;

    full_adder full_adder_1bit_FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(1'b0), //1비트 2진수 0
        .sum(sum[0]),
        .carry_out(w_carry0)
    );

    full_adder full_adder_1bit_FA1 (
        .a(a[1]),
        .b(b[1]),
        .cin(w_carry0),
        .sum(sum[1]),
        .carry_out(w_carry1)
    );

    full_adder full_adder_1bit_FA2 (
        .a(a[2]),
        .b(b[2]),
        .cin(w_carry1),
        .sum(sum[2]),
        .carry_out(w_carry2)
    );

    full_adder full_adder_1bit_FA3 (
        .a(a[3]),
        .b(b[3]),
        .cin(w_carry2),
        .sum(sum[3]),
        .carry_out(carry_out)
    );
    


endmodule
