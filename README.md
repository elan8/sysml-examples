# SysML v2 examples

Small **SysML v2** (KerML text) models used as examples and teaching aids. Each folder is self-contained; open the `.sysml` files in a SysML v2–capable editor (for example the pilot tooling aligned with [SysML v2 Release](https://github.com/Systems-Modeling/SysML-v2-Release)).

## Examples

| Folder | Model | Notes |
|--------|--------|--------|
| [timer/](timer/) | [KitchenTimer.sysml](timer/KitchenTimer.sysml) | Kitchen timer: state machine, interfaces, requirements. See [timer/README.md](timer/README.md). |
| [drone/](drone/) | [SurveillanceDrone.sysml](drone/SurveillanceDrone.sysml) | Surveillance quadrotor: structure, requirements, connections. See [drone/README.md](drone/README.md). |
| [intersection/](intersection/) | [TrafficLightIntersection.sysml](intersection/TrafficLightIntersection.sysml) | Traffic intersection controller and phases. See [intersection/README.md](intersection/README.md). |
| [office/](office/) | [office.sysml](office/office.sysml) | Minimal desk setup (parts, connections, one requirement). See [office/README.md](office/README.md). |

## Layout

- One **package** per top-level `.sysml` file, named to match the example.
- Long-form system descriptions live in each folder’s **README** where present; the models trace to those narratives where noted in file headers.
