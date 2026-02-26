module top(
    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    output [7:0] seg,
    output [3:0] an,
    output [15:0] led
    );

    wire [2:0] w_debounced_btn;
    wire [13:0] w_seg_data;
    wire w_tick;

    // 1. 버튼 디바운서
    btn_debouncer u_btn_debouncer(
        .clk(clk), .reset(reset),
        .btn(btn), .debounced_btn(w_debounced_btn)
    );

    // 2. FND 컨트롤러 (내부에서 in_data를 display 모듈로 넘겨주는지 꼭 확인!)
    fnd_controller u_fnd_controller(
        .clk(clk), .reset(reset),
        .in_data(w_seg_data), // 이 데이터가 fnd_digit_display까지 가야 함
        .tick(w_tick),
        .an(an), .seg(seg)
    );

    // 3. 컨트롤 타워 (애니메이션 데이터 생성)
    control_tower u_control_tower(
        .clk(clk), .reset(reset),
        .btn(w_debounced_btn),
        .sw(sw),
        .seg_data(w_seg_data),
        .led(led)
    );

    // 4. 1ms 틱 생성기 (중복된 tick_gen 삭제)
    tick_generator u_tick_generator(
        .clk(clk), .reset(reset),
        .tick(w_tick)
    );

endmodule