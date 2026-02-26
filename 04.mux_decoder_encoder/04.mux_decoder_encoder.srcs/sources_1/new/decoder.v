`timescale 1ns / 1ps



module decoder(
    input [1:0] a,
    output reg [3:0] led

    );

    // assign led = (a == 2'b00) ? 4'b0001 : 
    //              (a == 2'b01) ? 4'b0010 :
    //              (a == 2'b10) ? 4'b0100 : 4'b1000;

    always @(*) begin
        if (a == 2'b00) led = 4'b0001;
        else if (a == 2'b01) led=4'b0010;
        else if (a == 2'b10) led =  4'b0100;
        else led=4'b1000;
    end
endmodule
