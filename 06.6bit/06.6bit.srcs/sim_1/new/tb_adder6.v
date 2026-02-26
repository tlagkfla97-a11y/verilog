`timescale 1ns / 1ps

module tb_adder6;

    reg [11:0] sw;
    reg sel;
    wire carry_out;
    wire [5:0] sum;

    adder6 dut(
        .sw(sw),
        .sel(sel),
        .carry_out(carry_out),
        .sum(sum)
    );

    initial begin
        // 초기화
        sw = 0; sel = 1;

        // 덧셈 테스트
        #10 sw = {6'b000011, 6'b000101}; sel=1; // 3 + 5
        #10 sw = {6'b111111, 6'b000001}; sel=1; // 63 + 1
        #10 sw = {6'b101010, 6'b010101}; sel=1; // 42 + 21

        // 뺄셈 테스트
        #10 sw = {6'b001100, 6'b000011}; sel=0; // 12 - 3
        #10 sw = {6'b000011, 6'b001100}; sel=0; // 3 - 12
        #10 sw = {6'b111111, 6'b000001}; sel=0; // 63 - 1

        #20 $finish;
    end

endmodule