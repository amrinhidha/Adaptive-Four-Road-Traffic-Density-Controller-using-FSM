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

## System Architecture

Inputs

The system takes its inputs from the board:

Slide switches sw[7:0]: two switches per road set the traffic density, with 00 for none, 01 for medium, and 10 or 11 for heavy.
btn[0]: reset.
btn[1]: pedestrian request.
btn[2]: emergency override.

## **Modules**

Density module: splits the 8 switch bits into four 2-bit density values, one for each road.

Priority module: takes those four densities and picks which road gets the next green. It treats any density of 2 or 3 as “heavy” and searches for the busiest road, starting just after the road served last. When two roads have the same density, the turn rotates between them instead of always favoring North. It outputs the selected road and its density.

Timer module: divides the 100 MHz clock down to a single pulse every second, called one_sec_tick. The FSM uses it as its time base.

Emergency module: passes the emergency button through a two-flip-flop synchronizer so that the asynchronous button press is safe to use in the clocked logic.
Pedestrian module: synchronizes the pedestrian button, debounces it for 20 ms, detects the press edge, and latches a pending request. The request stays pending until the FSM clears it.

Traffic FSM: the controller at the center of the design. It has three states: ALL_RED, GREEN and YELLOW. It reads the tick, the selected road and density, the pedestrian request and the emergency signal. It outputs the 12-bit light pattern, the current road, the last served road, the walk signal, a pedestrian-clear pulse, and a 5-bit countdown.

Seven-segment countdown module: converts the countdown value into two decimal digits and shows them on the display by switching between the digits at 2 kHz.

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

**State Diagram**


<img width="930" height="580" alt="image" src="https://github.com/user-attachments/assets/a3444830-4195-4423-a285-743b2be3b8cc" />



**State transition**

<img width="866" height="666" alt="image" src="https://github.com/user-attachments/assets/034033d4-7e1d-45dc-bdbb-7c67da69fb8b" />



