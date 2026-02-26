`timescale 1ns / 1ps
//반가산기 -> 1비트 1비트를 더해주는 가장 기본적인 회로.

module tb_halfadder();//가짜 환경, 합성 안되는 시뮬레이션 전용. 
reg a, b;// 값을 직접 바꾸지 않기 위해. 값 저장 가능한 변수이다. 하드웨어 레지스터가 아님.

wire sum, carry_out;

half_adder dut(//(Device Under Test)testbench 신호 -> half_adder 포트 연결.

.a(a),

.b(b),

.sum(sum),//xor 서로 다를 때만 1

.carry_out(carry_out)//and 둘다 1일때만

);

initial begin //시뮬레이션 시작하자마자 한번 실행.
//#시간, 모든 입력 조합을 순서대로 테스트.
#00 a = 1'b0; b = 1'b0;
#10 a = 1'b0; b = 1'b1;
#10 a = 1'b1; b = 1'b0;
#10 a = 1'b1; b = 1'b1;
#10 $finish; //40초에서 시뮬레이션 종료.

end
endmodule
