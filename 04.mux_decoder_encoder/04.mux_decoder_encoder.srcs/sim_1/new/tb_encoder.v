`timescale 1ns / 1ps



module tb_encoder();








  reg [3:0] r_d;
  wire [1:0] w_a;
  

  //2.검증
  encoder u_encoder(
    .d(r_d),
    
    .a(w_a)
  );
  //3. test 시나리오 작성.

  initial begin

    $monitor("time=%0t d=%b a=%b", $time, r_d, w_a);
    //초기값 설정
    r_d=4'b0000;
    // 결과 출력

    //--- sel :1 (a출력)
    #10; r_d=4'b0000;
    #10; r_d=4'b0001;
    #10; r_d=4'b0010;
    #10; r_d=4'b0100;
    #10; r_d=4'b1000;
    #10; r_d=4'b1100;
    #10; r_d=4'b0110;
    
    #10 $finish;
  end



  // 검증 할 모듈을 인스턴스화

endmodule

