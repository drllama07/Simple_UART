# UART Transmitter

A simple UART transmitter implemented in SystemVerilog as a project to learn digital hardware design and serial communication.

## Features

- Finite state machine for UART transmission
- Configurable clock frequency and baud rate
- Baud rate generator
- Shift register for serialising 8-bit data
- Verilator simulation and C++ testbench

## Architecture

The design consists of three main modules:

- **UART TX:** Controls the transmission process using a finite state machine.
- **BaudGen:** Generates timing ticks based on the configured clock frequency and baud rate.
- **ShiftRegister:** Serialises the input byte, transmitting the least significant bit first. Also, can be used to parallelize a serial input.

## UART Configuration

The transmitter is designed for 8N1 communication:

- 8 data bits
- No parity bit
- 1 stop bit
- Idle line held high

## Tools

- SystemVerilog
- Verilator
- C++

## Status

Work in progress. Currently implementing and testing the transmitter logic and timing in simulation.
