`timescale 1ns / 1ps



module tb_button_debounce();
    //
    parameter CLK_FREQ = 100_000_000; // 100MHz
    parameter CLK_PERIOD = 10; //10ns (100MHz의 1주기 10ns)
    parameter BTN_PRESS_LIMIT = 1_000_000; //10ms = 1,000,000ns
    //버튼이 눌린 상태를 유지할 시간.

    reg clk;
    reg reset;
    reg btnC;
    wire [1:0] led;

    top_btn u_top_btn(
    .clk(clk),
    .reset(reset),
    .btnC(btnC),
    .led(led)
    );

    initial begin
        clk=0;
        forever #5 clk = ~clk;    //5ns 마다 클럭 반전. 10ns 주기. 즉 클럭 신호 토글.
    
    end

    initial begin // 쓰레기 값과 노이즈를 주고 LED가 한번만 토글되는지 확인.
        reset=1; //회로 초기화.
        btnC=0; //버튼을 누르지 않은 상태로 설정.
      #100; //100ns 기다림.
      reset=0; //리셋 해제-> 회로 동작 준비.
      // btn input gen
      //버튼 신호 입력 노이즈
      $display ("[%0t] start btn noise generation.....", $time);
      #100 btnC=1;
      #200 btnC=0;
      #150 btnC=1;
      #80 btnC=0;  
      #500  ;        //쓰레기값

      //눌르기.
      btnC=1;
      #(BTN_PRESS_LIMIT); //이거 동안 버튼 누르기.
      #100;
      if(led !== 2'b00) begin//LED 상태 확인. 
        $display ("[%0t] test passed led changed....", $time);
      end else begin
        $display ("[%0t] TEST FAILED led not changed....", $time);
      end
      #1000;
      $display("========= simulation finished =========");
      $finish;
      end
      

 
    
    


endmodule
