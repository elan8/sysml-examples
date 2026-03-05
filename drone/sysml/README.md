# Surveillance Drone – SysML v2 model

This folder contains the SysML v2 textual model for the **surveillance quadrotor drone** described in [../README.md](../README.md).

## File

- **SurveillanceDrone.sysml** – Single-package model with:
  - **Structure:** `SurveillanceQuadrotorDrone` and subsystems (`Airframe`, `Propulsion` with 4× `PropulsionUnit`, `FlightControlAndSensing`, `Gimbal`, `CameraPayload`, `Communication`, `Power`); ports and connections per README §6.
  - **Requirements:** Requirement definitions from README §5 and `satisfy requirement ... by` usages.
  - **Use cases:** PatrolOverwatch, PointOfInterestOrbit, FollowTarget, Inspection, Search, ReturnToLaunchLanding (README §3.2).
  - **Behavior:** Action definitions (ExecutePatrol, ExecuteOrbit, ControlGimbal, CaptureVideo); flight mode state machine.
  - **Parametrics:** `TotalThrustMargin` constraint, `FlightTimeEstimate` calculation.
  - **Allocations:** Actions allocated to part usages (flightControl, gimbal, cameraPayload).

## Notation

SysML v2 textual notation as in the [SysML v2 Language Specification](https://www.omg.org/spec/SysML/2.0/Language/) (see also `temp/SysML_v2.txt` in this repo).

## Propulsion

Propulsion is modeled as one **Propulsion** part containing **4× PropulsionUnit** (each unit: motor + ESC + propeller with command and power ports).
