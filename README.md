
This is the RTL implemenation of Sliding mode controller (SMC) for  a DC-DC boost converter, implemented on Altera DE2-115 FPGA.

## Overview ##

Conventional PI controllers are made to operate in a specfic region if they surpass that, they fail to stablize the voltage to reasonable levels. This project improvises the SMC implemented by the base paper by implementing it in FPGA in Q16.16 fixed point veriog RTL.


## Results 
| Controller | Voltage Dip | Recovery Time |     |     |         |            |                                                                                                                    |
| ---------- | ----------- | ------------- | --- | --- | ------- | ---------- | ------------------------------------------------------------------------------------------------------------------ |
| PI         | ~11V dip    | ~1.0s         |     | SMC | <1V dip | Several ms | Hardware validated on DE2-115 with oscilloscope measurements confirming stable DC output with ~25ms settling time. |

## RTL Modules 
| Module           | Function                           |     |
| ---------------- | ---------------------------------- | --- |
| error_calc.v     | Computes error and derivative      |     |
| slide_calc.v     | Sliding surface s = e + λ·ė        |     |
| boundary_layer.v | Chattering suppression (±Φ = 2.0V) |     |
| pwm_gen.v        | 100kHz PWM at 100MHz clock         |     |
| wrapper.v        | Top-level interconnect             |     |
## Tools 
 1. MATLAB/Simulink (plant modelling, PI baseline) 
 2. Intel Quartus Prime (synthesis, DE2-115) 
 3. Verilog RTL, Q16.16 fixed-point arithmetic
## Repository Structure

rtl/src/ — RTL source modules
rtl/tb/ — Simulation testbenches
 rtl/project/ — Quartus project files (.qsf/.qpf) 
 simulink/ — MATLAB/Simulink model (.slx) 
 report/ — Full project report (PDF) 