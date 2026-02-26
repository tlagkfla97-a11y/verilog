`timescale 1ns / 1ps
// contol_tower의 결과물을 받아서 실제 눈으로 볼 수 있는 7-segment에 숫자를 띄워주는 디스플레이 엔진.
module fnd_controller(
    input [13:0] in_data, //control tower의 assign문의 seg 데이터가 들어온다.
    input clk,
    input reset,
    input tick, //1ms 마다 tick.
    output [3:0] an,
    output [7:0] seg
    );

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100, w_d1000;

    fnd_digit_select u_fnd_digit_select(
        .clk(clk),
        .reset(reset), 
        .sel(w_sel) ,
        .tick(tick)
    );

    bin2bcd4digit u_bin2bcd4digit(
        .in_data(in_data), .d1(w_d1), .d10(w_d10), .d100(w_d100), .d1000(w_d1000)
    );

    fnd_digit_display u_fnd_digit_display(
        .digit_sel(w_sel), 
        .d1(w_d1), 
        .d10(w_d10), 
        .d100(w_d100), 
        .d1000(w_d1000), 
        .an(an), 
        .seg(seg),
        .in_data(in_data)
    );

endmodule
//-----------------------------------------------------------
//1ms마다 fnd를 display하기 위해서 digit 1자리씩 선택하는 로직.
//4ms까지는 잔상 효과가 있다. 그 이상의 시간 지연을 주면 깜박임 현상 발생 주의 요함.
//------------------------------------------------------------

//자릿수 선택기. 지금은 첫번째 칸 켤 시간, 다음은 두번째 칸 하고 알려주는 타이머.
module fnd_digit_select(
    input clk,          // 반드시 clk를 추가로 받아야 합니다
    input reset,
    input tick, //1ms tick
    output reg [1:0] sel //2비트. 3까지만 커질 수 있음.
    );

    reg r_tick_prev; 

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sel <= 0;
            r_tick_prev <= 0;
        end else begin
            r_tick_prev <= tick; // 이전 tick 상태 저장
            
            // tick이 Low였다가 High가 되는 순간(Rising Edge)에만 sel 증가
            if(tick == 1'b1 && r_tick_prev == 1'b0) begin
                sel <= sel + 1; //sel은 2비트이기 때문에 3까지만 커진다. 00->01->10->11.
            end
        end
    end
endmodule
//진법 변환기. 2진수를 10진수로 바꾸는것. 14비트 이진수를 1000의 자리, 100의자리 , 10의 자리 1의자리로 쪼개기.
// input[13:0] in_data : 14 bit fnd에 9999 까지 표현하기 위한 bin size
//0~9999 천/백/십/일 자리숫자 0~9 까지 bcd로 4 bit 표현.
module bin2bcd4digit(
    input [13:0] in_data,
    output reg [3:0] d1,
    output reg [3:0] d10,
    output reg [3:0] d100,
    output reg [3:0] d1000
    );

  always @(*) begin
        if (in_data >= 10000) begin
            d1 = 0; d10 = 0; d100 = 0; d1000 = 0;
        end else begin
            // 연산 결과가 꼬이지 않도록 직접 계산하여 할당
            d1    =  in_data % 10; //첫째자리수 저장.
            d10   = (in_data / 10) % 10; //두번째 자릿수 저장
            d100  = (in_data / 100) % 10; //세번째 자릿수 저장.
            d1000 = (in_data / 1000) % 10; //네번째 자릿수 저장.
        end
    end
endmodule
module fnd_digit_display(
    input [13:0] in_data, //control tower의 seg_data
    input [1:0] digit_sel,//fnd_digit_select에서 받아온 sel. tick(1ms)마다 1~3까지 커짐. 잔상효과를 위함.
    input [3:0] d1, d10, d100, d1000,
    output reg [3:0] an,
    output reg [7:0] seg
    );

    // 내부에서 사용할 임시 4비트 데이터
    reg [3:0] selected_value;

    always @(*) begin
        // 1. 초기화 (Latch 방지)
        an = 4'b1111;
        seg = 8'b11111111;
        selected_value = 4'd0;

        if (in_data >= 10000) begin
            // --- [애니메이션 모드] ---
            case (in_data - 10000)
                4'd0:  begin an = 4'b0111; seg = 8'b11111110; end // A (AN3)
                4'd1:  begin an = 4'b1011; seg = 8'b11111110; end // A (AN2)
                4'd2:  begin an = 4'b1101; seg = 8'b11111110; end // A (AN1)
                4'd3:  begin an = 4'b1110; seg = 8'b11111110; end // A (AN0)
                4'd4:  begin an = 4'b1110; seg = 8'b11111101; end // B (AN0)
                4'd5:  begin an = 4'b1110; seg = 8'b11111011; end // C (AN0)
                4'd6:  begin an = 4'b1110; seg = 8'b11110111; end // D (AN0)
                4'd7:  begin an = 4'b1101; seg = 8'b11110111; end // D (AN1)
                4'd8:  begin an = 4'b1011; seg = 8'b11110111; end // D (AN2)
                4'd9:  begin an = 4'b0111; seg = 8'b11110111; end // D (AN3)
                4'd10: begin an = 4'b0111; seg = 8'b11101111; end // E (AN3)
                4'd11: begin an = 4'b0111; seg = 8'b11011111; end // F (AN3)
                default: begin an = 4'b1111; seg = 8'b11111111; end
            endcase
        end else begin
            // --- [일반 숫자 모드] ---
            // 자릿수 선택과 데이터 선택을 동시에 수행
            case (digit_sel)//잔상효과. 빠르게(1ms) 번갈아가며 표시.
                2'b00: begin an = 4'b1110; selected_value = d1;    end //맨 오른쪽 첫째자리 선택.
                2'b01: begin an = 4'b1101; selected_value = d10;   end // 두번째 자리 선택.
                2'b10: begin an = 4'b1011; selected_value = d100;  end // 세번째 자리 선택.
                2'b11: begin an = 4'b0111; selected_value = d1000; end// 네번째 자리 선택.
            endcase

            // 선택된 데이터를 seg 폰트로 변환
            case(selected_value)
                4'd0: seg = 8'b11000000;//0 dp-g-f-e-d-c-b-a 순.
                4'd1: seg = 8'b11111001;//1
                4'd2: seg = 8'b10100100;//2
                4'd3: seg = 8'b10110000;//3
                4'd4: seg = 8'b10011001;//4
                4'd5: seg = 8'b10010010;//5
                4'd6: seg = 8'b10000010;//6
                4'd7: seg = 8'b11111000;//7
                4'd8: seg = 8'b10000000;//8
                4'd9: seg = 8'b10010000;//9
                default: seg = 8'b11111111;//all off
            endcase
        end
    end
endmodule
