`timescale 1ns / 1ps


module wrapper (
    input  wire        clk,         
    input  wire        key0,       
    input  wire        sw0,          
    
    input  wire        adc_dout,     
    output wire        adc_cs_n,     
    output wire        adc_sclk,     
    output wire        adc_din,     

    
    output wire        pwm_out,     
    output wire        led_pwm,      
    
 
    output wire signed [31:0] error,
    output wire signed [31:0] de_dt,
    output wire signed [31:0] s_val,
    output wire signed [31:0] duty_target
);

    wire reset = ~key0;

   
    wire [9:0] adc_raw;
    mcp3008_reader u_adc_reader (
        .clk(clk),
        .reset(reset),
        .miso(adc_dout),
        .mosi(adc_din),
        .sclk(adc_sclk),
        .cs_n(adc_cs_n),
        .adc_data(adc_raw)
    );

 
    wire signed [31:0] v_sensor = (sw0) ? {22'd0, adc_raw} : 32'sd0;

    
    wire signed [31:0] v_ref = 32'sd751;

    
    assign led_pwm = pwm_out;

    error_calc u_error_calc (
        .clk(clk),
        .reset(reset),
        .v_ref(v_ref),
        .v_sensor(v_sensor),
        .error(error),
        .de_dt(de_dt)
    );

  
    slide_calc u_slide_calc (
        .error(error),
        .de_dt(de_dt),
        .s_val(s_val)
    );

   
    Boundary_layer u_boundary_layer (
        .clk(clk),
        .reset(reset),
        .s_value(s_val),
        .duty_target(duty_target)
    );

  
    PWM_gen u_pwm_gen (
        .clk(clk),
        .reset(reset),
        .duty_target(duty_target[9:0]),
        .pwm_out(pwm_out)
    );

endmodule
