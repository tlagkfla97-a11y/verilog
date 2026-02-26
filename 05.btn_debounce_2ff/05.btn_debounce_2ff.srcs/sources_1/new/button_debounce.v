`timescale 1ns / 1ps
//클럭을 80Hz로 느리게 만든다. 2개의 DFF로 샘플링. 상승엣지만 검출.


// module button_debounce(
//     input i_clk,
//     input i_reset,
//     input i_btn,
//     output o_clean_btn
//     );

//     wire w_o_clk;
//     wire w_Q1, w_Q2, w_Q2_bar;

//     clock_80Hz u_clock_80Hz ( //100MHZ를 80HZ 로 분주.
//     .i_clk(i_clk), //100MHz
//     .i_reset(i_reset), //reset switch
//     .o_clk(w_o_clk)  // 80hz

//     );

//     D_FF u1_D_FF(
//         .i_clk(w_o_clk),  // 80Hz
//         .i_reset(i_reset),  // reset sw
//         .D(i_btn),
//         .Q(w_Q1) 
//     );

//      D_FF u2_D_FF(
//         .i_clk(w_o_clk),  // 80Hz
//         .i_reset(i_reset),  // reset sw
//         .D(w_Q1),
//         .Q(w_Q2) 
//     );
//     assign w_Q2_bar= ~w_Q2;
//     assign o_clean_btn=w_Q1 & w_Q2_bar;





// endmodule

module button_debounce(
    input i_clk, //100MHz
    input i_reset, //reset switch
    input i_btn,
    output reg o_clean_btn  // 80hz
);

    reg [19:0] counter; //1000,000 클럭이 지나면 안정적이라고 판단. 1000,000은 이진수로 20비트.
    reg btn_sync_0, btn_sync_1;
    reg stable_state;

    //입력 동기화
    always @(posedge i_clk) begin
        btn_sync_0 <= i_btn; //비동기 입력을 받아서 첫 단계로 안정화.
        btn_sync_1 <= btn_sync_0; // 첫 단계 출력을 다시 클럭에 맞춰 안정화.
    end

    // 디바운스 로직
    always @(posedge i_clk or posedge i_reset) begin
        if(i_reset) begin
            counter <=0;
            stable_state <= 0;//이전 버튼 상태.
            o_clean_btn <=0;
        end
        else begin
            //입력이 기존 안정값과 다르면 카운트 시작
            if (btn_sync_1 != stable_state) begin//현재 버튼 입력이 이전 안정값과 다르면 버튼이 눌리거나 떼졌음.
                counter <= counter +1; //버튼이 변화했을 때 바로 출력하지 않고
                //안정적인 상태인지 확인하기 위해 카운터를 1씩 증가한다.

                if(counter >= 1_000_000 - 1) begin//카운터가 1000000까지 올라가면 버튼 상태가 그동안 변화하지 않고 안정적이었다고 판다.ㄴ
                    stable_state <= btn_sync_1;//안정값 갱신.
                    o_clean_btn <= btn_sync_1;//외부로 안정신호 출력.
                    counter <=0;//다음 변화 감지를 위해 초기화.
            end
        end
        else begin
            counter <= 0;
        end
    end
    end

endmodule