# Traffic Light Intersection

This example is centered on controller behavior. It is useful for learners who want to study a phase-oriented state machine in a domain that is easy to reason about at system level.

Choose this example after the timer if you want a slightly richer control problem with operator input, detector input, signal heads, and mode-oriented behavior.

## Purpose

Model a signalized intersection with a compact controller, signal heads, detector input, and an operator command path.

## Try It With Spec42

From the repository root:

```bash
spec42 check intersection/
```

In VS Code, open `TrafficLightIntersection.sysml` and `Views.sysml`; use `controllerStateMachine` in the Model Visualizer for the phase and mode diagram.

## What This Example Demonstrates

- a controller-focused state machine with phase sequencing
- a clear relationship between controller logic, signal heads, detectors, and operator input
- simple requirements and use cases attached to an operational scenario
- a compact example of mode-oriented behavior using `Normal` and `Flash`
- separate views for structure (`GeneralView`) and behavior (`StateTransitionView`)

The corresponding views in `Views.sysml` are:

- `structure` (`GeneralView`) — `intersectionInstance` with part/port filter (no state machines)
- `connections` (`InterconnectionView`) — signal and detector wiring
- `controllerStateMachine` (`StateTransitionView`) — `ControllerStateMachine` behavior definition

## What Is Intentionally Simplified

- the example uses a reduced intersection model rather than a full real-world traffic installation
- pedestrian timing, detector behavior, all-red handling, and preemption are discussed more fully in the README than in the model
- requirements and safety rules are illustrative and not a substitute for traffic-control standards

## What To Inspect In The Model

- `TrafficLightIntersection` (in `TrafficLightIntersectionStructure.sysml`) for the top-level structure
- `Normal` and `ControllerStateMachine` in `TrafficLightIntersectionBehavior.sysml`
- the signal, detector, and operator ports for simple interface patterns
- the requirement definitions and `satisfy` usages in `TrafficLightIntersection.sysml`

## Known Limitations

- this example keeps timing logic and safety constraints lightweight
- several operational concepts are intentionally sketched rather than modeled in full detail

## Validation And Tooling Notes

- expected use: a behavior-focused example to inspect in a SysML v2-capable editor
- validation stance: `spec42 check intersection/` should load cleanly with no intended diagnostics
- if a tool reports differences in state or requirement notation, treat the model as an illustrative pattern rather than a standards-complete deployment model

## Files

| File | Purpose |
|------|---------|
| [TrafficLightIntersection.sysml](TrafficLightIntersection.sysml) | Instance, `satisfy` — start here |
| [TrafficLightIntersectionPorts.sysml](TrafficLightIntersectionPorts.sysml) | Lamp, detector, and operator interfaces |
| [TrafficLightIntersectionStructure.sysml](TrafficLightIntersectionStructure.sysml) | Parts and connections |
| [TrafficLightIntersectionBehavior.sysml](TrafficLightIntersectionBehavior.sysml) | Phases, controller state machine, lamp actions |
| [TrafficLightIntersectionRequirements.sysml](TrafficLightIntersectionRequirements.sysml) | Requirements, use cases, clearance constraint |
| [Views.sysml](Views.sysml) | Structure, interconnection, state-transition views |

## Walkthrough

Read the model in this order:

1. `TrafficLightIntersection.sysml` — `intersectionInstance` and `satisfy` relations
2. `TrafficLightIntersectionPorts.sysml` — typed interfaces
3. `TrafficLightIntersectionStructure.sysml` — intersection decomposition and wiring
4. `TrafficLightIntersectionBehavior.sysml` — `ControllerStateMachine` and phase cycle
5. `TrafficLightIntersectionRequirements.sysml` — requirements and use cases
6. `Views.sysml` — `structure`, `connections`, and `controllerStateMachine`
