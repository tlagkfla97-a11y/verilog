`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/21 17:25:06
// Design Name: 
// Module Name: test_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_tb(

    );
    reg         clk;
    reg         reset;
    reg  [2:0]  btn;
    reg         tick;
    wire [15:0] led;

    // DUT
    control_tower dut (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .tick(tick),
        .led(led)
    );

 // 100 MHz clk (10ns period)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // tick pulse: every 1us generate 1 clk-width pulse
    initial begin
        tick = 1'b0;
        forever begin
            #990;
            tick = 1'b1;
            #10;
            tick = 1'b0;
        end
    end

    // 버튼 0 짧게 누르기 (mode change)
    task press_btn0;
    begin
        @(posedge clk);
        btn[0] <= 1'b1;
        repeat (3) @(posedge clk);
        btn[0] <= 1'b0;
    end
    endtask

    // one-hot 체크 (0이 아니고 1비트만 켜짐)
    task check_onehot_led;
    begin
        if (led == 16'b0 || ((led & (led - 1'b1)) != 16'b0)) begin
            $display("[%0t] ERROR: LED not one-hot: %b", $time, led);
        end
    end
    endtask

    integer i;

    initial begin
        // init
        reset = 1'b1;
        btn   = 3'b000;

        // reset release
        #100;
        reset = 1'b0;

        // MODE_1 진입 (btn[0] edge)
        press_btn0();
        $display("[%0t] MODE_1 entered", $time);

        // 120 tick 동안 관찰 (50 tick마다 step 이동 기대)
        for (i = 0; i < 120; i = i + 1) begin
            @(posedge tick);
            check_onehot_led();
            if ((i % 10) == 0) begin
                $display("[%0t] tick=%0d led=%b", $time, i, led);
            end
        end

        // MODE_2 진입 확인
        press_btn0();
        $display("[%0t] MODE_2 entered, led=%b", $time, led);

        #2000;
        $finish;
    end

endmodule
