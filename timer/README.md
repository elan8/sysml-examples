# Kitchen Timer — Project Description

A SysML v2 example project for a **programmable kitchen timer**. This document provides a detailed system description to support modeling in SysML v2, with emphasis on **state machine behavior** (countdown, pause, reset), **interfaces** (buttons, display, buzzer, power), and implementation-level traceability.

---

## 1. Project Overview

### 1.1 Purpose

The system is a **countdown timer** for cooking, workouts, and other timed tasks. It allows the user to set a duration, start the countdown, optionally pause and resume, and receive an audible alarm when time expires.

### 1.2 System Type

- **Configuration:** Standalone, battery-powered appliance with display, buttons, and buzzer.
- **Control:** Central timer controller that runs a state machine (Idle, Running, Paused, Expired) and drives the display and buzzer based on user input and countdown logic.
- **Domain:** Consumer kitchen appliance; portable, self-contained device.

### 1.3 Key Stakeholders

| Stakeholder | Interest |
|-------------|----------|
| End user | Ease of use, readability, audible alarm, battery life. |
| Manufacturer | Safety, usability, cost, reliability, battery runtime. |

---

## 2. System Context and Boundaries

### 2.1 System of Interest

The **Kitchen Timer** includes:

- **In scope:** Timer controller (logic and state machine), display (countdown value), button interface (user input), buzzer (alarm), battery (power supply).
- **Out of scope:** Charging infrastructure (if rechargeable), battery chemistry details, packaging, and physical enclosure design.

### 2.2 External Interfaces (High Level)

- **User:** Button presses (Start/Stop, Reset, +, -).
- **User:** Audible alarm (buzzer) when timer expires.
- **User:** Visual feedback (display showing remaining time).
- **Power:** Battery powers all subsystems; battery is in-scope.

---

## 3. Subsystems and Architecture

### 3.1 Timer Controller

- **Role:** Execute the timer logic; maintain current state and countdown value; advance state based on button events and timer tick (CountdownComplete).
- **Components:** Logic (state machine), countdown register, timing parameters (min/max value, tick rate).
- **Key attributes:** minValue, maxValue, tickRate.

### 3.2 Display

- **Role:** Show remaining time (or set value when idle) to the user in MM:SS format.
- **Description:** LCD or LED display; controller commands which value to display.
- **Key attributes:** format (MM:SS).

### 3.3 Button Interface

- **Role:** Capture user input and provide button events to the controller.
- **Description:** Physical buttons (Start/Stop, Reset, Increment, Decrement) with debouncing.
- **Key attributes:** Number and mapping of buttons.

### 3.4 Buzzer

- **Role:** Produce audible alarm when timer expires.
- **Description:** Piezo or similar buzzer; controller commands on/off.
- **Key attributes:** duration (how long alarm sounds until acknowledged), audibility.

### 3.5 Battery

- **Role:** Power supply for all subsystems (controller, display, button interface, buzzer).
- **Description:** Primary battery (e.g., AAA or similar); provides voltage and current to loads.
- **Key attributes:** capacity, voltage, runtimeEstimate.

---

## 4. Subsystems Summary

| Part            | Role                            | Key attributes                    |
| --------------- | ------------------------------- | --------------------------------- |
| TimerController | Logic, countdown, state machine | minValue, maxValue, tickRate      |
| Display         | Shows remaining time (MM:SS)    | format                            |
| ButtonInterface | Captures user input             | —                                 |
| Buzzer          | Alarm on expiration             | duration                          |
| Battery         | Power supply for all subsystems | capacity, voltage, runtimeEstimate |

---

## 5. Behavior — State Machine Focus

### 5.1 Controller State Machine

High-level states for the **timer controller**:

1. **Idle** — Timer not running; user can set time via +/−; Start transitions to Running.
2. **Running** — Countdown in progress; Stop → Paused; CountdownComplete → Expired.
3. **Paused** — Countdown suspended; Start → Running (resume); Reset → Idle.
4. **Expired** — Countdown reached zero; buzzer on; Reset → Idle.

### 5.2 State Diagram (Conceptual)

```
[*] --> Idle
Idle --> Running : StartPressed
Idle --> Idle    : IncrementPressed / DecrementPressed
Running --> Paused   : StopPressed
Running --> Expired  : CountdownComplete
Paused --> Running : StartPressed
Paused --> Idle    : ResetPressed
Expired --> Idle   : ResetPressed
```

### 5.3 Transitions (Driven By)

- **Button events:** StartPressed, StopPressed, ResetPressed, IncrementPressed, DecrementPressed.
- **Timer event:** CountdownComplete (internal; when countdown reaches zero).

---

## 6. Use Cases / Scenarios

1. **SetAndStartTimer** — User sets time via +/−, then presses Start; countdown begins.
2. **PauseResume** — User presses Stop to pause; presses Start to resume.
3. **Reset** — User presses Reset to return to Idle and clear the set value.
4. **HearAlarm** — When countdown expires, buzzer sounds; user hears alarm and optionally resets.
5. **QuickStart** — User presses Start with preset (e.g., 5 min) without changing value; countdown begins.

