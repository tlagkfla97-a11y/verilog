`timescale 1ns / 1ps



module Coffee_top#(parameter TEST_TIME=5000, 
parameter DB_LIMIT = 20'd999_999
)(
    input clk,
    input reset,
    input [2:0] btn,
    output[7:0] seg,
    output [3:0] an,
    output [15:0] coin_val_out,
    output coffee_make_out
    
    

    );
    wire[2:0] w_debounced_btn;
    wire[15:0] w_coin_val;
    wire [13:0] w_seg;//seg_data
    wire w_tick;
    wire w_coffee_out;//커피 배출 완료 센서
    wire w_coffee_make;
    wire w_coffee_return;
    wire w_seg_en;
    btn_debouncer #(.DEBOUNCE_LIMIT(DB_LIMIT)) u_btn_debouncer(
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .debounced_btn(w_debounced_btn)
    );
    coffee_fnd_controller u_coffee_fnd_controller(
        .clk(clk),
        .in_data(w_seg),
        .tick(w_tick),
        .reset(reset),
        .an(an),
        .seg(seg)
    );
     tick_generator u_tick_generator(
        .clk(clk), 
        .reset(reset),
        .tick(w_tick)
    );
    coffee_machine u_coffee_machine(
        .clk(clk),      //100MHz
        .reset(reset),    //reset btn( active high )
        .coin(w_debounced_btn[0]),     // 동전 투입(100원 단위)btnL
        .return_coin_btn(w_debounced_btn[1]),  //동전 반환 버튼 btn[c]
        .coffee_btn(w_debounced_btn[2]),//btnr
        .coffee_out(w_coffee_out),   //커피 배출 완료 센서
        .coin_val(w_coin_val),  //현재 금액 표시
        .seg_en(w_seg_en),  //FND 활성화 신호
        .coffee_make(w_coffee_make), //커피 제조 시작 신호
        .coin_return(w_coffee_return)  //동전 반환 동작 신호

    );
    
    coffee_controller #(.TIME(TEST_TIME)) u_coffee_controller(
         .clk(clk),
         .reset(reset),
         .coin_val(w_coin_val),
         .coffee_make(w_coffee_make),
         .tick(w_tick),
         .coffee_out(w_coffee_out),
         .seg_data(w_seg)

   
 );
assign coin_val_out=w_coin_val;
assign coffee_make_out = w_coffee_out;


endmodule
