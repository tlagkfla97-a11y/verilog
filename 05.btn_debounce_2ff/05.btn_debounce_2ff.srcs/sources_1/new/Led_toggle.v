`timescale 1ns / 1ps

module Led_toggle (
  input btn_debounce,
  output [1:0] led
    );

 reg r_led_toggle =1'b0;

    always @(posedge btn_debounce) begin // 버튼 디바운스가 0에서 1로 변할 때.
        r_led_toggle <= ~r_led_toggle; //LED 상태를 반전.
        end
    assign led[0] =(r_led_toggle ==1) ? 1'b1 : 1'b0;

endmodule
