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

`CheckoutFlow` and `OrderEventFanout` (in `WebShopArchitecture.sysml`) are the two
`SequenceView` scenarios. They use the standard SysML v2 interaction vocabulary
(SysML v2.0 §7.13 / §7.16, and §9.2.20 for `SequenceView`).

### The pattern

```sysml
occurrence def CheckoutFlow {
    // Each lifeline is a `part` typed by a real architecture part def.
    // Its `event occurrence` features, chained with `then`, are the points
    // on the lifeline where messages are sent or received, top to bottom.
    part storefront : Storefront {
        event occurrence submitSent;
        then event occurrence outcomeReceived;
    }
    part apiGateway : ApiGateway {
        event occurrence submitReceived;
        then event occurrence forwardSent;
        // ...
    }

    // Each message runs from a send event to a receive event.
    // `of <ItemDef>` is the optional payload type.
    message submitCheckout of CheckoutRequest
        from storefront.submitSent to apiGateway.submitReceived;

    // `succession` fixes the order the messages occur in.
    succession first submitCheckout then forwardCheckout;
}
```

`CheckoutFlow` models the nominal payment-approved path; the payment-declined branch is
covered by `WebShopBehavior::OrderLifecycleStateMachine` (transition `fail_payment`).
The same skeleton — `occurrence def`, typed `part` lifelines with ordered
`event occurrence`s, `message`, `succession` — is all you need for your own sequence
scenarios.

### How Spec42 picks lifelines and messages

There is **no marker type and no naming convention**. Spec42 classifies elements in a
`SequenceView` by their SysML v2 semantic kind:

- a `part` (`PartUsage`), `port` (`PortUsage`), or `actor` (`ActorUsage`) in the exposed
  scope is a **lifeline / participant**;
- a `message` (a `FlowUsage`) is a **message edge**, with its ends resolved from the
  `from` / `to` events;
- `event occurrence` order (`then`) and `succession` between messages give the
  **time order**.

An earlier version of this example defined its own `part def Lifeline` / `part def
Message` / `SynchronousCall` / `AltFragment` hierarchy. That was never required — those
were just plain parts named suggestively — and Spec42 does not look at element names, so
the approach is not used here.

### `action def` / `send` / `accept`

`message` models the *abstract logical* interaction that a `SequenceView` reads. Per
SysML v2.0 §7.16.2, a message can be *realized* more concretely by a `send` action on the
sender and a matching `accept` action on the receiver (or by streaming / succession
flows). This example stays at the `message` level; a lower-level model would add the
send/accept actions and bind them to the message. Modelling an interaction *only* with
`action def` + `send` / `accept` and no `message` does not currently feed `SequenceView`.

> **Tooling note.** Spec42's `SequenceView` renderer currently projects the lifelines
> but not yet the `message` edges or their ordering (`message` / `FlowUsage` lowering is
> a known Spec42 gap). The model is written to be correct now; the diagram fills in as
> Spec42 catches up. Tracked upstream in `elan8/spec42` (SequenceView message
> projection).

## Scope

This model intentionally omits the full e-commerce-platform operational depth (BFF/mobile edge split, gRPC pricing service, retry/DLQ topic set, and broader platform observability/delivery surface) to stay compact and easy to learn, and it avoids dependencies on external domain-library packages.
