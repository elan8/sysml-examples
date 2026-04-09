# Traffic Light Intersection

This example is centered on controller behavior. It is useful for learners who want to study a phase-oriented state machine in a domain that is easy to reason about at system level.

## What This Example Demonstrates

- a controller-focused state machine with phase sequencing
- a clear relationship between controller logic, signal heads, detectors, and operator input
- simple requirements and use cases attached to an operational scenario
- a compact example of mode-oriented behavior using `Normal` and `Flash`

## What Is Intentionally Simplified

- the example uses a reduced intersection model rather than a full real-world traffic installation
- pedestrian timing, detector behavior, all-red handling, and preemption are discussed more fully in the README than in the model
- requirements and safety rules are illustrative and not a substitute for traffic-control standards

## What To Inspect In The Model

- `TrafficLightIntersection` for the top-level structure
- `Normal` and `ControllerStateMachine` for the key behavior
- the signal, detector, and operator ports for simple interface patterns
- the requirement definitions and `satisfy` usages

## Known Limitations

- this example keeps timing logic and safety constraints lightweight
- several operational concepts are intentionally sketched rather than modeled in full detail

## File

- [TrafficLightIntersection.sysml](TrafficLightIntersection.sysml) - complete SysML v2 model for this example

## Detailed Description

### Purpose

The system is a traffic signal installation that controls vehicle and pedestrian flow at a single intersection. It assigns right-of-way to different approaches in a safe, predictable sequence and can support special modes such as flashing or preemption.

### Scope

- In scope: the intersection controller, signal heads, a detector, operator input, and the phase-oriented behavior model.
- Out of scope: adjacent intersections, central traffic-management integration, and a full standards-complete deployment model.

### Simplified Phase Model

For teaching purposes, the example focuses on a reduced phase sequence:

- `Phase A`: Main Street green, Side Street red
- `Phase B`: Main Street yellow, Side Street red
- `Phase C`: Side Street green, Main Street red
- `Phase D`: Side Street yellow, Main Street red

The top-level controller mode switches between a normal cycle and flash mode.

### Requirements And Use Cases

The example includes illustrative requirements for conflict avoidance, clearance time, fail-safe behavior, phase sequence, supported modes, and visibility. It also includes lightweight use cases such as normal operation, switching to flash, returning to normal, actuated green, and pedestrian crossing.
