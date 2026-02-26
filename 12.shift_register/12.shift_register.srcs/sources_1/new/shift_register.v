`timescale 1ns / 1ps

// 1010111

module shift_register(

input clk,
input reset, //SW15
input btnU,  //1을 입력
input btnD,  //0을 입력
output [15:0] led
    );

    reg [6:0] sr7;
    reg btn_prev;
   
    wire btn_now;
    wire shift_tick;

    //현재 버튼 상태 확인
    assign btn_now= btnU | btnD;
    // 버튼이 눌리는 순간 포착

    assign shift_tick = btn_now & ~btn_prev;
  
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            sr7 <= 7'b0000000;
            btn_prev <= 1'b0;
            

        end else begin
            btn_prev <= btn_now; //현재 상태를 저장하여 다음 클럭에서 비교

            //버튼이 눌린 순간에만 동작
            if(shift_tick) begin
            sr7 <= {sr7[5:0], (btnU? 1'b1 : 1'b0)}; //shift reg
            end
        end
    end
    //led[7:1]에 shift register 값 표시.
    assign led[7:1] = sr7;
    //패턴 검출 시 led[0] 점등
    assign led[0] = (sr7 == 7'b1010111) ? 1'b1:1'b0;
   
   
endmodule
