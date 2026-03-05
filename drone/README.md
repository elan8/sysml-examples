# Surveillance Quadrotor Drone — Project Description

A SysML v2 example project for a **surveillance quadrotor drone** with a gimbal-mounted camera payload. This document provides a detailed system description to support modeling in SysML v2 (structure, behavior, requirements, and interfaces).

---

## 1. Project Overview

### 1.1 Purpose

The system is an **unmanned aerial vehicle (UAV)** designed for **surveillance and reconnaissance**. It provides stabilized, high-quality video and still imagery from the air for security, monitoring, inspection, and situational awareness.

### 1.2 System Type

- **Configuration:** Quadrotor (four rotors in X or H layout).
- **Payload:** Gimbal assembly with one or more cameras (e.g., visible and thermal).
- **Control:** Remotely piloted and/or semi-autonomous (waypoint, orbit, follow modes).
- **Domain:** Small UAS (sUAS), typically under 25 kg MTOW for regulatory simplicity.

### 1.3 Key Stakeholders

| Stakeholder | Interest |
|-------------|----------|
| Operator / Pilot | Safe flight, intuitive control, reliable video feed. |
| Mission planner | Coverage, endurance, mission profiles. |
| Maintenance | Diagnostics, part life, accessibility. |
| Regulator | Safety, identification, geofencing, compliance. |
| End user (e.g., security) | Image quality, latency, area coverage. |

---

## 2. System Context and Boundaries

### 2.1 System of Interest

The **Surveillance Quadrotor Drone** includes:

- **In scope:** Airframe, propulsion (motors, ESCs, propellers), flight controller and sensors, gimbal mechanism, camera(s), communication links (telemetry, video), battery and power distribution, and onboard software (flight, gimbal, camera, mission).
- **Out of scope (external):** Ground control station (GCS), charging infrastructure, spare parts inventory, training simulators (may be separate projects with interfaces).

### 2.2 External Interfaces (High Level)

- **Operator:** Commands via radio (RC) and/or data link; receives video and telemetry.
- **Environment:** Atmosphere (wind, temperature, humidity), terrain, obstacles, GPS/GNSS, lighting.
- **Regulatory / ATC:** Identification (e.g., Remote ID), geofencing data, airspace constraints.

---

## 3. Mission and Use Cases

### 3.1 Primary Mission

**Surveillance and reconnaissance:** Fly to an area of interest, maintain position or orbit, and stream or record stabilized video and stills (visible and optionally thermal) for real-time monitoring or post-mission analysis.

### 3.2 Representative Use Cases

1. **Patrol / overwatch** — Predefined or manual route; continuous video to GCS.
2. **Point of interest (POI) / orbit** — Circle a fixed point with camera pointed at center; adjustable radius and altitude.
3. **Follow target** — Track a moving object (person/vehicle) with gimbal while maintaining safe flight.
4. **Inspection** — Structured flight path (e.g., grid) for infrastructure or area inspection; high-resolution stills and video.
5. **Search** — Area search with thermal camera; loiter and zoom as needed.
6. **Return to launch (RTL) / landing** — Automated or assisted return and landing with payload secured.

---

## 4. Subsystems and Architecture

### 4.1 Airframe

- **Role:** Structural support, attachment points for all subsystems, protection of internals, aerodynamic and weight efficiency.
- **Description:** Central body (fuselage) with four arms in quad-X or H configuration. Arms house motor mounts and often integrate landing gear. Material typically carbon fiber, plastic, or aluminum; design balances stiffness, weight, and crash resilience.
- **Key attributes:** Frame size (wheelbase), weight, max payload capacity, foldable or fixed arms, IP rating if any.

### 4.2 Propulsion

