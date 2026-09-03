# FPGA-Based Traffic Light Controller with Priority System

## Project Description

This project implements an FPGA-based traffic light controller using Verilog HDL. The system is designed to control traffic signals for two roads, Road A and Road B. It uses a finite state machine (FSM) to control the sequence of red, yellow, and green lights.

The controller normally operates in a predefined sequence. It also includes a priority system that allows emergency vehicles to receive priority. When an emergency signal is detected on a particular road, the controller changes the traffic light state to provide a green signal for that road while stopping traffic on the other road.

The design is developed and verified using Verilog simulation. A testbench is used to generate the clock, reset, normal traffic conditions, and emergency conditions. The simulation waveform is analyzed to verify the correct operation of the traffic light controller.

## Objectives

- Design a traffic light controller using Verilog HDL.
- Implement the controller using a finite state machine.
- Control traffic signals for two roads.
- Provide priority for emergency vehicles.
- Verify the design using simulation.
- Analyze the simulation waveform and outputs.

## Features

- Two-road traffic control
- Red, yellow, and green traffic signals
- FSM-based control
- Emergency priority system
- Reset functionality
- Verilog HDL implementation
- Simulation and waveform verification

## System Operation

Under normal conditions, the traffic lights operate in sequence:

1. Road A gets a green signal.
2. Road A changes to yellow.
3. Road B gets a green signal.
4. Road B changes to yellow.
5. The cycle repeats.

When an emergency signal is detected:

- Emergency on Road A → Road A receives priority.
- Emergency on Road B → Road B receives priority.

This allows emergency vehicles to pass through the intersection quickly.

## Block Diagram

```text
             +------------------+
             |      Clock       |
             +--------+---------+
                      |
                      v
             +------------------+
             |  Traffic Light   |
             |       FSM        |
             +--------+---------+
                      |
          +-----------+-----------+
          |                       |
          v                       v
   +-------------+         +-------------+
   |    Road A   |         |    Road B   |
   | R Y G Lights|         | R Y G Lights|
   +-------------+         +-------------+
          ^                       ^
          |                       |
   Emergency A              Emergency B
