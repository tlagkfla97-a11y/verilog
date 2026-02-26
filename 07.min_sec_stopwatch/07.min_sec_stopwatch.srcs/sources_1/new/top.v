`timescale 1ns / 1ps

module top(
    input clk,
    input reset, // sw[15]
    input [2:0] btn, // btn[0] :  btnL  btn[1] :  btnC  btn[2] :  btnR
    input[7:0] sw,
    output[7:0] seg,
    output [3:0] an,
    output [15:0] led
    );
    reg[16:0] r_1ms_counter;
    wire w_tick_1ms = (r_1ms_counter == 100_000 - 1);//r_1ms_counter가 99999되는 순간 1 저장.
    wire [2:0] w_debounced_btn;
    wire [13:0] w_seg_data;
    wire w_total_reset= reset | btn[1];
    

    //1ms tick 세기.
    always @(posedge clk)begin
        if(reset) r_1ms_counter <=0;
        else if(w_tick_1ms) r_1ms_counter <=0;
        else r_1ms_counter <= r_1ms_counter +1;
    end
    

    btn_debouncer u_btn_debouncer(
        .clk(clk),
        .reset(reset),
        
        .btn(btn),   // 3개의 버튼 입력: btn[2:0] → 각각 btnL, btnC, btnR
        .debounced_btn(w_debounced_btn)
    );
    //1ms마다 1이 되는 w_tick_1ms가 fnd_controller로 넘어감.
    fnd_controller u_fnd_controller(
        .clk(clk),
        .in_data(w_seg_data),
        .tick(w_tick_1ms),
        .reset(reset),
        .an(an),
        .seg(seg)
    );

    min_sec_control_tower u_min_sec_control_tower(
        .clk(clk),
        .reset(w_total_reset), // sw[15]
        .btn(w_debounced_btn), // btn[0] :  btnL  btn[1] :  btnC  btn[2] :  btnR
        .sw(sw),
        .seg_data(w_seg_data),
        .led(led)
    );

 

 

endmodule
