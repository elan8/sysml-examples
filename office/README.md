# Office Workstation — Project Description

A SysML v2 example project for a **desk workstation setup**.  
This model demonstrates a compact but complete pattern with:

- typed interfaces and structural connections,
- a small operational state machine on the laptop,
- requirements with `satisfy` traces,
- basic use cases.

---

## 1. Project Overview

### 1.1 Purpose

Model a realistic office workstation used for engineering and analysis tasks: laptop, monitor, keyboard, mouse, and wall power.

### 1.2 Scope

- **In scope:** wiring/connectivity at system level (power, HDMI, USB), session behavior (active/locked/off), and high-level performance/availability requirements.
- **Out of scope:** network architecture, OS/software deployment details, thermal behavior, and enclosure ergonomics.

---

## 2. Model Contents

## 2.1 Structure

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

### 2.2 Ports and interfaces

Typed ports are used to keep connections explicit and checkable:

- `ACOutletPort` / `~ACOutletPort`
- `HdmiPort` / `~HdmiPort`
- `UsbHostPort` / `~UsbHostPort`

### 2.3 Behavior

`Laptop` exhibits `WorkSessionStateMachine` with three states:

- `PoweredOff`
- `ActiveSession`
- `IdleLocked`

Events: `StartWork`, `LockScreen`, `ResumeWork`, `ShutdownWorkstation`.

### 2.4 Requirements and traceability

The model includes requirement definitions for:

- laptop capability (`ProductivityComputerReq`),
- external display support (`ExternalDisplayReq`),
- input-device availability (`InputDeviceReq`),
- continuous power (`ContinuousPowerReq`).

`officeInstance : OfficeDeskSetup` is used with `satisfy` relations to trace fulfillment.

### 2.5 Use cases

- `StartDeskWork`
- `LockAndResume`

---

## 3. File

- **[`office.sysml`](office.sysml)** — complete SysML v2 model for this example.

---

## 4. Relationship to other examples

Compared with [timer](../timer/), [drone](../drone/), and [intersection](../intersection/), this example remains intentionally compact but now includes both **structure and behavior** with requirement traceability.
