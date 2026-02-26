`timescale 1ns / 1ps



module D_FF( //비동기 리셋, 클럭 상승 엣지에서 D(데이터 입력)를 Q(출력)에 저장.
    input i_clk,  // 80Hz
    input i_reset,  // reset sw
    input D,
    output reg Q
    );

    always @(posedge i_clk, posedge i_reset) begin
            if(i_reset ) begin
                Q <= 0;
            end else begin
                Q <= D;        
            end
    end
      
endmodule
