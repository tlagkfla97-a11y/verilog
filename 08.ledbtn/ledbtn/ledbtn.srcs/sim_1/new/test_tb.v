`timescale 1ns / 1ps



module test_tb(

    );
    reg         clk;
    reg         reset;
    reg  [2:0]  btn;
    wire         tick;
    wire [15:0] led;

    // DUT
    control_tower #(.MAX_COUNT(5)) dut ( //led 주기를 500ns 씩 세는 걸로 오버라이딩.
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .tick(tick),
        .led(led)
    );

    tick_generator #(.TICK_COUNT(10)) u_tick_gen( //tick 주기를 100ns씩 센다.
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

 // 100 MHz clk (10ns period)
    initial clk = 1'b0;
    always #5 clk = ~clk;

 
   

    // 버튼 0 짧게 누르기 (mode change)
    task press_btn0;
    begin
        @(posedge clk); //클럭이 0에서 1로 변하는 찰나에만 동작하라.
        btn[0] <= 1'b1;
        repeat (3) //3번 클럭동안 누르기.
        @(posedge clk); 
        btn[0] <= 1'b0;
    end
    endtask

    task wait_and_display;
    input [31:0] count;
    integer i;
    begin
        for (i = 0; i < count; i = i + 1) begin
            @(posedge tick);
            if ((i % 5) == 0) begin
                $display("[%0t] tick=%0d led=%b", $time, i, led);
            end
        end
    end
    endtask

  

   

    initial begin
        // init
        reset = 1'b1;
        btn   = 3'b000;

        // reset release
        #100;
        reset = 1'b0;

// MODE_1
        press_btn0();
        $display("--- MODE_1 START ---");
        wait_and_display(120); // 태스크 호출!

        // MODE_2
        press_btn0();
        $display("--- MODE_2 START ---");
        wait_and_display(120);

        // MODE_3
        press_btn0();
        $display("--- MODE_3 START ---");
        wait_and_display(120);

        // MODE_4
        press_btn0();
        $display("--- MODE_4 START ---");
        wait_and_display(120);

        #2000;
        $finish;
    end

endmodule
