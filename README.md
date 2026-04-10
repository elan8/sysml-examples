# SysML v2 worked examples

Small SysML v2 text models used as teaching examples and learner-oriented reference material. Each folder is self-contained and pairs a `.sysml` model with a README that explains the example, what it demonstrates, and what has been simplified.

## Status

- These examples are intentionally compact and prioritize readability over domain completeness.
- Some requirements, constraints, and behaviors are illustrative rather than fully formalized.
- Tool support may vary across SysML v2 editors and pilot implementations.
- This repository is meant to help people learn from readable examples, not to serve as a normative or fully validated reference set.

## How To Use This Repo

- Audience: learners exploring SysML v2 text models and lightweight teaching examples.
- Organization: one top-level package per example, with the narrative context in the example README and the model in the `.sysml` file.
- Recommended reading order: [office/](office/) -> [timer/](timer/) -> [intersection/](intersection/) -> [drone/](drone/).
- Best learner starting point after the `office` warm-up: [timer/](timer/), which is the strongest internally aligned example in the repository.
- What to inspect:
  - `office`: typed ports, simple structure, small state machine, and `satisfy` traces.
  - `timer`: the flagship example; a compact model combining structure, state behavior, interfaces, requirements, and use cases.
  - `intersection`: controller-oriented state behavior and a phased operational model.
  - `drone`: a larger worked example showing broader system decomposition and richer behavioral sketches.

## Examples

| Folder | Model | Main focus |
|--------|--------|--------|
| [office/](office/) | [office.sysml](office/office.sysml) | Smallest example; typed interfaces, simple behavior, and requirement traceability. |
| [timer/](timer/) | [KitchenTimer.sysml](timer/KitchenTimer.sysml) | Compact end-to-end example with structure, states, interfaces, requirements, and use cases. |
| [intersection/](intersection/) | [TrafficLightIntersection.sysml](intersection/TrafficLightIntersection.sysml) | Phase-based control logic and state-machine-centered behavior. |
| [drone/](drone/) | [SurveillanceDrone.sysml](drone/SurveillanceDrone.sysml) | Broader system structure, interfaces, requirements, and behavioral sketches. |

## Validation

- The files in this repository have been reviewed for readability and packaging as teaching examples.
- This repository does not yet include automated CI validation or conformance checking for the models.
- The [timer](timer/) example is the first example in this repository validated against [spec42](https://github.com/elan8/spec42), the SysML v2 language server and VS Code extension from Elan8.
- For the canonical `timer` workflow, open [KitchenTimer.sysml](timer/KitchenTimer.sysml) in `spec42` and run validation/checks through the language server-backed editor workflow; the flagship example is expected to load without intended diagnostics.
- To review the other models yourself, open a `.sysml` file in a SysML v2-capable editor and confirm that the package loads and the syntax is accepted by your chosen tool version.
- If a tool reports differences, treat the examples as illustrative first and adapt them to the conventions and supported subset of that editor.

## Layout

- One package per top-level `.sysml` file, named to match the example.
- Each example README explains the teaching goal, the main model elements to inspect, and the intended simplifications.
- The `.sysml` files keep domain narratives lightweight and focus on readable model structure.
