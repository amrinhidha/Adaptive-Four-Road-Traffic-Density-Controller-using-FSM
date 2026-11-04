# Adaptive Four-Road Traffic Density Controller using Verilog HDL

## Project Overview
An FPGA-based Adaptive Traffic Density Controller designed using Verilog HDL and a Moore Finite State Machine (FSM). The system manages traffic signals at a four-road intersection (North, East, South, and West) by monitoring traffic density and dynamically allocating green signal time based on traffic priority.

## Key Features
- **Traffic Density Detection:** Accepts traffic density inputs for all four roads using FPGA switches.
- **Priority-Based Selection:** Selects the road with the highest traffic density.
- **Adaptive Signal Timing:** Adjusts green signal duration based on traffic density.
- **Moore FSM Architecture:** Implements traffic signal control using defined states and transitions.
- **Emergency Handling:** Forces all traffic signals to RED when an emergency input is activated.
- **LED-Based Visualization:** Displays traffic signal states using the FPGA board's onboard LEDs.

## Traffic Signal Timing
- Low Density – 5 seconds Green
- Medium Density – 10 seconds Green
- High Density – 15 seconds Green
- Yellow Signal – 3 seconds
- All-Red Interval – 1 second

## Technologies Used
- Verilog HDL
- Moore Finite State Machine
- Xilinx Vivado 2015
- Real Digital Boolean FPGA Board
- FPGA switches, pushbuttons and LEDs

## Learning Outcomes
- FSM design and state transition implementation.
- Verilog RTL coding and simulation.
- Priority-based digital control logic.
- Clock division and timer implementation.
- FPGA synthesis, implementation and hardware testing.

**Objective:** To develop an efficient and adaptive traffic signal control system that improves traffic flow by prioritizing roads according to vehicle density while incorporating emergency handling.

**
State diagram
**
<img width="872" height="682" alt="image" src="https://github.com/user-attachments/assets/18a139a3-300a-4890-9103-437e1971740a" />

