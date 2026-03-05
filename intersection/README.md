# Traffic Light Intersection — Project Description

A SysML v2 example project for a **road intersection controlled by traffic lights**. This document provides a detailed system description to support modeling in SysML v2, with emphasis on **state machine behavior** (light phases, sequences, and modes).

---

## 1. Project Overview

### 1.1 Purpose

The system is a **traffic signal installation** that controls vehicle and pedestrian flow at a single intersection. It assigns right-of-way to different approaches in a safe, predictable sequence and can support special modes (e.g. flashing, pedestrian demand, preemption).

### 1.2 System Type

- **Configuration:** Typically a 4-way intersection (two roads crossing) with one signal head per approach (or per lane group), plus optional pedestrian signals.
- **Control:** Central intersection controller that runs a fixed or actuated cycle; states and timing drive the physical lights.
- **Domain:** Traffic control equipment; may reference standards (e.g. MUTCD, local specs).

### 1.3 Key Stakeholders

| Stakeholder | Interest |
|-------------|----------|
| Road authority / Traffic engineer | Safety, capacity, compliance with standards. |
| Motorists | Clear signals, predictable timing, minimal delay. |
| Pedestrians | Safe crossing time, visible walk/don’t walk. |
| Maintenance | Diagnostics, lamp monitoring, easy repair. |
| Emergency / Transit | Preemption or priority for specific approaches. |

---

## 2. System Context and Boundaries

### 2.1 System of Interest

The **Traffic Light Intersection** includes:

- **In scope:** Intersection controller (logic and timing), signal heads (red / yellow / green, and optionally pedestrian indicators) for each approach, detectors (e.g. inductive loops, pedestrian buttons) if actuated, cabinet and power, and the communication between controller and field devices.
- **Out of scope (external):** Adjacent intersections (may be referenced for coordination), central traffic management system, power grid (modeled as external interface only).

### 2.2 External Interfaces (High Level)

- **Environment:** Road users (vehicles, pedestrians), detectors (vehicles, button presses), ambient light.
- **Operator / Maintenance:** Configuration, diagnostics, manual override (e.g. flash mode).
- **Optional:** Preemption input (e.g. fire, transit), coordination link to other intersections.

---

## 3. Intersection Layout and Approaches

### 3.1 Typical 4-Way Intersection

- **Approaches:** Four approaches (e.g. North, South, East, West). Each approach has one or more lanes (through, left turn, right turn) and optionally a crosswalk.
- **Conflict groups:** Vehicle movements that must not have green at the same time (e.g. North–South through vs. East–West through; opposing left turns). The controller ensures only non-conflicting phases receive green.
- **Signal faces:** Each approach (or lane group) has a signal head showing Red, Yellow, Green. Pedestrian signals show Walk, Flashing Don’t Walk, Don’t Walk (or equivalent).

### 3.2 Simplified Model for State Machine Focus

For the example, a **single road (two approaches)** can be used: e.g. Main Street (East and West) crossing Side Street (North and South). Phases can be reduced to:

- **Phase A:** Main Street (East + West) green; Side Street red.
- **Phase B:** Main Street yellow (clearance); Side Street red.
- **Phase C:** Side Street (North + South) green; Main Street red.
- **Phase D:** Side Street yellow; Main Street red.

Pedestrian phases can be included (e.g. Walk with Main green, Walk with Side green) or omitted for simplicity.

---

## 4. Subsystems and Architecture

### 4.1 Intersection Controller

- **Role:** Execute the signal timing plan; maintain current phase/state; advance state based on time and (if actuated) detector inputs; handle special modes.
- **Components:** Logic (state machine), timing parameters (min/max green, yellow time, all-red), optional communication interface.
- **Key attributes:** Cycle length, phase sequence, green/yellow/all-red times per phase, actuated vs. fixed-time.

### 4.2 Signal Heads (Lamp Assemblies)

- **Role:** Display Red, Yellow, Green (and optionally pedestrian symbols) to road users.
- **Description:** One or more signal heads per approach; each head has lamps (or LED modules) for each indication. Controller commands which indication is on.
- **Key attributes:** Number of faces per approach, type (vehicle vs. pedestrian), lamp monitoring (optional).

### 4.3 Detectors (Optional for Actuated Control)

- **Role:** Provide presence or demand (vehicles, pedestrian button) to the controller.
- **Description:** Inductive loops, video, or other vehicle detectors; pedestrian pushbuttons.
- **Key attributes:** Coverage (lane, approach), type (presence, passage, demand).

### 4.4 Cabinet and Power

- **Role:** House controller, power distribution, and protection; supply power to controller and lamps.
- **Description:** Field cabinet, power supply, load switches (or similar) driving lamps.
- **Key attributes:** Redundancy (if any), lamp monitoring capability.

---

## 5. Behavior — State Machine Focus

