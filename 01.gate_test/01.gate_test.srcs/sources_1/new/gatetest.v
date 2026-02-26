`timescale 1ns / 1ps



module gatetest(
    input wire a,
    input b, // wire를 생략 하면 default로 wire다. 1bit를 의미. 
             // 아무런 언급을 안하면 1 bit로 인식한다.
    output [4:0] led  // led[0]~led[4]
    );

    assign led[0]=a & b; // 연속 할당문 assign : 연결하라는 의미이다.둘다 1이면 1
                         // <=
    assign led[1] = a | b; //하나라도 1이면 1
    assign led[2] = ~(a & b); //NAND 
    assign led[3] = ~(a | b); // NOR 
    assign led[4] = a ^ b;



endmodule
