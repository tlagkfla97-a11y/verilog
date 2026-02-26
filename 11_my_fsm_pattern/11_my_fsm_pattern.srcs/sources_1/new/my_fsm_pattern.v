`timescale 1ns / 1ps



module my_fsm_pattern(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out

    );

    parameter S0 = 3'd0, S1=3'd1, S2= 3'd2, S3= 3'd3, S4= 3'd4;
    
    reg [2:0] current_state = S0;
    reg [2:0] next_state;

    //1. 조합회로. 다음 state만 결정

    always @(*) begin
        case (current_state)
            S0: next_state = (in) ? S0 : S1;
            S1: next_state = (in) ? S2 : S1;
            S2: next_state = (in) ? S3 : S1;
            S3: next_state = (in) ? S0 : S4;
            S4: next_state = (in) ? S2 : S1;
        
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if(reset)
            current_state <= S0;
        else current_state <= next_state;
        

    end

    //3. output logic (조합회로)

    always @(*) begin
        out = 1'b0;

        case(current_state)
            S3: begin
                if(in == 1'b0) out = 1'b1;
                else out = 1'b0;
            end
            default : out= 1'b0;
        endcase
    end


endmodule
