# Webshop Software Example

This example is the software-commerce scenario in `webshop/`. It combines a readable webshop model with a compact, self-contained set of software, communication, data, and platform concepts.

Use this example if you want to see `spec42` applied to software architecture rather than a physical system.

## Try It With Spec42

From the repository root:

```bash
spec42 check webshop/
```

In VS Code, open `webshop.sysml` and `Views.sysml` to explore the structure, interaction scenarios, action flow, state transition, and requirements views.

The entry model is `webshop.sysml`, which assembles:

- local software structure (`HttpService`, `SqlDatabase`, `KafkaTopic`, `ExternalSystem`)
- behavioral modeling (`OrderLifecycleStateMachine` and `CheckoutPipeline`)
- requirements with traceability (`requirement`, `satisfy`, and one illustrative `allocate`)
- interaction scenarios for synchronous checkout orchestration and asynchronous event fan-out

The corresponding views in `Views.sysml` are:

- `structure` (`GeneralView`)
- `connections` (`InterconnectionView`)
- `checkoutFlow` (`SequenceView`)
- `orderEventFanout` (`SequenceView`)
- `orderLifecycle` (`StateTransitionView`)
- `checkoutPipeline` (`ActionFlowView`)
- `requirements` (`GeneralView`)

## About the interaction scenarios (`Lifeline` / `Message` parts)

`CheckoutFlow` and `OrderEventFanout` model their sequences as ordinary structural
`part` usages, not with behavioral `action def` / `send` / `accept`. The types they use
— `InteractionScenario`, `Lifeline`, `Message`, `SynchronousCall`, `ReturnMessage`,
`AsynchronousMessage`, `CreationMessage`, `Activation`, `InteractionOperand`,
`AltFragment` — are **defined locally at the top of `WebShopArchitecture.sysml`**. They
are not standard-library elements and carry no built-in behavioral semantics; they are a
teaching scaffold whose names line up with sequence-diagram vocabulary.

A scenario is a `part def :> InteractionScenario` that contains:

- one `part <name> : Lifeline` per participant (these become the lifeline columns), and
- one `part <name> : SynchronousCall` (or `ReturnMessage`, `AsynchronousMessage`, ...)
  per message, each fixing its endpoints with `ref from : Lifeline = <lifeline>` and
  `ref to : Lifeline = <lifeline>`. `Activation` and `AltFragment` group messages.

What Spec42's `SequenceView` renders from this is deliberately conservative: it projects
the **exposed lifelines** and the authored message endpoints. Per the diagram-view query
contract, message ordering, activations, and interaction fragments are shown only when
the analysis publication publishes those facts — the renderer never fabricates an order
or an activation from element names or declaration order. So treat the `part`-ordering in
the source as documentation of intent; the diagram reflects only what the engine can
resolve authoritatively.

If you are building your own interaction model, you can follow this same local-scaffold
pattern, or use standard SysML v2 behavioral constructs (`action def`, `perform`,
`send` / `accept`, item flows) — the standard constructs are the portable choice; this
example uses the structural pattern to keep the scenario readable as plain text.

## Scope

This model intentionally omits the full e-commerce-platform operational depth (BFF/mobile edge split, gRPC pricing service, retry/DLQ topic set, and broader platform observability/delivery surface) to stay compact and easy to learn, and it avoids dependencies on external domain-library packages.
