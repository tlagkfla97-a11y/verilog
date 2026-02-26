`timescale 1ns / 1ps //가짜로 미리 검증.

module tb_full_adder();

    reg  r_a, r_b, r_cin;

    wire w_sum, w_carry_out;

full_adder u_full_aadder(
    .a(r_a),
    .b(r_b),
    .sum(w_sum),
    .carry_out(w_carry_out)

    

);

initial begin
    #00 r_a=0; r_b=0; r_cin=0;
    #10 r_a=0; r_b=0; r_cin=1;
    #10 r_a=0; r_b=1; r_cin=0;
    #10 r_a=0; r_b=1; r_cin=1;
    #10 r_a=1; r_b=0; r_cin=0;
    #10 r_a=1; r_b=0; r_cin=1;
    #10 r_a=1; r_b=1; r_cin=0;
    #10 r_a=1; r_b=1; r_cin=1;
    #10 $finish;
    
end


endmodule
