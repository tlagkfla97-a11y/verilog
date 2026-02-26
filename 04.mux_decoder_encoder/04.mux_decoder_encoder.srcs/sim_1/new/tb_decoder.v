`timescale 1ns / 1ps



module tb_decoder();
`timescale 1ns / 1ps




  reg [1:0] r_a;
  wire [3:0] w_led;
  

  //2.검증
  decoder u_decoder(
    .a(r_a),
    
    .led(w_led)
  );
  //3. test 시나리오 작성.

  initial begin
    //초기값 설정
    r_a=2'b00;
    // 결과 출력

    //--- sel :1 (a출력)
    #10; r_a=2'b01;
    #10; r_a=2'b01;
    #10; r_a=2'b10;
    #10; r_a=2'b11;
    #10 $finish;

  end

  // 검증 할 모듈을 인스턴스화

endmodule


