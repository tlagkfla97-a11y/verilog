`timescale 1ns / 1ps



module min_sec_fnd_controller(
    input [13:0] in_data,
    input clk,
    input reset,
    input tick,
    output [3:0] an,
    output [7:0] seg
    );

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100, w_d1000;

    fnd_digit_select u_fnd_digit_select(
        //.clk(clk),
         .reset(reset), 
         .sel(w_sel) ,
          .tick(tick)
    );

    bin2bcd4digit u_bin2bcd4digit(
        .in_data(in_data),
        .d1(w_d1),
        .d10(w_d10), 
        .d100(w_d100), 
        .d1000(w_d1000)
    );

    fnd_digit_display u_fnd_digit_display(
        .digit_sel(w_sel), 
        .d1(w_d1), 
        .d10(w_d10), 
        .d100(w_d100), 
        .d1000(w_d1000), 
        .an(an), 
        .seg(seg)
    );

    
endmodule

//자릿수 선택기. 지금은 첫번째 칸 켤 시간, 다음은 두번째 칸 하고 알려주는 타이머.
module fnd_digit_select(
   // input clk,
    input reset,
    input tick,
    output reg [1:0] sel // 00 01 10 11 : 1ms마다 바뀜
    );
    //reg[$clog2(100_000):0] r_1ms_counter=0; //100000이라는 숫자를 담으려면 최소 몇비트가 필요한가 계산해주는것. 2의 몇승? 17승.
    // always @(posedge clk, posedge reset, posedge tick) begin
        
    //     if(reset) begin
    //         r_1ms_counter <= 0;//동시에 실행. 서로 순서가 바뀌어도 상관 없음. non blocking 방식.
    //         sel <=0;
    //     end else begin
    //         if(r_1ms_counter == 100_000-1) begin //1ms
    //             r_1ms_counter <=0;
    //             sel <= sel+1;
    //         end else begin
    //             r_1ms_counter <= r_1ms_counter +1;
    //         end
    // end
    always @(posedge reset, posedge tick) begin
          if(reset) begin
            sel <=0;
        end else begin
            if(tick) begin //1ms
                
                sel <= sel+1;
            end else begin
                
            end
    end
    end
endmodule
//진법 변환기. 2진수를 10진수로 바꾸는것. 14비트 이진수를 1000의 자리, 100의자리 , 10의 자리 1의자리로 쪼개기.
// input[13:0] in_data : 14 bit fnd에 9999 까지 표현하기 위한 bin size
//0~9999 천/백/십/일 자리숫자 0~9 까지 bcd로 4 bit 표현.
module bin2bcd4digit(
    input [13:0] in_data,
    output [3:0] d1,
    output [3:0] d10,
    output [3:0] d100,
    output [3:0] d1000
    );
    assign d1 = in_data % 10;
    assign d10 = ( in_data /10 ) % 10;
    assign d100 = ( in_data /100 ) % 10;
    assign d1000 = ( in_data /1000 ) % 10;
endmodule
//현재 선택된 자릿수에 맞는 숫자를 led 조각으로 변환해 실제 불을 켠다.
module fnd_digit_display(
    input [1:0] digit_sel,
    input [3:0] d1,
    input [3:0] d10,
    input [3:0] d100,
    input [3:0] d1000,
    output reg [3:0] an,
    output reg [7:0] seg
    );

    reg [3:0] bcd_data;

    always @(digit_sel) begin //digit_sel값이 바뀔 때 언제나 실행
        case (digit_sel)
            2'b00:begin
                bcd_data=d1;
                an = 4'b1110;
            end
                2'b01:begin
                bcd_data=d10;
                an = 4'b1101;
            end
                2'b10:begin
                bcd_data=d100;
                an = 4'b1011;
            end
            2'b11:begin
                bcd_data=d1000;
                an = 4'b0111;
            end
            default: begin
                bcd_data=4'b0000;
                an = 4'b1111; 
            end
        endcase
    end

    always @(bcd_data) begin//bcd데이터가 바뀌면 실행/ 1일때 off되는것.
        case(bcd_data)
            4'd0: seg =  8'b11000000;//0
            4'd1: seg =  8'b11111001;//1
            4'd2: seg =  8'b10100100;//2
            4'd3: seg =  8'b10110000;//3
            4'd4: seg =  8'b10011001;//4
            4'd5: seg =  8'b10010010;//5
            4'd6: seg =  8'b10000010;//6
            4'd7: seg =  8'b11111000;//7
            4'd8: seg =  8'b10000000;//8
            4'd9: seg =  8'b10010000;//9
            default : seg =  8'b11111111; // all off

        endcase
    end

endmodule
