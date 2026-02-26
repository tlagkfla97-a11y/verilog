`timescale 1ns / 1ps



module tb_coffee_machine();
    //input
    reg clk;     //100MHz
    reg reset;   //reset btn( active high )
    reg [2:0] btn;     // 동전 투입(100원 단위)
      //동전 반환 버튼 btn[1]
    //reg coffee_btn; ntm[2]
    wire [7:0] seg;
    wire [3:0] an;
    
   
    wire [15:0] coin_val;  //현재 금약 표시
    wire coffee_out;
   
    //모듈 인스턴스화
   Coffee_top #(.TEST_TIME(50),.DB_LIMIT(100)) uut(
    .clk(clk),
    .reset(reset),
    .btn(btn),
    .seg(seg),
    .an(an),
    .coin_val_out(coin_val),
    .coffee_make_out(coffee_out)

   );
    //동전 투입 task : clk 에 동기화 시키자
    task insert_coin;
    begin
        @(posedge clk);
        #1 btn[0]=1;//setup time 확보 1딜레이 줌.
        repeat(150) @(posedge clk); //클럭이 상승엣지를 만날 때까지 3번반복.
        #1 btn[0]=0;
        repeat(100) @(posedge clk); 
    end
    endtask

   
    task return_coin;
    begin
        @(posedge clk);
        #1 btn[1]=1;//setup time 확보 1딜레이 줌.
       repeat(150) @(posedge clk); //클럭이 상승엣지를 만날 때까지 3번반복.
        #1 btn[1]=0;
        repeat(100) @(posedge clk); 

    end

    endtask
    task coffee_btn;
    begin
        @(posedge clk);
        #1 btn[2]=1;//setup time 확보 1딜레이 줌.
        repeat(150) @(posedge clk); //클럭이 상승엣지를 만날 때까지 3번반복.
        #1 btn[2]=0;
        repeat(100) @(posedge clk); 

    end
    endtask

    // 100MHz clock 생성
    initial clk =0;
    always #5 clk = ~clk;

    initial begin
        // 1.초기 신호 unknown 방지
        reset=1;
        btn=3'b000;
        
        //----2.정상적인 reset seq
        #100;   //100ns 동안 reset 유지
        @(negedge clk)  //클럭이 하강엣지 일 때 리셋 해제 (글리치 방지) 상승이 오기전에 데이터를 미리 안정시키는것.
        reset=0;
        $display("time : %t reset rel... IDLE state: ", $time);
        #50;

        // 3. scenario : 300원 투입 (IDLE -> COIN_IN --> READY)
        $display("time : %t reset rel... coin insert state...", $time);
        insert_coin();  
        insert_coin();
        insert_coin();
        // READY 확인
        #20;
        if (coin_val >= 300)
             $display("time : %t current READY coin_val: %d ...", $time,coin_val);
        else
            $display("time : %t error coin_val: %d...", $time,coin_val);
            //coffee_btn 누른다. READY --> COFFEE --> READY
        @(posedge clk);
        #1 coffee_btn();//setup time 확보
       $display("time : %t coffee button pressed.animation start...", $time);
        #50;
        wait(coffee_out ==1);

        //-- 5. 동전 반환 (READY --> COINT_OUT --> IDLE)
        $display("time : %t coin return coin_val: %d  ...", $time, coin_val);
       #100;
        #1 return_coin();
         $display("time : %t return_coin_btn == 0  ...", $time);
       
        #100;
        if(coin_val == 0)
             $display("time : %t return coin_val:%d  goto IDLE   ...", $time, coin_val);

        #300;
        $display("Simulation Success Finished.......", $time);
        $finish;
end
    
endmodule
