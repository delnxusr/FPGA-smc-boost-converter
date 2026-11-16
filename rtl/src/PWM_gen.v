`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 11:30:28 AM
// Design Name: 
// Module Name: PWM_gen
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


module PWM_gen(input wire clk,input wire reset,input wire [9:0] duty_target,    output reg pwm_out
    );
    reg [9:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 10'd0;
            pwm_out <= 1'b0;
        end else begin
          
            if (counter >= 10'd999) begin
                counter <= 10'd0; 
            end else begin
                counter <= counter + 10'd1;
            end

         
            if (counter < duty_target) begin
                pwm_out <= 1'b1; 
            end else begin
                pwm_out <= 1'b0;
            end
        end
    end


    
endmodule
