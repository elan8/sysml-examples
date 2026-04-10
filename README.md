# SysML v2 worked examples

Small SysML v2 text models used as teaching examples and learner-oriented reference material. Each folder is self-contained and pairs a `.sysml` model with a README that explains the example, what it demonstrates, and what has been simplified.

## Repository Goal

This repository is a curated set of readable SysML v2 examples for learners, instructors, and teams who want compact text-first models to study. The emphasis is on teaching value, internal coherence, and approachable structure rather than domain completeness or standards-complete rigor.

## Quality Bar

- The examples are intentionally compact and prioritize readability over domain completeness.
- Requirements, constraints, and behaviors are included to illustrate modeling patterns, not to claim full formalization.
- Each example should read as a deliberate worked example with a clear teaching goal and stated limitations.
- This repository is not a normative reference set or a conformance suite.

## How To Use This Repo

- Audience: learners exploring SysML v2 text models and lightweight teaching examples.
- Organization: one top-level package per example, with the narrative context in the example README and the model in the `.sysml` file.
- Recommended reading order: [office/](office/) -> [timer/](timer/) -> [intersection/](intersection/) -> [drone/](drone/).
- Best learner starting point after the `office` warm-up: [timer/](timer/), which is the strongest internally aligned example in the repository.

## Example Set

| Folder | Model | Role in the set | Main focus |
|--------|--------|--------|--------|
| [office/](office/) | [office.sysml](office/office.sysml) | Smallest orientation example | Typed interfaces, simple structure, small state machine, and basic requirement traceability. |
| [timer/](timer/) | [KitchenTimer.sysml](timer/KitchenTimer.sysml) | Flagship validated example | Compact end-to-end example with structure, states, interfaces, requirements, use cases, and a small implementation view. |
| [intersection/](intersection/) | [TrafficLightIntersection.sysml](intersection/TrafficLightIntersection.sysml) | Behavior-focused middle example | Phase-based controller logic, operating modes, and state-machine-centered behavior. |
| [drone/](drone/) | [SurveillanceDrone.sysml](drone/SurveillanceDrone.sysml) | Advanced broad example | Larger system decomposition, multiple subsystem interfaces, requirements, mission actions, and flight-mode behavior. |

## Validation Policy

- This repository is `spec42`-first rather than tool-neutral in the strictest sense.
- The [timer](timer/) example is the canonical validated example for the repository and is expected to remain the cleanest end-to-end workflow in [spec42](https://github.com/elan8/spec42).
- The other examples are learner-oriented worked examples. Review them in a SysML v2-capable editor and treat tool differences as expected variation unless the example intent is clearly broken.
- The CI workflow in this repository checks documentation and repository layout only. It does not claim automated semantic validation of all `.sysml` models.

## Working With The Models

- Inspect each example README first to understand purpose, scope, simplifications, and known limitations.
- Expect one top-level package per `.sysml` file, named to match the example.
- Prefer reading examples as teaching artifacts: start with structure and interfaces, then move to states, requirements, and use cases.
- If a tool reports differences, adapt the examples to the conventions and supported subset of that tool version rather than assuming the repository is defining the only valid style.

## Repository Layout

- Each example folder contains one primary `.sysml` file and one README.
- Example READMEs use a common structure so readers can compare examples quickly.
- Supporting repository files document contribution expectations, validation stance, and lightweight automation for layout checks.
