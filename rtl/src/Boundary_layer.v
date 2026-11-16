`timescale 1ns / 1ps

module Boundary_layer (
    input  wire              clk,
    input  wire              reset,
    input  wire signed [31:0] s_value,
    output reg  signed [31:0] duty_target
);
    // PHI = 2.0V scaled in ADC counts (2.0V * (10/92) * (1024/3.3) = ~67 counts)
    localparam signed [31:0] PHI_POS = 32'sd67;
    localparam signed [31:0] PHI_NEG = -32'sd67;
    
    localparam [9:0] D_MAX = 10'd900; // 90% Duty Cycle
    localparam [9:0] D_MIN = 10'd100; // 10% Duty Cycle
    localparam [9:0] D_NOM = 10'd300; // 30% Nominal Duty Cycle 

    always @(posedge clk) begin
        if (reset) begin
            duty_target <= D_NOM;
        end else begin
            if (s_value > PHI_POS) begin
                duty_target <= D_MAX;
            end else if (s_value < PHI_NEG) begin
                duty_target <= D_MIN;
            end else begin
                duty_target <= D_NOM; 
            end
        end
    end

endmodule
