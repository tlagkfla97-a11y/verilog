`timescale 1ns / 1ps

module top_tb();
    //입력 신호
    reg clk;
    reg reset;
    reg [2:0] btn;
    reg [7:0] sw;

    //출력 신호
    wire [7:0] seg;
    wire [3:0] an;
    wire [15:0] led;

    //테스트할 모듈 dut에 연결
    top uut (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .sw(sw),
        .seg(seg),
        .an(an),
        .led(led)

    );
    //100MHz 클럭 생성
    always #5 clk = ~clk;

    initial begin
        //초깃값 설정
        clk=0;
        reset=1;
        btn = 3'b000;
        sw=8'h00;

        //리셋 해제
        #100;
        reset = 0;
        #50;

        //버튼 누르기 테스트
        #100;
        btn[0] = 1;
        # 20_000_000;
        btn[0]=0;

        #100_000_000;

        #100;
        btn[0]=1;
        #20_000_000;
        btn[0]=0;
        #200_000_000;
        $finish;



    end


    
endmodule
