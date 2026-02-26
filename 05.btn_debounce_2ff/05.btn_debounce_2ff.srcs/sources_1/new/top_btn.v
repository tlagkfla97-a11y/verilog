`timescale 1ns / 1ps

module top_btn(
    input clk,
    input reset,
    input btnC,
    output [1:0] led
 ); //버튼 -> 디바운스 -> LED 토글 모듈 연결

 wire w_clean_btn; //디바운스 후 깨끗한 버튼 신호

button_debounce u_button_debounce( //버튼 신호를 안정된 신호로 변환.
    .i_clk(clk),
    .i_reset(reset),
    .i_btn(btnC),
    .o_clean_btn(w_clean_btn)
 );
 Led_toggle u_Led_toggle( //버튼을 누를 때마다 LED 상태 변경

    .btn_debounce(w_clean_btn),
    .led(led)
    );

endmodule
