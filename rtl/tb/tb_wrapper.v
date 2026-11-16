`timescale 1ns / 1ps

module tb_wrapper;

    // Inputs
    reg clk;
    reg reset;
    reg signed [31:0] v_ref;
    reg signed [31:0] v_sensor;

    // Outputs
    wire signed [31:0] error;
    wire signed [31:0] de_dt;
    wire signed [31:0] s_val;
    wire signed [31:0] duty_target;
    wire pwm_out;

    // Instantiate Unit Under Test (UUT)
    wrapper uut (
        .clk(clk),
        .reset(reset),
        .v_ref(v_ref),
        .v_sensor(v_sensor),
        .error(error),
        .de_dt(de_dt),
        .s_val(s_val),
        .duty_target(duty_target),
        .pwm_out(pwm_out)
    );

    // 100 MHz clock generation (Period = 10ns)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Q16.16 voltage values (Voltage * 65536)
    localparam signed [31:0] V_24V    = 32'sd1572864; // 24.0V
    localparam signed [31:0] V_20V    = 32'sd1310720; // 20.0V (undervoltage / load dip)
    localparam signed [31:0] V_28V    = 32'sd1835008; // 28.0V (overvoltage overshoot)
    localparam signed [31:0] V_24_05V = 32'sd1576140; // 24.05V (inside boundary layer)

    initial begin
        // Reset sequence
        reset = 1'b1;
        v_ref = V_24V;
        v_sensor = 32'sd0;

        #100;
        @(posedge clk);
        reset = 1'b0;
        $display("[Time: %0t ns] Reset released. Starting tests...", $time);

        // Test 1: Cold start (V_sensor = 0V, V_ref = 24V)
        // Error > 0, s > +Phi (131072) -> expect D_MAX (900)
        #200;
        $display("[TEST 1: Cold Start] Error=%0d, s_val=%0d, duty_target=%0d (Expect 900)",
                 error, s_val, duty_target);

        // Wait 2 PWM periods (20us)
        #20000;

        // Test 2: Overvoltage (V_sensor = 28V)
        // Error < 0, s < -Phi (-131072) -> expect D_MIN (100)
        @(posedge clk);
        v_sensor = V_28V;
        #200;
        $display("[TEST 2: Overvoltage 28V] Error=%0d, s_val=%0d, duty_target=%0d (Expect 100)",
                 error, s_val, duty_target);

        #20000;

        // Test 3: Inside Boundary Layer (V_sensor = 24.05V)
        // |s| < Phi -> expect duty_target to hold previous state (100)
        @(posedge clk);
        v_sensor = V_24_05V;
        #200;
        $display("[TEST 3: Inside Boundary] Error=%0d, s_val=%0d, duty_target=%0d (Should hold 100)",
                 error, s_val, duty_target);

        #20000;

        // Test 4: Voltage Dip (V_sensor = 20V)
        // Error > 0, s > +Phi -> expect switch back to D_MAX (900)
        @(posedge clk);
        v_sensor = V_20V;
        #200;
        $display("[TEST 4: Voltage Dip 20V] Error=%0d, s_val=%0d, duty_target=%0d (Expect 900)",
                 error, s_val, duty_target);

        #30000;
        $display("[Time: %0t ns] All tests completed.", $time);
        $finish;
    end

    // Real-time duty monitor
    always @(duty_target) begin
        $display("  >> [Time: %0t ns] duty_target = %0d (%0.1f%%)",
                 $time, duty_target, (duty_target / 10.0));
    end

endmodule
