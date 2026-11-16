`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 05:26:54 PM
// Design Name: 
// Module Name: slide_calc
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


module slide_calc( input wire signed [31:0] error,
input wire signed [31:0] de_dt,
output signed [31:0] s_val

    );

  assign s_val= error +(de_dt>>>10);

    
endmodule
