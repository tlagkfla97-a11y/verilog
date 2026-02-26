`timescale 1ns / 1ps //시뮬레이션 시간 단


module full_adder( //이전자리 carry싸지 포함해서 진짜 덧셈을 할 수 있는 가장 기본적인 덧셈 회로.
    input wire a, b, cin, //a,b ->더할 두 비트, cin->이전 자리에서 넘어온 carry, input과 input wire는 같다.

    output wire sum, carry_out //sum 현재 자리 결과 , carry_out  다음 자리로 넘길 carry

);
    
    wire w_sum1,w_sum2, w_carry_out1, w_carry_out2;//내부 연결선 선언.

    half_adder u1_half_adder (//첫번째 반가산기 a+b
    .a(a), 
    .b(b),

    .sum(w_sum1), 
    .carry_out(w_carry_out1)

    );

    half_adder u2_half_adder ( //(a+b)+cin
    .a(w_sum1), 
    .b(cin),

    .sum(w_sum2), 
    .carry_out(w_carry_out2)

    );
    assign sum = w_sum2;
    assign carry_out = w_carry_out1 | w_carry_out2;


endmodule
