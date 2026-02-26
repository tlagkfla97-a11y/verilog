`timescale 1ns / 1ps



module clock_80Hz(
    input i_clk, //원래 100MHz 클럭
    input i_reset, //reset switch
    output reg o_clk  // 분주 후 80hz

    );
    //reg [23:0] r_counter=0; //1,250,000 : 10ns ㅌ 1,250000=12.5ms
    // log2(8) :8은 2의 몇제곱이냐. 3제곱. 1000 : reg [3:0] r_counter
    reg [$clog2(1250000)-1:0] r_counter=0; //125000를 저장할 수 있는 size를 계산해준다.

    //10ns의 clk가 오거나 i_reset버튼을 누르면 항상 수행한다.

    always @(posedge i_clk,posedge i_reset) begin
        if(i_reset) begin //비동기 reset
       //비동기 reset 0 -->1
        r_counter <=0;
        o_clk <=0;
         end else begin 
            if(r_counter == ((1_250_000)/2)-1) begin //80Hz 1주기 12.5ms : 
                r_counter <=0;
                o_clk <=~o_clk; //하프 사이클 마다 카운트.               
            end else begin 
                r_counter <= r_counter + 1;

            end
        end
    end

endmodule
