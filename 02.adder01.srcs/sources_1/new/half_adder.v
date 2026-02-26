`timescale 1ns / 1ps



module half_adder(a, b, sum,
carry_out);//입력 2개 받아서 출력 2개 내는 반가산기

    input a, b; //1비트 입력

    output sum, carry_out; // 덧셈 결과, 자리올림

    assign sum = a ^ b; 

    assign carry_out = a & b;

endmodule