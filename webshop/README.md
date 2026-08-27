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

## About the interaction scenarios (`occurrence def` + `message`)

`CheckoutFlow` and `OrderEventFanout` (in `WebShopArchitecture.sysml`) use the standard
SysML v2 interaction vocabulary — no locally invented `Lifeline` / `Message` types:

- The scenario is an **`occurrence def`**.
- Each **lifeline** is a `part` typed by an architecture part def (`Storefront`,
  `CheckoutService`, `OrdersEventsTopic`, ...), carrying `event occurrence` features
  ordered top-to-bottom with `then`. These are the lifeline columns.
- Each **`message`** connects a send event to a receive event
  (`message submitCheckout of CheckoutRequest from storefront.submitSent to
  apiGateway.submitReceived;`). The `of <ItemDef>` clause is the optional payload.
- **`succession first m1 then m2;`** fixes the order the messages occur in — the
  diagram never infers order from declaration order.

`CheckoutFlow` models the nominal payment-approved path; the payment-declined branch is
covered by `WebShopBehavior::OrderLifecycleStateMachine`.

This is the portable, spec-conformant way to model an interaction (SysML v2.0 §7.13 /
§7.16, and §9.2.20 for `SequenceView`). See the standard training models
`Interaction Example-1` and the pub/sub sequence example for the same pattern.

> **Tooling note.** Spec42's `SequenceView` renderer currently projects the lifelines
> but not yet the `message` edges or their ordering (`message`/`FlowUsage` lowering is a
> known Spec42 gap). The model is written to be correct now; the diagram will fill in
> as Spec42 catches up. Tracked in `elan8/spec42` — see the issue linked from this
> repository's `webshop` discussion.

## Scope

This model intentionally omits the full e-commerce-platform operational depth (BFF/mobile edge split, gRPC pricing service, retry/DLQ topic set, and broader platform observability/delivery surface) to stay compact and easy to learn, and it avoids dependencies on external domain-library packages.
