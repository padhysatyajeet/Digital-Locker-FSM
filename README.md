# Digital Locker FSM – Verilog Implementation

## Overview

This Verilog project implements a digital locker system using a Finite State Machine (FSM). The locker accepts a 4-digit password and provides secure access by validating the entered code. It supports lockout after multiple failed attempts and outputs corresponding status signals (unlocked, locked). The design is fully testable via simulation tools.



## Features

- Implements a 4-state FSM (IDLE, COMPARE, UNLOCKED_STATE, LOCKED_STATE) using parameter encoding.

- Accepts a 4-digit numeric password (hardcoded as 1-2-3-4) through sequential input using submit pulses.

- Tracks incorrect attempts and locks permanently after 3 failures using attempts_left counter.

## Outputs:

unlocked = 1 when correct password is entered.

locked = 1 after 3 wrong attempts.

## Inputs:

digit_in: 4-bit input digit.

submit: signal to enter a digit.

clk and reset for synchronous operation.
