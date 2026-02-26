`timescale 1ns / 1ps


module tb_adder8();

  reg[7:0] a;//시뮬레이션에서 입력은 reg
  reg[7:0] b;
  wire [7:0] sum;//시뮬레이션에서 출력은 wire
  wire carry_out;
  integer i;

  adder8 dut(
    .a(a),
    .b(b),
    .sum(sum),
    .carry_out(carry_out)
  );

  initial begin
      // 1) 초기화
  a = 0; b = 0;
 
  #10;

  // 2) 기본/코너 케이스
  a=8'h00; b=8'h00;  #10;  // 0 + 0
  a=8'h01; b=8'h01;  #10;  // 1 + 1
  a=8'hFF; b=8'h00;  #10;  // 최대 + 0
  a=8'hFF; b=8'h01;  #10;  // 오버플로우 확인 (255+1)
  a=8'h80; b=8'h80;  #10;  // MSB 캐리 확인
  a=8'h55; b=8'hAA;  #10;  // 0101.. + 1010.. 패턴
  a=8'h0F; b=8'h01;  #10;  // 하위 니블 캐리전파
  a=8'h7F; b=8'h01;  #10;  // 여러 비트 캐리전파

  // 3) cin=1 케이스(캐리 입력 동작 확인)
  a=8'h00; b=8'h00;  #10;  // 0+0+1
  a=8'hFF; b=8'h00;  #10;  // 255+0+1
  a=8'h10; b=8'h0F;  #10;  // 캐리 연쇄
  
    // for(i=0; i<256; i=i+1) begin
    //     a=i%256;
    //     b=(i+1)%256;
    //     #10;
    // end

    #10 $finish;

  end

endmodule
