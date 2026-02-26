`timescale 1ns / 1ps

module tb_top();
    //입력 신호 정의
    reg clk;
    reg reset; // sw[15]
    reg [2:0] btn; // btn[0] :  btnL  btn[1] :  btnC  btn[2] :  btnR
    reg[7:0] sw;
    //출력 신호 정의 
    wire [7:0] seg;
    wire [3:0] an;
    wire [15:0] led;

    //DUT(Design Under Test) 인스턴스화
 top u_top(
        .clk(clk),
        .reset(reset), // sw[15]
        .btn(btn), // btn[0] :  btnL  btn[1] :  btnC  btn[2] :  btnR
        .sw(sw),
        .seg(seg),
        .an(an),
        .led(led)
  
    );

    //100MHz clock 생성 (10ns주기)
    always #5 clk = ~clk; //5마다 하이로우 반복.


    task btn_press;
        input integer btn_index; // integer signed 32bit reg [31:0] 비트처럼 일일이 지정을 안해도 됨.
        begin
            $display("btn_press btn:%0d start", btn_index);

            //noise를 만든다. (0.55ms) 만들기 나름.
            btn[btn_index]=1; #100000; // 0.1ms high
            btn[btn_index]=0; #200000; // 0.2ms low
            btn[btn_index]=1; #150000; // 0.15ms high
            btn[btn_index]=0; #100000; // 0.1ms low
            //2. 안정구간 11ms 유지 --> 이 구간이 지나야 clean_btn이 1이 된다.
            btn[btn_index]=1;
            #11000000;  //11ms 유지
            //3. btn을 뗀다(10ms 이상 )
            btn[btn_index]=0;
            #11000000;
            $display("btn_press btn:%0d release FINISH", btn_index);

        end
    endtask

  initial begin
        $monitor("time=%t mode:%b an:%b seg:%b", $time, led[15:13], an, seg);
        // led[15:13]나 an이나 seg값이 바뀌면 해당 라인 출력
    end
    initial begin
        // initial 설정을한다.
        clk=0;
        reset=1;
        btn=3'b000;
        sw=8'b00000000;
        // 2. reset 해제
        #100;
        reset=0;
        #100;
        //3. 모드변경 (IDLE->UP_COUNTER btn[0] : btnL)
        $display("MODE IDLE --> UP_COUNTER");
        btn_press(0); //btn[0]
        // 4. UP_COUNTER 동작 관찰
        #20000000 //20ms
        //5.------모드변경  UP ---> DOWN ----------

         $display("UP_COUNTER --> DOWN_COUNTER");
        btn_press(0); //btn[0]
        // 5. DOWN_COUNTER 동작 관찰
        #10000000 //10ms

        //6.------모드변경  DOWN ---> SLIDE ----------
        $display("MODE DOWN_COUNTER --> SLIDE_SW_READ");
        btn_press(0);   // btn[0]
        sw = 8'h55;     // 0101 | 0101
        #1000000;
        sw = 8'hAA;     // 1010 | 1010  반전 
        #1000000;
        $display("simulation Ended.......");
        $finish;
    end





    


    endmodule
