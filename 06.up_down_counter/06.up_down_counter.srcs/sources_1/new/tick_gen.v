`timescale 1ns / 1ps



module tick_gen(
    input clk,
    input reset,
    output [15:0] led
    );

    reg [$clog2(100000):0] counter_10ns = 0;  // 0.000_000_010 ns 
                                //     100_000
    reg [$clog2(100000):0] counter_ms=0;  // 100_000 * 500  == 500ms  
    reg r_led=0;

    always @(posedge reset, posedge clk) begin
        if (reset) begin
            counter_10ns <= 0;
            counter_ms <= 0;
        end else begin
            if (counter_10ns == 100000) begin
                counter_10ns <=0;
                counter_ms <= counter_ms + 1; 
            end else begin
                counter_10ns <= counter_10ns + 1;
            end
            if (counter_ms == 500) begin
                counter_ms <= 0;
                r_led  <= ~r_led;
            end
        end
    end

    assign led[0] = r_led;
endmodule
