`timescale 1ns / 1ps



module control_tower(
    input clk,
    input reset,
    input [2:0]btn,
    input tick, //1ms
    output reg [15:0] led

    );

    // mode define
    parameter MODE_1 = 3'b001;
    parameter MODE_2 = 3'b010;
    parameter MODE_3 = 3'b011;
    parameter MODE_4 = 3'b100;
    parameter MAX_COUNT = 6'd50;

    reg r_prev_btnL=0;
    reg [2:0] r_mode=3'b000;
    reg [6:0] r_counter;
           // 10ms를 재기 위한 카운터 10ns * 1000000
    reg [4:0] r_step_1 =0;  
    reg [4:0] r_step_2 =0;
    reg [4:0] r_step_3 =0;
    reg [4:0] r_step_4 =0; 

    // mode check
    always @(posedge clk, posedge reset) begin
        if (reset) begin//리셋 버튼 눌렸을 때 초기화
            r_mode <= 0;
            r_prev_btnL <= 0;
        end else begin
            if (btn[0] && !r_prev_btnL)//엣지 검출. 지금 버튼이 눌려있고 이전에 안 눌려있었다면
                r_mode <= (r_mode== MODE_4) ? MODE_1: (r_mode + 1);//현재모드가 slide 모드라면 업카운터로 넘어가고 아니면 +1 다음 단계로 넘어가란 뜻. 1->2->3->1
        end
        r_prev_btnL <= btn[0];//이번 클럭에서 누른 버튼 상태를 일단 r_prev_btnL에 넣어둬라.
    end

    always @(posedge tick, posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            
            r_step_1 <= 0;
            r_step_2 <= 15;
            r_step_3 <= 7;
            r_step_4 <= 0;

        end
        else begin
            // 첫번째 모드
            
                if(r_counter >= MAX_COUNT - 1 ) begin
                    r_counter <=0;

                    case(r_mode)
                        MODE_1 :r_step_1 <= (r_step_1>=15)? 0 : r_step_1 + 1;
                        MODE_2 :r_step_2 <= (r_step_2==0)? 15 : r_step_2 - 1;
                        MODE_3 :r_step_3 <= (r_step_3==0)? 7 : r_step_3-1;
                        MODE_4 :r_step_4 <= (r_step_4>=7)? 0 : r_step_4+1;
                    endcase
                end else begin
                    r_counter <= r_counter+1;
                end


           
    end
    end

    always @(*) begin
        led = 16'b0;
        case (r_mode)
            MODE_1: led[r_step_1] = 1'b1;
            MODE_2: led[r_step_2] = 1'b1;
            MODE_3: begin
                 led[r_step_3] = 1'b1;
                 led[15-r_step_3]=1'b1;
            end

            MODE_4: begin
                led[r_step_4] = 1'b1;
                led[15-r_step_4] = 1'b1;


            end
            default: led = 16'b0;
        endcase
    end







endmodule
