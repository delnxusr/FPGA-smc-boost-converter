`timescale 1ns / 1ps


module mcp3008_reader (
    input  wire        clk,        
    input  wire        reset,     
    input  wire        miso,       
    output reg         mosi,      
    output reg         sclk,       
    output reg         cs_n,      
    output reg [9:0]   adc_data    
);

    
    reg [5:0] clk_div;
    reg       sclk_tick;

    always @(posedge clk) begin
        if (reset) begin
            clk_div   <= 6'd0;
            sclk_tick <= 1'b0;
        end else begin
            if (clk_div >= 6'd24) begin
                clk_div   <= 6'd0;
                sclk_tick <= 1'b1;
            end else begin
                clk_div   <= clk_div + 6'd1;
                sclk_tick <= 1'b0;
            end
        end
    end

  
    reg [5:0]  step;
    reg [9:0]  shift_reg;
    reg [11:0] sample_timer;

    always @(posedge clk) begin
        if (reset) begin
            cs_n         <= 1'b1;
            sclk         <= 1'b0;
            mosi         <= 1'b0;
            step         <= 6'd0;
            adc_data     <= 10'd0;
            shift_reg    <= 10'd0;
            sample_timer <= 12'd0;
        end else if (sclk_tick) begin
            case (step)
                6'd0: begin
                    cs_n <= 1'b1;
                    sclk <= 1'b0;
                    mosi <= 1'b0;
                    if (sample_timer >= 12'd20) begin
                        sample_timer <= 12'd0;
                        step         <= 6'd1;
                    end else begin
                        sample_timer <= sample_timer + 12'd1;
                    end
                end

               
                6'd1:  begin cs_n <= 1'b0; sclk <= 1'b0; mosi <= 1'b1; step <= 6'd2;  end 
                6'd2:  begin sclk <= 1'b1; step <= 6'd3;  end
                6'd3:  begin sclk <= 1'b0; mosi <= 1'b1; step <= 6'd4;  end 
                6'd4:  begin sclk <= 1'b1; step <= 6'd5;  end
                6'd5:  begin sclk <= 1'b0; mosi <= 1'b0; step <= 6'd6;  end 
                6'd6:  begin sclk <= 1'b1; step <= 6'd7;  end
                6'd7:  begin sclk <= 1'b0; mosi <= 1'b0; step <= 6'd8;  end 
                6'd8:  begin sclk <= 1'b1; step <= 6'd9;  end
                6'd9:  begin sclk <= 1'b0; mosi <= 1'b0; step <= 6'd10; end 
                6'd10: begin sclk <= 1'b1; step <= 6'd11; end

                
                6'd11: begin sclk <= 1'b0; mosi <= 1'b0; step <= 6'd12; end 
                6'd12: begin sclk <= 1'b1; step <= 6'd13; end              

                
                6'd13: begin sclk <= 1'b0; step <= 6'd14; end
                6'd14: begin sclk <= 1'b1; shift_reg[9] <= miso; step <= 6'd15; end
                6'd15: begin sclk <= 1'b0; step <= 6'd16; end
                6'd16: begin sclk <= 1'b1; shift_reg[8] <= miso; step <= 6'd17; end
                6'd17: begin sclk <= 1'b0; step <= 6'd18; end
                6'd18: begin sclk <= 1'b1; shift_reg[7] <= miso; step <= 6'd19; end
                6'd19: begin sclk <= 1'b0; step <= 6'd20; end
                6'd20: begin sclk <= 1'b1; shift_reg[6] <= miso; step <= 6'd21; end
                6'd21: begin sclk <= 1'b0; step <= 6'd22; end
                6'd22: begin sclk <= 1'b1; shift_reg[5] <= miso; step <= 6'd23; end
                6'd23: begin sclk <= 1'b0; step <= 6'd24; end
                6'd24: begin sclk <= 1'b1; shift_reg[4] <= miso; step <= 6'd25; end
                6'd25: begin sclk <= 1'b0; step <= 6'd26; end
                6'd26: begin sclk <= 1'b1; shift_reg[3] <= miso; step <= 6'd27; end
                6'd27: begin sclk <= 1'b0; step <= 6'd28; end
                6'd28: begin sclk <= 1'b1; shift_reg[2] <= miso; step <= 6'd29; end
                6'd29: begin sclk <= 1'b0; step <= 6'd30; end
                6'd30: begin sclk <= 1'b1; shift_reg[1] <= miso; step <= 6'd31; end
                6'd31: begin sclk <= 1'b0; step <= 6'd32; end
                6'd32: begin sclk <= 1'b1; shift_reg[0] <= miso; step <= 6'd33; end

             
                6'd33: begin
                    sclk     <= 1'b0;
                    cs_n     <= 1'b1;
                    adc_data <= shift_reg;
                    step     <= 6'd0;
                end

                default: step <= 6'd0;
            endcase
        end
    end

endmodule
