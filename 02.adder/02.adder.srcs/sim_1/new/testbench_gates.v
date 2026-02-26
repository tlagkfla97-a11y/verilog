`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/10 15:04:05
// Design Name: 
// Module Name: testbench_gates
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


module testbench_gates();
    reg a;
    reg b;
    wire ld0;
    wire ld1;
    wire ld2;
    wire ld3;
    wire ld4;
    wire ld5;

    
Gates dut(
    .a(a),
    .b(b),
    .ld0(ld0),
    .ld1(ld1),
    .ld2(ld2),
    .ld3(ld3),
    .ld4(ld4),
    .ld5(ld5)
);
    


initial begin
    #00 a=1'b0; b=1'b0;
    #10 a=1'b0; b=1'b1;
    #10 a=1'b1; b=1'b0;
    #10 a=1'b1; b=1'b1;
    #10 $finish;

end
endmodule
