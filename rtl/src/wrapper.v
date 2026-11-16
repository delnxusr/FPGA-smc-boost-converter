`timescale 1ns / 1ps

module wrapper (
    input  wire        clk,
    input  wire        reset,
    input  wire signed [31:0] v_ref,
    input  wire signed [31:0] v_sensor,
    output wire signed [31:0] error,
    output wire signed [31:0] de_dt,
    output wire signed [31:0] s_val,
    output wire signed [31:0] duty_target,
    output wire        pwm_out
);

    // 1. Error and derivative calculation
    error_calc u_error_calc (
        .clk      (clk),
        .reset    (reset),
        .v_ref    (v_ref),
        .v_sensor (v_sensor),
        .error    (error),
        .de_dt    (de_dt)
    );

    // 2. Sliding surface calculation
    slide_calc u_slide_calc (
        .error (error),
        .de_dt (de_dt),
        .s_val (s_val)
    );

    // 3. Boundary layer hysteresis
    Boundary_layer u_boundary_layer (
        .clk         (clk),
        .reset       (reset),
        .s_value     (s_val),
        .duty_target (duty_target)
    );

    // 4. 100 kHz PWM generation
    PWM_gen u_pwm_gen (
        .clk         (clk),
        .reset       (reset),
        .duty_target (duty_target[9:0]),
        .pwm_out     (pwm_out)
    );

endmodule
