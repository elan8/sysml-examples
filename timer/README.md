# Kitchen Timer

This example is the recommended first substantial model in the repository. It stays compact enough for learners to read in one sitting while still combining structure, state behavior, interfaces, requirements, use cases, and a small implementation view.

Start here after the tiny office example if you want to see the core `spec42` workflow on a model that is still easy to keep in your head.

## Purpose

Model a countdown timer for cooking, workouts, and other timed tasks with a clear link between structure, behavior, requirements, and a compact implementation view.

## Try It With Spec42

From the repository root:

```bash
spec42 check timer/
```

In VS Code, open `KitchenTimer.sysml` and `Views.sysml`, then use the Model Explorer for structure and the Model Visualizer for structure, interconnection, and state-transition views.

## Why Start Here

- it is the strongest end-to-end teaching example in the repo
- it stays small enough to read quickly without losing the link between structure, behavior, and traceability
- it is the first example in this repository validated against `spec42`

## What This Example Demonstrates

- a readable state-machine-centered behavioral example
- typed interfaces for buttons, display, buzzer, and power
- a small decomposition from logical timer behavior into implementation-oriented parts
- requirements and `satisfy` traces in a compact setting
- simple use cases that connect the model back to user intent
- separate views for structure (`GeneralView`) and behavior (`StateTransitionView`), with `filter` on the structure view so exhibited state does not appear there

The corresponding views in `Views.sysml` are:

- `structure` (`GeneralView`) — `timerInstance` with `filter` on part/port definitions and usages (no states)
- `connections` (`InterconnectionView`) — `timerInstance` power and signal wiring
- `timerStateMachine` (`StateTransitionView`) — `TimerStateMachine` behavior definition

## What Is Intentionally Simplified

- countdown logic, timing accuracy, and electrical behavior are sketched at example level rather than fully formalized
- the requirements and constraints are illustrative and not intended as a complete product specification
- physical implementation details are selective and only included where they help explain structure or interfaces

## What To Inspect In The Model

- `KitchenTimer` (in `KitchenTimerStructure.sysml`) for the top-level system structure
- `TimerStateMachine` for the main behavioral flow
- the port definitions for button, display, buzzer, and battery interactions
- the requirement definitions and `satisfy` usages in `KitchenTimer.sysml`
- the `TimerPCB` decomposition as a bridge between logical and implementation-oriented views

**Two display ports:** `DisplayCommandPort` is the logical value (MM:SS string) from firmware; `LcdSegmentDrivePort` is the physical COM/SEG drive to the glass. Both are intentional.

## Known Limitations

- this is a teaching example, not a validated appliance design
- the requirements remain lightweight and readable rather than fully verification-ready
- the parametric constraints are illustrative support for the timing and runtime requirements, not a full analysis model
- countdown timing and `CountdownComplete` are modeled as states and events only; there is no explicit countdown action or tick binding to the state machine

## Validation And Tooling Notes

- canonical validation target: [`spec42`](https://github.com/elan8/spec42)
- this is the repository's flagship validated example
- current goal: the model should load cleanly and publish no intended diagnostics in the `spec42` workflow
- if you adapt the model to another SysML v2 tool, keep the teaching story and end-to-end coherence intact even if notation adjustments are required

## Files

| File | Purpose |
|------|---------|
| [KitchenTimer.sysml](KitchenTimer.sysml) | Instance, `satisfy` — start here |
| [KitchenTimerPorts.sysml](KitchenTimerPorts.sysml) | Typed interfaces (buttons, display, power) |
| [KitchenTimerStructure.sysml](KitchenTimerStructure.sysml) | Parts, PCB, connections |
| [KitchenTimerBehavior.sysml](KitchenTimerBehavior.sysml) | States, events, `TimerStateMachine` |
| [KitchenTimerRequirements.sysml](KitchenTimerRequirements.sysml) | Requirements, use cases, illustrative constraints |
| [Views.sysml](Views.sysml) | Structure, interconnection, state-transition views |

## Walkthrough

Read the model in this order:

1. `KitchenTimer.sysml` — `timerInstance` and `satisfy` relations
2. `KitchenTimerPorts.sysml` — typed interfaces
3. `KitchenTimerStructure.sysml` — `KitchenTimer`, `TimerPCB`, and power fan-out
4. `KitchenTimerBehavior.sysml` — `TimerStateMachine`
5. `KitchenTimerRequirements.sysml` — requirements and use cases
6. `Views.sysml` — `structure` for parts and ports only; `connections` for wiring; `timerStateMachine` for the state diagram
