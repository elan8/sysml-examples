# Surveillance Quadrotor Drone

This is the broadest example in the repository. It is meant as a worked example for learners who already understand the smaller models and want to see how the same patterns scale to a more complex system description.

Use this example when you want to evaluate how `spec42` helps navigate a larger model with multiple subsystems, interfaces, requirements, and behavior views.

## Purpose

Model a surveillance quadrotor UAV with flight control, sensors, gimbal, camera payload, communication links, and onboard power distribution.

## Try It With Spec42

From the repository root:

```bash
spec42 check drone/
```

In VS Code, open `SurveillanceDrone.sysml` and `Views.sysml`; the Model Explorer and Visualizer are especially useful for moving through the subsystem structure.

## What This Example Demonstrates

- decomposition of a larger system into airframe, propulsion, flight control, gimbal, payload, communication, and power
- a wider set of ports, requirements, use cases, mission actions, and flight-mode behavior than the smaller examples
- a learner-friendly bridge from simple examples to a richer system-of-interest narrative
- ISQ/SI quantity types for mass, length, time, force, power, charge, current, angles, and angular rate
- separate views for structure (`GeneralView`) and behavior (`StateTransitionView`)

The corresponding views in `Views.sysml` are:

- `structure` (`GeneralView`) — `droneInstance` with part/port filter (no state machines)
- `connections` (`InterconnectionView`) — subsystem and power wiring
- `flightModeStateMachine` (`StateTransitionView`) — `FlightModeStateMachine` behavior definition

## Requirement And Quantity Patterns

The requirement definitions are reusable types. The aggregator declares an anonymous
requirement usage and asserts its satisfaction by a concrete part:

```sysml
satisfy requirement : EnduranceReq by droneInstance;
```

For a requirement that needs a name for later tracing or verification, use the equivalent
named pattern instead:

```sysml
requirement endurance : EnduranceReq;
satisfy endurance by droneInstance;
```

The short `satisfy endurance` form references a requirement usage. `EnduranceReq` is a
definition, so it belongs after the typing operator `:`. These satisfaction assertions
express the intended design claim; they do not provide test or analysis evidence.

In `PowerPort`, `out power :> electricPower;` subsets the ISQ quantity feature and inherits
its power value type. `electricPower` is an attribute usage, so `: electricPower` would
incorrectly use a feature as a type. The port's `maxCurrent` is a default value so individual
power ports can redefine it for their loads.

## What Is Intentionally Simplified

- many domain concepts are modeled at sketch level to keep the model readable across files
- interfaces often use simple value types where a stricter model would introduce richer domain types
- telemetry, C2, and camera command ports still use `String` where a product model would use structured messages or enums
- the mission actions are intentionally lightweight and illustrative rather than a detailed executable workflow
- the requirements are not intended to be a complete or authoritative drone architecture

## What To Inspect In The Model

- `SurveillanceQuadrotorDrone` in `SurveillanceDroneStructure.sysml` for system structure and main connections
- `FlightControlAndSensing` for subsystem decomposition
- the requirement set and `satisfy` usages in `SurveillanceDrone.sysml`
- the mission action definitions in `SurveillanceDroneBehavior.sysml`
- `FlightModeStateMachine` as a larger state-oriented example

## Known Limitations

- this is the broadest and least formalized example in the repo and should be read as a worked teaching model rather than a polished reference architecture
- several behaviors and interfaces favor readability over strict typing or exhaustive completeness
- power, sensing, autonomy, and regulation topics are deliberately compressed into a compact model

## Validation And Tooling Notes

- expected use: an advanced worked example to inspect after the smaller models
- validation stance: `spec42 check drone/` should load cleanly with no intended diagnostics
- if your tool is sensitive to advanced action or state notation, preserve the top-level teaching structure and simplify locally as needed

## Files

| File | Purpose |
|------|---------|
| [SurveillanceDrone.sysml](SurveillanceDrone.sysml) | Instance, `satisfy` — start here |
| [SurveillanceDronePorts.sysml](SurveillanceDronePorts.sysml) | Motor, sensor, telemetry, power, and C2 interfaces |
| [SurveillanceDroneStructure.sysml](SurveillanceDroneStructure.sysml) | Subsystems, decomposition, connections |
| [SurveillanceDroneBehavior.sysml](SurveillanceDroneBehavior.sysml) | Mission actions and `FlightModeStateMachine` |
| [SurveillanceDroneRequirements.sysml](SurveillanceDroneRequirements.sysml) | Requirements, use cases, parametrics |
| [Views.sysml](Views.sysml) | Structure, interconnection, state-transition views |

## Walkthrough

Read the model in this order:

1. `SurveillanceDrone.sysml` — `droneInstance` and `satisfy` relations
2. `SurveillanceDronePorts.sysml` — typed interfaces
3. `SurveillanceDroneStructure.sysml` — `SurveillanceQuadrotorDrone` and subsystem wiring
4. `SurveillanceDroneBehavior.sysml` — mission actions and `FlightModeStateMachine`
5. `SurveillanceDroneRequirements.sysml` — requirements and use cases
6. `Views.sysml` — `structure`, `connections`, and `flightModeStateMachine`