- **Role:** Generate lift and thrust for takeoff, hover, translation, and landing.
- **Components:**
  - **Motors:** Four brushless DC (BLDC) outrunner motors; kV and size matched to propeller and battery voltage.
  - **Electronic speed controllers (ESCs):** One per motor; receive PWM or DShot commands from flight controller; provide 3-phase drive to motors.
  - **Propellers:** Two pairs of counter-rotating props; diameter and pitch chosen for thrust, efficiency, and acoustic signature.
- **Key attributes:** Thrust per motor (and total), hover throttle, max current, propeller size and material.

### 4.3 Flight Control and Sensing

- **Role:** Stabilize attitude, execute pilot or autonomous commands, enforce limits and failsafes.
- **Components:**
  - **Flight controller (FC):** Main processor running attitude and rate control, mixing for quadrotor, and high-level modes (altitude hold, GPS hold, waypoint, RTL).
  - **Inertial measurement unit (IMU):** Accelerometer and gyroscope (often magnetometer) for orientation and angular rate.
  - **Barometer:** Altitude (pressure) for height hold and terrain awareness.
  - **GNSS/GPS receiver:** Position and velocity for navigation, hold, waypoints, geofence, RTL.
  - **Compass (optional):** Heading when GPS is poor or for yaw alignment.
  - **Optional:** Rangefinder (sonar/lidar) for precision landing or low-altitude hold; obstacle sensors for avoidance.
- **Key attributes:** Update rates (e.g., 400 Hz attitude loop), supported flight modes, geofence behavior, failsafe logic.

### 4.4 Gimbal

- **Role:** Isolate the camera(s) from aircraft motion and point them in a desired direction (pan/tilt, and optionally roll).
- **Description:** Mechanically stabilized platform with one to three axes (typically pan and tilt; roll optional). Actuated by brushless or servo motors with feedback (e.g., encoders or IMU on gimbal). Control can be:
  - **Stabilization only:** Hold attitude relative to horizon or to body.
  - **Pointing:** Follow operator command (joystick, touch) or track a target (from image processing).
- **Mounting:** Under the fuselage (underslung) is common for surveillance quads to maximize field of view forward and downward.
- **Key attributes:** Axes (pan, tilt, roll), angular range per axis, max angular rate, payload capacity (mass), stabilization bandwidth, power and communication interface to FC/camera.

### 4.5 Camera Payload

- **Role:** Capture visible and/or thermal imagery for surveillance; provide video stream and optional stills.
- **Typical configuration:**
  - **Primary camera:** Visible spectrum (RGB), 4K or 1080p video, stills (e.g., 12 MP); may have optical zoom.
  - **Secondary camera (optional):** Thermal (LWIR) for night and search; often lower resolution, core or radiometric.
  - **Integration:** Cameras mounted on gimbal; single gimbal can carry one or two cameras (co-aligned or side-by-side).
- **Interfaces:** Video out (analog composite, HD-SDI, or digital e.g. HDMI/USB for encoding); control (start/stop record, zoom, settings) via serial, USB, or dedicated protocol. Power from gimbal or separate power rail.
- **Key attributes:** Resolution, frame rate, FOV, zoom range, thermal sensitivity (NETD) if applicable, latency to GCS.

### 4.6 Communication

- **Role:** Command and control (C2), video downlink, telemetry.
- **Links:**
  - **RC / C2 link:** Low-latency control (stick commands, mode switches); often 900 MHz, 2.4 GHz, or 5.8 GHz; redundant link optional.
  - **Telemetry:** Position, attitude, battery, status, alerts; can share C2 radio or separate modem (e.g., 4G/LTE for beyond-line-of-sight).
  - **Video downlink:** Analog (e.g., 5.8 GHz) or digital (e.g., Occusync, DJI Lightbridge style); latency and robustness vs. resolution trade-off.
- **Key attributes:** Range (LOS/BVLOS if applicable), latency, bandwidth, frequency bands, encryption.

### 4.7 Power

