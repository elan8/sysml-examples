# Surveillance Quadrotor Drone

This is the broadest example in the repository. It is meant as a worked example for learners who already understand the smaller models and want to see how the same patterns scale to a more complex system description.

## What This Example Demonstrates

- decomposition of a larger system into airframe, propulsion, flight control, gimbal, payload, communication, and power
- a wider set of ports, requirements, use cases, actions, and behavioral sketches than the smaller examples
- a learner-friendly bridge from simple examples to a richer system-of-interest narrative

## What Is Intentionally Simplified

- many domain concepts are modeled at sketch level to keep the file readable
- interfaces often use simple value types where a stricter model would introduce richer domain types
- requirements and actions are illustrative and are not intended to be a complete or authoritative drone architecture

## What To Inspect In The Model

- `SurveillanceQuadrotorDrone` for the system structure and main connections
- `FlightControlAndSensing` for subsystem decomposition
- the requirement set and `satisfy` usages for traceability patterns
- the action definitions and behavioral subtype for examples of broader behavioral modeling
- `FlightModeStateMachine` as a larger state-oriented example

## Known Limitations

- this is the least formalized example in the repo and should be read as a worked teaching model rather than a polished reference architecture
- several behaviors and interfaces favor readability over strict typing or exhaustive completeness

## File

- [SurveillanceDrone.sysml](SurveillanceDrone.sysml) - complete SysML v2 model for this example

## Detailed Description

### Purpose

The system is an unmanned aerial vehicle designed for surveillance and reconnaissance. It provides stabilized video and still imagery from the air for monitoring, inspection, and situational awareness.

### Scope

- In scope: airframe, propulsion, flight controller and sensors, gimbal, cameras, communication links, battery, power distribution, and onboard mission-related behavior.
- Out of scope: ground control station implementation, charging infrastructure, spare-parts inventory, and training systems.

### Main Subsystems

- airframe
- propulsion
- flight control and sensing
- gimbal
- camera payload
- communication
- power

### Requirements And Behaviors

The example includes illustrative requirements for endurance, altitude, wind tolerance, video latency, failsafe behavior, geofencing, remote identification, gimbal range, control modes, and operating temperature. It also includes representative use cases, action definitions, and a flight-mode state machine to show how a larger model can gather several SysML v2 concepts in one place.
