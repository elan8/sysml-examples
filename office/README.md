# Office Workstation

This is the smallest example in the repository. It is designed as a quick first read for learners who want to see a compact SysML v2 text model with typed ports, simple structural connections, a small state machine, and basic `satisfy` relationships.

## What This Example Demonstrates

- typed interfaces and explicit structural connections
- a small operational state machine on the laptop
- simple requirements with `satisfy` traces
- a lightweight use-case layer

## What Is Intentionally Simplified

- the model stays at desk-setup level and does not try to model networking, software deployment, thermal behavior, or ergonomics
- interface typing is kept simple so the example stays readable for first-time learners
- the requirements are illustrative and are not meant to represent a full verification-ready specification

## What To Inspect In The Model

- `OfficeDeskSetup` for the main parts and connections
- the port definitions for the power, HDMI, and USB examples
- `WorkSessionStateMachine` for the smallest behavior example in the repo
- `officeInstance` and the `satisfy` usages for traceability

## Known Limitations

- this example optimizes for readability over strict realism
- it is intentionally smaller and less formal than the timer, intersection, and drone examples

## File

- [office.sysml](office.sysml) - complete SysML v2 model for this example

## Detailed Description

### Purpose

Model a realistic office workstation used for engineering and analysis tasks: laptop, monitor, keyboard, mouse, and wall power.

### Scope

- In scope: wiring and connectivity at system level, session behavior, and high-level performance and availability requirements.
- Out of scope: network architecture, OS and software deployment details, thermal behavior, and enclosure ergonomics.

### Model Contents

The top-level system is `OfficeDeskSetup` with:

- `wallSocket : WallSocket`
- `laptop : Laptop`
- `monitor : Monitor`
- `mouse : Mouse`
- `keyboard : Keyboard`

Main connections:

- `laptop.hdmi -> monitor.hdmi`
- `laptop.power -> wallSocket.power`
- `monitor.power -> wallSocket.power`
- `laptop.usb1 -> mouse.usb`
- `laptop.usb2 -> keyboard.usb`

`Laptop` exhibits `WorkSessionStateMachine` with three states:

- `PoweredOff`
- `ActiveSession`
- `IdleLocked`

The model includes requirement definitions for:

- laptop capability (`ProductivityComputerReq`)
- external display support (`ExternalDisplayReq`)
- input-device availability (`InputDeviceReq`)
- continuous power (`ContinuousPowerReq`)

Compared with the other examples, this one is intentionally minimal and serves as a quick orientation point before moving on to the richer timer example.
