# Traffic Light Intersection – SysML v2 model

This folder contains the SysML v2 textual model for the **traffic light intersection** described in [../README.md](../README.md).

## File

- **TrafficLightIntersection.sysml** – Single-package model with:
  - **Structure:** `TrafficLightIntersection` (controller, mainStreetSignals, sideStreetSignals, detector); ports and connections per README §8.
  - **State machine:** Controller exhibits `ControllerStateMachine` with modes **Normal** (phase cycle) and **Flash**. Normal has substates PhaseA → PhaseB → PhaseC → PhaseD → PhaseA with time-based transitions (`PhaseTimerElapsed`). Normal ↔ Flash on `FlashCommand` / `NormalCommand`.
  - **Requirements:** Safety (NoConflictingGreens, ClearanceTime, FailSafe), functionality (PhaseSequence, Modes), operability (Visibility); satisfy by intersection or controller.
  - **Use cases:** NormalOperation, SwitchToFlash, ReturnToNormal, ActuatedGreen, PedestrianCrossing.
  - **Optional:** Action defs for lamp commands (SetMainGreen, etc.), ClearanceTimeConstraint parametric, placeholder actions.

## Main behavioral focus

The **intersection controller state machine** is the central artifact: phase cycle (A→B→C→D) inside Normal, plus Flash mode and transitions between Normal and Flash.

## Notation

SysML v2 textual notation; see [SysML v2 Language Specification](https://www.omg.org/spec/SysML/2.0/Language/) and `temp/SysML_v2.txt` in this repo.