- **Role:** Supply all onboard systems from takeoff to landing.
- **Components:**
  - **Battery:** Typically LiPo or Li-ion multi-cell (4S–6S common); capacity (mAh) and C-rating define endurance and max current.
  - **Power distribution:** PDB or integrated ESC/PDB; distributes main battery to ESCs, FC, gimbal, cameras, and radios; may provide regulated 5 V / 12 V.
  - **Battery management:** Voltage and current sensing; used for remaining capacity estimate, low-battery warning, and RTL trigger.
- **Key attributes:** Nominal voltage, capacity, max discharge rate, weight, flight time (at defined hover or mission profile).

---

## 5. Key Requirements (Summary)

### 5.1 Performance

- **Endurance:** Minimum flight time (e.g., ≥ 25 min at nominal hover with standard payload).
- **Range:** Max operational distance (LOS or BVLOS as specified).
- **Max altitude (AGL):** Per regulation and mission (e.g., 120 m AGL typical).
- **Wind tolerance:** Operate in winds up to specified speed (e.g., 10 m/s).
- **Video:** Minimum resolution (e.g., 1080p), max latency (e.g., &lt; 300 ms end-to-end).

### 5.2 Safety and Compliance

- **Failsafe:** RTL or land on C2 loss, low battery, critical sensor failure.
- **Geofencing:** Respect no-fly zones and altitude limits.
- **Identification:** Remote ID or equivalent where required.
- **Structural:** No single-point failures that lead to loss of control (e.g., redundancy or degraded operation).

### 5.3 Operability

- **Deployment:** Takeoff and landing without dedicated runway; hand launch / landing optional.
- **Gimbal:** Continuous 360° pan or sufficient range for mission; tilt range (e.g., –90° to 0° or +30°).
- **Control modes:** Manual, attitude, GPS hold, waypoint, orbit, RTL, and optionally follow.

### 5.4 Environment

- **Operating temperature:** e.g., –10 °C to +45 °C.
- **Ingress protection:** Minimum IP rating for rain and dust if required.

---

## 6. Interfaces (Summary)

| From | To | Content |
|------|-----|--------|
| Flight controller | ESCs | Throttle / motor commands (PWM, DShot) |
| Flight controller | Gimbal | Stabilization targets, mode, optional tracking commands |
| Gimbal | Camera(s) | Power, control (record, zoom), optional sync |
| Camera(s) | Video encoder / transmitter | Video (and optional metadata) |
| Flight controller | C2 / telemetry radio | Telemetry, status |
| Operator (GCS) | C2 radio | RC commands, mode changes, mission upload |
| C2 / video radio | GCS | Video stream, telemetry |
| Battery / PDB | All subsystems | Power (various voltages) |
| GNSS, IMU, baro | Flight controller | Position, velocity, attitude, altitude |

---

## 7. Life Cycle Considerations

- **Design:** Modularity (gimbal and camera as replaceable payload), standard interfaces (e.g., gimbal mounting footprint, video protocol).
- **Production:** Assembly order, calibration (IMU, gimbal, compass), software flashing and configuration.
- **Operation:** Pre-flight checks (sensors, gimbal, camera, links, battery), mission execution, post-flight data offload.
- **Support:** Diagnostics (logs, health indicators), firmware updates, battery and propeller replacement, gimbal and camera servicing.

---

## 8. Relation to SysML v2

This description is intended to be refined into SysML v2 models, including:

- **Structure:** Block definition and internal block diagrams for the drone and its subsystems (airframe, propulsion, flight control, gimbal, cameras, communication, power).
- **Behavior:** Use cases, activities (e.g., mission phases, gimbal control), state machines (flight modes, gimbal states).
- **Requirements:** Requirement elements with traceability to design and verification.
- **Parametrics:** Constraints for performance (e.g., thrust vs. weight, endurance vs. payload).
- **Allocations:** Functions and requirements allocated to structural elements and to software/hardware.

---

*This document is the authoritative high-level description for the Surveillance Quadrotor Drone SysML v2 example project. It will be updated as the model evolves.*