---

## 7. Key Requirements (Summary)

### 7.1 Functionality

- **TimerRange:** Support 1–99 minutes (or 0:01–99:59).
- **DisplayFormat:** Display remaining time in MM:SS format.
- **Accuracy:** ±1 second per minute of elapsed time.
- **StateConsistency:** No conflicting states (e.g., running and expired simultaneously).

### 7.2 Operability

- **BuzzerAudibility:** Alarm shall be audible in typical kitchen environment.
- **ButtonResponsiveness:** Button presses shall be acknowledged within 100 ms.

### 7.3 Power

- **BatteryRuntime:** Minimum runtime (e.g., 100 hours typical use) on single charge or battery set.

---

## 8. Interfaces (Summary)

| From            | To         | Content                                                                             |
| --------------- | ---------- | ----------------------------------------------------------------------------------- |
| ButtonInterface | Controller | Events: StartPressed, StopPressed, ResetPressed, IncrementPressed, DecrementPressed |
| Controller      | Display    | Value to show (seconds or formatted string, e.g. MM:SS)                            |
| Controller      | Buzzer     | On/Off command                                                                      |
| Battery         | All loads  | DC power (typed `electricPower` flow); `voltage = 4.5 [V]`, `maxCurrent = 0.5 [A]`; each load specifies `maxCurrent` (e.g. controller `0.02 [A]`, buzzer `0.05 [A]`) |

Electrical power is modeled per [SE-Trends interface modeling](https://www.se-trends.de/en/interface-modeling-with-sysml-v2-in-syside/) using the **SysML v2 standard library**: `BatteryOutlet` (source) and `DevicePower` (sink) port definitions with typed `electricPower` flow and unit-qualified voltage/current (`[V]`, `[A]`); device-specific current draw via `:>>` override.

---

## 9. Implementation View

The logical architecture (controller, display, buttons, buzzer) maps to a physical implementation as follows:

### 9.1 PCB Assembly (`TimerPCB`)

The **printed circuit board** hosts:

- **Microcontroller (MCU)** — Has built-in LCD controller; runs the timer firmware and state machine; COM/SEG to display glass, GPIO to buttons.
- **Display** — Segment LCD glass, mounted on the PCB; driven by the MCU’s built-in LCD controller via COM/SEG lines (multiplexed drive).
- **Button interface** — Mechanical switches mounted on the PCB; one side tied to ground, the other to MCU GPIO with pull-ups; debounce in firmware.
- **Buzzer driver** — Transistor or FET that switches battery power to the buzzer when the MCU drives its GPIO high.

### 9.2 Buzzer (Off-Board)

The **buzzer** is a passive component with only **+/− terminals**. When power is applied across its terminals, it buzzes. It connects to the PCB via the buzzer driver:

- MCU GPIO (logical `buzzerOn`) → Buzzer driver transistor gate
- Buzzer driver switches battery power → Buzzer +/− terminals

There is no separate "buzzer command" bus; control is implemented by **switched power**.

### 9.3 Display Interface (Segment LCD)

The display is **segment LCD glass** driven by the MCU’s **built-in LCD controller**. The physical interface is **COM/SEG** (common and segment electrodes): the controller outputs multiplexed waveforms on these lines to the glass. Firmware converts the logical display value (e.g. MM:SS) into segment data and writes it to the LCD controller; no separate display driver IC is required. This is typical for low-power, battery-operated timers.

### 9.4 Power Flow

Battery provides power to all PCB loads (MCU, display, buttons, buzzer driver). The buzzer driver receives power and, when enabled by the MCU, passes it through to the buzzer. The MCU does not directly power the buzzer; the driver acts as a switch between battery and buzzer.

---

## 10. Relation to SysML v2

This description is intended to be refined into SysML v2 models, with emphasis on:

- **Structure:** Block definition and internal block diagrams for the kitchen timer; implementation-level parts (PCB, microcontroller, buzzer driver) with display and buttons mounted on the PCB; logical vs. physical interfaces (e.g., buzzer command vs. switched power).
- **Behavior — state machines:** State definitions for timer states (Idle, Running, Paused, Expired) exhibited by the Microcontroller; transition usages with triggers (button events, CountdownComplete); entry/exit or do actions for display updates and buzzer commands.
- **Behavior — activities (optional):** Actions for UpdateDisplay, StartCountdown, SoundAlarm, ClearDisplay, if activity decomposition is used.
- **Requirements:** Requirement elements for functionality, operability, and power with traceability.
- **Allocations:** Requirements and behaviors allocated to the controller, display, buzzer, and battery.

The **timer controller state machine** is the central behavioral model for this example.

---

*This document is the authoritative high-level description for the Kitchen Timer SysML v2 example project.*
