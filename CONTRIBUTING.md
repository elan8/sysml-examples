# Contributing

Small, focused improvements are the best fit for this repository.

## What Good Contributions Look Like

- Keep examples readable for learners first.
- Preserve the repository shape: one top-level package per example file, paired with one example README.
- Prefer changes that make an example more coherent, easier to study, or more honest about its limitations.
- Avoid turning these examples into domain-complete, standards-complete, or tool-specific reference models unless the repository goal changes.

## Editing Guidelines

- Prefer plain UTF-8 text and avoid introducing editor-specific encoding artifacts.
- Keep comments, section headers, and naming consistent with the surrounding example.
- Make requirements, constraints, and behaviors only as formal as needed to support the teaching goal.
- When a model is intentionally simplified, say so in the example README instead of silently leaving the simplification ambiguous.
- Update the example README whenever a model change affects teaching intent, scope, key elements to inspect, or known limitations.

## Validation Expectations

- If you change a `.sysml` file, open it in a SysML v2-capable editor and confirm the package still loads in your chosen tool version.
- For [timer/KitchenTimer.sysml](timer/KitchenTimer.sysml), preserve the no-intended-diagnostics workflow in [`spec42`](https://github.com/elan8/spec42); this is the repository's flagship validated example.
- For the other examples, prefer honest compatibility notes over overstating validation confidence.
- If your tooling only supports a subset of the notation used here, document that in the PR or commit message.

## README Expectations

Each example README should cover:

- purpose
- what the example demonstrates
- what is intentionally simplified
- what to inspect in the model
- known limitations
- validation or tooling notes

## Pull Request Checklist

- The example still reads as a compact worked example rather than a dump of domain detail.
- The README and `.sysml` file tell the same story.
- New claims about validation or rigor are accurate and specific.
- Repository hygiene checks still pass.
