# Contributing

Small, focused improvements are the best fit for this repository.

## Guidelines

- Keep examples readable for learners.
- Prefer plain UTF-8 text and avoid introducing editor-specific encoding artifacts.
- Keep one top-level package per example file.
- Update the example README when a model change affects teaching intent, scope, or limitations.
- Avoid turning these examples into domain-complete or standards-complete reference models unless the repository goal changes.

## Validation

- If you change a `.sysml` file, open it in a SysML v2-capable editor and confirm the package still loads in your chosen tool version.
- For [timer/KitchenTimer.sysml](C:/Git/sysml-examples/timer/KitchenTimer.sysml), preserve the no-intended-diagnostics workflow in [`spec42`](https://github.com/elan8/spec42); this is the repository's flagship validated example.
- If your tooling only supports a subset of the notation used here, document that in the PR or commit message.
