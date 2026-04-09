# Kitchen Timer

This example is the recommended first substantial model in the repository. It stays compact enough for learners to read in one sitting while still combining structure, state behavior, interfaces, requirements, use cases, and a small implementation view.

## What This Example Demonstrates

- a readable state-machine-centered behavioral example
- typed interfaces for buttons, display, buzzer, and power
- a small decomposition from logical timer behavior into implementation-oriented parts
- requirements and `satisfy` traces in a compact setting
- simple use cases that connect the model back to user intent

## What Is Intentionally Simplified

- countdown logic, timing accuracy, and electrical behavior are sketched at example level rather than fully formalized
- the requirements and constraints are illustrative and not intended as a complete product specification
- physical implementation details are selective and only included where they help explain structure or interfaces

## What To Inspect In The Model

- `KitchenTimer` for the top-level system structure
- `TimerStateMachine` for the main behavioral flow
- the port definitions for button, display, buzzer, and battery interactions
- the requirement definitions and `satisfy` usages
- the `TimerPCB` decomposition as a bridge between logical and implementation-oriented views

## Known Limitations

- this is a teaching example, not a validated appliance design
- some actions and constraints are placeholders meant to illustrate modeling patterns rather than executable logic

## File

- [KitchenTimer.sysml](KitchenTimer.sysml) - complete SysML v2 model for this example

## Detailed Description

### Purpose

The system is a countdown timer for cooking, workouts, and other timed tasks. It allows the user to set a duration, start the countdown, optionally pause and resume, and receive an audible alarm when time expires.

### Scope

- In scope: timer controller logic, display, button interface, buzzer, battery, and a compact implementation view.
- Out of scope: packaging, enclosure design, charging infrastructure, and detailed battery chemistry.

### Main Subsystems

- `TimerController` or equivalent control logic represented by the state machine and MCU-related parts
- display output for the remaining time
- button input for start, stop, reset, increment, and decrement
- buzzer behavior on expiration
- battery and switched power flow

### Main Behavior

The central behavioral model is the timer state machine with these states:

- `Idle`
- `Running`
- `Paused`
- `Expired`

Typical transitions are driven by user input events such as `StartPressed`, `StopPressed`, and `ResetPressed`, plus the internal `CountdownComplete` event.

### Requirements And Traceability

The example includes illustrative requirements for timer range, display format, timing accuracy, audibility, responsiveness, state consistency, and battery runtime. A concrete `timerInstance` is used to show simple `satisfy` traces.
