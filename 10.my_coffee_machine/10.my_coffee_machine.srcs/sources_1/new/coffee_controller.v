`timescale 1ns / 1ps

// fnd랑 연결해서 숫자 표시.

module coffee_controller#(parameter TIME=5000)(
    
   input clk,reset,
   input [15:0] coin_val,
   input coffee_make,
  input tick,
  output reg coffee_out,
  output [13:0] seg_data

);
  
  reg [12:0] r_msec_count;
  reg [3:0] r_ani_step;
  reg [1:0] r_mode;

  always @(posedge clk or posedge reset) begin
    if(reset) begin
        r_msec_count <=0;
        r_ani_step<=0;
        coffee_out <=0;
        r_mode <=0;
    end else begin
        if(coffee_make) begin //circular animation 코드
            r_mode <=1;
            if(tick) begin
                r_msec_count <= r_msec_count+1;
                if(r_msec_count % 100 ==0) begin //0.1초 주기로 
                    if(r_ani_step>=11) r_ani_step <=0;
                    else r_ani_step <= r_ani_step + 1;
                end
            end
            if(r_msec_count >= TIME) begin // 5초가 되었을 때.
                coffee_out<=1; //coffee_machine 모듈로.
            end
        end else begin
            r_mode <=0;
            r_msec_count<=0;
            r_ani_step <=0;
            coffee_out <=0;
        end


        end
    end

assign seg_data = (r_mode == 1) ? (14'd10000+r_ani_step) : coin_val[13:0];
//rmode가 1이면 circular animation로직. 아니면 coin_val.

endmodule