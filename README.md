# SysML v2 worked examples

Short, readable SysML v2 text models for learning, teaching, and quick experimentation.

## What is in this repo?

Each example folder contains:
- one main `.sysml` model
- one README explaining purpose, scope, and simplifications

Current examples:
- [office/](office/): smallest intro model for orientation
- [timer/](timer/): best end-to-end reference model in this repo
- [intersection/](intersection/): behavior-focused traffic light controller
- [drone/](drone/): larger, multi-subsystem system model
- [webshop/](webshop/): software architecture-focused example

Recommended order: [office/](office/) -> [timer/](timer/) -> [intersection/](intersection/) -> [drone/](drone/) -> [webshop/](webshop/).

## What can you use it for?

- Learn SysML v2 text syntax from compact, realistic examples.
- Teach modeling concepts with examples that are easy to explain in class or workshops.
- Reuse modeling patterns for structure, interfaces, states, requirements, and use cases.
- Try tools and editor workflows on small models before working on larger systems.

## Expectations and limits

- These are teaching-oriented worked examples, not complete domain models.
- The [timer/](timer/) example is the primary validated reference (`spec42`-first).
- Other examples may need small adaptations depending on your SysML v2 tooling.
- CI checks repository structure/docs, not full semantic validation of every model.
