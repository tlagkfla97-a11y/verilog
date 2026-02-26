`timescale 1ns / 1ps

module adder6(
    input [5:0] a,      // sw[5:0]
    input [5:0] b,      // sw[11:6]
    input sel,          // 덧셈/뺄셈 선택
    output carry_out,
    output [5:0] sum
);

    assign {carry_out, sum} = sel ? a + b : a + (~b + 6'b1);//맨 위 비트는 carryout에 넣고 나머지 비트는 sum에 넣느다.

endmodule