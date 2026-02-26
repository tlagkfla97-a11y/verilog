`timescale 1ns / 1ps



// module mux2_1(
//     input a,   //첫번째 입력
//     input b,
//     input sel,
//     output out  //출력


//     );
//     assign out=(sel==1) ? a:b;

// endmodule

// module mux2_1(
//     input a,   //첫번째 입력
//     input b,
//     input sel,
//     output out  //출력


//     );
//     reg r_out;//always 블록 안에서는 reg 타입이어야 함.


//     // always @(sel or a,b) begin
//     //     if (sel) r_out = a;
//     //     else r_out = b;
//     // end

//     always @(*) begin//입력이 하나라도 바뀌면 항상 실행해라
//         case (sel)
//         1'b1: r_out = a; // sel=1->a
//         1'b0: r_out = b;// sel=0->b
//         endcase
//     end
//     assign out = r_out; //out은 wire, r_out은 reg. 연결해주는 것.

module mux2_1(
    input [3:0] a,   //첫번째 입력
    input [3:0] b,
    input sel,
    output [3:0] out  //출력


    );
    reg [3:0] r_out;//always 블록 안에서는 reg 타입이어야 함.


    // always @(sel or a,b) begin
    //     if (sel) r_out = a;
    //     else r_out = b;
    // end

    always @(*) begin//입력이 하나라도 바뀌면 항상 실행해라
        case (sel)
        1'b1: r_out = a; // sel=1->a
        1'b0: r_out = b;// sel=0->b
        endcase
    end
    assign out = r_out; //out은 wire, r_out은 reg. 연결해주는 것.
    
    
endmodule

