`timescale 1ns / 1ps



module min_sec_control_tower(
    input clk,
    input reset, //sw[15]
    input [2:0] btn, //btn[0]:btnL, btn[1]:btnC, btn[2]:btnR
    input [7:0] sw,
    output [13:0] seg_data,
    output reg [15:0] led
    

    );

     // mode define
    parameter CLOCK = 3'b01;
    parameter STOP_WATCH = 3'b10;
    parameter ANIMATION = 3'b11;

    reg r_prev_btnL=0;
    reg [2:0] r_mode=3'b000;
    reg [$clog2(100000000)-1:0] r_counter;  
    reg [$clog2(1000000)-1:0] r_ms_counter;      // 10ms를 재기 위한 카운터 10ns * 1000000
    reg [6:0] r_sec=0;
    reg [6:0] r_min=0;
    reg [6:0] r_sw_sec=0;
    reg [6:0] r_sw_min=0;
    reg [23:0]r_ani_timer = 0;
    reg[3:0] r_ani_step = 0;

   


    // mode check
    always @(posedge clk, posedge reset) begin
        if (reset) begin//리셋 버튼 눌렸을 때 초기화
            r_mode <= 0;
            r_prev_btnL <= 0;
        end else begin
            if (btn[0] && !r_prev_btnL)//엣지 검출. 지금 버튼이 눌려있고 이전에 안 눌려있었다면
                r_mode = (r_mode== ANIMATION) ? CLOCK: r_mode + 1;//현재모드가 animation 모드라면 Clock모드 로 넘어가고 아니면 +1 다음 단계로 넘어가란 뜻. 1->2->3->1
        end
        r_prev_btnL <= btn[0];//이번 클럭에서 누른 버튼 상태를 일단 r_prev_btnL에 넣어둬라.
    end

// up counter
always @(posedge clk, posedge reset) begin
    if (reset) begin
        r_counter <= 0;
        r_ms_counter <= 0;
        r_sec <= 0; r_min <= 0;
        r_sw_sec <= 0; r_sw_min <= 0;
        r_ani_timer<=0;
        r_ani_step <=0;
    end 
    else begin
        // 1. CLOCK 모드: 1초씩 카운트
        if (r_mode == CLOCK) begin 
            if (r_counter == 100_000_000 - 1) begin 
                r_counter <= 0;
                if(r_sec >= 59) begin
                    r_sec <= 0;
                    r_min <= (r_min >= 59) ? 0 : r_min + 1;//r_sec가 59가 되면 r_min이 1 커진다.
                end else begin
                    r_sec <= r_sec + 1; //r_sec 1초에 1씩 커진다.
                end
            end else begin
                r_counter <= r_counter + 1;
            end
        end 
        
        // 2. STOP_WATCH 모드: 10ms(0.01초)씩 카운트
        else if (r_mode == STOP_WATCH) begin 
            if (r_ms_counter == 1_000_000 - 1) begin 
                r_ms_counter <= 0;
                if(r_sw_sec >= 59) begin
                    r_sw_sec <= 0;
                    r_sw_min <= (r_sw_min >= 59) ? 0 : r_sw_min + 1;
                end else begin
                    r_sw_sec <= r_sw_sec + 1;
                end
            end else begin
                r_ms_counter <= r_ms_counter + 1;
            end
        end

        // 3. ANIMATION 혹은 기타 상태
        else if (r_mode == ANIMATION) begin 
            if(r_ani_timer == 5_000_000-1) begin  //0.05초마다.
                r_ani_timer <= 0;
                // 0부터 11까지 총 12단계가 필요함 (테두리 전체)
                if(r_ani_step >= 11) r_ani_step <= 0; //0.05초마다 r_ani_step이 0부터 11까지 세줌. 11이되면 다시 0.
                else r_ani_step <= r_ani_step + 1;
            end else begin
                r_ani_timer <= r_ani_timer + 1;
            end
        end
    
    end // else(not reset) 끝
end // always 끝







// led mode display

always @(r_mode) begin  // r_mode가 변경 될때 실행
    case (r_mode)
        CLOCK: begin
            led[15:14] = CLOCK;//카운터 숫자와 상관없이 가장 왼쪽 led 두개로 현재 무슨 모드인지 보여줌.
        end
        STOP_WATCH: begin
            led[15:14] = STOP_WATCH;
        end
        ANIMATION: begin
            led[15:14] = ANIMATION;
        end
        default:
            led[15:14] = 3'b000;
    endcase
end





// 3. 최종 선택 (assign 문)
assign seg_data = (r_mode == CLOCK)      ? r_min*100+r_sec : //분은 세번째 자리부터 표시되어야 하므로 100을 곱해준다.
                  (r_mode == STOP_WATCH) ? r_sw_min*100+r_sw_sec : 
                  (r_mode == ANIMATION)  ? (10000 + r_ani_step) : 0; 
                  //r_ani_step(0~11)+10000 10000을 더해주는 이유는 분초시계나 스탑워치로 읽히지 않기 위해 아예 
                  //특수모드 인걸 보여주기 위해 최대 표시 숫자인 9999보다 큰 10000으로 설정.

endmodule