### 5.1 Phase States (Vehicle Signals)

For each approach or conflict group, the signal can be in one of:

- **Red** — Stop; no right-of-way.
- **Yellow** — Clearance; prepare to stop (fixed short duration, e.g. 3–5 s).
- **Green** — Go; right-of-way (duration may be fixed or extend on actuation).

All-red (brief full red for all approaches) may be modeled as a short state between phases or as part of yellow timing.

### 5.2 Controller State Machine (Conceptual)

High-level states for the **intersection controller**:

1. **Normal** — Running the main cycle (phase sequence A → B → C → D → A …).
2. **Phase A (Main Green)** — Main Street green; Side Street red; timers running (min green, max green, or gap-based).
3. **Phase B (Main Yellow)** — Main Street yellow; Side Street red; yellow timer.
4. **Phase C (Side Green)** — Side Street green; Main Street red.
5. **Phase D (Side Yellow)** — Side Street yellow; Main Street red.
6. **All-Red (optional)** — Brief state between phases for clearance.
7. **Flash** — All approaches in flashing yellow (or red/yellow by approach); no cycle, e.g. for maintenance or failure.
8. **Preempt** (optional) — Special phase(s) for emergency or transit; overrides normal cycle.
9. **Off / Dark** (optional) — Signals off (e.g. power failure); may be out of scope.

Transitions are driven by:

- **Time:** Min green elapsed, max green elapsed, yellow time elapsed, all-red elapsed.
- **Demand (if actuated):** Gap-out (no vehicles), passage timer, pedestrian call.
- **Events:** Mode switch to Flash, preemption request, return to Normal.

### 5.3 Timing Parameters (Typical)

- **Min green:** e.g. 5–10 s.
- **Max green:** e.g. 30–60 s (or unlimited in fixed-time).
- **Yellow:** e.g. 3–5 s.
- **All-red:** e.g. 1–2 s.
- **Pedestrian walk:** e.g. 7 s; flashing don’t walk e.g. 4–7 s (if modeled).

---

## 6. Use Cases / Scenarios

1. **Normal operation** — Controller runs phase sequence; vehicles and pedestrians obey signals.
2. **Actuated green** — Green extends on vehicle demand until max green or gap-out.
3. **Pedestrian crossing** — Button press registers; walk phase is served in the cycle (e.g. with Main or Side green).
4. **Switch to flash** — Operator or fault triggers flash mode; all approaches flash (e.g. yellow main, red side).
5. **Return to normal** — Flash (or preempt) ends; controller resumes normal cycle from a defined phase.
6. **Preemption** (optional) — Emergency vehicle or transit priority; phase(s) forced to green for selected approach(es).

---

## 7. Key Requirements (Summary)

### 7.1 Safety

- **Conflict:** No two conflicting movements shall have green simultaneously.
- **Clearance:** Yellow (and all-red if used) shall be long enough for clearance per approach speed.
- **Fail-safe:** On fault or loss of controller, transition to flash or safe state (e.g. all red or flash).

### 7.2 Functionality

- **Cycle:** Controller shall run the defined phase sequence (e.g. A → B → C → D) with configurable timing.
- **Modes:** Support at least Normal and Flash; optionally Preempt.
- **Pedestrian:** If modeled, serve pedestrian demand with adequate walk and clearance time.

### 7.3 Operability

- **Visibility:** Signal indications shall meet standard visibility (luminance, position).
- **Maintenance:** Lamp or LED failure shall be detectable (lamp monitoring) where required.

---

## 8. Interfaces (Summary)

| From | To | Content |
|------|-----|--------|
| Controller | Signal heads (per approach) | Command: Red / Yellow / Green (and pedestrian if applicable). |
| Detectors | Controller | Vehicle presence, pedestrian demand. |
| Operator / Central | Controller | Mode (Normal / Flash), config, preemption request. |
| Power | Controller, Lamps | Mains power (and backup if modeled). |

---

## 9. Relation to SysML v2

This description is intended to be refined into SysML v2 models, with emphasis on:

- **Structure:** Block definition and internal block diagrams for the intersection system (controller, signal heads, detectors, cabinet); parts and ports for commands and detector inputs.
- **Behavior — state machines:** State definitions for controller modes (Normal, Flash, Preempt) and for the phase cycle (Phase A, B, C, D, All-Red); transition usages with triggers (time, demand, events); entry/exit or do actions for timers and lamp commands.
- **Behavior — activities (optional):** Actions for “run phase A”, “run yellow”, etc., if activity decomposition is used.
- **Requirements:** Requirement elements for safety, functionality, and operability with traceability.
- **Allocations:** Requirements and behaviors allocated to the controller and signal heads.

The **intersection controller state machine** is the central behavioral model for this example.

---

*This document is the authoritative high-level description for the Traffic Light Intersection SysML v2 example project.*
