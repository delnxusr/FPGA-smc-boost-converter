`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 01:02:25 PM
// Design Name: 
// Module Name: error_calc
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


module error_calc (
    input wire clk,
    input wire reset,
    input wire signed [31:0] v_ref,      
    input wire signed [31:0] v_sensor,   
    output reg signed [31:0] error,
    output reg signed [31:0] de_dt
);

    reg signed [31:0] prev_error;

    always @(posedge clk) begin
        if (reset) begin
            error <= 0;
            prev_error <= 0;
            de_dt <= 0;
        end else begin
            
            error <= v_ref - v_sensor;
            
            
            prev_error <= error;
            
            
            de_dt <= error - prev_error;
        end
    end
endmodule
